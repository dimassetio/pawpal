import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pawpal/app/data/helpers/firebase_options.dart';
import 'package:pawpal/app/data/helpers/themes.dart';
import 'package:pawpal/app/data/models/user_model.dart';
import 'package:pawpal/app/modules/auth/controllers/auth_controller.dart';

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  var authController = Get.put(AuthController(), permanent: true);
  runApp(
    GetMaterialApp(
      title: "Godsseo-App",
      debugShowCheckedModeBanner: false,
      initialRoute: authController.isLoggedIn
          ? authC.user.hasRole(Role.administrator)
              ? Routes.HOME_ADMIN
              : Routes.HOME
          : Routes.AUTH_SIGN_IN,
      getPages: AppPages.routes,
      theme: mainTheme,
    ),
  );
}
