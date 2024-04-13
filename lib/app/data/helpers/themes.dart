import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Color mainColor = Color(0XFFF59566);
Color secondaryColor = Color(0XFFFFDBC9);
Color bgColor = Color(0XFFFFFFFF);
// Color bgColor = Color(0XFFF2F8FF);
Color textColor = Color(0XFF555555);
Color secondTextColor = Color(0XFF8C8C8C);
Color clrGrey = Color(0XFFD9D9D9);
Color clrLightGrey = Color(0XFFF5F5F5);
Color clrPastelPink = Color(0XFFFEECE2);
Color clrPastelGreen = Color(0XFFD6FFD2);
Color clrPastelBlue = Color(0XFFD6F3FF);

Color clr_white = Color(0XFFFFFFFF);

ThemeData mainTheme = ThemeData.from(
    colorScheme: ColorScheme(
  brightness: Brightness.light,
  primary: mainColor,
  onPrimary: clr_white,
  secondary: secondaryColor,
  onSecondary: textColor,
  error: Colors.red[600]!,
  onError: clr_white,
  background: bgColor,
  onBackground: textColor,
  surface: clr_white,
  onSurface: textColor,
)).copyWith(textTheme: GoogleFonts.poppinsTextTheme(), dividerColor: clrGrey);
// ThemeData.from(colorScheme: ColorScheme.fromSeed(seedColor: mainColor));

ThemeData theme(context) => Theme.of(context);
TextTheme textTheme(context) => Theme.of(context).textTheme;
Color primaryColor(context) => theme(context).primaryColor;
