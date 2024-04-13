import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pawpal/app/data/helpers/database.dart';
import 'package:nb_utils/nb_utils.dart';

class UserModel extends Database {
  static const String ID = "ID";
  static const String UID = "UID";
  static const String ROLE = "ROLE";
  static const String USERNAME = "USERNAME";
  static const String NAMA = "NAMA";
  static const String EMAIL = "EMAIL";
  static const String GENDER = "GENDER";
  static const String ALAMAT = "ALAMAT";
  static const String SEKOLAH = "SEKOLAH";
  static const String TGL_MASUK = "TGL_MASUK";
  static const String FOTO = "FOTO";
  static const String IS_ACTIVE = "IS_ACTIVE";

  String? id;
  String? uid;
  String? role;
  String? email;
  String? username;
  String? nama;
  String? gender;
  String? sekolah;
  DateTime? tglMasuk;
  String? alamat;
  String? foto;
  bool? isActive;

  int countInternDays() {
    return (tglMasuk is DateTime)
        ? DateTime.now().difference(tglMasuk!).inDays + 1
        : 0;
  }

  UserModel({
    this.id,
    this.uid,
    this.role,
    this.email,
    this.username,
    this.nama,
    this.sekolah,
    this.tglMasuk,
    this.gender,
    this.alamat,
    this.foto,
    this.isActive,
  }) : super(
          collectionReference: firestore.collection(userCollection),
          storageReference: storage.ref(userCollection),
        );

  // UserModel.fromSnapshot(String? id, Map<String, dynamic> json)
  UserModel.fromSnapshot(DocumentSnapshot doc)
      : id = doc.id,
        super(
            collectionReference: firestore.collection(userCollection),
            storageReference: storage.ref(userCollection)) {
    var json = doc.data() as Map<String, dynamic>?;
    role = json?[ROLE];
    email = json?[EMAIL];
    username = json?[USERNAME];
    nama = json?[NAMA];
    sekolah = json?[SEKOLAH];
    tglMasuk = (json?[TGL_MASUK] as Timestamp?)?.toDate();
    gender = json?[GENDER];
    alamat = json?[ALAMAT];
    foto = json?[FOTO];
    isActive = json?[IS_ACTIVE];
  }

  Map<String, dynamic> toJson() {
    return {
      ID: id,
      UID: uid,
      ROLE: role,
      EMAIL: email,
      USERNAME: username,
      NAMA: nama,
      GENDER: gender,
      ALAMAT: alamat,
      SEKOLAH: sekolah,
      TGL_MASUK: tglMasuk,
      FOTO: foto,
      IS_ACTIVE: isActive,
    };
  }

  Future<UserModel?> getByUid() async {
    return uid.isEmptyOrNull
        ? null
        : await super
            .collectionReference
            .where(UID, isEqualTo: uid!)
            .get()
            .then((value) => value.docs.isNotEmpty
                ? UserModel.fromSnapshot(value.docs.first)
                : null);
  }

  bool hasRole(String value) => role == value;

  bool hasRoles(List<String> value) => value.contains(role);

  Future<UserModel> save({File? file, bool? isSet}) async {
    id.isEmptyOrNull
        ? id = await super.add(toJson())
        : (isSet ?? false)
            ? super.collectionReference.doc(id).set(toJson())
            : await super.edit(toJson());
    if (file != null && !id.isEmptyOrNull) {
      foto = await super.upload(id: id!, file: file);
      await super.edit(toJson());
    }
    return this;
  }

  Future<UserModel?> getUser() async {
    return id.isEmptyOrNull
        ? null
        : UserModel.fromSnapshot(await super.getID(id!));
  }

  Stream<UserModel> stream() {
    return super
        .collectionReference
        .doc(id)
        .snapshots()
        .map((event) => UserModel.fromSnapshot(event));
  }

  Stream<UserModel> streamByUid(pUid) {
    return super
        .collectionReference
        .where(UID, isEqualTo: pUid)
        .snapshots()
        .map((event) => event.docs.isEmpty
            ? UserModel()
            : UserModel.fromSnapshot(event.docs.first));
  }
}

abstract class Role {
  static const administrator = 'Administrator';
  static const user = 'User';
  // static const magang = 'Magang';
  // static const mentor = 'Mentor';
  // static const hrd = 'HRD';
  // static const employee = 'Employee';

  static const list = [administrator, user];
  // static const list = [magang, administrator, mentor, hrd, employee];
}
