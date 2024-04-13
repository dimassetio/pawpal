import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pawpal/app/data/helpers/assets.dart';
import 'package:pawpal/app/data/helpers/themes.dart';
import 'package:pawpal/app/data/widgets/app_bar.dart';
import 'package:pawpal/app/data/widgets/text_field.dart';

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
                          backgroundImage: AssetImage(img_logo),
                        ),
                        16.width,
                        Text(
                          "Person Name",
                          style: textTheme(context).titleMedium,
                        ),
                      ],
                    ),
                  ),
                  title: "Chats Detail"),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Card(
                        color: clrLightGrey,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 2, horizontal: 8),
                            child: Text("Today")),
                      ),
                      16.height,
                      BubbleChat(
                        isOpposite: false,
                        message:
                            "Sampel Messages in two lines. Sampel Messages in two lines.",
                        time: "8.43 am",
                      ),
                      16.height,
                      BubbleChat(
                        isOpposite: true,
                        message: "Sampel Messages in one lines.",
                        time: "8.43 am",
                      ),
                      16.height,
                      BubbleChat(
                        isOpposite: true,
                        message: "Sampel Messages in one lines.",
                        time: "8.43 am",
                      ),
                      16.height,
                      BubbleChat(
                        isOpposite: false,
                        message: "Sampel Messages with media. (soon)",
                        time: "8.43 am",
                      ),
                      16.height,
                      BubbleChat(
                        isOpposite: false,
                        message: "Sampel Messages with media. (soon)",
                        time: "8.43 am",
                      ),
                      16.height,
                      BubbleChat(
                        isOpposite: false,
                        message: "Sampel Messages with media. (soon)",
                        time: "8.43 am",
                      ),
                      16.height,
                      BubbleChat(
                        isOpposite: false,
                        message: "Sampel Messages with media. (soon)",
                        time: "8.43 am",
                      ),
                      16.height,
                      BubbleChat(
                        isOpposite: false,
                        message: "Sampel Messages with media. (soon)",
                        time: "8.43 am",
                      ),
                      16.height,
                      BubbleChat(
                        isOpposite: false,
                        message: "Sampel Messages with media. (soon)",
                        time: "8.43 am",
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(32),
                  ),
                  color: clrLightGrey),
              child: Row(
                children: [
                  Expanded(
                    child: PPTextfield(
                      isBordered: true,
                      fillColor: clr_white,
                      hint: "Write a message",
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
                      child: IconButton(
                          onPressed: () {}, icon: Icon(Icons.send_rounded)))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BubbleChat extends StatelessWidget {
  const BubbleChat({
    super.key,
    required this.isOpposite,
    required this.message,
    required this.time,
    this.mediaUrl,
  });

  final bool isOpposite;
  final String message;
  final String time;
  final String? mediaUrl;

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
            Text(
              message,
              textAlign: isOpposite ? TextAlign.left : TextAlign.right,
              style: textTheme(context)
                  .bodyMedium
                  ?.copyWith(color: isOpposite ? null : clr_white),
            ),
            4.height,
            Text(
              time,
              textAlign: isOpposite ? TextAlign.left : TextAlign.right,
              style: textTheme(context)
                  .labelMedium
                  ?.copyWith(color: isOpposite ? null : clrLightGrey),
            ),
          ],
        ),
      ),
    );
  }
}
