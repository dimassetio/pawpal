import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawpal/app/data/models/chats_model.dart';
import 'package:pawpal/app/data/models/message_model.dart';
import 'package:pawpal/app/modules/auth/controllers/auth_controller.dart';

class ChatsController extends GetxController {
  //TODO: Implement ChatsController

  var _isLoading = false.obs;
  get isLoading => this._isLoading.value;
  set isLoading(value) => this._isLoading.value = value;

  TextEditingController searchC = TextEditingController();

  RxList<ChatsModel> chats = RxList();

  Future<ChatsModel> loadChat(int index) async {
    try {
      var model = chats[index];
      if (model.receiver == null || model.messages == null) {
        model.receiver = await model.getReceiverData(authC.user.id!);
        var message = await model.getLastMessage();
        if (message is MessageModel) {
          model.messages = [message];
        }
        chats[index] = model;
      }
      model.unreadCount = await model
          .getUnreadMessages(authC.user.id ?? '')
          .then((value) => value.length);
      return model;
    } on Exception catch (e) {
      Get.snackbar("Error", e.toString());
      return chats[index];
    }
  }

  Stream<List<ChatsModel>> streamChats() {
    try {
      isLoading = true;
      return ChatsModel().streamChats(authC.user.id!);
    } on Exception catch (e) {
      Get.snackbar("Error", e.toString());
      return Stream.error("$e");
    } finally {
      isLoading = false;
      print("Get Stream Chat is Done");
    }
  }

  RxString _searchV = ''.obs;
  String get searchV => this._searchV.value;
  set searchV(String value) => this._searchV.value = value;

  @override
  void onInit() {
    super.onInit();
    chats.bindStream(streamChats());
    print("object");
    searchC.addListener(() {
      searchV = searchC.text;
      print(searchV);
    });
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
