// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:pawpal/app/data/helpers/assets.dart';
import 'package:pawpal/app/data/helpers/formatter.dart';
import 'package:pawpal/app/data/helpers/themes.dart';
import 'package:pawpal/app/data/widgets/bottom_bar.dart';
import 'package:pawpal/app/data/widgets/card_column.dart';
import 'package:nb_utils/nb_utils.dart';

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
                    InkWell(
                      onTap: () {},
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: Row(
                          children: [
                            Icon(
                              Icons.location_on_rounded,
                              color: primaryColor(context),
                            ),
                            12.width,
                            Text("Malang"),
                            12.width,
                            Icon(
                              Icons.keyboard_arrow_down_rounded,
                            )
                          ],
                        ),
                      ),
                    ),
                    Card(
                      margin: EdgeInsets.zero,
                      child: IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.search,
                            color: primaryColor(context),
                          )),
                    )
                  ],
                ),
                8.height,
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    radius: 24,
                  ),
                  title: Text(
                    "Hi Dimas,",
                    style: textTheme(context).titleMedium,
                  ),
                  subtitle: Text(
                    "Good ${getTimeCategory()}!",
                  ),
                ),
                8.height,
                Container(
                  // Remove color soon
                  // color: primaryColor(context),
                  child: CarouselSlider.builder(
                    itemCount: controller.carouselImages.length,
                    itemBuilder: (context, index, realIndex) =>
                        Image.asset(controller.carouselImages[index]),
                    options: CarouselOptions(
                        autoPlay: true,
                        aspectRatio: 19 / 9,
                        viewportFraction: 0.9),
                  ),
                ),
                16.height,
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
                        return Obx(
                          () => Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                            margin: EdgeInsets.only(bottom: 8, right: 16),
                            child: Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40),
                                color: controller.selectedCategory == index
                                    ? primaryColor(context)
                                    : clrLightGrey,
                              ),
                              width: 76,
                              // child:
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    radius: 26,
                                    backgroundColor: clrGrey,
                                    foregroundImage: AssetImage(
                                        controller.categoryItems[index][0]),
                                  ),
                                  12.height,
                                  Text(
                                    controller.categoryItems[index][1],
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
                        );
                      }),
                ),
                16.height,
                GridView.builder(
                  itemCount: 4,
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 3 / 4),
                  itemBuilder: (context, index) => PetCard(),
                ),
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
  const PetCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return PPCardColumn(
      children: [
        Container(
          child: AspectRatio(
            aspectRatio: 1,
            child: Image.asset(img_dog),
          ),
        ),
        8.height,
        Text(
          "Pet Name",
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
            Text(
              "Pet Location",
              style: textTheme(context)
                  .bodyMedium
                  ?.copyWith(color: secondTextColor),
            ),
          ],
        ),
      ],
    );
  }
}
