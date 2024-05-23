import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pawpal/app/data/models/banner_model.dart';
import 'package:pawpal/app/data/widgets/form_foto.dart';

class CarouselFormController extends GetxController {
  PPFormFoto formFoto = PPFormFoto();
  TextEditingController indexC = TextEditingController();
  BannerModel? banner;

  var _isLoading = false.obs;
  bool get isLoading => this._isLoading.value;
  set isLoading(bool value) => this._isLoading.value = value;

  Future save() async {
    try {
      isLoading = true;
      banner ??= BannerModel();
      banner!.index = indexC.text.toInt();

      File? file;
      if (formFoto.newPath.isNotEmpty) {
        file = File(formFoto.newPath);
      }
      await banner!.save(file: file);
      Get.back();
      Get.snackbar("Success", "Data Saved Successfully");
    } on Exception catch (e) {
      Get.snackbar("Error", "$e");
    } finally {
      isLoading = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is BannerModel) {
      banner = Get.arguments;
      formFoto.oldPath = banner?.image ?? '';
      indexC.text = "${banner?.index}";
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
}
