import 'package:flutter/material.dart';
import 'package:pawpal/app/data/helpers/themes.dart';

class PPCardColumn extends StatelessWidget {
  PPCardColumn(
      {this.children = const [],
      this.padding = 16,
      this.margin,
      this.height,
      this.width,
      this.radius,
      this.elevation,
      this.color,
      this.crossAxis,
      this.mainAxis});
  final List<Widget> children;
  final double padding;
  final double? height;
  final double? width;
  final double? radius;
  final double? elevation;
  final Color? color;
  final EdgeInsetsGeometry? margin;
  final MainAxisAlignment? mainAxis;
  final CrossAxisAlignment? crossAxis;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: margin ?? EdgeInsets.zero,
      color: color ?? clr_white,
      elevation: elevation ?? 2,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius ?? 16)),
      child: Container(
        height: height,
        alignment: Alignment.centerLeft,
        width: width,
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: crossAxis ?? CrossAxisAlignment.start,
          mainAxisAlignment: mainAxis ?? MainAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }
}
