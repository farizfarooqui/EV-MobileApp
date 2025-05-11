import 'package:appwrite/appwrite.dart';

class AppwriteService {
  late Client client;
  late Databases databases;

  AppwriteService() {
    client = Client()
        .setEndpoint('https://fra.cloud.appwrite.io/v1')
        .setProject('682088f8000cbce0b9e5')
        .setSelfSigned(status: true);

    databases = Databases(client);
  }
}
