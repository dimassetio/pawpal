import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pawpal/app/data/helpers/assets.dart';
import 'package:pawpal/app/data/helpers/themes.dart';
import 'package:pawpal/app/data/widgets/app_bar.dart';

import '../controllers/pet_show_controller.dart';

class PetShowView extends GetView<PetShowController> {
  const PetShowView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              color: theme(context).colorScheme.secondary,
              width: Get.width,
              child: InkWell(
                onTap: () {
                  toast("TAPPED");
                  print("TAPPED");
                },
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Image.asset(img_dog),
                ),
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: PPAppBar(
                    title: "Pet Detail",
                    titleWidget: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                      decoration: BoxDecoration(
                        color: clr_white,
                        borderRadius: BorderRadius.circular(32),
                      ),
                      child: Text("Pet Detail"),
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      margin: EdgeInsets.only(top: Get.width - 120),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(32),
                          ),
                          color: clr_white),
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Pet Name",
                            style: textTheme(context).titleMedium,
                          ),
                          4.height,
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
                          16.height,
                          Row(
                            children: [
                              // AspectRatio(
                              //   aspectRatio: 1,
                              //   child:
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 16),
                                padding: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: clrPastelPink,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Column(
                                  children: [
                                    Text("Male"),
                                    8.height,
                                    Text(
                                      "Gender",
                                      style: textTheme(context)
                                          .bodySmall
                                          ?.copyWith(color: secondTextColor),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 16),
                                padding: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: clrPastelGreen,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Column(
                                  children: [
                                    Text("Male"),
                                    8.height,
                                    Text(
                                      "Gender",
                                      style: textTheme(context)
                                          .bodySmall
                                          ?.copyWith(color: secondTextColor),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 16),
                                padding: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: clrPastelBlue,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Column(
                                  children: [
                                    Text("Male"),
                                    8.height,
                                    Text(
                                      "Gender",
                                      style: textTheme(context)
                                          .bodySmall
                                          ?.copyWith(color: secondTextColor),
                                    ),
                                  ],
                                ),
                              ),
                              // )
                            ],
                          ),
                          16.height,
                          Container(
                            decoration: BoxDecoration(
                                color: clrLightGrey,
                                borderRadius: BorderRadius.circular(20)),
                            padding: EdgeInsets.all(8),
                            child: Row(
                              children: [
                                SizedBox(
                                  height: 72,
                                  width: 72,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.asset(img_logo),
                                  ),
                                ),
                                12.width,
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Person Name"),
                                      Text(
                                        "Short Description sdoasjdo saodn aosd asd asdn osadn odn n",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: textTheme(context)
                                            .bodySmall
                                            ?.copyWith(color: secondTextColor),
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
                                            "User Location",
                                            style: textTheme(context)
                                                .bodySmall
                                                ?.copyWith(
                                                    color: secondTextColor),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 16),
                            child: Text(
                              "Description",
                              style: textTheme(context).titleMedium,
                            ),
                          ),
                          Text(
                            "Description of the pets. it just a demo. Description of the pets. Description of the pets. it just a demo.  it just a demo. ",
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 16),
                            child: Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.all(12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                    onPressed: () {},
                                    child: Text("Adopt Now"),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
