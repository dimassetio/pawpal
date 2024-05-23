import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pawpal/app/data/helpers/database.dart';
import 'package:nb_utils/nb_utils.dart';

class BannerModel extends Database {
  static const String ID = "ID";
  static const String INDEX = "INDEX";
  static const String IMAGE = "IMAGE";
  static const String DATECREATED = "DATECREATED";
  static const String LASTMODIFIED = "LASTMODIFIED";

  String? id;
  int? index;
  String? image;
  DateTime? dateCreated;
  DateTime? lastModified;

  BannerModel({
    this.id,
    this.index,
    this.image,
    this.dateCreated,
    this.lastModified,
  }) : super(
          collectionReference: firestore.collection(bannersCollection),
          storageReference: storage.ref(bannersCollection),
        );

  BannerModel.fromSnapshot(DocumentSnapshot doc)
      : id = doc.id,
        super(
          collectionReference: firestore.collection(bannersCollection),
          storageReference: storage.ref(bannersCollection),
        ) {
    var json = doc.data() as Map<String, dynamic>?;
    index = json?[INDEX];
    image = json?[IMAGE];
    dateCreated = (json?[DATECREATED] as Timestamp?)?.toDate();
    lastModified = (json?[LASTMODIFIED] as Timestamp?)?.toDate();
  }

  Map<String, dynamic> toJson() {
    return {
      ID: id,
      INDEX: index,
      IMAGE: image,
      DATECREATED: dateCreated,
      LASTMODIFIED: lastModified,
    };
  }

  Future<BannerModel> save({File? file, bool? isSet}) async {
    if (id.isEmptyOrNull) dateCreated = DateTime.now();
    lastModified = DateTime.now();
    id.isEmptyOrNull
        ? id = await super.add(toJson())
        : (isSet ?? false)
            ? super.collectionReference.doc(id).set(toJson())
            : await super.edit(toJson());
    if (file is File && !id.isEmptyOrNull) {
      image = await super.upload(id: id!, file: file);
      await super.edit(toJson());
    }
    return this;
  }

  Future<BannerModel?> getModel() async {
    return id.isEmptyOrNull
        ? null
        : BannerModel.fromSnapshot(await super.getID(id!));
  }
}
