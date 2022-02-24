import 'package:bono_gifts/views/gift/model/history_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryProvider extends ChangeNotifier {
  DateFormat format = DateFormat('dd-MMMM-yyyy');

  List<HistoryModel> allHistory = [];
  List<HistoryModel> receivedHistory = [];
  List<HistoryModel> sendHistory = [];

  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

   getHistoryFromFirebase() async {
    var data = await _firebaseFirestore.collection('history').get();
    var doc = data.docs.map((e) => e.data()).toList();
    // var check = await _firebaseFirestore.collectionGroup('/');
    print('***** inside get history method');
    print('********** this is data');
    print(data);
    print('****** this is all doc');
    print(doc[0]['date']);
    // print(date);
    print(isReceived(doc[0]['receiver-number'].toString().trim()));
    print(doc[0]['receiver-number']);
    // var tim = DateTime.fromMicrosecondsSinceEpoch(doc[0]['date'])
    print(doc);
    if (doc.isNotEmpty) {
      for (var element in doc) {
        addToList(allHistory, element);
        if (element['receiver-number'] == getPhone().toString()) {
          addToList(receivedHistory, element);
        } else {
          addToList(sendHistory, element);
        }
      }
    }
    notifyListeners();
  }

  addToList(List<HistoryModel> list, element) {
    Timestamp timestamp = element['date'];
    DateTime dateTime = timestamp.toDate();
    var date = format.format(dateTime);
    list.add(HistoryModel(
        date: date,
        giftImage: element['gift-images'],
        price: double.parse(element['price'].toString()),
        receiverImage: element['receiver-image'],
        receiverName: element['receiver-name'],
        receiverNumber: element['receiver-number'],
        senderImage: element['sender-image'],
        senderName: element['sender-name'],
        senderNumber: element['sender-number'],
        trackingStatus: element['tracking-status']));
    notifyListeners();
  }

  bool isReceived(String num) {
    bool isTrue = false;
    String number = getPhone().toString().trim();
    print('this is number in received method -----' + num);
    isTrue = num == number;
    if (num == number) {
      isTrue = true;
    }
    // isTrue = '1' == '1';
    return isTrue;
  }

  getPhone() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String phone = prefs.getString('phone').toString();
    // print('this is number from local storage ------' + phone);
    return phone;
  }
}
