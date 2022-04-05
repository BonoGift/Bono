import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:bono_gifts/models/birthday_network_model.dart';
import 'package:bono_gifts/models/celebrities_model.dart';
import 'package:bono_gifts/models/celebrity_item_model.dart';
import 'package:bono_gifts/models/contact_model.dart';
import 'package:bono_gifts/models/move_list_model.dart';
import 'package:bono_gifts/models/network_cat_model.dart';
import 'package:bono_gifts/models/network_model.dart';
import 'package:bono_gifts/provider/sign_up_provider.dart';
import 'package:bono_gifts/services/celebrities_service.dart';
import 'package:bono_gifts/services/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:intl/intl.dart';
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

  List<CelebritiesModel> celebritiesList = [];

  List<BirthdayNetworkModel> birthdayNetworkList = [
    BirthdayNetworkModel(month: 'January', items: [], sequence: 1),
    BirthdayNetworkModel(month: 'February', items: [], sequence: 2),
    BirthdayNetworkModel(month: 'March', items: [], sequence: 3),
    BirthdayNetworkModel(month: 'April', items: [], sequence: 4),
    BirthdayNetworkModel(month: 'May', items: [], sequence: 5),
    BirthdayNetworkModel(month: 'June', items: [], sequence: 6),
    BirthdayNetworkModel(month: 'July', items: [], sequence: 7),
    BirthdayNetworkModel(month: 'August', items: [], sequence: 8),
    BirthdayNetworkModel(month: 'September', items: [], sequence: 9),
    BirthdayNetworkModel(month: 'October', items: [], sequence: 10),
    BirthdayNetworkModel(month: 'November', items: [], sequence: 11),
    BirthdayNetworkModel(month: 'December', items: [], sequence: 12),
  ];
  List<BirthdayNetworkModel> formattedBirthdayNetworkList = [];

  List<NetWorkModel> moveList = [];

  List<String> newList = [];
  List<ContModel> nameCont = [];
  List<MoveListModel> moveListt = [];

  bool isScreenOn = true;
  bool isFirstLoad = true;

  final celebritiesService = CelebritiesService();

  List<String> months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];

  void changeIsScreenOnValue() {
    isScreenOn = false;
  }

  void changeIsFirstLoad() {
    isFirstLoad = false;
  }

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
    //print(contactList);
    for (var i = 0; i < contactList.length; i++) {
      service.fetchSearch1(contactList, i, 'searchPhone1').then((value) {
        for (var d = 0; d < value.docs.length; d++) {
          netWorkLsit.add(NetWorkModel(
            name: value.docs[d]['name'],
            phone: value.docs[d]['phone'],
            photo: value.docs[d]['profile_url'],
            dobFormat: value.docs[d]['dobFormat'],
            isSelect: false,
          ));
        }
      });
      service.fetchSearch1(contactList, i, 'phone').then((value) {
        for (var d = 0; d < value.docs.length; d++) {
          netWorkLsit.add(NetWorkModel(
            name: value.docs[d]['name'],
            phone: value.docs[d]['phone'],
            photo: value.docs[d]['profile_url'],
            dobFormat: value.docs[d]['dobFormat'],
            isSelect: false,
          ));
        }
      });
      service.fetchSearch1(contactList, i, 'searchPhone').then((value) {
        for (var d = 0; d < value.docs.length; d++) {
          netWorkLsit.add(NetWorkModel(
            name: value.docs[d]['name'],
            phone: value.docs[d]['phone'],
            photo: value.docs[d]['profile_url'],
            dobFormat: value.docs[d]['dobFormat'],
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
                    'dobFormat': d.dobFormat,
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
            formatBirthdayNetworkList(
              NetWorkModel(
                phone: dd['phone'],
                photo: dd['imageUrl'],
                isSelect: false,
                name: dd['name'],
                dobFormat: dd['dobFormat'],
              ),
            );
            switch (dd['status']) {
              case 0:
                friendsList.add(NetWorkModel(phone: dd['phone'], photo: dd['imageUrl'], isSelect: false, name: dd['name']));
                break;
              case 1:
                familyList.add(NetWorkModel(phone: dd['phone'], photo: dd['imageUrl'], isSelect: false, name: dd['name']));
                break;
              case 2:
                workList.add(NetWorkModel(phone: dd['phone'], photo: dd['imageUrl'], isSelect: false, name: dd['name']));
                break;
              case 3:
                schoolList.add(NetWorkModel(phone: dd['phone'], photo: dd['imageUrl'], isSelect: false, name: dd['name']));
                break;
              case 4:
                neighborList.add(NetWorkModel(phone: dd['phone'], photo: dd['imageUrl'], isSelect: false, name: dd['name']));
                break;
              case 5:
                othersList.add(NetWorkModel(phone: dd['phone'], photo: dd['imageUrl'], isSelect: false, name: dd['name']));
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
    sortBirthdayNetworkList();
  }

  void formatBirthdayNetworkList(NetWorkModel data) {
    DateFormat dateFormat = DateFormat('MMMM');

    String month = dateFormat.format(DateTime.parse(data.dobFormat!.toDate().toString())).toString();

    int index = birthdayNetworkList.indexWhere((element) => element.month == month);
    birthdayNetworkList[index].items.add(data);
  }

  void sortBirthdayNetworkList() {
    if (birthdayNetworkList.isNotEmpty) {
      List<BirthdayNetworkModel> items = [];

      birthdayNetworkList.sort((a, b) {
        return a.sequence!.compareTo(b.sequence!);
      });

      birthdayNetworkList.removeWhere((element) {
        if (months.indexOf(element.month!) + 1 < DateTime.now().month) {
          items.add(element);
          return true;
        }
        return false;
      });

      birthdayNetworkList.addAll(items);

      birthdayNetworkList.forEach((element) {
        element.items.sort((a, b) {
          DateTime aDateTime = a.dobFormat!.toDate();
          DateTime bDateTime = b.dobFormat!.toDate();
          DateTime now = DateTime.now();

          var daOfBirth = DateTime(now.year, aDateTime.month, aDateTime.day);
          var todayDate = DateTime(now.year, bDateTime.month, bDateTime.day);
          var io = daOfBirth.difference(todayDate).inDays;

          return io < 0 ? -1 : 1;
        });
      });
    }
  }

  void sortCelebritiesList() {
    if (celebritiesList.isNotEmpty) {
      List<CelebritiesModel> items = [];

      celebritiesList.sort((a, b) {
        return a.sequence! > b.sequence! ? 1 : -1;
      });

      celebritiesList.removeWhere((element) {
        if (months.indexOf(element.month!) + 1 < DateTime.now().month) {
          items.add(element);
          return true;
        }
        return false;
      });
      celebritiesList.addAll(items);
    }
  }

  Future<void> getCelebritiesList() async {
    await celebritiesService.getCelebritiesList().then((data) async {
      for (var item in data.docs) {
        List<CelebrityItemModel> items = [];

        await celebritiesService.getCelebritiesDataList(id: item.reference.id).then((value) {
          for (var snapshot in value.docs) {
            items.add(
              CelebrityItemModel(
                id: snapshot.reference.id,
                name: snapshot['name'],
                birthday: DateTime.parse(snapshot['birthday']!),
                zodiac: snapshot['zodiac'],
                image: snapshot['image'],
              ),
            );
          }
          celebritiesList.add(
            CelebritiesModel(
              month: item['month'],
              items: items,
              sequence: (months.indexOf(item['month']) + 1),
            ),
          );
        });
      }
    });
    sortCelebritiesList();
  }

  String getBirthdayDaysLeft(DateTime dateTime) {
    DateTime now = DateTime.now();
    var daOfBirth = DateTime(now.year, dateTime.month, dateTime.day);
    var todayDate = DateTime(now.year, now.month, now.day);
    var io = daOfBirth.difference(todayDate).inDays;

    if (io == 0) {
      return 'Today';
    }

    if (io == 1) {
      return 'Tomorrow';
    }

    if (io < 0) {
      io = io + 365;
    }
    return io.toString();
  }

  String getBirthdayDate(DateTime dateTime, {DateFormat? dateFormat}) {
    var inputFormat = dateFormat ?? DateFormat('dd-MMM, EEEE');
    String formattedDate = inputFormat.format(dateTime);
    return formattedDate;
  }

  String getZodiacByBirthday(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    String zodiac = getZodiacSign(dateTime);
    return zodiac;
  }

  String getZodiacSign(DateTime date) {
    var days = date.day;
    var months = date.month;
    if (months == 1) {
      if (days >= 21) {
        return "aquarius";
      } else {
        return "capricorn";
      }
    } else if (months == 2) {
      if (days >= 20) {
        return "picis";
      } else {
        return "aquarius";
      }
    } else if (months == 3) {
      if (days >= 21) {
        return "aries";
      } else {
        return "pisces";
      }
    } else if (months == 4) {
      if (days >= 21) {
        return "taurus";
      } else {
        return "aries";
      }
    } else if (months == 5) {
      if (days >= 22) {
        return "gemini";
      } else {
        return "taurus";
      }
    } else if (months == 6) {
      if (days >= 22) {
        return "cancer";
      } else {
        return "gemini";
      }
    } else if (months == 7) {
      if (days >= 23) {
        return "leo";
      } else {
        return "cancer";
      }
    } else if (months == 8) {
      if (days >= 23) {
        return "virgo";
      } else {
        return "leo";
      }
    } else if (months == 9) {
      if (days >= 24) {
        return "libra";
      } else {
        return "virgo";
      }
    } else if (months == 10) {
      if (days >= 24) {
        return "scorpio";
      } else {
        return "libra";
      }
    } else if (months == 11) {
      if (days >= 23) {
        return "sagittarius";
      } else {
        return "scorpio";
      }
    } else if (months == 12) {
      if (days >= 22) {
        return "capricorn";
      } else {
        return "sagittarius";
      }
    }
    return "";
  }

  bool checkBirthdayPassed(DateTime dateTime) {
    var daOfBirth = DateTime(date.year, dateTime.month, dateTime.day);
    var todayDate = DateTime(date.year, date.month, date.day);
    var io = daOfBirth.difference(todayDate).inDays;
    return io < 0;
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
