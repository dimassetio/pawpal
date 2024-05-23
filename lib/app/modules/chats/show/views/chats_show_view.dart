import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pawpal/app/data/helpers/assets.dart';
import 'package:pawpal/app/data/helpers/formatter.dart';
import 'package:pawpal/app/data/helpers/themes.dart';
import 'package:pawpal/app/data/models/message_model.dart';
import 'package:pawpal/app/data/models/pet_model.dart';
import 'package:pawpal/app/data/widgets/app_bar.dart';
import 'package:pawpal/app/data/widgets/text_field.dart';
import 'package:pawpal/app/modules/auth/controllers/auth_controller.dart';

import '../controllers/chats_show_controller.dart';

class ChatsShowView extends GetView<ChatsShowController> {
  const ChatsShowView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          // scrollable: true,
          children: [
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: clrLightGrey,
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(32))),
              child: PPAppBar(
                  titleWidget: Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        16.width,
                        CircleAvatar(
                          foregroundImage:
                              (controller.chats.receiver?.foto?.isEmptyOrNull ??
                                      true)
                                  ? null
                                  : CachedNetworkImageProvider(
                                      controller.chats.receiver!.foto!),
                          backgroundImage: AssetImage(img_logo),
                        ),
                        16.width,
                        Text(
                          controller.chats.receiver?.username ?? "Person Name",
                          style: textTheme(context).titleMedium,
                        ),
                      ],
                    ),
                  ),
                  title: "Chats Detail"),
            ),
            // Obx(() => Text(controller.messages.length.toString())),
            Expanded(
              child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: Obx(() => ListView.builder(
                        itemCount: controller.messages.length,
                        shrinkWrap: true,
                        controller: controller.scrollC,
                        reverse: true,
                        itemBuilder: (context, index) {
                          var message = controller.messages[index];

                          return Column(
                            children: [
                              if (index == (controller.messages.length - 1) ||
                                  !isSameDay(
                                      message.dateCreated,
                                      controller
                                          .messages[index + 1].dateCreated))
                                Card(
                                  color: clrLightGrey,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16)),
                                  margin: EdgeInsets.only(top: 16),
                                  child: Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 2, horizontal: 8),
                                      child: Text(isSameDay(message.dateCreated,
                                              DateTime.now())
                                          ? "Today"
                                          : dateFormatter(
                                              message.dateCreated))),
                                ),
                              BubbleChat(
                                message: message,
                              ).marginOnly(
                                  top: 16, bottom: index == 0 ? 16 : 0),
                            ],
                          );
                        },
                      ))),
            ),
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(32),
                  ),
                  color: clrLightGrey),
              child: Column(
                children: [
                  Obx(() => controller.pet is PetModel
                      ? PetTile(
                          pet: controller.pet!,
                        ).marginOnly(bottom: 8)
                      : SizedBox()),
                  Row(
                    children: [
                      Expanded(
                        child: PPTextfield(
                          isBordered: true,
                          fillColor: clr_white,
                          controller: controller.messageC,
                          focus: controller.focus,
                          hint: "Write a message",
                          inputAction: TextInputAction.send,
                          onSubmit: controller.isLoading
                              ? null
                              : (v) {
                                  if (controller.messageC.text.isNotEmpty) {
                                    controller.sendMessage();
                                  }
                                },
                          padding: EdgeInsets.symmetric(horizontal: 16),
                        ),
                      ),
                      Card(
                          margin: EdgeInsets.only(left: 16),
                          color: clr_white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32),
                          ),
                          // decoration: BoxDecoration(
                          //   // color: primaryColor(context),
                          // ),
                          child: Obx(
                            () => IconButton(
                                onPressed: controller.isLoading
                                    ? null
                                    : () {
                                        if (controller
                                            .messageC.text.isNotEmpty) {
                                          controller.sendMessage();
                                        }
                                      },
                                icon: controller.isLoading
                                    ? CircularProgressIndicator()
                                    : Icon(Icons.send_rounded)),
                          ))
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PetTile extends StatelessWidget {
  const PetTile({super.key, required this.pet, this.color});
  final PetModel pet;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: SizedBox(
        height: 60,
        width: 60,
        child: pet.media.isEmptyOrNull
            ? Image.asset(
                img_logo,
                fit: BoxFit.cover,
              )
            : CachedNetworkImage(imageUrl: pet.media!, fit: BoxFit.cover),
      ),
      // trailing: IconButton(
      //     onPressed: () {
      //       pet= null;
      //     },
      //     icon: Icon(Icons.close)),
      // tileColor: Colors.white.withOpacity(0.2),

      textColor: color,
      title: Text(pet.title ?? ''),
      subtitle: Text(pet.description ?? ''),
    );
  }
}

class BubbleChat extends StatelessWidget {
  const BubbleChat({
    super.key,
    required this.message,
    // required this.isOpposite,
    // required this.message,
    // required this.time,
    // this.mediaUrl,
    // this.isRead = false,
  });
  final MessageModel message;

  bool get isOpposite => message.senderId != authC.user.id;
  // final bool isOpposite;
  // final String message;
  // final String time;
  // final String? mediaUrl;
  // final bool isRead;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isOpposite ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isOpposite ? clrLightGrey : primaryColor(context),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(18),
            bottomLeft: isOpposite ? Radius.zero : Radius.circular(18),
            bottomRight: isOpposite ? Radius.circular(18) : Radius.zero,
          ),
        ),
        child: Column(
          crossAxisAlignment:
              isOpposite ? CrossAxisAlignment.start : CrossAxisAlignment.end,
          children: [
            if (message.petReference != null)
              FutureBuilder<PetModel?>(
                future: PetModel.getFromRef(message.petReference!),
                builder: (context, snapshot) => snapshot.data is PetModel
                    ? PetTile(
                        pet: snapshot.data!,
                        color: isOpposite ? null : clr_white,
                      )
                    : SizedBox(),
              ),
            if (message.petReference != null)
              Divider(
                height: 0,
                thickness: 1,
              ).marginOnly(bottom: 2),
            // Text(message.petReference!.id ?? "null"),
            Text(
              message.text ?? '',
              textAlign: isOpposite ? TextAlign.left : TextAlign.right,
              style: textTheme(context)
                  .bodyMedium
                  ?.copyWith(color: isOpposite ? null : clr_white),
            ),
            4.height,
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  timeFormatter(message.dateCreated),
                  textAlign: isOpposite ? TextAlign.left : TextAlign.right,
                  style: textTheme(context)
                      .labelMedium
                      ?.copyWith(color: isOpposite ? null : clrLightGrey),
                ),
                if (!isOpposite && (message.isRead ?? false))
                  Icon(
                    Icons.check,
                    size: 14,
                    color: isOpposite ? null : clrLightGrey,
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
