import 'package:get/get.dart';

import '../controllers/pet_show_controller.dart';

class PetShowBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PetShowController>(
      () => PetShowController(),
    );
  }
}
