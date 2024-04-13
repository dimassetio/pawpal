import 'package:get/get.dart';

import '../controllers/pet_form_controller.dart';

class PetFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PetFormController>(
      () => PetFormController(),
    );
  }
}
