import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pawpal/app/data/helpers/formatter.dart';
import 'package:pawpal/app/data/helpers/location_service.dart';
import 'package:pawpal/app/data/models/pet_model.dart';
import 'package:pawpal/app/data/widgets/dialog.dart';
import 'package:pawpal/app/data/widgets/form_foto.dart';
import 'package:pawpal/app/modules/auth/controllers/auth_controller.dart';

class PetFormController extends GetxController {
  TextEditingController titleC = TextEditingController();
  TextEditingController ageC = TextEditingController();
  TextEditingController sizeC = TextEditingController();
  TextEditingController priceC = TextEditingController();
  TextEditingController descriptionC = TextEditingController();
  TextEditingController nameC = TextEditingController();
  TextEditingController provinsiC = TextEditingController();
  TextEditingController kotaC = TextEditingController();
  TextEditingController kecamatanC = TextEditingController();
  TextEditingController alamatC = TextEditingController();

  String? categoryC;
  int? genderC;
  String? unitC;
  String? statusC;
  String? visibilityC;
  Position? positionC;

  PetModel? editedPet;
  bool isEdit = false;
  GlobalKey<FormState> formKey = GlobalKey();

  String get selectedPhotoPath => formFoto.newPath;

  PPFormFoto formFoto = PPFormFoto();

  var _isLoading = false.obs;
  get isLoading => this._isLoading.value;
  set isLoading(value) => this._isLoading.value = value;

  Future loadLocation() async {
    try {
      isLoading = true;
      positionC = await getPosition();
      List<Placemark> placemarks = await placemarkFromCoordinates(
          positionC!.latitude, positionC!.longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        provinsiC.text = place.administrativeArea ?? provinsiC.text;
        kotaC.text = place.subAdministrativeArea ?? kotaC.text;
        kecamatanC.text = place.locality ?? kecamatanC.text;
      }
    } on Exception catch (e) {
      Get.snackbar("Location Service Error", e.toString());
      return null;
    } finally {
      isLoading = false;
    }
  }

  Future save(BuildContext context) async {
    try {
      isLoading = true;
      PetModel model = editedPet ?? PetModel();
      model.title = titleC.text;
      model.category = categoryC;
      // model.userId = model.userId ?? authC.user.id;
      model.userId ??= authC.user.id;
      model.gender = genderC;
      model.age = ageC.text.toInt();
      model.size = sizeC.text.toDouble();
      model.unit = unitC;
      model.description = descriptionC.text;
      model.price = currencyDeformatter(priceC.text).toDouble();
      model.location = positionC is Position ? posToGeo(positionC!) : null;
      model.status = statusC ?? PetStatus.open;
      model.visibility = visibilityC ?? PetVisibilty.inReview;
      model.province = provinsiC.text;
      model.city = kotaC.text;
      model.locality = kecamatanC.text;
      model.address = alamatC.text;
      File? fileFoto =
          selectedPhotoPath.isEmptyOrNull ? null : File(selectedPhotoPath);

      await model.save(file: fileFoto);
      // if (!isEdit) {
      await showDialog(
        context: context,
        builder: (context) => PPDialog(
            title: "Pet adoption offer created successfully",
            subtitle:
                "Your post is not visible yet until admin approve your post. Please wait patiently."),
      );
      // }
      Get.back(result: model);
      var message =
          isEdit ? "Data updated successfully" : "Data created successfully";
      Get.snackbar("Success", message);
    } catch (e) {
      printError(info: e.toString());
      Get.snackbar("An Error Occured", e.toString());
    } finally {
      isLoading = false;
    }
  }

  void loadController() {
    if (editedPet is PetModel) {
      titleC.text = editedPet!.title ?? '';
      categoryC = editedPet!.category;

      genderC = editedPet!.gender;
      ageC.text = editedPet!.age.toString();
      sizeC.text = editedPet!.size.toString();
      unitC = editedPet!.unit;
      descriptionC.text = editedPet!.description ?? '';
      priceC.text = currencyFormatter(editedPet!.price?.toInt());
      positionC = editedPet?.location is GeoPoint
          ? geoToPost(editedPet!.location!)
          : null;
      statusC = editedPet!.status;
      visibilityC = editedPet!.visibility;
      provinsiC.text = editedPet!.province ?? '';
      kotaC.text = editedPet!.city ?? '';
      kecamatanC.text = editedPet!.locality ?? '';
      alamatC.text = editedPet!.address ?? '';
      formFoto.oldPath = editedPet!.media ?? '';
    }
  }

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    isEdit = Get.arguments is PetModel;
    if (isEdit) {
      editedPet = Get.arguments;
      loadController();
    } else {
      loadLocation();
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
