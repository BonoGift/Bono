import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ChatService {
  // status
  //  0 for firends
  //    1 for family
  //    2 for work
  //    3 for school
  //    4 for neghibor
  //    5 for others

  Future<QuerySnapshot> fetchSearch1(
      List<String> contactList, int i, String format) async {
    Future<QuerySnapshot> snap = FirebaseFirestore.instance
        .collection('users')
        .where(format, isEqualTo: contactList[i])
        .get();
    return snap;
  }

  Future<String> uploadImage(
      Uint8List? imageBytes, String cid, String filename, String userid) async {
    var snapshot = await FirebaseStorage.instance
        .ref()
        .child('chats/${userid}/$cid/$filename')
        .putData(imageBytes!);
    var url = (await snapshot.ref.getDownloadURL()).toString();
    return url;
  }

  likeMessage(String parentDoc, String subDoc, String docId, bool value) {
    FirebaseFirestore.instance
        .collection('chats')
        .doc(parentDoc)
        .collection(subDoc)
        .doc(docId)
        .update({
      'isFavorite': value,
    });
    FirebaseFirestore.instance
        .collection('chats')
        .doc(subDoc)
        .collection(parentDoc)
        .doc(docId)
        .update({
      'isFavorite': value,
    });
  }

  Future<String> uploadVoiceNote(
      Uint8List? imageBytes, String cid, String filename, String userid) async {
    var snapshot = await FirebaseStorage.instance
        .ref()
        .child('chats/${userid}/$cid/$filename')
        .putData(imageBytes!);
    var url = (await snapshot.ref.getDownloadURL()).toString();
    return url;
  }

  Future<bool> saveContactsToFirebase(
      String phoneId, Map<String, dynamic> map, String contactDoc) async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(phoneId)
        .collection('contacts')
        .doc(contactDoc)
        .set({
      'phone': contactDoc,
      'name': map['name'],
      'imageUrl': map['imageUrl'],
      'status': 0,
    });
    return true;
  }

  Future<DocumentSnapshot> fetchExistingMatchContacts(
      String docName, String userPhone) async {
    Future<DocumentSnapshot> snap = FirebaseFirestore.instance
        .collection('users')
        .doc(userPhone)
        .collection('contacts')
        .doc(docName)
        .get();
    print('this is contacts -----------');
    print(snap);
    return snap;
  }

  Future<QuerySnapshot> getContactsFromFirebase(
      String userPhone, int format) async {
    Future<QuerySnapshot> snap = FirebaseFirestore.instance
        .collection('users')
        .doc(userPhone)
        .collection('contacts')
        .where('status', isEqualTo: format)
        .get();
    print('this is contact data from firebase');
    print(snap);
    return snap;
  }

  Future<bool> moveNetworks(
      String userPhone, String targetPhone, int status) async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userPhone)
        .collection('contacts')
        .doc(targetPhone)
        .update({
      'status': status,
    }).then((value) {
      return true;
    });
    return false;
  }
}
