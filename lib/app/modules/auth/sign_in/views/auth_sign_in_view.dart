import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:pawpal/app/data/helpers/assets.dart';
import 'package:pawpal/app/data/helpers/themes.dart';
import 'package:pawpal/app/data/widgets/text_field.dart';
import 'package:pawpal/app/routes/app_pages.dart';
import 'package:nb_utils/nb_utils.dart';

import '../controllers/auth_sign_in_controller.dart';

class AuthSignInView extends GetResponsiveView<AuthSignInController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('AuthSignInView'),
      //   centerTitle: true,
      // ),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Center(
            child: Form(
              key: controller.formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    img_logo,
                    height: 100,
                  ),
                  16.height,
                  // Card(
                  //   margin: EdgeInsets.all(20),
                  //   color: bgColor,
                  //   shape: RoundedRectangleBorder(
                  //     borderRadius: BorderRadius.circular(16),
                  //   ),
                  //   child: Container(
                  //     decoration: BoxDecoration(
                  //       color: bgColor,
                  //       borderRadius: BorderRadius.circular(16),
                  //     ),
                  //     padding: EdgeInsets.all(20),
                  //     child: Column(
                  //       children: [
                  Text(
                    "Sign In",
                    style: textTheme(context)
                        .headlineMedium
                        ?.copyWith(color: textColor),
                  ),
                  8.height,
                  Text(
                    "Enter your credential to continue to PawPal!",
                    style: textTheme(context)
                        .labelMedium
                        ?.copyWith(color: textColor),
                  ),
                  16.height,
                  PPTextfield(
                    isBordered: true,
                    borderRadius: 12,
                    label: "Email",
                    isZeroPadding: false,
                    icon: Icon(Icons.email),
                    validator: (value) => (value?.validateEmail() ?? false)
                        ? null
                        : "Email is not valid",
                    textFieldType: TextFieldType.EMAIL,
                    controller: controller.emailC,
                  ),
                  20.height,
                  PPTextfield(
                    controller: controller.passwordC,
                    textFieldType: TextFieldType.PASSWORD,
                    validator: (value) =>
                        value.isEmptyOrNull ? 'This field is required!' : null,
                    label: "Password",
                    isBordered: true,
                    borderRadius: 12,
                    isZeroPadding: false,
                    icon: Icon(Icons.lock),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      child: Text("Forgot Password?"),
                      onPressed: () {
                        Get.toNamed(Routes.AUTH_FORGET_PASSWORD);
                      },
                    ),
                  ),
                  Container(
                    width: Get.width,
                    child: Obx(
                      () => ElevatedButton(
                        onPressed: controller.isLoading
                            ? null
                            : () {
                                if (controller.formKey.currentState
                                        ?.validate() ??
                                    false) {
                                  controller.signIn();
                                }
                              },
                        style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.all(16),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12))),
                        child: controller.isLoading
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator())
                            : Text(
                                "Sign In",
                              ),
                      ),
                    ),
                  ),
                  16.height,
                  TextButton(
                    onPressed: () {
                      Get.offNamed(Routes.AUTH_SIGN_UP);
                    },
                    child: Text(
                      "Didn't have an account? \nRegister Here!",
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            //     )
            //   ],
            // ),
            // ),
          ),
        ),
      ),
    );
  }
}
