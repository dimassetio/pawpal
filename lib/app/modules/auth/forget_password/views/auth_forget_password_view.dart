import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:pawpal/app/data/helpers/assets.dart';
import 'package:pawpal/app/data/helpers/themes.dart';
import 'package:pawpal/app/data/helpers/validator.dart';
import 'package:nb_utils/nb_utils.dart';

import '../controllers/auth_forget_password_controller.dart';

class AuthForgetPasswordView extends GetView<AuthForgetPasswordController> {
  const AuthForgetPasswordView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: theme(context).scaffoldBackgroundColor,
          leadingWidth: Get.width,
          leading: Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
                onPressed: () {
                  Get.back();
                },
                label: Text("Kembali"),
                icon: Icon(
                  Icons.chevron_left_rounded,
                  color: primaryColor(context),
                )),
          ),
        ),
        body: SafeArea(
            child: Container(
          padding: EdgeInsets.all(20),
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Center(
              child: Form(
                key: controller.formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      svg_verification,
                      height: 200,
                    ),
                    16.height,
                    Text(
                      "Reset Password",
                      style: textTheme(context)
                          .titleLarge
                          ?.copyWith(color: primaryColor(context)),
                    ),
                    16.height,
                    Text(
                      "Masukkan email anda untuk mereset password",
                      style: textTheme(context).bodyMedium,
                    ),
                    16.height,
                    TextFormField(
                      controller: controller.emailC,
                      validator: emailValidator,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide()),
                          hintText: "EmailAnda@gmail.com",
                          isDense: true),
                    ),
                    16.height,
                    Obx(
                      () => ElevatedButton(
                        onPressed: controller.isLoading
                            ? null
                            : () async {
                                if (controller.formKey.currentState
                                        ?.validate() ??
                                    false) {
                                  if (await controller.resetPassword()) {
                                    Get.dialog(ResetPasswordDialog(
                                        controller: controller));
                                  }
                                }
                              },
                        style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                vertical: 16, horizontal: 64),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12))),
                        child: controller.isLoading
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator())
                            : Text(
                                "Reset",
                              ),
                      ),
                    ),
                    16.height,
                  ],
                ),
              ),
            ),
          ),
        )));
  }
}

class ResetPasswordDialog extends StatelessWidget {
  const ResetPasswordDialog({
    super.key,
    required this.controller,
  });

  final AuthForgetPasswordController controller;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        // alignment: Alignment.center,
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(svg_verification),
            Text(
              "Periksa Email Anda",
              textAlign: TextAlign.center,
              style: textTheme(context)
                  .titleMedium
                  ?.copyWith(color: primaryColor(context)),
            ),
            8.height,
            Text(
              "Kami telah mengirimkan email ke ${controller.emailC.text}. Silahkan periksa email anda dan ikuti langkah-langkahnya untuk mereset password",
              textAlign: TextAlign.center,
            ),
            16.height,
            ElevatedButton(
              onPressed: () {
                Get.back(closeOverlays: true);
              },
              child: Text("Kembali"),
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 64),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24))),
            )
          ],
        ),
      ),
    );
  }
}
