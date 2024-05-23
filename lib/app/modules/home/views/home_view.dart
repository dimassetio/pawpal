// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:pawpal/app/data/helpers/assets.dart';
import 'package:pawpal/app/data/helpers/formatter.dart';
import 'package:pawpal/app/data/helpers/themes.dart';
import 'package:pawpal/app/data/models/pet_model.dart';
import 'package:pawpal/app/data/widgets/bottom_bar.dart';
import 'package:pawpal/app/data/widgets/card_column.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pawpal/app/modules/auth/controllers/auth_controller.dart';
import 'package:pawpal/app/routes/app_pages.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      child: Image.asset(img_logo),
                      height: 48,
                      width: 48,
                    ),
                    Text(
                      "PawPal",
                      style: textTheme(context).headlineSmall,
                    ),
                    SizedBox(
                      width: 48,
                    )
                    // Card(
                    //   margin: EdgeInsets.zero,
                    //   child: IconButton(
                    //       onPressed: () {},
                    //       icon: Icon(
                    //         Icons.search,
                    //         color: primaryColor(context),
                    //       )),
                    // )
                  ],
                ),
                8.height,
                Obx(
                  () => ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      radius: 24,
                      child: Icon(Icons.person),
                      foregroundImage: authC.user.foto is String
                          ? CachedNetworkImageProvider(authC.user.foto!)
                          : null,
                    ),
                    title: Text(
                      "Hi ${authC.user.username ?? ''},",
                      style: textTheme(context).titleMedium,
                    ),
                    subtitle: Text(
                      "Good ${getTimeCategory()}!",
                    ),
                  ),
                ),
                8.height,
                InkWell(
                  onTap: () {
                    controller.getLocation();
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.location_on_rounded,
                          color: primaryColor(context),
                        ),
                        12.width,
                        Obx(
                          () => Expanded(
                            child: controller.isLoading
                                ? SizedBox(
                                    width: 60, child: LinearProgressIndicator())
                                : Text(
                                    controller.place == null
                                        ? "--Location Service Error--"
                                        : "${controller.place.locality}, ${controller.place.subAdministrativeArea}",
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Obx(
                  () => Container(
                      margin: EdgeInsets.all(8),
                      child: controller.banners.isEmpty
                          ? SizedBox()
                          : CarouselSlider.builder(
                              itemCount: controller.banners.length,
                              itemBuilder: (context, index, realIndex) {
                                return Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16)),
                                  margin: EdgeInsets.symmetric(horizontal: 8),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: CachedNetworkImage(
                                      fit: BoxFit.cover,
                                      imageUrl:
                                          controller.banners[index].image ?? '',
                                      errorWidget: (context, url, error) =>
                                          Text(" Error: $error, \n Url: $url"),
                                    ),
                                  ),
                                );
                              },
                              options: CarouselOptions(
                                  autoPlay: true,
                                  aspectRatio: 16 / 9,
                                  viewportFraction: 0.9),
                            )),
                ),
                8.height,
                Align(
                  alignment: Alignment.centerLeft,
                  child:
                      Text("Categories", style: textTheme(context).titleMedium),
                ),
                16.height,
                Container(
                  height: 120,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: controller.categoryItems.length,
                      physics: ScrollPhysics(),
                      itemBuilder: (context, index) {
                        var category = controller.categoryItems[index];

                        return Obx(
                          () => Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                            color: controller.selectedCategory == index
                                ? primaryColor(context)
                                : clrLightGrey,
                            margin: EdgeInsets.only(bottom: 8, right: 16),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(40),
                              onTap: () {
                                if (controller.selectedCategory != index) {
                                  controller.selectedCategory = index;
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                width: 76,
                                // child:
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      radius: 26,
                                      backgroundColor: clrGrey,
                                      foregroundImage: AssetImage(category[0]),
                                    ),
                                    12.height,
                                    Text(
                                      category[1],
                                      // "Reptile",
                                      style: textTheme(context)
                                          .bodyMedium
                                          ?.copyWith(
                                              color:
                                                  controller.selectedCategory ==
                                                          index
                                                      ? clr_white
                                                      : textColor),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                ),
                16.height,
                Obx(() => controller.petLoading
                    ? Container(
                        height: 32,
                        width: 32,
                        child: CircularProgressIndicator(),
                      )
                    : controller.filteredPet.isEmpty
                        ? PPCardColumn(
                            crossAxis: CrossAxisAlignment.center,
                            children: [
                                Image.asset(img_form_default),
                                8.height,
                                Text("Sorry, No Data Found")
                              ])
                        : ListView.builder(
                            itemCount: controller.filteredPet.length,
                            shrinkWrap: true,
                            physics: ScrollPhysics(),
                            itemBuilder: (context, index) =>
                                PetCard(pet: controller.filteredPet[index])
                                    .marginOnly(bottom: 16),
                          ))
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: PPBottomNavbarUser(
        currentIndex: 0,
      ),
    );
  }
}

class PetCard extends StatelessWidget {
  PetCard({
    super.key,
    required this.pet,
  });
  final PetModel pet;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.toNamed(Routes.PET_SHOW, arguments: pet),
      child: PPCardColumn(
        color: clrLightGrey,
        padding: 0,
        children: [
          Container(
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              child: pet.media.isEmptyOrNull
                  ? Image.asset(img_dog)
                  : CachedNetworkImage(imageUrl: pet.media!),
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pet.title ?? "Pet Name",
                        style: textTheme(context).titleSmall,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_rounded,
                            size: 16,
                            color: primaryColor(context),
                          ),
                          8.width,
                          Expanded(
                            child: Text(
                              "${pet.province}, ${pet.city}",
                              overflow: TextOverflow.ellipsis,
                              style: textTheme(context)
                                  .bodyMedium
                                  ?.copyWith(color: secondTextColor),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      Icons.monetization_on_rounded,
                      size: 16,
                      color: primaryColor(context),
                    ),
                    4.width,
                    Text(
                      currencyFormatter(pet.price?.toInt() ?? 0),
                      style: textTheme(context)
                          .bodyMedium
                          ?.copyWith(color: secondTextColor),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
