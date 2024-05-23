import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawpal/app/data/helpers/formatter.dart';
import 'package:pawpal/app/data/models/user_model.dart';
import 'package:pawpal/app/modules/auth/controllers/auth_controller.dart';
import 'package:nb_utils/nb_utils.dart';

class UsersFormController extends GetxController {
  bool isEdit = false;
  GlobalKey<FormState> formKey = GlobalKey();

  final _isLoading = false.obs;
  get isLoading => _isLoading.value;
  set isLoading(value) => _isLoading.value = value;

  TextEditingController usernameC = TextEditingController();
  TextEditingController phoneC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController alamatC = TextEditingController();
  TextEditingController passwordC = TextEditingController();
  TextEditingController confirmPasswordC = TextEditingController();
  TextEditingController tglMasukC = TextEditingController();
  TextEditingController bioC = TextEditingController();

  String? selectedRole;
  DateTime? selectedTglMasuk;
  bool? isActive;

  var selectedPhotoPath = ''.obs;

  UserModel? editedUser;

  void loadController() {
    if (editedUser is UserModel) {
      usernameC.text = editedUser!.username ?? '';
      phoneC.text = editedUser!.phone ?? '';
      emailC.text = editedUser!.email ?? '';
      alamatC.text = editedUser!.alamat ?? '';
      bioC.text = editedUser!.bio ?? '';
      tglMasukC.text = dateFormatter(editedUser!.tglMasuk);
      selectedRole = editedUser!.role;
      selectedTglMasuk = editedUser!.tglMasuk;
      isActive = editedUser!.isActive;
    }
  }

  Future save() async {
    try {
      isLoading = true;
      UserModel user = editedUser ?? UserModel();
      // Register User
      bool isSet = false;
      if (editedUser == null) {
        var userCredential =
            await authC.createUser(emailC.text, passwordC.text);
        if (userCredential.user != null) {
          user.id = userCredential.user!.uid;
          user.uid = userCredential.user!.uid;
          isSet = true;
          await userCredential.user!.sendEmailVerification();
          toast("Email verification sent to ${emailC.text}");
        }
      }
      user.phone = phoneC.text;
      user.role = selectedRole;
      user.email = emailC.text;
      user.username = usernameC.text;
      user.tglMasuk = selectedTglMasuk;
      user.bio = bioC.text;
      user.alamat = alamatC.text;
      user.isActive = isActive;

      File? fileFoto = selectedPhotoPath.value.isEmptyOrNull
          ? null
          : File(selectedPhotoPath.value);

      await user.save(file: fileFoto, isSet: isSet);
    } catch (e) {
      printError(info: e.toString());
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    isEdit = Get.arguments is UserModel;
    if (isEdit) {
      editedUser = Get.arguments;
      loadController();
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
