import 'package:get/get.dart';

import '../controllers/adoption_controller.dart';

class AdoptionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdoptionController>(
      () => AdoptionController(),
    );
  }
}
