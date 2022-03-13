import 'package:bono_gifts/provider/sign_up_provider.dart';
import 'package:bono_gifts/provider/wcmp_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class BuyProvider extends ChangeNotifier {
  FirebaseFirestore fire = FirebaseFirestore.instance;
  final SignUpProvider signUpProvider = SignUpProvider();
  late TextEditingController noteController;

  String? userName;
  String? userImage;
  DateTime? userDob;
  String? userDobDays;
  String? userAddress;
  String? diffDays;

  init() {
    noteController = TextEditingController(text: '');
  }

  assignVals(WooCommerceMarketPlaceProvider provider, String name, String image,
      String phone) async {
    provider.selectReceiver(await signUpProvider.getUserById(phone));
    userName = name;
    userImage = image;
    fire.collection('users').doc(phone).get().then((value) {
      print(value.data());
      userDob = value.data()?['dobFormat'].toDate();
      userAddress = value.data()?['country'];
      getDateDiff();
      notifyListeners();
    });
  }

  clearAll() {
    userName = null;
    userImage = null;
    userDob = null;
    userAddress = null;
    notifyListeners();
  }

  getDateDiff() {
    DateTime d = DateTime.now();
    var daOfBirth = DateTime(d.year, userDob!.month, userDob!.day);
    var todayDate = DateTime(d.year, d.month, d.day);
    var io = daOfBirth.difference(todayDate).inDays;
    diffDays = io.toString();
  }
}
