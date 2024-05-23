import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pawpal/app/data/helpers/assets.dart';
import 'package:pawpal/app/data/helpers/formatter.dart';
import 'package:pawpal/app/data/helpers/themes.dart';
import 'package:pawpal/app/data/models/adoption_model.dart';
import 'package:pawpal/app/data/models/pet_model.dart';
import 'package:pawpal/app/data/widgets/app_bar.dart';
import 'package:pawpal/app/data/widgets/bottom_bar.dart';
import 'package:pawpal/app/data/widgets/card_column.dart';
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
                  Tab(text: 'Adoption Offer'),
                  Tab(text: 'Adoption Request'),
                ],
              ),
            ),
            16.height,
            Expanded(
              child: TabBarView(
                children: [
                  // Content of Tab 1
                  // ListView.builder(
                  //   itemCount: 5,
                  //   physics: ScrollPhysics(),
                  //   itemBuilder: (context, index) => PetAdoptionCard(
                  //     pet: PetModel(),
                  //   ),
                  // ),
                  // Content of Tab 2
                  StreamBuilder<List<PetModel>>(
                      stream: controller.streamOffer(),
                      builder: (context, snapshot) {
                        return snapshot.connectionState ==
                                ConnectionState.waiting
                            ? Column(
                                children: [
                                  2.height,
                                  CircularProgressIndicator(),
                                ],
                              )
                            : (snapshot.data?.isEmpty ?? true)
                                ? PPCardColumn(
                                    crossAxis: CrossAxisAlignment.center,
                                    children: [
                                        Image.asset(img_form_default),
                                        8.height,
                                        Text("You don't have offer history")
                                      ])
                                : ListView.builder(
                                    itemCount: snapshot.data?.length ?? 0,
                                    physics: ScrollPhysics(),
                                    itemBuilder: (context, index) =>
                                        PetAdoptionCard(
                                            pet: snapshot.data![index]),
                                  );
                      }),
                  StreamBuilder<List<AdoptionModel>>(
                      stream: controller.streamRequest(),
                      builder: (context, snapshot) {
                        return snapshot.connectionState ==
                                ConnectionState.waiting
                            ? Column(
                                children: [
                                  2.height,
                                  CircularProgressIndicator(),
                                ],
                              )
                            : (snapshot.data?.isEmpty ?? true)
                                ? PPCardColumn(
                                    crossAxis: CrossAxisAlignment.center,
                                    children: [
                                        Image.asset(img_form_default),
                                        8.height,
                                        Text("You don't have request history")
                                      ])
                                : ListView.builder(
                                    itemCount: snapshot.data?.length ?? 0,
                                    physics: ScrollPhysics(),
                                    itemBuilder: (context, index) =>
                                        PetAdoptionCard(
                                            adoption: snapshot.data![index],
                                            pet: snapshot.data![index].pet ??
                                                PetModel(
                                                    title: "Pet Not Found")),
                                  );
                      }),
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
    required this.pet,
    this.adoption,
  });

  final PetModel pet;
  final AdoptionModel? adoption;

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
          Get.toNamed(Routes.PET_SHOW, arguments: pet);
        },
        child: Container(
          // padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: SizedBox(
                  width: 140,
                  height: 140,
                  child: pet.media.isEmptyOrNull
                      ? Image.asset(img_dog)
                      : CachedNetworkImage(
                          imageUrl: pet.media!,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        pet.title ?? "Pet Name",
                        style: textTheme(context)
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.w500),
                      ),
                      8.height,
                      Text(
                        currencyFormatter(pet.price?.toInt() ?? 0),
                        style: textTheme(context).labelLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: primaryColor(context)),
                      ),
                      8.height,
                      Text(
                        "${pet.description}",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      8.height,
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                        decoration: BoxDecoration(
                          color: primaryColor(context),
                          borderRadius: BorderRadius.circular(32),
                        ),
                        child: Text(
                          pet.status ?? '',
                          style: textTheme(context)
                              .labelMedium
                              ?.copyWith(color: clr_white),
                        ),
                      ),
                      // Row(
                      //   children: [
                      //     Icon(
                      //       Icons.location_on_rounded,
                      //       size: 16,
                      //       color: primaryColor(context),
                      //     ),
                      //     8.width,
                      //     Expanded(
                      //       child: Text(
                      //         "${pet.locality}, ${pet.city}",
                      //         overflow: TextOverflow.ellipsis,
                      //         style: textTheme(context)
                      //             .bodyMedium
                      //             ?.copyWith(color: secondTextColor),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
