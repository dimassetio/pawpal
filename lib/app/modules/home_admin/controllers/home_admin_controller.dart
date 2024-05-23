import 'package:get/get.dart';
import 'package:pawpal/app/data/helpers/database.dart';
import 'package:pawpal/app/data/models/banner_model.dart';
import 'package:pawpal/app/data/models/pet_model.dart';

class HomeAdminController extends GetxController {
  var _isLoading = false.obs;
  bool get isLoading => this._isLoading.value;
  set isLoading(bool value) => this._isLoading.value = value;

  var _limit = 10.obs;
  int get limit => this._limit.value;
  set limit(int value) => this._limit.value = value;

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

  RxList<PetModel> _postRequests = <PetModel>[].obs;
  List<PetModel> get postRequests => this._postRequests;
  set postRequests(List<PetModel> value) => this._postRequests.value = value;

  RxList<PetModel> _allPost = <PetModel>[].obs;
  List<PetModel> get allPost => this._allPost;
  set allPost(List<PetModel> value) => this._allPost.value = value;

  void addLimit() {
    limit = limit + 10;
  }

  Stream<List<PetModel>> streamRequest() {
    try {
      isLoading = true;
      return Database.collectionGroup(petCollection)
          .where(PetModel.VISIBILITY, isEqualTo: PetVisibilty.inReview)
          .orderBy(PetModel.DATECREATED, descending: true)
          .snapshots()
          .map((event) =>
              event.docs.map((e) => PetModel.fromSnapshot(e)).toList());
    } on Exception catch (e) {
      Get.snackbar("Error Streaming Post Request", e.toString());
      return Stream.error(e);
    } finally {
      isLoading = false;
    }
  }

  Stream<List<PetModel>> streamAll(int value) {
    try {
      isLoading = true;
      return Database.collectionGroup(petCollection)
          .orderBy(PetModel.DATECREATED, descending: true)
          .limit(value)
          .snapshots()
          .map((event) =>
              event.docs.map((e) => PetModel.fromSnapshot(e)).toList());
    } on Exception catch (e) {
      Get.snackbar("Error Streaming Post Request", e.toString());
      return Stream.error(e);
    } finally {
      isLoading = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    _postRequests.bindStream(streamRequest());
    _allPost.bindStream(streamAll(_limit.value));
    _banners.bindStream(streamBanner());
    ever(_limit, (callback) => _allPost.bindStream(streamAll(_limit.value)));
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
