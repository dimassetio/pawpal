import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pawpal/app/data/helpers/location_service.dart';
import 'package:pawpal/app/data/models/user_model.dart';
import 'package:pawpal/app/modules/auth/controllers/auth_controller.dart';

class ProfileController extends GetxController {
  GlobalKey<FormState> formKey = GlobalKey();

  TextEditingController usernameC = TextEditingController();
  TextEditingController phoneC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController bioC = TextEditingController();
  TextEditingController addressC = TextEditingController();

  var _locationLoading = false.obs;
  get locationLoading => this._locationLoading.value;
  set locationLoading(value) => this._locationLoading.value = value;

  var _isLoading = false.obs;
  get isLoading => this._isLoading.value;
  set isLoading(value) => this._isLoading.value = value;

  var _isEdit = false.obs;
  get isEdit => this._isEdit.value;
  set isEdit(value) => this._isEdit.value = value;

  Rxn<XFile> _selectedFile = Rxn();
  XFile? get selectedFile => this._selectedFile.value;
  set selectedFile(XFile? value) => this._selectedFile.value = value;

  void loadController() {
    usernameC.text = authC.user.username ?? '';
    phoneC.text = authC.user.phone ?? '';
    emailC.text = authC.user.email ?? '';
    bioC.text = authC.user.bio ?? '';
    addressC.text = authC.user.alamat ?? '';
  }

  Future save() async {
    try {
      isLoading = true;
      UserModel user = authC.user;
      if (user.id.isEmptyOrNull) {
        throw Exception("User Id not found");
      }
      user.username = usernameC.text;
      user.phone = phoneC.text;
      user.bio = bioC.text;
      user.alamat = addressC.text;
      await user.save(
          file: selectedFile is XFile ? File(selectedFile?.path ?? '') : null);
      isEdit = false;
      Get.snackbar("Success", "Data updated successfully");
    } on Exception catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading = false;
    }
  }

  Future loadLocation() async {
    try {
      locationLoading = true;
      var positionC = await getPosition();
      List<Placemark> placemarks = await placemarkFromCoordinates(
          positionC.latitude, positionC.longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        addressC.text =
            "${place.street}, ${place.subLocality}, ${place.locality}, ${place.subAdministrativeArea}";
      } else {
        Get.snackbar("Request Failed", "Failed to get address location");
      }
    } on Exception catch (e) {
      Get.snackbar("Location Service Error", e.toString());
      return null;
    } finally {
      locationLoading = false;
    }
  }

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    loadController();
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
