// ignore_for_file: prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pawpal/app/data/helpers/assets.dart';
import 'package:pawpal/app/data/helpers/themes.dart';
import 'package:pawpal/app/data/models/chats_model.dart';
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
          Obx(
            () => PPTextfield(
              icon: Icon(Icons.search),
              isBordered: true,
              label: "Search names",
              controller: controller.searchC,
              suffixIcon: controller.searchV.isNotEmpty
                  ? IconButton(
                      onPressed: () {
                        controller.searchC.clear();
                        FocusScope.of(context).unfocus();
                      },
                      icon: Icon(Icons.clear))
                  : null,
            ),
          ),
          16.height,
          Obx(
            () => controller.isLoading
                ? LinearProgressIndicator()
                : ListView.builder(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemCount: controller.chats.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          FutureBuilder<ChatsModel>(
                              future: controller.loadChat(index),
                              builder: (context, snapshot) {
                                return Obx(() {
                                  if (controller.searchV.isNotEmpty) {
                                    if (!((snapshot.data ??
                                                controller.chats[index])
                                            .receiver
                                            ?.username
                                            ?.toLowerCase()
                                            .contains(controller.searchV
                                                .toLowerCase()) ??
                                        false)) {
                                      return SizedBox();
                                    }
                                  }

                                  return PPChatCard(
                                      isLoading: snapshot.connectionState ==
                                          ConnectionState.waiting,
                                      chat: snapshot.data ??
                                          controller.chats[index]);
                                });
                              }),
                          Divider(
                            height: 10,
                            thickness: 1,
                          ),
                        ],
                      );
                    }),
          ),
        ],
      ),
      bottomNavigationBar: PPBottomNavbarUser(currentIndex: 2),
    );
  }
}

class PPChatCard extends StatelessWidget {
  PPChatCard({
    super.key,
    this.isLoading = false,
    required this.chat,
  });

  final ChatsModel chat;
  final bool isLoading;
  final unreadCount = 0.obs;

  @override
  Widget build(BuildContext context) {
    unreadCount.value = chat.unreadCount ?? 0;
    return ListTile(
      leading: CircleAvatar(
        foregroundImage: (chat.receiver?.foto.isEmptyOrNull ?? true)
            ? null
            : CachedNetworkImageProvider(chat.receiver!.foto!),
        backgroundImage: AssetImage(img_logo),
        radius: 32,
      ),
      contentPadding: EdgeInsets.zero,
      title: isLoading
          ? LinearProgressIndicator(
              color: textColor,
            )
          : Text(chat.receiver?.username ?? "Person Name"),
      subtitle: isLoading
          ? LinearProgressIndicator(
              color: textSecondaryColor,
            )
          : Text((chat.messages?.isEmpty ?? true)
              ? "Preview messages"
              : chat.messages?.first.text ?? ''),
      trailing: Obx(
        () => unreadCount.value > 0
            ? Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                    color: primaryColor(context),
                    borderRadius: BorderRadius.circular(32)),
                child: Text(
                  "${unreadCount.value}",
                  style: textTheme(context)
                      .labelMedium
                      ?.copyWith(color: clr_white),
                ),
              )
            : SizedBox(),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      onTap: () {
        unreadCount.value = 0;
        Get.toNamed(Routes.CHATS_SHOW, arguments: chat);
      },
    );
  }
}
