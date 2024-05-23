import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawpal/app/data/models/user_model.dart';
import 'package:pawpal/app/modules/auth/controllers/auth_controller.dart';
import 'package:pawpal/app/routes/app_pages.dart';

class AuthSignInController extends GetxController {
  final _isLoading = false.obs;
  set isLoading(value) => _isLoading.value = value;
  get isLoading => _isLoading.value;

  final _showPassword = false.obs;
  set showPassword(value) => _showPassword.value = value;
  get showPassword => _showPassword.value;

  TextEditingController emailC = TextEditingController();
  TextEditingController passwordC = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void togglePasword() {
    showPassword = !showPassword;
  }

  Future signIn() async {
    try {
      isLoading = true;
      String? message = await authC.signIn(emailC.text, passwordC.text);
      if (message == null) {
        if (authC.user.hasRole(Role.user)) {
          Get.snackbar("Sign In Berhasil", "Selamat datang di PawPal-App");
          Get.toNamed(Routes.HOME);
        } else if (authC.user.hasRoles(
          [Role.administrator],
        )) {
          Get.snackbar(
              "Sign In Berhasil", "Selamat datang PawPal administrator");
          Get.toNamed(Routes.HOME_ADMIN);
        } else {
          Get.snackbar("Sign In Gagal",
              "Role tidak teridentifikasi. Role anda adalah '${authC.user.role}'");
        }
      } else {
        Get.snackbar("Sign In Gagal", message);
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
      printError(info: e.toString());
    } finally {
      isLoading = false;
    }
  }

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
