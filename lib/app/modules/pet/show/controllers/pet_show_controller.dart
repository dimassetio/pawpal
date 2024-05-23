import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pawpal/app/data/helpers/formatter.dart';
import 'package:pawpal/app/data/helpers/themes.dart';
import 'package:pawpal/app/data/models/adoption_model.dart';
import 'package:pawpal/app/data/models/chats_model.dart';
import 'package:pawpal/app/data/models/pet_model.dart';
import 'package:pawpal/app/data/models/user_model.dart';
import 'package:pawpal/app/modules/auth/controllers/auth_controller.dart';
import 'package:pawpal/app/routes/app_pages.dart';

class PetShowController extends GetxController {
  //TODO: Implement PetShowController
  Rx<PetModel> _pet = Rx<PetModel>(PetModel());
  PetModel get pet => this._pet.value;
  set pet(PetModel value) => this._pet.value = value;

  Rx<bool> _isLoading = false.obs;
  bool get isLoading => this._isLoading.value;
  set isLoading(bool value) => this._isLoading.value = value;

  String? get getPetLocation => pet.city.isEmptyOrNull
      ? null
      : "${pet.address}, ${pet.locality}, ${pet.city}, ${pet.province}";

  bool get isUnpublished =>
      [PetVisibilty.inReview, PetVisibilty.restricted].contains(pet.visibility);

  GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController noteC = TextEditingController();

  List<List> get highlightData => [
        [
          clrPastelPink,
          petGenderName(pet.gender ?? PetGender.unknown),
          'Gender'
        ],
        [clrPastelGreen, pet.age.toString(), 'Age'],
        [clrPastelBlue, pet.size.toString(), pet.unit ?? ''],
      ];

  Future<UserModel?> getUser() async {
    try {
      return await UserModel(id: pet.userId).getUser();
    } on Exception catch (e) {
      Get.snackbar("Error", "$e");
      return Future.error(e.toString());
    }
  }

  Future adopt() async {
    if (authC.user.id == null || pet.userId == null) {
      throw Exception("User Id or Pet Owner Id Not Found");
    }
    ChatsModel? chatModel =
        (await ChatsModel().getFromConnection(authC.user.id!, pet.userId!))
            .firstOrNull;

    if (chatModel == null) {
      chatModel = ChatsModel(connections: [authC.user.id!, pet.userId!]);
      chatModel = await chatModel.save();
    }
    chatModel.receiver = await chatModel.getReceiverData(authC.user.id!);

    AdoptionModel adoption = AdoptionModel(
      ownerId: pet.userId,
      userId: authC.user.id,
      petId: pet.id,
      status: AdoptionStatus.inNego,
    );
    Get.back();
    Get.toNamed(Routes.CHATS_SHOW, arguments: [chatModel, pet, adoption]);
  }

  Future changeStatus(String status) async {
    try {
      isLoading = true;
      pet.status = status;
      pet = await pet.save();
      Get.back();
      Get.snackbar("Success", "Data updated successfully");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading = false;
    }
  }

  Future changeVisibility({required String visibility, String? note}) async {
    try {
      isLoading = true;
      pet.visibility = visibility;
      if (note is String) {
        pet.note = note;
      }
      pet = await pet.save();
      Get.back();
      Get.snackbar("Success", "Data updated successfully");
      noteC.clear();
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading = false;
    }
  }

  Future<List<UserModel?>> getAdopterList() async {
    try {
      return pet.getAdopters();
    } on Exception catch (e) {
      Get.snackbar("Error getting adopter list", e.toString());
      printError(info: "$e");
      return Future.error(e);
    }
  }

  @override
  void onInit() {
    super.onInit();
    // if (Get.arguments is PetModel) {
    pet = Get.arguments ?? PetModel();
    _pet.bindStream(pet.stream());
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
