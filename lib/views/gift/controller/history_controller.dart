import 'package:bono_gifts/models/wcmp_api/order_response_model.dart';
import 'package:bono_gifts/services/wcmp_service.dart';
import 'package:bono_gifts/views/gift/model/history_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryProvider extends ChangeNotifier {
  DateFormat format = DateFormat('dd-MMMM-yyyy');

  int index = 0;

  List<HistoryModel> allHistory = [];
  List<HistoryModel> receivedHistory = [];
  List<HistoryModel> sendHistory = [];

  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  final WooCommerceMarketPlaceService wooCommerceMarketPlaceService =
      WooCommerceMarketPlaceService();

  Future<void> getHistoryFromFirebase() async {
    clearHistories();
    var data = await _firebaseFirestore
        .collection('history')
        .orderBy('date', descending: true)
        .get();
    List<HistoryModel> histories =
        data.docs.map((e) => HistoryModel.fromJson(e.data())).toList();
    if (histories.isNotEmpty) {
      for (HistoryModel history in histories) {
        print('History ' + history.toJson().toString());
        print(
            "Status ${history.receiverNumber} == ${await getPhone().toString()} : ${history.receiverNumber == getPhone().toString()}");
        if (history.receiverNumber == await getPhone()) {
          await addToList(allHistory, history, true);
          await addToList(receivedHistory, history, true);
        } else if (history.senderNumber == await getPhone()) {
          await addToList(allHistory, history, false);

          await addToList(sendHistory, history, false);
        }
      }
      await getStatusFromWordpress();
    }
    notifyListeners();
  }

  getStatusFromWordpress() async {
    List<OrderResponseModel> data =
        await wooCommerceMarketPlaceService.getAllOrders();
    for (OrderResponseModel order in data) {
      print("finding");
      for (int i = 0; i < allHistory.length; i++) {
        if (allHistory[i].id == order.id) {
          print("matched");

          allHistory[i].setStatus(order.status);
          print(allHistory[i].status);
        }
      }
      for (int i = 0; i < receivedHistory.length; i++) {
        if (receivedHistory[i].id == order.id) {
          print("matched");

          receivedHistory[i].setStatus(order.status);
          print(receivedHistory[i].status);
        }
      }
      for (int i = 0; i < sendHistory.length; i++) {
        if (sendHistory[i].id == order.id) {
          print("matched");

          sendHistory[i].setStatus(order.status);
          print(sendHistory[i].status);
        }
      }
    }
    notifyListeners();
  }

  Future<void> addToList(
      List<HistoryModel> list, HistoryModel history, bool isReceived) async {
    // Timestamp timestamp = history.date;
    // DateTime dateTime = timestamp.toDate();
    // var date = format.format(dateTime);
    HistoryModel historyModel = HistoryModel(
        id: history.id,
        date: history.date,
        giftImage: history.giftImage,
        price: history.price,
        receiverImage: history.receiverImage,
        receiverName: history.receiverName,
        receiverNumber: history.receiverNumber,
        senderImage: history.senderImage,
        senderName: history.senderName,
        senderNumber: history.senderNumber,
        status: history.status);

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
