import 'package:get/get.dart';
import 'package:pawpal/app/data/models/banner_model.dart';

class CarouselController extends GetxController {
  //TODO: Implement CarouselController
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
