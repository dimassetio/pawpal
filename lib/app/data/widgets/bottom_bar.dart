// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawpal/app/data/helpers/themes.dart';
import 'package:pawpal/app/routes/app_pages.dart';

class PPBottomNavbar extends StatelessWidget {
  PPBottomNavbar({required this.currentIndex});
  final int currentIndex;
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        onTap: (index) {
          switch (index) {
            case 0:
              Get.toNamed(Routes.HOME_ADMIN);
              break;
            case 1:
              Get.toNamed(Routes.USERS);
              break;
            case 2:
              Get.toNamed(Routes.PROFILE);
              break;
            default:
              Get.snackbar("Error", "Unknown index");
          }
        },
        currentIndex: currentIndex,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.dashboard), label: "Dashboard"),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: "Users"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ]);
  }
}

class PPBottomNavbarUser extends StatelessWidget {
  PPBottomNavbarUser({required this.currentIndex});
  final int currentIndex;
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        onTap: (index) {
          switch (index) {
            case 0:
              Get.toNamed(Routes.HOME);
              break;
            case 1:
              Get.toNamed(Routes.ADOPTION);
              break;
            case 2:
              Get.toNamed(Routes.CHATS);
              break;
            case 3:
              Get.toNamed(Routes.PROFILE);
              break;
            default:
              Get.snackbar("Error", "Unknown index");
          }
        },
        currentIndex: currentIndex,
        selectedItemColor: primaryColor(context),
        unselectedItemColor: textColor,
        elevation: 16,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_rounded), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.pets_rounded), label: "Adoption"),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chats"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ]);
  }
}
