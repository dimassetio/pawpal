import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:pawpal/app/data/helpers/database.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pawpal/app/data/models/pet_model.dart';

class AdoptionModel extends Database {
  static const String ID = "ID";
  static const String USER_ID = "USER_ID";
  static const String OWNER_ID = "OWNER_ID";
  static const String PET_ID = "PET_ID";
  static const String STATUS = "STATUS";
  static const String DATECREATED = "DATECREATED";
  static const String LASTMODIFIED = "LASTMODIFIED";

  String? id;
  String? ownerId;
  String? status;
  String? userId;
  String? petId;
  PetModel? pet;
  DateTime? dateCreated;
  DateTime? lastModified;

  DocumentReference get petReference =>
      PetModel.getCollectionReference(userId).doc(petId);

  AdoptionModel({
    this.id,
    this.ownerId,
    this.status,
    this.userId,
    this.petId,
    this.dateCreated,
    this.lastModified,
  }) : super(
          collectionReference: getCollectionReference(userId),
          storageReference: getStorageReference(userId),
        );

  static CollectionReference getCollectionReference(String? userId) => firestore
      .collection(userCollection)
      .doc(userId ?? 'trash')
      .collection(adoptionsCollection);

  static Reference getStorageReference(String? userId) => storage
      .ref(userCollection)
      .child(userId ?? 'trash')
      .child(adoptionsCollection);

  AdoptionModel.fromSnapshot(DocumentSnapshot doc)
      : id = doc.id,
        super(
          collectionReference: getCollectionReference(
              (doc.data() as Map<String, dynamic>?)?[USER_ID]),
          storageReference: getStorageReference(
              (doc.data() as Map<String, dynamic>?)?[USER_ID]),
        ) {
    var json = doc.data() as Map<String, dynamic>?;
    ownerId = json?[OWNER_ID];
    userId = json?[USER_ID];
    status = json?[STATUS];
    petId = json?[PET_ID];
    dateCreated = (json?[DATECREATED] as Timestamp?)?.toDate();
    lastModified = (json?[LASTMODIFIED] as Timestamp?)?.toDate();
  }

  Map<String, dynamic> toJson() {
    return {
      ID: id,
      OWNER_ID: ownerId,
      STATUS: status,
      USER_ID: userId,
      PET_ID: petId,
      DATECREATED: dateCreated,
      LASTMODIFIED: lastModified,
    };
  }

  Future<AdoptionModel> save({File? file, bool? isSet}) async {
    if (id.isEmptyOrNull) dateCreated = DateTime.now();
    lastModified = DateTime.now();
    id.isEmptyOrNull
        ? id = await super.add(toJson())
        : (isSet ?? false)
            ? super.collectionReference.doc(id).set(toJson())
            : await super.edit(toJson());
    return this;
  }

  Future<AdoptionModel?> getModel() async {
    return id.isEmptyOrNull
        ? null
        : AdoptionModel.fromSnapshot(await super.getID(id!));
  }

  Future<PetModel?> getPet() async {
    pet = await PetModel.getCollectionReference(ownerId)
        .doc(petId)
        .get()
        .then((value) => PetModel.fromSnapshot(value));
    return pet;
  }
}

abstract class AdoptionStatus {
  static const inNego = 'In Negotiation';
  static const canceled = 'Canceled';
  static const complete = 'Completed';

  static const list = [inNego, canceled, complete];
}
