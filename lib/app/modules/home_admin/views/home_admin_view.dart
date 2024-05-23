import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pawpal/app/data/helpers/assets.dart';
import 'package:pawpal/app/data/helpers/formatter.dart';
import 'package:pawpal/app/data/helpers/themes.dart';
import 'package:pawpal/app/data/widgets/bottom_bar.dart';
import 'package:pawpal/app/modules/adoption/views/adoption_view.dart';
import 'package:pawpal/app/modules/auth/controllers/auth_controller.dart';
import 'package:pawpal/app/modules/home/views/home_view.dart';
import 'package:pawpal/app/routes/app_pages.dart';

import '../controllers/home_admin_controller.dart';

class HomeAdminView extends GetView<HomeAdminController> {
  const HomeAdminView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                      "PawPal Admin",
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
                16.height,
                TextButton(
                  style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 8)),
                  child: Text(
                    "Carousel Settings",
                    style: textTheme(context)
                        .titleMedium
                        ?.copyWith(decoration: TextDecoration.underline),
                  ),
                  onPressed: () {
                    Get.toNamed(Routes.CAROUSEL);
                  },
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 16),
                  child: Obx(
                    () => controller.banners.isEmpty
                        ? Text("Banner is empty")
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
                          ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Post Approval",
                      style: textTheme(context).titleMedium,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                          color: primaryColor(context),
                          borderRadius: BorderRadius.circular(32)),
                      child: Text(
                        "${controller.postRequests.length}",
                        style: textTheme(context)
                            .labelMedium
                            ?.copyWith(color: clr_white),
                      ),
                    )
                  ],
                ),
                16.height,
                Obx(
                  () => controller.isLoading
                      ? LinearProgressIndicator()
                      : controller.postRequests.isEmpty
                          ? Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 16),
                              decoration: BoxDecoration(
                                color: primaryColor(context),
                                borderRadius: BorderRadius.circular(32),
                              ),
                              child: Text(
                                'No waiting approval at the moment',
                                style: textTheme(context)
                                    .labelMedium
                                    ?.copyWith(color: clr_white),
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: ScrollPhysics(),
                              itemCount: controller.postRequests.length,
                              itemBuilder: (context, index) {
                                var pet = controller.postRequests[index];
                                return PetAdoptionCard(pet: pet);
                              },
                            ),
                ),
                16.height,
                Text(
                  "All Post",
                  style: textTheme(context).titleMedium,
                ),
                16.height,
                Obx(
                  () => ListView.separated(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    separatorBuilder: (context, index) => 16.height,
                    itemCount: controller.allPost.length,
                    itemBuilder: (context, index) {
                      var pet = controller.allPost[index];
                      return PetCard(pet: pet);
                    },
                  ),
                ),
                16.height,
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    child: Text("View more"),
                    onPressed: () {
                      controller.addLimit();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: PPBottomNavbar(
        currentIndex: 0,
      ),
    );
  }
}
