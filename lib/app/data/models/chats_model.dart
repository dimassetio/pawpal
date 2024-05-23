import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:pawpal/app/data/helpers/database.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pawpal/app/data/models/message_model.dart';
import 'package:pawpal/app/data/models/user_model.dart';

class ChatsModel extends Database {
  static const String ID = "ID";
  static const String CONNECTIONS = "CONNECTIONS";
  static const String DATECREATED = "DATECREATED";
  static const String LASTMODIFIED = "LASTMODIFIED";

  String? id;
  List<String>? connections;
  List<MessageModel>? messages;
  UserModel? receiver;
  int? unreadCount;
  DateTime? dateCreated;
  DateTime? lastModified;

  ChatsModel({
    this.id,
    this.unreadCount,
    this.messages,
    this.receiver,
    this.connections,
    this.dateCreated,
    this.lastModified,
  }) : super(
          collectionReference: firestore.collection(chatsCollection),
          storageReference: storage.ref(chatsCollection),
        );

  ChatsModel.fromSnapshot(DocumentSnapshot doc)
      : id = doc.id,
        super(
          collectionReference: firestore.collection(chatsCollection),
          storageReference: storage.ref(chatsCollection),
        ) {
    var json = doc.data() as Map<String, dynamic>?;

    dateCreated = (json?[DATECREATED] as Timestamp?)?.toDate();
    lastModified = (json?[LASTMODIFIED] as Timestamp?)?.toDate();
    connections = List<String>.from(json?[CONNECTIONS]);
  }

  Map<String, dynamic> toJson() {
    return {
      ID: id,
      CONNECTIONS: connections,
      DATECREATED: dateCreated,
      LASTMODIFIED: lastModified,
    };
  }

  Stream<List<ChatsModel>> streamChats(String userId) {
    return collectionReference
        .where(CONNECTIONS, arrayContains: userId)
        .orderBy(LASTMODIFIED, descending: true)
        .snapshots()
        .map((value) =>
            value.docs.map((e) => ChatsModel.fromSnapshot(e)).toList());
  }

  Future<ChatsModel> save({File? file, bool? isSet}) async {
    if (id.isEmptyOrNull) dateCreated = DateTime.now();
    lastModified = DateTime.now();
    id.isEmptyOrNull
        ? id = await super.add(toJson())
        : (isSet ?? false)
            ? super.collectionReference.doc(id).set(toJson())
            : await super.edit(toJson());
    return this;
  }

  Future<ChatsModel?> getPet() async {
    return id.isEmptyOrNull
        ? null
        : ChatsModel.fromSnapshot(await super.getID(id!));
  }

  Stream<ChatsModel> stream() {
    return super
        .collectionReference
        .doc(id)
        .snapshots()
        .map((event) => ChatsModel.fromSnapshot(event));
  }

  Stream<List<MessageModel>> streamMessages() {
    return super
        .collectionReference
        .doc(id)
        .collection(messageCollection)
        .orderBy(DATECREATED, descending: true)
        .snapshots()
        .map((event) =>
            event.docs.map((e) => MessageModel.fromSnapshot(e)).toList());
  }

  Future<List<MessageModel>> getUnreadMessages(String senderId) {
    return super
        .collectionReference
        .doc(id)
        .collection(messageCollection)
        .where(MessageModel.ISREAD, isEqualTo: false)
        .where(MessageModel.SENDER_ID, isNotEqualTo: senderId)
        .get()
        .then((value) =>
            value.docs.map((e) => MessageModel.fromSnapshot(e)).toList());
  }

  Future<MessageModel?> getLastMessage() {
    return super
        .collectionReference
        .doc(id)
        .collection(messageCollection)
        .orderBy(DATECREATED, descending: true)
        .limit(1)
        .get()
        .then((value) => value.docs.isEmpty
            ? null
            : MessageModel.fromSnapshot(value.docs.first));
  }

  Future<List<ChatsModel>> getFromConnection(String user1, String user2) async {
    return await super
        .collectionReference
        .where(CONNECTIONS, whereIn: [
          [user1, user2],
          [user2, user1],
        ])
        .get()
        .then((value) =>
            value.docs.map((e) => ChatsModel.fromSnapshot(e)).toList());
  }

  Future<UserModel?> getReceiverData(String userId) async {
    if (connections?.isEmpty ?? true) {
      return null;
    }
    receiver = await UserModel(
            uid: connections!.firstWhereOrNull((element) => element != userId))
        .getByUid();
    return receiver;
  }
}
