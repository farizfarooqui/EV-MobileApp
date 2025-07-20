import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nobile/Constants/Constants.dart';
import 'package:nobile/Controller/PersonalInfoController.dart';
import 'package:nobile/Views/Widgets/GradientLoaderButton.dart';
import 'package:nobile/Views/Widgets/SmallLoader.dart';

class PersonalInfoScreen extends StatelessWidget {
  final PersonalInfoController controller = Get.put(PersonalInfoController());

  PersonalInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme =
        Get.context != null ? Theme.of(Get.context!) : ThemeData.dark();
    return Scaffold(
      backgroundColor: theme.brightness == Brightness.dark
          ? const Color(0xFF121212)
          : Colors.white, // backgroundColor: Colors.black.withOpacity(0.04),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: colorPrimary),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Personal Information',
          style: TextStyle(
            color: colorPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: SmallLoader(color: colorPrimary),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Picture Section
              _buildProfilePictureSection(),
              const SizedBox(height: 32),

              // Personal Information Form
              _buildPersonalInfoForm(context),
              const SizedBox(height: 32),

              // Save Button
              _buildSaveButton(),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildProfilePictureSection() {
    return Center(
      child: Column(
        children: [
          // Profile Picture
          GestureDetector(
            onTap: controller.showImagePickerDialog,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: colorPrimary, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: colorPrimary.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ClipOval(
                child: Obx(() {
                  if (controller.profileImage.value != null) {
                    return Image.file(
                      controller.profileImage.value!,
                      fit: BoxFit.cover,
                    );
                  } else if (controller.profileImageUrl.value.isNotEmpty) {
                    return Image.network(
                      controller.profileImageUrl.value,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildDefaultProfilePicture();
                      },
                    );
                  } else {
                    return _buildDefaultProfilePicture();
                  }
                }),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Profile Picture Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Change Photo Button
              GestureDetector(
                onTap: controller.showImagePickerDialog,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: colorPrimary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: colorPrimary.withOpacity(0.3)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.camera_alt, size: 16, color: colorPrimary),
                      SizedBox(width: 6),
                      Text(
                        'Change',
                        style: TextStyle(
                          color: colorPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Remove Photo Button
              Obx(() => controller.profileImageUrl.value.isNotEmpty ||
                      controller.profileImage.value != null
                  ? GestureDetector(
                      onTap: controller.removeProfilePicture,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border:
                              Border.all(color: Colors.red.withOpacity(0.3)),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.delete, size: 16, color: Colors.red),
                            SizedBox(width: 6),
                            Text(
                              'Remove',
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : const SizedBox.shrink()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultProfilePicture() {
    return Container(
      color: colorPrimary.withOpacity(0.1),
      child: Icon(
        Icons.person,
        size: 60,
        color: colorPrimary.withOpacity(0.6),
      ),
    );
  }

  Widget _buildPersonalInfoForm(context) {
    final theme =
        Get.context != null ? Theme.of(Get.context!) : ThemeData.dark();
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark
            ? const Color(0xFF1E1E1E)
            : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colorPrimary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.person, color: colorPrimary, size: 24),
              ),
              const SizedBox(width: 12),
              const Text(
                'Personal Details',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Name Field
          _buildFormField(
            context: context,
            label: 'Full Name',
            icon: 'assets/SVG/person.svg',
            controller: controller.nameController,
            hint: 'Enter your full name',
            keyboardType: TextInputType.name,
          ),
          const SizedBox(height: 20),

          // Email Field
          _buildFormField(
            context: context,

            label: 'Email Address',
            icon: 'assets/SVG/email.svg',
            controller: controller.emailController,
            hint: 'Enter your email address',
            keyboardType: TextInputType.emailAddress,
            enabled: false, // Email should not be editable
          ),
          const SizedBox(height: 20),

          // Phone Field
          _buildFormField(
            context: context,
            label: 'Phone Number',
            icon: 'assets/SVG/Phone.svg',
            controller: controller.phoneController,
            hint: 'Enter your phone number',
            keyboardType: TextInputType.phone,
          ),
        ],
      ),
    );
  }

  Widget _buildFormField({
    required String label,
    required String icon,
    required TextEditingController controller,
    required String hint,
    required TextInputType keyboardType,
    bool enabled = true,
    required BuildContext context, // Pass context to access theme
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: colorScheme.primary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: enabled
                  ? (theme.brightness == Brightness.dark
                      ? Colors.white24
                      : Colors.grey.withOpacity(0.3))
                  : Colors.grey.withOpacity(0.1),
            ),
          ),
          child: TextField(
            controller: controller,
            enabled: enabled,
            keyboardType: keyboardType,
            style: TextStyle(
              color: enabled
                  ? (theme.brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black)
                  : Colors.grey,
              fontSize: 16,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: theme.brightness == Brightness.dark
                  ? Colors.grey[900] // Dark background inside textfield
                  : Colors.grey[100], // Light background for light mode
              hintText: hint,
              hintStyle: TextStyle(
                color: theme.brightness == Brightness.dark
                    ? Colors.white54
                    : Colors.grey.withOpacity(0.6),
                fontSize: 14,
              ),
              prefixIcon: Padding(
                padding: const EdgeInsets.all(15.0),
                child: SvgPicture.asset(
                  icon,
                  height: 20,
                  width: 20,
                  colorFilter: ColorFilter.mode(
                    enabled
                        ? colorScheme.primary
                        : Colors.grey, // icon color based on state
                    BlendMode.srcIn,
                  ),
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: theme.brightness == Brightness.dark
                      ? Colors.white24
                      : Colors.grey.withOpacity(0.4),
                  width: 0.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: theme.brightness == Brightness.dark
                      ? colorScheme.primary.withOpacity(0.5)
                      : Colors.grey.withOpacity(0.4),
                  width: 1.0,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return Obx(() => GradientLoaderButton(
          isLoading: controller.isSaving.value,
          onPressed: controller.saveUserData,
          text: "Save Changes",
          fontsize: 18,
        ));
  }
}
