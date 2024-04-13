import 'package:get/get.dart';
import 'package:pawpal/app/data/helpers/assets.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController

  List carouselImages = [
    img_carousel_1,
    // img_carousel_2,
  ];

  RxInt _selectedCategory = 0.obs;
  int get selectedCategory => this._selectedCategory.value;
  set selectedCategory(int value) => this._selectedCategory.value = value;

  List<List<String>> categoryItems = [
    [
      img_dog,
      "Dog",
    ],
    [
      img_cat,
      "Cat",
    ],
    [
      img_fish,
      "Fish",
    ],
    [
      img_reptile,
      "Reptile",
    ],
  ];

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
