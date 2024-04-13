// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pawpal/app/data/helpers/assets.dart';
import 'package:pawpal/app/data/helpers/themes.dart';
import 'package:pawpal/app/data/widgets/app_bar.dart';
import 'package:pawpal/app/data/widgets/bottom_bar.dart';
import 'package:pawpal/app/data/widgets/main_container.dart';
import 'package:pawpal/app/data/widgets/text_field.dart';
import 'package:pawpal/app/routes/app_pages.dart';

import '../controllers/chats_controller.dart';

class ChatsView extends GetView<ChatsController> {
  const ChatsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PPMainContainer(
        scrollable: true,
        children: [
          PPAppBar(title: "Chats"),
          16.height,
          PPTextfield(
            icon: Icon(Icons.search),
            isBordered: true,
            label: "Search names",
          ),
          16.height,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(right: 16),
                width: 72,
                child: Column(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(36),
                        color: clrLightGrey,
                        border:
                            Border.all(color: primaryColor(context), width: 2),
                      ),
                      child: Icon(
                        Icons.add_rounded,
                        size: 48,
                        color: primaryColor(context),
                      ),
                    ),
                    8.height,
                    Text(
                      "Add New",
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 16),
                width: 72,
                child: Column(
                  children: [
                    Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(36),
                          color: clrLightGrey,
                          border: Border.all(
                              color: primaryColor(context), width: 2),
                        ),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(36),
                            child: Image.asset(img_logo))),
                    8.height,
                    Text(
                      "Person Name",
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Divider(
            height: 20,
          ),
          PPChatCard(),
          Divider(
            height: 10,
            thickness: 1,
          ),
          PPChatCard(),
          Divider(
            height: 10,
            thickness: 1,
          ),
        ],
      ),
      bottomNavigationBar: PPBottomNavbarUser(currentIndex: 2),
    );
  }
}

class PPChatCard extends StatelessWidget {
  const PPChatCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: AssetImage(img_logo),
        radius: 32,
      ),
      contentPadding: EdgeInsets.zero,
      title: Text("Person Name"),
      subtitle: Text("Preview messages"),
      trailing: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
            color: primaryColor(context),
            borderRadius: BorderRadius.circular(32)),
        child: Text(
          "3",
          style: textTheme(context).labelMedium?.copyWith(color: clr_white),
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      onTap: () {
        Get.toNamed(Routes.CHATS_SHOW);
      },
    );
  }
}
