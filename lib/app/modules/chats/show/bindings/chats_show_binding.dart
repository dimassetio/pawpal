import 'package:get/get.dart';

import '../controllers/chats_show_controller.dart';

class ChatsShowBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChatsShowController>(
      () => ChatsShowController(),
    );
  }
}
