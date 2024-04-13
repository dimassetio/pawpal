import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pawpal/app/data/helpers/assets.dart';
import 'package:pawpal/app/data/helpers/formatter.dart';
import 'package:pawpal/app/data/helpers/themes.dart';
import 'package:pawpal/app/data/widgets/app_bar.dart';
import 'package:pawpal/app/data/widgets/bottom_bar.dart';
import 'package:pawpal/app/data/widgets/main_container.dart';
import 'package:pawpal/app/routes/app_pages.dart';

import '../controllers/adoption_controller.dart';

class AdoptionView extends GetView<AdoptionController> {
  const AdoptionView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: PPMainContainer(
          scrollable: false,
          children: [
            PPAppBar(
              title: "Adoption History",
            ),
            16.height,
            Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: clrLightGrey,
              ),
              child: TabBar(
                labelColor: primaryColor(context),
                unselectedLabelColor: textColor,
                indicator: BoxDecoration(
                    color: clr_white, borderRadius: BorderRadius.circular(16)),
                tabs: [
                  Tab(text: 'Adoption Request'),
                  Tab(text: 'Adoption Offer'),
                ],
              ),
            ),
            16.height,
            Expanded(
              child: TabBarView(
                children: [
                  // Content of Tab 1
                  ListView.builder(
                    itemCount: 5,
                    physics: ScrollPhysics(),
                    itemBuilder: (context, index) => PetAdoptionCard(),
                  ),

                  // Content of Tab 2
                  ListView.builder(
                    itemCount: 2,
                    physics: ScrollPhysics(),
                    itemBuilder: (context, index) => PetAdoptionCard(),
                  ),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.toNamed(Routes.PET_FORM);
          },
          child: Icon(Icons.add),
        ),
        bottomNavigationBar: PPBottomNavbarUser(currentIndex: 1),
      ),
    );
  }
}

class PetAdoptionCard extends StatelessWidget {
  const PetAdoptionCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: clrLightGrey,
      margin: EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          Get.toNamed(Routes.PET_SHOW);
        },
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 140,
                height: 140,
                child: Image.asset(img_dog),
              ),
              12.width,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Pet Name",
                      style: textTheme(context)
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w500),
                    ),
                    8.height,
                    Text(
                      currencyFormatter(300000),
                      style: textTheme(context).labelLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: primaryColor(context)),
                    ),
                    8.height,
                    Text(
                      "Lorem ipsum dolor sit amet consecteur. Lorem ipsum dolor sit amet consecteur. Lorem ipsum dolor sit amet consecteur. Lorem ipsum dolor sit amet consecteur. Lorem ipsum dolor sit amet consecteur. Lorem ipsum dolor sit amet consecteur. Lorem ipsum dolor sit amet consecteur. ",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    8.height,
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
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
