import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class BuyProvider extends ChangeNotifier{

  FirebaseFirestore fire = FirebaseFirestore.instance;

  String? userName;
  String? userImage;
  DateTime? userDob;
  String? userDobDays;
  String? userAddress;
  String? diffDays;

  assignVals(String name,String image,String phone){
    userName = name;
    userImage = image;
    fire.collection('users').doc(phone).get().then((value){
      print(value.data());
      userDob = value.data()?['dobFormat'].toDate();
      userAddress = value.data()?['country'];
      getDateDiff();
      notifyListeners();
    });
  }

  clearAll(){
    userName = null;
    userImage = null;
    userDob = null;
    userAddress = null;
    notifyListeners();
  }

  getDateDiff(){
    DateTime d = DateTime.now();
    var daOfBirth = DateTime(d.year,userDob!.month,userDob!.day);
    var todayDate = DateTime(d.year,d.month,d.day);
    var io = daOfBirth.difference(todayDate).inDays;
    diffDays = io.toString();

  }

}