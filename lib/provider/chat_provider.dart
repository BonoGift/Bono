import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:bono_gifts/models/contact_model.dart';
import 'package:bono_gifts/models/move_list_model.dart';
import 'package:bono_gifts/models/network_cat_model.dart';
import 'package:bono_gifts/models/network_model.dart';
import 'package:bono_gifts/provider/sign_up_provider.dart';
import 'package:bono_gifts/services/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

class ChatProvider extends ChangeNotifier {
  List<int> networkCatList = [0, 1, 2, 3, 4, 5];
  List<String> phones = [];
  List<String> contactList = [];

  List<NetWorkModel> friendsList = [];
  List<NetWorkModel> familyList = [];
  List<NetWorkModel> workList = [];
  List<NetWorkModel> neighborList = [];
  List<NetWorkModel> schoolList = [];
  List<NetWorkModel> othersList = [];

  List<NetWorkModel> moveList = [];

  List<String> newList = [];
  List<ContModel> nameCont = [];
  List<MoveListModel> moveListt = [];

  AudioCache audio = AudioCache(fixedPlayer: AudioPlayer());

  playSendMusic() {
    audio.play("send.wav");
  }

  playRecieveMessage() {
    audio.play("receive.wav");
  }

  playBackgroundRecieveMessage() {
    audio.play("receive_bg.wav");
  }

  addinMoveList(MoveListModel item, bool isChecked) {
    moveListt = [];
    moveListt.add(item);
    notifyListeners();

    /*  if(isChecked) {
      for (var i = 0; i < moveListt.length; i++) {
        if (moveListt[i].phone.contains(item.phone)) {
          moveListt.removeAt(i);
        }
      }
      notifyListeners();
    } else {
      moveListt.add(item);
      notifyListeners();
    }
    notifyListeners();
    print("move list ${moveListt.length}");*/
  }

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  makeNetWorkSelect(int index) {
    netWorkLsit[index].isSelect = !netWorkLsit[index].isSelect;
    notifyListeners();
  }

  makeCatSE(int idn) {
    networkCat[idn].isSel = !networkCat[idn].isSel;
    notifyListeners();
  }

  makeselect(int i) {
    for (var l in networkCat) {
      l.isSel = false;
    }
    networkCat[i].isSel = true;
    notifyListeners();
  }

  makeCatSelect(int ind) {
    for (var l in networkCat) {
      l.isSel = false;
    }
    networkCat[ind].isSel = true;
  }

  addFirstChar(String chat) {
    matchList.add(chat);
  }

  checkBoxSelect(int i, List<dynamic> list) {
    list[i].isSelect = !list[i].isSelect;
    notifyListeners();
  }

  shareBono() {
    Share.share("Hi, Iam using Bono messaging app. it let's you surprise your friends with real gifts!. Let's chat there :)....,click the link below to download it\n www.gitbono.com");
  }

  moveNetWorkInFirebase(BuildContext context, int status) {
    friendsList = [];
    familyList = [];
    workList = [];
    neighborList = [];
    schoolList = [];
    othersList = [];
    final pro = Provider.of<SignUpProvider>(context, listen: false);
    for (var i = 0; i < moveListt.length; i++) {
      service.moveNetworks(pro.phone!, moveListt[i].phone, status).then((value) {
        getContactsFromFirebase(context);
        moveListt.clear();
      });
    }
  }

  searchNetwork(String searchPertren) {
    for (var i = 0; i < friendsList.length; i++) {
      if (friendsList[i].name.toLowerCase().contains(searchPertren.toLowerCase())) {
      } else {
        friendsList.removeAt(i);
      }
    }
    for (var i = 0; i < familyList.length; i++) {
      if (familyList[i].name.toLowerCase().contains(searchPertren.toLowerCase())) {
      } else {
        familyList.removeAt(i);
      }
    }
    for (var i = 0; i < workList.length; i++) {
      if (workList[i].name.toLowerCase().contains(searchPertren.toLowerCase())) {
      } else {
        workList.removeAt(i);
      }
    }
    for (var i = 0; i < schoolList.length; i++) {
      if (schoolList[i].name.toLowerCase().contains(searchPertren.toLowerCase())) {
      } else {
        schoolList.removeAt(i);
      }
    }
    for (var i = 0; i < neighborList.length; i++) {
      if (neighborList[i].name.toLowerCase().contains(searchPertren.toLowerCase())) {
      } else {
        neighborList.removeAt(i);
      }
    }
    for (var i = 0; i < othersList.length; i++) {
      if (othersList[i].name.toLowerCase().contains(searchPertren.toLowerCase())) {
      } else {
        othersList.removeAt(i);
      }
    }
    notifyListeners();
  }

  List matchList = [];

  void getContacts(BuildContext context) async {
    contactList.clear();
    if (await FlutterContacts.requestPermission()) {
      List<Contact> contacts = await FlutterContacts.getContacts();
      contacts = await FlutterContacts.getContacts(withProperties: true, withPhoto: true);
      for (var i = 0; i < contacts.length; i++) {
        contactList.add(contacts[i].phones[0].number.replaceAll(' ', ''));
        nameCont.add(ContModel(name: "${contacts[i].name.first} ${contacts[i].name.last}", phone: contacts[i].phones[0].number));
        // print(contactList);
        notifyListeners();
      }
    }
    Future.delayed(const Duration(seconds: 2), () {
      for (int i = 0; i < nameCont.length; i++) {
        addinMatchList(nameCont[i].name.substring(0, 1).toLowerCase());
      }
      fetchNewtrork(context);
    });
    notifyListeners();
  }

  addinMatchList(String char) {
    matchList.add(char);
    // notifyListeners();
  }

  List<NetWorkModel> netWorkLsit = [];

  final service = ChatService();

  List<NetCatMo> networkCat = [
    NetCatMo(name: 'All', isSel: false),
    NetCatMo(name: 'Friends', isSel: false),
    NetCatMo(name: 'Family', isSel: false),
    NetCatMo(name: 'Work', isSel: false),
    NetCatMo(name: 'School', isSel: false),
    NetCatMo(name: 'Neigbour', isSel: false),
    NetCatMo(name: 'Others', isSel: false),
  ];

  fetchNewtrork(BuildContext context) {
    print(contactList);
    // .where('searchPhone',isLessThanOrEqualTo: contactList[i]).where('searchPhone1',isEqualTo: contactList[i])
    for (var i = 0; i < contactList.length; i++) {
      service.fetchSearch1(contactList, i, 'searchPhone1').then((value) {
        for (var d = 0; d < value.docs.length; d++) {
          print(value.docs[d]['name']);
          netWorkLsit.add(NetWorkModel(
            name: value.docs[d]['name'],
            phone: value.docs[d]['phone'],
            photo: value.docs[d]['profile_url'],
            isSelect: false,
          ));
        }
      });
      service.fetchSearch1(contactList, i, 'phone').then((value) {
        for (var d = 0; d < value.docs.length; d++) {
          print(value.docs[d]['name']);
          netWorkLsit.add(NetWorkModel(name: value.docs[d]['name'], phone: value.docs[d]['phone'], photo: value.docs[d]['profile_url'], isSelect: false));
        }
      });
      service.fetchSearch1(contactList, i, 'searchPhone').then((value) {
        for (var d = 0; d < value.docs.length; d++) {
          print(value.docs[d]['name']);
          netWorkLsit.add(NetWorkModel(
            name: value.docs[d]['name'],
            phone: value.docs[d]['phone'],
            photo: value.docs[d]['profile_url'],
            isSelect: false,
          ));
        }
      });
    }
    Future.delayed(const Duration(seconds: 2), () {
      addContactToFirebase(context);
    });
    notifyListeners();
  }

  addContactToFirebase(BuildContext context) {
    final pro = Provider.of<SignUpProvider>(context, listen: false);
    for (var d in netWorkLsit) {
      service.fetchExistingMatchContacts(d.phone, pro.phone!).then((value) {
        if (!value.exists) {
          service
              .saveContactsToFirebase(
                  pro.phone!,
                  {
                    'imageUrl': d.photo,
                    'phone': d.phone,
                    'name': d.name,
                  },
                  d.phone)
              .then((value) {
            print("added");
          });
        }
      });
    }
    // Future.delayed(const Duration(seconds: 2),(){getContactsFromFirebase(context);});
  }

  emptyNetworks() {
    friendsList = [];
    familyList = [];
    workList = [];
    neighborList = [];
    schoolList = [];
    othersList = [];
    notifyListeners();
  }

  Map<String, String> errorMap = {};

  getContactsFromFirebase(BuildContext context) {
    print('_____ this is get contact from firebase in char provider');
    emptyNetworks();
    final pro = Provider.of<SignUpProvider>(context, listen: false);
    for (var d = 0; d < networkCatList.length; d++) {
      service.getContactsFromFirebase(pro.phone!, d).then((value) {
        try {
          for (var dd in value.docs) {
            switch (dd['status']) {
              case 0:
                friendsList.add(NetWorkModel(phone: dd['phone'], photo: dd['imageUrl'], isSelect: false, name: dd['name']));
                //print(friendsList.toString() + '--------- friendList');
                //notifyListeners();
                break;
              case 1:
                familyList.add(NetWorkModel(phone: dd['phone'], photo: dd['imageUrl'], isSelect: false, name: dd['name']));
                //notifyListeners();
                break;
              case 2:
                workList.add(NetWorkModel(phone: dd['phone'], photo: dd['imageUrl'], isSelect: false, name: dd['name']));
                //notifyListeners();
                break;
              case 3:
                schoolList.add(NetWorkModel(phone: dd['phone'], photo: dd['imageUrl'], isSelect: false, name: dd['name']));
                //notifyListeners();
                break;
              case 4:
                neighborList.add(NetWorkModel(phone: dd['phone'], photo: dd['imageUrl'], isSelect: false, name: dd['name']));
                //notifyListeners();
                break;
              case 5:
                othersList.add(NetWorkModel(phone: dd['phone'], photo: dd['imageUrl'], isSelect: false, name: dd['name']));
                //notifyListeners();
                break;
            }
            notifyListeners();
          }
        } catch (e) {
          errorMap.addAll({'error': e.toString()});
        }
      });
      notifyListeners();
    }
    //notifyListeners();
  }

  DateTime date = DateTime.now();

  String docId = '';

  String generateRandomString(int len) {
    var r = Random();
    const _chars = 'BCDEFGxcbHIJKLsdfdMNOPhfQRSTUdfdfcvVWXYZ';
    docId = List.generate(len, (index) => _chars[r.nextInt(_chars.length)]).join();
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)]).join();
  }

  sendTextMessage(BuildContext context, message, String recieverPhone, String messageCount, String recieverName, String profileImage) {
    final pro = Provider.of<SignUpProvider>(context, listen: false);
    firestore.collection('chats').doc(pro.phone.toString()).collection(recieverPhone).doc(docId).set({
      'message': message.text,
      'date': "${date.year}/${date.month}/${date.day}",
      'timestamp': DateTime.now(),
      'recieverID': recieverPhone,
      'senderID': pro.phone,
      'profileImage': pro.userImage,
      'count': messageCount,
      'isSendMe': true,
      'isSeen': false,
      'isOnline': true,
      'messageType': 'text',
      'isFavorite': false,
      'id': docId,
    });
    firestore.collection('chats').doc(recieverPhone).collection(pro.phone.toString()).doc(docId).set({
      'message': message.text,
      'date': "${date.year}/${date.month}/${date.day}",
      'timestamp': DateTime.now(),
      'recieverID': recieverPhone,
      'senderID': pro.phone,
      'profileImage': pro.userImage,
      'count': messageCount,
      'isSendMe': false,
      'isSeen': false,
      'isOnline': false,
      'messageType': 'text',
      'isFavorite': false,
      'id': docId,
    });
    firestore.collection('recentChats').doc(recieverPhone).collection('myChats').doc(pro.phone).set({
      'lastMessage': message.text,
      'date': "${date.year}/${date.month}/${date.day}",
      'timestamp': DateTime.now(),
      'recieverID': recieverPhone,
      'senderID': pro.phone,
      'recieverName': pro.name,
      'profileImage': pro.userImage,
      'count': messageCount,
      'isSendMe': false,
      'isSeen': false,
      'isOnline': false,
      'messageType': 'text',
      // 'token': widget.fcmToken,
    });
    firestore.collection('recentChats').doc(pro.phone.toString()).collection('myChats').doc(recieverPhone).set({
      'lastMessage': message.text,
      'date': "${date.year}/${date.month}/${date.day}",
      'timestamp': DateTime.now(),
      'recieverID': recieverPhone,
      'senderID': pro.phone,
      'recieverName': recieverName,
      'profileImage': profileImage,
      'count': messageCount,
      'isSendMe': true,
      'isSeen': false,
      'isOnline': true,
      'messageType': 'text',
      // 'token':widget.fcmToken,
    });
    playSendMusic();
  }

  sendImageMessage(BuildContext context, message, String recieverPhone, String messageCount, String recieverName, String profileImage) {
    final pro = Provider.of<SignUpProvider>(context, listen: false);
    firestore.collection('chats').doc(pro.phone.toString()).collection(recieverPhone).doc(docId).set({
      'message': message,
      'date': "${date.year}/${date.month}/${date.day}",
      'timestamp': DateTime.now(),
      'recieverID': recieverPhone,
      'senderID': pro.phone,
      'profileImage': pro.userImage,
      'count': messageCount,
      'isSendMe': true,
      'isSeen': false,
      'isOnline': true,
      'messageType': 'image',
      'isFavorite': false,
      'id': docId,
    });
    firestore.collection('chats').doc(recieverPhone).collection(pro.phone.toString()).doc(docId).set({
      'message': message,
      'date': "${date.year}/${date.month}/${date.day}",
      'timestamp': DateTime.now(),
      'recieverID': recieverPhone,
      'senderID': pro.phone,
      'profileImage': pro.userImage,
      'count': messageCount,
      'isSendMe': false,
      'isSeen': false,
      'isOnline': false,
      'messageType': 'image',
      'isFavorite': false,
      'id': docId,
    });
    firestore.collection('recentChats').doc(recieverPhone).collection('myChats').doc(pro.phone).set({
      'lastMessage': message,
      'date': "${date.year}/${date.month}/${date.day}",
      'timestamp': DateTime.now(),
      'recieverID': recieverPhone,
      'senderID': pro.phone,
      'recieverName': pro.name,
      'profileImage': pro.userImage,
      'count': messageCount,
      'isSendMe': false,
      'isSeen': false,
      'isOnline': false,
      'messageType': 'image',
      // 'token': widget.fcmToken,
    });
    firestore.collection('recentChats').doc(pro.phone.toString()).collection('myChats').doc(recieverPhone).set({
      'lastMessage': message,
      'date': "${date.year}/${date.month}/${date.day}",
      'timestamp': DateTime.now(),
      'recieverID': recieverPhone,
      'senderID': pro.phone,
      'recieverName': recieverName,
      'profileImage': profileImage,
      'count': messageCount,
      'isSendMe': true,
      'isSeen': false,
      'isOnline': true,
      'messageType': 'image',
      // 'token':widget.fcmToken,
    });
    playSendMusic();
  }

  sendVoiceMessage(BuildContext context, message, String recieverPhone, String messageCount, String recieverName, String profileImage) {
    final pro = Provider.of<SignUpProvider>(context, listen: false);
    firestore.collection('chats').doc(pro.phone.toString()).collection(recieverPhone).doc(docId).set({
      'message': message,
      'date': "${date.year}/${date.month}/${date.day}",
      'timestamp': DateTime.now(),
      'recieverID': recieverPhone,
      'senderID': pro.phone,
      'profileImage': pro.userImage,
      'count': messageCount,
      'isSendMe': true,
      'isSeen': false,
      'isOnline': true,
      'messageType': 'voice',
      'isFavorite': false,
      'id': docId,
    });
    firestore.collection('chats').doc(recieverPhone).collection(pro.phone.toString()).doc(docId).set({
      'message': message,
      'date': "${date.year}/${date.month}/${date.day}",
      'timestamp': DateTime.now(),
      'recieverID': recieverPhone,
      'senderID': pro.phone,
      'profileImage': pro.userImage,
      'count': messageCount,
      'isSendMe': false,
      'isSeen': false,
      'isOnline': false,
      'messageType': 'voice',
      'isFavorite': false,
      'id': docId,
    });
    firestore.collection('recentChats').doc(recieverPhone).collection('myChats').doc(pro.phone).set({
      'lastMessage': message,
      'date': "${date.year}/${date.month}/${date.day}",
      'timestamp': DateTime.now(),
      'recieverID': recieverPhone,
      'senderID': pro.phone,
      'recieverName': pro.name,
      'profileImage': pro.userImage,
      'count': messageCount,
      'isSendMe': false,
      'isSeen': false,
      'isOnline': false,
      'messageType': 'voice',
      // 'token': widget.fcmToken,
    });
    firestore.collection('recentChats').doc(pro.phone.toString()).collection('myChats').doc(recieverPhone).set({
      'lastMessage': message,
      'date': "${date.year}/${date.month}/${date.day}",
      'timestamp': DateTime.now(),
      'recieverID': recieverPhone,
      'senderID': pro.phone,
      'recieverName': recieverName,
      'profileImage': profileImage,
      'count': messageCount,
      'isSendMe': true,
      'isSeen': false,
      'isOnline': true,
      'messageType': 'voice',
      // 'token':widget.fcmToken,
    });
    playSendMusic();
  }

  likeMessage(String parentDoc, String subDoc, String docId, bool val) {
    service.likeMessage(parentDoc, subDoc, docId, val);
  }
}
