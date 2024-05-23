import 'package:get/get.dart';
import 'package:pawpal/app/data/models/adoption_model.dart';
import 'package:pawpal/app/data/models/pet_model.dart';
import 'package:pawpal/app/modules/auth/controllers/auth_controller.dart';

class AdoptionController extends GetxController {
  Stream<List<PetModel>> streamOffer() {
    try {
      // var stream = PetModel.streamOfferedPet(authC.user.id ?? "");
      return PetModel.getCollectionReference(authC.user.id)
          .where(PetModel.STATUS,
              whereIn: [PetStatus.open, PetStatus.inNego, PetStatus.sold])
          .orderBy(PetModel.DATECREATED, descending: true)
          .snapshots()
          .map((event) =>
              event.docs.map((e) => PetModel.fromSnapshot(e)).toList());
      // _offerList.bindStream(stream);
      // return stream;
    } on Exception catch (e) {
      Get.snackbar("Error", e.toString());
      return Stream.error(e.toString());
    }
  }

  Stream<List<AdoptionModel>> streamRequest() {
    return AdoptionModel.getCollectionReference(authC.user.id)
        .orderBy(AdoptionModel.DATECREATED, descending: true)
        .snapshots()
        .asyncMap((event) async {
      var values = event.docs.map((e) async {
        var adoption = AdoptionModel.fromSnapshot(e);
        adoption.pet = await adoption.getPet();
        return adoption;
      }).toList();
      return await Future.wait(values);
    });
  }

  RxList<PetModel> _offerList = RxList();
  List<PetModel> get offerList => this.offerList;
  set offerList(value) => this._offerList.value = value;

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
}
