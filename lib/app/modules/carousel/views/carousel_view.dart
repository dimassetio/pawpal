import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pawpal/app/data/widgets/app_bar.dart';
import 'package:pawpal/app/data/widgets/card_column.dart';
import 'package:pawpal/app/data/widgets/main_container.dart';
import 'package:pawpal/app/routes/app_pages.dart';

import '../controllers/carousel_controller.dart';

class CarouselView extends GetView<CarouselController> {
  const CarouselView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Get.toNamed(Routes.CAROUSEL_FORM);
          }),
      body: PPMainContainer(
        scrollable: true,
        children: [
          PPAppBar(title: "Carousel Banner List"),
          16.height,
          Obx(
            () => ListView.builder(
              shrinkWrap: true,
              physics: ScrollPhysics(),
              itemCount: controller.banners.length,
              itemBuilder: (context, index) => InkWell(
                onTap: () => Get.toNamed(Routes.CAROUSEL_FORM,
                    arguments: controller.banners[index]),
                child: PPCardColumn(
                  padding: 0,
                  children: [
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: CachedNetworkImage(
                          imageUrl: controller.banners[index].image ?? '',
                          errorWidget: (context, url, error) =>
                              Text(" Error: $error, \n Url: $url"),
                        ),
                      ),
                    ),
                  ],
                  margin: EdgeInsets.only(bottom: 16),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
