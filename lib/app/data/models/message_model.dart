import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:pawpal/app/data/helpers/database.dart';
import 'package:nb_utils/nb_utils.dart';

class MessageModel extends Database {
  static const String ID = "ID";
  static const String CHAT_ID = "CHAT_ID";
  static const String TEXT = "TEXT";
  static const String SENDER_ID = "SENDER_ID";
  static const String ISREAD = "ISREAD";
  static const String MEDIA = "MEDIA";
  static const String PET_REFERENCE = "PET_REFERENCE";
  static const String DATECREATED = "DATECREATED";
  static const String LASTMODIFIED = "LASTMODIFIED";

  String? id;
  String? chatId;
  String? text;
  String? senderId;
  bool? isRead;
  String? media;
  DocumentReference? petReference;
  DateTime? dateCreated;
  DateTime? lastModified;

  MessageModel({
    this.id,
    this.chatId,
    this.text,
    this.isRead,
    this.senderId,
    this.media,
    this.petReference,
    this.dateCreated,
    this.lastModified,
  }) : super(
          collectionReference: getCollectionReference(chatId),
          storageReference: getStorageReference(chatId),
        );

  static CollectionReference getCollectionReference(String? chatId) => firestore
      .collection(chatsCollection)
      .doc(chatId ?? 'trash')
      .collection(messageCollection);

  static Reference getStorageReference(String? chatId) => storage
      .ref(chatsCollection)
      .child(chatId ?? 'trash')
      .child(messageCollection);

  MessageModel.fromSnapshot(DocumentSnapshot doc)
      : id = doc.id,
        super(
          collectionReference: firestore
              .collection(chatsCollection)
              .doc((doc.data() as Map<String, dynamic>?)?[CHAT_ID])
              .collection(messageCollection),
          storageReference: storage
              .ref(chatsCollection)
              .child((doc.data() as Map<String, dynamic>?)?[CHAT_ID])
              .child(messageCollection),
        ) {
    var json = doc.data() as Map<String, dynamic>?;
    chatId = json?[CHAT_ID];
    text = json?[TEXT];
    isRead = json?[ISREAD];
    senderId = json?[SENDER_ID];
    media = json?[MEDIA];
    petReference = json?[PET_REFERENCE];
    dateCreated = (json?[DATECREATED] as Timestamp?)?.toDate();
    lastModified = (json?[LASTMODIFIED] as Timestamp?)?.toDate();
  }

  Map<String, dynamic> toJson() {
    return {
      ID: id,
      CHAT_ID: chatId,
      TEXT: text,
      SENDER_ID: senderId,
      ISREAD: isRead,
      MEDIA: media,
      PET_REFERENCE: petReference,
      DATECREATED: dateCreated,
      LASTMODIFIED: lastModified,
    };
  }

  Future<MessageModel> save({File? file, bool? isSet}) async {
    if (id.isEmptyOrNull) dateCreated = DateTime.now();
    lastModified = DateTime.now();
    id.isEmptyOrNull
        ? id = await super.add(toJson())
        : (isSet ?? false)
            ? super.collectionReference.doc(id).set(toJson())
            : await super.edit(toJson());
    return this;
  }

  Future<MessageModel?> getMessage() async {
    return id.isEmptyOrNull
        ? null
        : MessageModel.fromSnapshot(await super.getID(id!));
  }
}
