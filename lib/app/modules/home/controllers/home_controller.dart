import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:pawpal/app/data/helpers/assets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pawpal/app/data/models/banner_model.dart';
import 'package:pawpal/app/data/models/pet_model.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController

  List carouselImages = [
    img_carousel_1,
    // img_carousel_2,
  ];

  RxInt _selectedCategory = 0.obs;
  int get selectedCategory => this._selectedCategory.value;
  set selectedCategory(int value) => this._selectedCategory.value = value;

  String getCategory() {
    return categoryItems[selectedCategory][1];
  }

  List<List<String>> categoryItems = [
    [img_other_pet, "All"],
    [img_dog, PetCategory.dog],
    [img_cat, PetCategory.cat],
    [img_bird, PetCategory.bird],
    [img_fish, PetCategory.fish],
    [img_reptile, PetCategory.reptile],
    [img_other_pet, PetCategory.others],
  ];

  var _isLoading = false.obs;
  get isLoading => this._isLoading.value;
  set isLoading(value) => this._isLoading.value = value;

  var _petLoading = false.obs;
  get petLoading => this._petLoading.value;
  set petLoading(value) => this._petLoading.value = value;

  var _place = Rxn<Placemark>();
  get place => this._place.value;
  set place(value) => this._place.value = value;

  Future<Placemark?> getLocation() async {
    try {
      isLoading = true;
      bool serviceEnabled;
      LocationPermission permission;

      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled.');
      }
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception(
            'Location permissions are permanently denied, we cannot request permissions.');
      }

      Position position =
          // await Geolocator.getLastKnownPosition() ??
          await Geolocator.getCurrentPosition();

      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      place = placemarks.isNotEmpty ? placemarks.first : null;
      return place;
    } on Exception catch (e) {
      Get.snackbar("Location Service Error", e.toString());
      return null;
    } finally {
      isLoading = false;
    }
  }

  RxList<PetModel> pets = RxList();

  List<PetModel> get filteredPet => selectedCategory > 0
      ? pets
          .where((pet) => pet.category == categoryItems[selectedCategory][1])
          .toList()
      : pets;

  Stream<List<PetModel>> streamListPet() {
    try {
      petLoading = true;
      return PetModel.streamListedPet(100);
    } catch (e) {
      printError(info: e.toString());
      Get.snackbar("Error", "$e");
      return Stream.error("$e");
    } finally {
      petLoading = false;
    }
  }

  RxList<BannerModel> _banners = <BannerModel>[].obs;
  List<BannerModel> get banners => this._banners;
  set banners(List<BannerModel> value) => this._banners.value = value;

  Stream<List<BannerModel>> streamBanner() {
    try {
      return BannerModel()
          .collectionReference
          .orderBy(BannerModel.INDEX)
          .snapshots()
          .map((event) =>
              event.docs.map((e) => BannerModel.fromSnapshot(e)).toList());
    } on Exception catch (e) {
      printError(info: e.toString());
      return Stream.error(e);
    }
  }

  @override
  void onInit() {
    super.onInit();
    getLocation();
    pets.bindStream(streamListPet());
    _banners.bindStream(streamBanner());
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
