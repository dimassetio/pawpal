import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawpal/app/data/helpers/themes.dart';

class PPAppBar extends StatelessWidget {
  const PPAppBar({
    super.key,
    required this.title,
    this.trailingIcon,
    this.onBack,
    this.trailingFunction,
    this.titleWidget,
  });
  final String title;
  final Widget? titleWidget;
  final void Function()? onBack;
  final void Function()? trailingFunction;
  final Icon? trailingIcon;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          color: clrLightGrey,
          margin: EdgeInsets.zero,
          child: IconButton(
            onPressed: onBack ??
                () {
                  Get.back();
                },
            icon: Icon(
              Icons.chevron_left_rounded,
            ),
          ),
        ),
        titleWidget ??
            Text(
              title,
              style: textTheme(context).titleMedium,
            ),
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          color: clrLightGrey,
          margin: EdgeInsets.zero,
          child: IconButton(
            onPressed: trailingFunction ?? () {},
            icon: trailingIcon ??
                Icon(
                  Icons.more_horiz_rounded,
                ),
          ),
        ),
      ],
    );
  }
}
