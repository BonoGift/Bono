import 'package:bono_gifts/views/gift/model/history_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryProvider extends ChangeNotifier {
  DateFormat format = DateFormat('dd-MMMM-yyyy');

  List<HistoryModel> allHistory = [];
  List<HistoryModel> receivedHistory = [];
  List<HistoryModel> sendHistory = [];

  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  getHistoryFromFirebase() async {
    clearHistories();
    var data = await _firebaseFirestore.collection('history').get();
    List<HistoryModel> histories =
        data.docs.map((e) => HistoryModel.fromJson(e.data())).toList();
    if (histories.isNotEmpty) {
      for (HistoryModel history in histories) {
        print(
            "Status ${history.receiverNumber} == ${getPhone().toString()} : ${history.receiverNumber == getPhone().toString()}");
        if (history.receiverNumber == await getPhone()) {
          addToList(allHistory, history, true);
          addToList(receivedHistory, history, true);
        } else if (history.senderNumber == await getPhone()) {
          addToList(allHistory, history, false);

          addToList(sendHistory, history, false);
        }
      }
    }
    notifyListeners();
  }

  addToList(List<HistoryModel> list, HistoryModel history, bool isReceived) {
    // Timestamp timestamp = history.date;
    // DateTime dateTime = timestamp.toDate();
    // var date = format.format(dateTime);
    HistoryModel historyModel = HistoryModel(
        date: history.date,
        giftImage: history.giftImage,
        price: history.price,
        receiverImage: history.receiverImage,
        receiverName: history.receiverName,
        receiverNumber: history.receiverNumber,
        senderImage: history.senderImage,
        senderName: history.senderName,
        senderNumber: history.senderNumber,
        trackingStatus: history.trackingStatus);

    historyModel.isReceived = isReceived;
    list.add(historyModel);
    notifyListeners();
  }

  Future<void> addOrderHistory(HistoryModel history) async {
    try {
      await _firebaseFirestore.collection('history').add(history.toJson());
    } on FirebaseException catch (e) {
      print(e.message);
    }
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

  Future<String> getPhone() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String phone = prefs.getString('phone').toString();
    // print('this is number from local storage ------' + phone);
    return phone;
  }

  clearHistories() {
    allHistory.clear();
    receivedHistory.clear();
    sendHistory.clear();
  }
}
