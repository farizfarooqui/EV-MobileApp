import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:nobile/Service/UserPreferences.dart';

class PersonalInfoController extends GetxController {
  // Form controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  // Observable variables
  var isLoading = false.obs;
  var isSaving = false.obs;
  var profileImage = Rx<File?>(null);
  var profileImageUrl = ''.obs;
  var userData = <String, dynamic>{}.obs;

  // Image picker
  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.onClose();
  }

  Future<void> loadUserData() async {
    try {
      isLoading.value = true;
      final user = await UserPreferences.getUser();

      if (user != null) {
        userData.value = user;
        nameController.text = user['name'] ?? '';
        emailController.text = user['email'] ?? '';
        phoneController.text = user['phone'] ?? '';
        profileImageUrl.value = user['profileImageUrl'] ?? '';
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load user data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 90,
      );

      if (image != null) {
        File imageFile = File(image.path);
        // Crop the image
        File? croppedImage = await cropImage(imageFile);
        if (croppedImage != null) {
          profileImage.value = croppedImage;
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick image: $e');
    }
  }

  Future<File?> cropImage(File imageFile) async {
    try {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: imageFile.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Profile Picture',
            toolbarColor: const Color(0xFF1E3A8A), // colorPrimary equivalent
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: false,
          ),
          IOSUiSettings(
            title: 'Crop Profile Picture',
          ),
        ],
      );

      if (croppedFile != null) {
        return File(croppedFile.path);
      }
      return null;
    } catch (e) {
      Get.snackbar('Error', 'Failed to crop image: $e');
      return null;
    }
  }

  Future<String?> uploadProfileImage() async {
    if (profileImage.value == null) return null;

    try {
      final user = await UserPreferences.getUser();
      if (user == null) return null;

      final userId = user['uid'];
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_images')
          .child('$userId-$timestamp.jpg');

      final uploadTask = storageRef.putFile(profileImage.value!);
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      Get.snackbar('Error', 'Failed to upload image: $e');
      return null;
    }
  }

  Future<void> saveUserData() async {
    if (nameController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter your name');
      return;
    }

    try {
      isSaving.value = true;

      final user = await UserPreferences.getUser();
      if (user == null) {
        Get.snackbar('Error', 'User not found. Please login again.');
        return;
      }

      final userId = user['uid'];
      String? newProfileImageUrl = profileImageUrl.value;

      // Upload new profile image if selected
      if (profileImage.value != null) {
        newProfileImageUrl = await uploadProfileImage();
        if (newProfileImageUrl == null) {
          Get.snackbar('Error', 'Failed to upload profile image');
          return;
        }
      }

      // Prepare updated user data
      final updatedUserData = {
        'uid': userId,
        'name': nameController.text.trim(),
        'email': emailController.text.trim(),
        'phone': phoneController.text.trim(),
        'profileImageUrl': newProfileImageUrl,
        'updatedAt': Timestamp.now(),
        'createdAt': user['createdAt'],
        'isVerified': user['isVerified'] ?? false,
      };

      // Update in Firebase
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update(updatedUserData);

      // Update in SharedPreferences
      await UserPreferences.saveUser(updatedUserData);

      // Update local data
      userData.value = updatedUserData;
      profileImageUrl.value = newProfileImageUrl ?? '';

      Get.snackbar(
        'Success',
        'Profile updated successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Clear the selected image
      profileImage.value = null;
    } catch (e) {
      Get.snackbar('Error', 'Failed to update profile: $e');
    } finally {
      isSaving.value = false;
    }
  }

  void removeProfilePicture() {
    profileImage.value = null;
    profileImageUrl.value = '';
    Get.snackbar(
      'Success',
      'Profile picture removed!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.orange,
      colorText: Colors.white,
    );
  }

  void showImagePickerDialog() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Choose Profile Picture',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    Get.back();
                    pickImage(ImageSource.camera);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.camera_alt, size: 32, color: Colors.blue),
                        const SizedBox(height: 8),
                        const Text('Camera',
                            style: TextStyle(fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Get.back();
                    pickImage(ImageSource.gallery);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.photo_library, size: 32, color: Colors.blue),
                        const SizedBox(height: 8),
                        const Text('Gallery',
                            style: TextStyle(fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
