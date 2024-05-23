import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pawpal/app/data/helpers/assets.dart';
import 'package:pawpal/app/data/helpers/themes.dart';
import 'package:pawpal/app/data/models/user_model.dart';
import 'package:pawpal/app/data/widgets/app_bar.dart';
import 'package:pawpal/app/data/widgets/bottom_bar.dart';
import 'package:pawpal/app/data/widgets/card_column.dart';
import 'package:pawpal/app/data/widgets/form_foto.dart';
import 'package:pawpal/app/data/widgets/main_container.dart';
import 'package:pawpal/app/data/widgets/text_field.dart';
import 'package:pawpal/app/modules/auth/controllers/auth_controller.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PPMainContainer(
        scrollable: true,
        children: [
          Obx(
            () => PPAppBar(
              title: "Profile",
              trailingIcon: Icon(controller.isEdit ? Icons.cancel : Icons.edit),
              trailingFunction: () {
                if (controller.isEdit) {
                  controller.loadController();
                }
                controller.isEdit = !controller.isEdit;
              },
            ),
          ),
          16.height,
          // Profile Picture
          Obx(
            () => InkWell(
              borderRadius: BorderRadius.circular(75),
              onTap: controller.isEdit
                  ? () async {
                      controller.selectedFile =
                          await imagePickerBottomSheet(context);
                    }
                  : null,
              child: Container(
                margin: EdgeInsets.all(4),
                width: 100,
                height: 100,
                child: Stack(
                  children: [
                    Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: clrGrey,
                        borderRadius: BorderRadius.circular(75),
                      ),
                      child: CircleAvatar(
                        foregroundImage: (controller.selectedFile is XFile
                            ? kIsWeb
                                ? NetworkImage(controller.selectedFile!.path)
                                : FileImage(File(controller.selectedFile!.path))
                            : !authC.user.foto.isEmptyOrNull
                                ? CachedNetworkImageProvider(authC.user.foto!)
                                : null) as ImageProvider<Object>?,
                        backgroundImage: AssetImage(img_logo),
                        radius: 46,
                      ),
                    ),
                    if (controller.isEdit)
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Card(
                          margin: EdgeInsets.zero,
                          color: clr_white.withOpacity(0.9),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 8),
                              child: Icon(
                                Icons.camera_alt,
                                color: primaryColor(context),
                              )),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          16.height,
          Obx(
            () => Form(
              key: controller.isEdit ? controller.formKey : null,
              child: PPCardColumn(
                color: clrLightGrey,
                children: [
                  Text(
                    "User Profile",
                    style: textTheme(context).titleSmall,
                  ),
                  12.height,
                  Obx(
                    () => PPTextfield(
                      controller: controller.usernameC,
                      label: "Name",
                      isReadOnly: !controller.isEdit,
                      icon: Icon(Icons.person),
                    ),
                  ),
                  12.height,
                  Obx(
                    () => PPTextfield(
                      controller: controller.phoneC,
                      label: "Phone Number",
                      textFieldType: TextFieldType.PHONE,
                      isReadOnly: !controller.isEdit,
                      icon: Icon(Icons.phone_iphone_rounded),
                    ),
                  ),
                  12.height,
                  PPTextfield(
                    controller: controller.emailC,
                    label: "Email",
                    textFieldType: TextFieldType.EMAIL,
                    isReadOnly: true,
                    icon: Icon(Icons.email),
                  ),
                  12.height,
                  Obx(
                    () => PPTextfield(
                      controller: controller.bioC,
                      label: "Bio",
                      isReadOnly: !controller.isEdit,
                      textFieldType: TextFieldType.MULTILINE,
                      icon: Icon(Icons.description),
                    ),
                  ),
                  12.height,
                  Obx(
                    () => PPTextfield(
                      label: "Address Detail",
                      isReadOnly: !controller.isEdit,
                      controller: controller.addressC,
                      icon: Icon(Icons.map_rounded),
                      suffixIcon: !controller.isEdit
                          ? null
                          : IconButton(
                              onPressed: controller.locationLoading
                                  ? null
                                  : () {
                                      controller.loadLocation();
                                    },
                              icon: controller.locationLoading
                                  ? CircularProgressIndicator()
                                  : Icon(Icons.location_searching_rounded)),
                    ),
                  ),
                  12.height,
                ],
              ),
            ),
          ),
          16.height,

          Obx(
            () => PPCardColumn(
              padding: 0,
              color: controller.isEdit ? primaryColor(context) : clrLightGrey,
              children: [
                controller.isEdit
                    ? ListTile(
                        title: Text("Save"),
                        leading: controller.isLoading
                            ? CircularProgressIndicator(
                                color: clr_white,
                              )
                            : Icon(Icons.save),
                        iconColor: clr_white,
                        textColor: clr_white,
                        onTap: controller.isLoading
                            ? null
                            : () {
                                if (controller.formKey.currentState
                                        ?.validate() ??
                                    false) {
                                  controller.save();
                                }
                              },
                      )
                    : ListTile(
                        title: Text("Sign Out"),
                        leading: Icon(Icons.logout_rounded),
                        onTap: () {
                          authC.signOut();
                        },
                      ),
              ],
            ),
          ),
          16.height
        ],
      ),
      bottomNavigationBar: authC.user.hasRole(Role.user)
          ? PPBottomNavbarUser(
              currentIndex: 3,
            )
          : PPBottomNavbar(
              currentIndex: 2,
            ),
    );
  }
}
