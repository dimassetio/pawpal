import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:pawpal/app/data/helpers/assets.dart';
import 'package:pawpal/app/data/helpers/themes.dart';
import 'package:pawpal/app/data/helpers/validator.dart';
import 'package:pawpal/app/data/widgets/text_field.dart';
import 'package:pawpal/app/routes/app_pages.dart';
import 'package:nb_utils/nb_utils.dart';

import '../controllers/auth_sign_up_controller.dart';

class AuthSignUpView extends GetResponsiveView<AuthSignUpController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

        // appBar: AppBar(
        //   title: const Text('AuthSignUpView'),
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
                Text(
                  "Sign Up",
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
                  isZeroPadding: false,
                  controller: controller.nameC,
                  validator: requiredValidator,
                  label: "Name",
                  isBordered: true,
                  borderRadius: 12,
                  icon: Icon(Icons.account_circle_rounded),
                ),
                16.height,
                PPTextfield(
                  isZeroPadding: false,
                  controller: controller.emailC,
                  validator: emailValidator,
                  label: "Email",
                  borderRadius: 12,
                  isBordered: true,
                  icon: Icon(Icons.email_rounded),
                ),
                16.height,
                PPTextfield(
                  isZeroPadding: false,
                  controller: controller.passwordC,
                  validator: (value) => minLengthValidator(value, 6),
                  textFieldType: TextFieldType.PASSWORD,
                  label: "Password",
                  borderRadius: 12,
                  isBordered: true,
                  icon: Icon(Icons.lock),
                ),
                16.height,
                PPTextfield(
                  isZeroPadding: false,
                  controller: controller.confirmPasswordC,
                  textFieldType: TextFieldType.PASSWORD,
                  label: "Confirm Password",
                  borderRadius: 12,
                  isBordered: true,
                  icon: Icon(Icons.lock),
                  validator: (value) => controller.confirmPasswordC.text ==
                          controller.passwordC.text
                      ? null
                      : "Password does not match!",
                ),
                20.height,
                Container(
                  width: Get.width,
                  child: Obx(
                    () => ElevatedButton(
                      onPressed: controller.isLoading
                          ? null
                          : () {
                              if (controller.formKey.currentState?.validate() ??
                                  false) {
                                controller.signUp();
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
                              "Sign Up",
                            ),
                    ),
                  ),
                ),
                16.height,
                TextButton(
                  onPressed: () {
                    Get.offNamed(Routes.AUTH_SIGN_IN);
                  },
                  child: Text(
                    "Already have an account? \nLogin Here!",
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
