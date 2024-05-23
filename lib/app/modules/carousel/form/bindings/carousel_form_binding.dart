import 'package:get/get.dart';

import '../controllers/carousel_form_controller.dart';

class CarouselFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CarouselFormController>(
      () => CarouselFormController(),
    );
  }
}
