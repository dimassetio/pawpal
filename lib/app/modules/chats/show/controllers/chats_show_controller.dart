import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawpal/app/data/models/adoption_model.dart';
import 'package:pawpal/app/data/models/chats_model.dart';
import 'package:pawpal/app/data/models/message_model.dart';
import 'package:pawpal/app/data/models/pet_model.dart';
import 'package:pawpal/app/modules/auth/controllers/auth_controller.dart';

class ChatsShowController extends GetxController {
  //TODO: Implement ChatsShowController

  TextEditingController messageC = TextEditingController();
  FocusNode focus = FocusNode();
  ScrollController scrollC = ScrollController();

  late ChatsModel chats;

  var _isLoading = false.obs;
  get isLoading => this._isLoading.value;
  set isLoading(value) => this._isLoading.value = value;

  var _loadingMessage = false.obs;
  get loadingMessage => this._loadingMessage.value;
  set loadingMessage(value) => this._loadingMessage.value = value;

  Rxn<PetModel> _pet = Rxn();
  PetModel? get pet => this._pet.value;
  set pet(PetModel? value) => this._pet.value = value;

  Rxn<AdoptionModel> _adoption = Rxn();
  AdoptionModel? get adoption => this._adoption.value;
  set adoption(AdoptionModel? value) => this._adoption.value = value;

  Future sendMessage() async {
    try {
      isLoading = true;
      focus.unfocus();
      var model = MessageModel(
        chatId: chats.id!,
        senderId: authC.user.id,
        text: messageC.text,
        isRead: false,
        petReference: pet?.collectionReference.doc(pet?.id),
      );
      await model.save();
      if (pet is PetModel && adoption is AdoptionModel) {
        if (await AdoptionModel.getCollectionReference(authC.user.id)
            .where(AdoptionModel.PET_ID, isEqualTo: pet!.id)
            .get()
            .then((value) => value.docs.isEmpty)) {
          await adoption?.save();
        }
      }
      pet = null;
      messageC.clear();
    } on Exception catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading = false;
    }
  }

  RxList<MessageModel> messages = RxList();

  Stream<List<MessageModel>> streamMessages() {
    try {
      loadingMessage = true;
      return chats.streamMessages();
    } catch (e) {
      Get.snackbar("Error fetching messages", e.toString());
      return Stream.error("$e");
    } finally {
      loadingMessage = false;
    }
  }

  Future updateReadStatus() async {
    try {
      List<MessageModel> messages =
          await chats.getUnreadMessages(authC.user.id ?? '');
      for (var message in messages) {
        message.isRead = true;
        await message.save();
      }
    } on Exception catch (e) {
      printError(info: "$e");
    }
  }

  void loadArgument() {
    if (Get.arguments is List) {
      chats = Get.arguments[0];
      pet = Get.arguments[1];
      adoption = Get.arguments[2];
    } else {
      chats = Get.arguments ?? ChatsModel();
    }
  }

  @override
  void onInit() {
    super.onInit();
    loadArgument();
    messages.bindStream(streamMessages());
    updateReadStatus();
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
