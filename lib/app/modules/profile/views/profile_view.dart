import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pawpal/app/data/helpers/assets.dart';
import 'package:pawpal/app/data/helpers/themes.dart';
import 'package:pawpal/app/data/models/user_model.dart';
import 'package:pawpal/app/data/widgets/app_bar.dart';
import 'package:pawpal/app/data/widgets/bottom_bar.dart';
import 'package:pawpal/app/data/widgets/card_column.dart';
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
          PPAppBar(title: "Profile"),
          16.height,
          // Profile Picture
          InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(75),
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
                      backgroundImage: AssetImage(img_logo),
                      radius: 46,
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Card(
                      margin: EdgeInsets.zero,
                      color: clr_white.withOpacity(0.9),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      child: Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: 4, horizontal: 8),
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
          16.height,
          PPCardColumn(
            color: clrLightGrey,
            children: [
              Text(
                "User Profile",
                style: textTheme(context).titleSmall,
              ),
              12.height,
              PPTextfield(
                label: "Name",
                isReadOnly: true,
                icon: Icon(Icons.person),
              ),
              12.height,
              PPTextfield(
                label: "Phone Number",
                isReadOnly: true,
                icon: Icon(Icons.phone_iphone_rounded),
              ),
              12.height,
              PPTextfield(
                label: "Email",
                isReadOnly: true,
                icon: Icon(Icons.email),
              ),
              12.height,
            ],
          ),
          16.height,
          PPCardColumn(
            color: clrLightGrey,
            children: [
              Text(
                "User Address",
                style: textTheme(context).titleSmall,
              ),
              12.height,
              PPTextfield(
                label: "Province",
                isReadOnly: true,
                icon: Icon(Icons.map_rounded),
              ),
              12.height,
              PPTextfield(
                label: "City / Region",
                isReadOnly: true,
                icon: Icon(Icons.map_rounded),
              ),
              12.height,
              PPTextfield(
                label: "Locality",
                isReadOnly: true,
                icon: Icon(Icons.map_rounded),
              ),
              12.height,
              PPTextfield(
                label: "Address Detail",
                isReadOnly: true,
                icon: Icon(Icons.map_rounded),
              ),
              12.height,
            ],
          ),
          16.height,
          PPCardColumn(
            padding: 0,
            color: clrLightGrey,
            children: [
              ListTile(
                title: Text("Sign Out"),
                leading: Icon(Icons.logout_rounded),
                onTap: () {
                  authC.signOut();
                },
              ),
            ],
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
