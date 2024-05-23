import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pawpal/app/data/helpers/assets.dart';
import 'package:pawpal/app/data/helpers/themes.dart';
import 'package:pawpal/app/data/models/pet_model.dart';
import 'package:pawpal/app/data/models/user_model.dart';
import 'package:pawpal/app/data/widgets/app_bar.dart';
import 'package:pawpal/app/data/widgets/dialog.dart';
import 'package:pawpal/app/data/widgets/text_field.dart';
import 'package:pawpal/app/modules/auth/controllers/auth_controller.dart';
import 'package:pawpal/app/routes/app_pages.dart';

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
                  // toast("TAPPED");
                  // print("TAPPED");
                },
                child: AspectRatio(
                  aspectRatio: 1,
                  child: controller.pet.title.isEmptyOrNull
                      ? Image.asset(img_dog)
                      : CachedNetworkImage(
                          imageUrl: controller.pet.media!,
                          fit: BoxFit.cover,
                        ),
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
                    trailingWidget: authC.user.id == controller.pet.userId
                        ? PopupMenuButton(
                            child: IconButton(
                                onPressed: null,
                                icon: Icon(
                                  Icons.more_horiz,
                                  color: textColor,
                                )),
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                onTap: () async {
                                  var result = await Get.toNamed(
                                      Routes.PET_FORM,
                                      arguments: controller.pet);
                                  if (result is PetModel) {
                                    controller.pet = result;
                                  }
                                },
                                child: Row(
                                  children: [
                                    Icon(Icons.edit),
                                    16.width,
                                    Text("Edit")
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => Obx(
                                      () => PPDialog(
                                        title: "Take down this pet?",
                                        subtitle:
                                            "Are you sure to take down this post and other people will not see this post again?",
                                        negativeText: "Cancel",
                                        confirmText: controller.isLoading
                                            ? "wait..."
                                            : "Ok",
                                        onConfirm: () {
                                          if (!controller.isLoading)
                                            controller
                                                .changeStatus(PetStatus.closed);
                                        },
                                      ),
                                    ),
                                  );
                                },
                                child: Row(
                                  children: [
                                    Icon(Icons.delete),
                                    16.width,
                                    Text("Delete")
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => PPDialog(
                                      title: "Mark as Sold?",
                                      subtitle:
                                          "Are you sure to mark this pet as sold?",
                                      negativeText: "Cancel",
                                      onConfirm: () => controller
                                          .changeStatus(PetStatus.sold),
                                    ),
                                  );
                                },
                                child: Row(
                                  children: [
                                    Icon(Icons.check_circle_outline_rounded),
                                    16.width,
                                    Text("Mark as sold")
                                  ],
                                ),
                              ),
                            ],
                          )
                        : null,
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
                          Obx(
                            () => Text(
                              controller.pet.title ?? "Pet Name",
                              style: textTheme(context).titleMedium,
                            ),
                          ),
                          4.height,
                          16.height,
                          GridView.builder(
                            shrinkWrap: true,
                            itemCount: 3,
                            physics: ScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    childAspectRatio: 1,
                                    crossAxisSpacing: 28),
                            itemBuilder: (context, index) => Container(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                color: controller.highlightData[index][0],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Obx(
                                () => Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(controller.highlightData[index][1]),
                                    8.height,
                                    Text(
                                      controller.highlightData[index][2],
                                      style: textTheme(context)
                                          .bodySmall
                                          ?.copyWith(color: secondTextColor),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          16.height,
                          FutureBuilder<UserModel?>(
                              future: controller.getUser(),
                              builder: (context, snapshot) {
                                var data = snapshot.data;
                                return snapshot.connectionState ==
                                        ConnectionState.waiting
                                    ? LinearProgressIndicator()
                                    : Container(
                                        decoration: BoxDecoration(
                                            color: clrLightGrey,
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        padding: EdgeInsets.all(8),
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              height: 72,
                                              width: 72,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                child: (data?.foto
                                                            .isEmptyOrNull ??
                                                        true)
                                                    ? Image.asset(img_logo)
                                                    : CachedNetworkImage(
                                                        imageUrl: data!.foto!),
                                              ),
                                            ),
                                            12.width,
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    data?.username ??
                                                        "--Nickname--",
                                                    style: textTheme(context)
                                                        .titleMedium,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .location_on_rounded,
                                                        size: 16,
                                                        color: primaryColor(
                                                            context),
                                                      ),
                                                      8.width,
                                                      Expanded(
                                                        child: Text(
                                                          controller
                                                                  .getPetLocation ??
                                                              "Pet Location",
                                                          style: textTheme(
                                                                  context)
                                                              .bodyMedium
                                                              ?.copyWith(
                                                                  color:
                                                                      secondTextColor),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                              }),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 16),
                            child: Text(
                              "Description",
                              style: textTheme(context).titleMedium,
                            ),
                          ),
                          Obx(
                            () => Text(
                              controller.pet.description ?? "",
                            ),
                          ),
                          if (controller.pet.userId != authC.user.id &&
                              !authC.user.hasRole(Role.administrator))
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 16),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        padding: EdgeInsets.all(12),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                      ),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return PPDialog(
                                              title:
                                                  "Do you want to adopt this pet?",
                                              subtitle:
                                                  "We will connect you with the pet owner to deal a negotiation, are you sure?",
                                              negativeText: "Cancel",
                                              confirmText: "Continue",
                                              onConfirm: () {
                                                controller.adopt();
                                              },
                                            );
                                          },
                                        );
                                        // Get.toNamed(Routes.CHATS_SHOW,
                                        //     arguments: controller.pet);
                                      },
                                      child: Text("Adopt Now"),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          if (controller.pet.userId == authC.user.id ||
                              authC.user.hasRole(Role.administrator))
                            AdopterList(),
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

class AdminButton extends GetView<PetShowController> {
  const AdminButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          width: Get.width / 3,
          child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: primaryColor(context)),
                      borderRadius: BorderRadius.circular(32)),
                  backgroundColor: clr_white,
                  foregroundColor: primaryColor(context)),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => PPDialog(
                    title: "Reject this post?",
                    subtitle: "",
                    widget: Form(
                      key: controller.formKey,
                      child: PPTextfield(
                          label: "Add notes",
                          hint: "Add a reason to reject this post",
                          icon: Icon(Icons.comment),
                          controller: controller.noteC),
                    ),
                    negativeText: "Cancel",
                    onNegative: () {
                      Get.back();
                      controller.noteC.clear();
                    },
                    onConfirm: () {
                      if (controller.formKey.currentState?.validate() ??
                          false) {
                        controller.changeVisibility(
                            visibility: PetVisibilty.restricted,
                            note: controller.noteC.text);
                      }
                    },
                  ),
                );
              },
              icon: Icon(Icons.cancel_outlined),
              label: Text("Reject")),
        ),
        SizedBox(
          width: Get.width / 3,
          child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32))),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => PPDialog(
                    title: "Are you sure",
                    subtitle:
                        "This pet will published and all user can see this post?",
                    negativeText: "Cancel",
                    onConfirm: () => controller.changeVisibility(
                        visibility: PetVisibilty.published),
                  ),
                );
              },
              icon: Icon(Icons.check_circle_outline_rounded),
              label: Text("Aprrove")),
        ),
      ],
    ).marginOnly(top: 16);
  }
}

class AdopterList extends GetView<PetShowController> {
  const AdopterList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        16.height,
        Divider(
          thickness: 1,
          height: 1,
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Text(
            "Pet Status",
            style: textTheme(context).titleMedium,
          ),
        ),
        Obx(
          () => Container(
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
            decoration: BoxDecoration(
              color: primaryColor(context),
              borderRadius: BorderRadius.circular(32),
            ),
            child: Text(
              (controller.isUnpublished
                      ? controller.pet.visibility
                      : controller.pet.status) ??
                  '',
              style: textTheme(context)
                  .labelMedium
                  ?.copyWith(color: clr_white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Obx(
          () => ((authC.user.hasRole(Role.administrator) &&
                  controller.pet.visibility == PetVisibilty.inReview))
              ? AdminButton()
              : SizedBox(),
        ),
        Obx(
          () => controller.pet.visibility == PetVisibilty.restricted &&
                  controller.pet.note is String
              ? Container(
                  padding: EdgeInsets.all(16),
                  child: Text("Notes: ${controller.pet.note}"))
              : SizedBox(),
        ),
        FutureBuilder<List<UserModel?>>(
            future: controller.getAdopterList(),
            builder: (context, snapshot) {
              return Column(
                children: [
                  if (snapshot.data?.isNotEmpty ?? false)
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                        "Adopter candidate",
                        style: textTheme(context).titleMedium,
                      ),
                    ),
                  SizedBox(
                    height: 96,
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        itemCount: snapshot.data?.length ?? 0,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          var data = snapshot.data![index];
                          return data is UserModel
                              ? Container(
                                  margin: EdgeInsets.only(right: 16),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                          width: 64,
                                          height: 64,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(36),
                                            color: clrLightGrey,
                                            border: Border.all(
                                                color: primaryColor(context),
                                                width: 2),
                                          ),
                                          child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(36),
                                              child: data.foto is String
                                                  ? CachedNetworkImage(
                                                      imageUrl: data.foto!)
                                                  : Image.asset(img_logo))),
                                      8.height,
                                      Text(
                                        "${data.username}",
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                )
                              : SizedBox();
                        }),
                  ),
                ],
              );
            }),
      ],
    );
  }
}
