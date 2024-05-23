import 'package:get/get.dart';

import '../controllers/carousel_controller.dart';

class CarouselBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CarouselController>(
      () => CarouselController(),
    );
  }
}
