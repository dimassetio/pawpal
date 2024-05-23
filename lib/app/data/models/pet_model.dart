import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:pawpal/app/data/helpers/database.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pawpal/app/data/models/adoption_model.dart';
import 'package:pawpal/app/data/models/user_model.dart';

class PetModel extends Database {
  static const String ID = "ID";
  static const String TITLE = "TITLE";
  static const String CATEGORY = "CATEGORY";
  static const String USERID = "USERID";
  static const String GENDER = "GENDER";
  static const String AGE = "AGE";
  static const String SIZE = "SIZE";
  static const String UNIT = "UNIT";
  static const String DESCRIPTION = "DESCRIPTION";
  static const String PRICE = "PRICE";
  static const String LOCATION = "LOCATION";
  static const String PROVINCE = "PROVINCE";
  static const String CITY = "CITY";
  static const String LOCALITY = "LOCALITY";
  static const String ADDRESS = "ADDRESS";
  static const String DATECREATED = "DATECREATED";
  static const String LASTMODIFIED = "LASTMODIFIED";
  static const String STATUS = "STATUS";
  static const String VISIBILITY = "VISIBILITY";
  static const String NOTE = "NOTE";
  static const String MEDIA = "MEDIA";

  String? id;
  String? title;
  String? category;
  String? userId;
  int? gender;
  int? age;
  double? size;
  String? unit;
  String? description;
  double? price;
  GeoPoint? location;
  String? province;
  String? city;
  String? locality;
  String? address;
  DateTime? dateCreated;
  DateTime? lastModified;
  String? status;
  String? visibility;
  String? note;
  String? media;

  PetModel({
    this.id,
    this.title,
    this.category,
    this.userId,
    this.gender,
    this.age,
    this.size,
    this.unit,
    this.description,
    this.price,
    this.location,
    this.province,
    this.city,
    this.locality,
    this.address,
    this.dateCreated,
    this.lastModified,
    this.status,
    this.visibility,
    this.note,
    this.media,
  }) : super(
          collectionReference: getCollectionReference(userId),
          storageReference: getStorageReference(userId),
        );

  static CollectionReference getCollectionReference(String? userId) => firestore
      .collection(userCollection)
      .doc(userId ?? 'trash')
      .collection(petCollection);

  static Reference getStorageReference(String? userId) =>
      storage.ref(userCollection).child(userId ?? 'trash').child(petCollection);

  static Future<List<PetModel>> getListedPet() {
    return firestore
        .collectionGroup(petCollection)
        .where(STATUS, whereIn: [PetStatus.open, PetStatus.inNego])
        .where(VISIBILITY, isEqualTo: PetVisibilty.published)
        .orderBy(DATECREATED, descending: true)
        .get()
        .then((value) =>
            value.docs.map((e) => PetModel.fromSnapshot(e)).toList());
  }

  static Stream<List<PetModel>> streamListedPet(int limit) {
    return firestore
        .collectionGroup(petCollection)
        .where(STATUS, whereIn: [PetStatus.open, PetStatus.inNego])
        .where(VISIBILITY, isEqualTo: PetVisibilty.published)
        .orderBy(DATECREATED, descending: true)
        .limit(limit)
        .snapshots()
        .map((value) =>
            value.docs.map((e) => PetModel.fromSnapshot(e)).toList());
  }

  static Stream<List<PetModel>> streamOfferedPet(String uid) {
    return getCollectionReference(uid)
        .where(STATUS, isNotEqualTo: PetStatus.closed)
        .orderBy(DATECREATED, descending: true)
        .snapshots()
        .map((event) =>
            event.docs.map((e) => PetModel.fromSnapshot(e)).toList());
  }

  // PetModel.fromSnapshot(String? id, Map<String, dynamic> json)
  PetModel.fromSnapshot(DocumentSnapshot doc)
      : id = doc.id,
        super(
          collectionReference: getCollectionReference(
              (doc.data() as Map<String, dynamic>?)?[USERID]),
          storageReference: getStorageReference(
              (doc.data() as Map<String, dynamic>?)?[USERID]),
        ) {
    var json = doc.data() as Map<String, dynamic>?;
    title = json?[TITLE];
    category = json?[CATEGORY];
    userId = json?[USERID];
    gender = json?[GENDER];
    age = json?[AGE];
    size = json?[SIZE];
    unit = json?[UNIT];
    description = json?[DESCRIPTION];
    price = json?[PRICE];
    location = json?[LOCATION];
    province = json?[PROVINCE];
    city = json?[CITY];
    locality = json?[LOCALITY];
    address = json?[ADDRESS];
    dateCreated = (json?[DATECREATED] as Timestamp?)?.toDate();
    lastModified = (json?[LASTMODIFIED] as Timestamp?)?.toDate();
    status = json?[STATUS];
    visibility = json?[VISIBILITY];
    note = json?[NOTE];
    media = json?[MEDIA];
  }

  Map<String, dynamic> toJson() {
    return {
      ID: id,
      TITLE: title,
      CATEGORY: category,
      USERID: userId,
      GENDER: gender,
      AGE: age,
      SIZE: size,
      UNIT: unit,
      DESCRIPTION: description,
      PRICE: price,
      LOCATION: location,
      PROVINCE: province,
      CITY: city,
      LOCALITY: locality,
      ADDRESS: address,
      DATECREATED: dateCreated,
      LASTMODIFIED: lastModified,
      STATUS: status,
      VISIBILITY: visibility,
      NOTE: note,
      MEDIA: media,
    };
  }

  Future<PetModel> save({File? file, bool? isSet}) async {
    if (userId.isEmptyOrNull) {
      throw Exception("User Id Unidentified");
    }
    super.collectionReference = getCollectionReference(userId);
    super.storageReference = getStorageReference(userId);
    if (id.isEmptyOrNull) dateCreated = DateTime.now();
    lastModified = DateTime.now();
    id.isEmptyOrNull
        ? id = await super.add(toJson())
        : (isSet ?? false)
            ? super.collectionReference.doc(id).set(toJson())
            : await super.edit(toJson());

    if (file is File && !id.isEmptyOrNull) {
      media = await super.upload(id: id!, file: file);
      await super.edit(toJson());
    }
    return this;
  }

  static Future<PetModel?> getFromRef(DocumentReference ref) async {
    // return PetModel.fromSnapshot(await super.getID(id!));
    return ref.get().then((value) => PetModel.fromSnapshot(value));
  }

  Stream<PetModel> stream() {
    return super
        .collectionReference
        .doc(id)
        .snapshots()
        .map((event) => PetModel.fromSnapshot(event));
  }

  Future<List<UserModel?>> getAdopters() {
    try {
      return Database.collectionGroup(adoptionsCollection)
          .where(AdoptionModel.PET_ID, isEqualTo: id)
          .get()
          .then((value) {
        return Future.wait(value.docs.map((e) async =>
            await UserModel(id: AdoptionModel.fromSnapshot(e).userId)
                .getUser()));
      });
    } on Exception catch (e) {
      throw Exception(e);
    }
  }
}

abstract class PetCategory {
  static const cat = 'Cat';
  static const dog = 'Dog';
  static const fish = 'Fish';
  static const bird = 'Bird';
  static const reptile = 'Reptile';
  static const others = 'Others';

  static const list = [cat, dog, fish, bird, reptile, others];
}

abstract class PetGender {
  static const male = 10;
  static const female = 30;
  static const unknown = 20;
  static const list = [male, female, unknown];
}

abstract class PetStatus {
  static const open = 'Open Offer';
  static const inNego = 'In Negotiation';
  static const sold = 'Sold';
  static const closed = 'Closed';

  static const list = [open, inNego, sold, closed];
}

abstract class PetVisibilty {
  static const inReview = 'In Review';
  static const published = 'Published';
  static const restricted = 'Restricted';

  static const list = [inReview, published, restricted];
}

abstract class PetUnit {
  static const cm = 'Cm';
  static const m = 'M';
  static const g = 'G';
  static const kg = 'Kg';

  static const list = [cm, m, g, kg];
}
