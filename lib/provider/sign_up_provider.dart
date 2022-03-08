import 'dart:async';
import 'dart:typed_data';

import 'package:bono_gifts/models/user_model.dart';
import 'package:bono_gifts/routes/routes_names.dart';
import 'package:bono_gifts/services/sign_up_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpProvider extends ChangeNotifier {
  TextEditingController phoneNumber = TextEditingController();
  String code = '+971';
  String? dailCode;
  int time = 60;
  late Timer timer;
  String? dob;
  DateTime todayDate = DateTime.now();
  TextEditingController deliTitleContr = TextEditingController(text: "Home");
  String deliTitle = 'Home';
  String work = 'Work';
  TextEditingController room = TextEditingController();
  TextEditingController buildingName = TextEditingController();
  TextEditingController area = TextEditingController();
  TextEditingController street = TextEditingController();
  TextEditingController city = TextEditingController();
  double? latitude;
  double? longitude;
  Map<MarkerId, Marker> markers = {};
  XFile? image;
  String name = '';
  String? email;
  DateTime dobFormat = DateTime.now();
  String? country;
  String userImage = '';
  String? otp;
  String otpErro = '';
  bool isWaitingCon = false;
  Uint8List? bytesImage;
  String? phone;
  DateTime? timeStamp;

  List<String> myPosts = [];

  getImage() async {
    XFile? tempImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 25,
    );
    image = tempImage;
    bytesImage = await image!.readAsBytes();
    notifyListeners();
  }

  setDialCode(String code) => dailCode = code;

  setOTP(String otpCOde) => otp = otpCOde;

  setRoom(String sRoom) => room = TextEditingController(text: sRoom);

  setBuild(String sBuild) => buildingName = TextEditingController(text: sBuild);

  setArea(String sArea) => area = TextEditingController(text: sArea);

  setStreet(String sStreet) => street = TextEditingController(text: sStreet);

  setCity(String sCity) => city = TextEditingController(text: sCity);

  setPhoneNum(String phone) {
    phoneNumber = TextEditingController(text: phone);
    phone = '$dailCode$phone';
  }

  setName(String namee) => name = namee;

  setEmail(String emaill) => email = emaill;

  setDOB(String dobb, DateTime date) {
    dob = dobb;
    dobFormat = date;
    notifyListeners();
  }

  startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (time == 0) {
        time = 00;
        timer.cancel();
        notifyListeners();
      } else {
        time--;
        notifyListeners();
      }
    });
  }

  setLocation(GoogleMapController _controller) async {
    var status = Geolocator.checkPermission();
    status.whenComplete(() {
      // ignore: unrelated_type_equality_checks
      if (status == false) {
        Geolocator.requestPermission();
      }
    });
    // await Geolocator.requestPermission();
    Geolocator.getCurrentPosition().then((pos) async {
      latitude = pos.latitude;
      longitude = pos.longitude;
      addMarker();
      List<Placemark> newPlace = await placemarkFromCoordinates(pos.latitude, pos.longitude);
      setStreet(newPlace.last.street!);
      setArea(newPlace.last.name!);
      setCity(newPlace.last.locality!);
      country = newPlace.last.country;
      animateCamera(_controller);
      notifyListeners();
    });
  }

  // Permissions
  requestPermissions() async {
    if (kDebugMode) {
      print('---------------- this is request');
    }
    Permission.camera.request().then((value) {}).then((value) {
      // request camera
      Permission.location.request().then((value) {}).then((value) {
        // request location
        Permission.mediaLibrary.request().then((value) {}).then((value) {
          // request media library
          Permission.photos.request().then((value) {}).then((value) {
            // request photos
            Permission.microphone.request().then((value) {}); // request microphone
          });
        });
      });
    });
  }

  void animateCamera(GoogleMapController _controller) {
    _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(latitude!, longitude!),
      zoom: 30.12,
      // tilt: 10.0,
      // bearing: 12.0,
    )));
  }

  final service = SignUpService();

  addMarker() {
    MarkerId markerId = const MarkerId("map");
    Marker marker = Marker(markerId: markerId, icon: BitmapDescriptor.defaultMarker, position: LatLng(latitude!, longitude!));
    markers[markerId] = marker;
  }

  signUpUser(BuildContext context, bool isInit) {
    Map<String, dynamic> userMap = {
      'phone': '$dailCode${phoneNumber.text.replaceAll(' ', '')}',
      'name': name,
      'dob': dob,
      'dobFormat': dobFormat,
      'email': email,
      'image': bytesImage,
      'city': city.text.trim(),
      'country': country,
      'villa': room.text,
      'buildingName': buildingName.text,
      'area': area.text,
      'street': street.text,
      'searchPhone': '0${phoneNumber.text}',
      'dailCode': dailCode,
    };
    service.saveToFirebase(userMap).then((value) {
      saveToShared(true);
      makeWaitingDone();
      if (value && isInit) {
        Navigator.pushReplacementNamed(context, bottomNav);
      } else {
        getUser();
        Navigator.pop(context);
      }
    });
  }

  updateProfile(BuildContext context) async {
    Map<String, dynamic> userMap = {
      'phone': phoneNumber.text,
      'name': name,
      'dob': dob,
      'dobFormat': dobFormat,
      'email': email ?? '',
      'image': bytesImage,
      'city': city.text.trim(),
      'country': country ?? '',
      'villa': room.text,
      'buildingName': buildingName.text,
      'area': area.text,
      'street': street.text,
      'dailCode': dailCode,
    };
    phone = phoneNumber.text;
    await service.checkIfUserAlready(phoneNumber.text).then((value) {
      if (value.exists) {
        saveToShared(true);
        service.updateUserProfile(userMap, phone!).then((value) {
          saveToShared(false);
          makeWaitingDone();
          if (value) {
            getUser();
            Navigator.pop(context);
          }
        });
        //Navigator.pushNamed(context, laoding);
      } else {
        signUpUser(context, true);
        //Navigator.pushNamed(context, dobPage);
      }
    });
  }

  Timestamp? userDate;
  String? diffDays;

  getUser() async {
    await service.getUser(phone!).then((data) {
      phoneNumber = TextEditingController(text: data['phone']);
      name = data['name'];
      dob = data['dob'];
      dobFormat = data['dobFormat'].toDate();
      email = data['email'];
      userImage = data['profile_url'];
      country = data['country'];
      city = TextEditingController(text: data['city']);
      room = TextEditingController(text: data['villa']);
      buildingName = TextEditingController(text: data['buildingName']);
      area = TextEditingController(text: data['area']);
      street = TextEditingController(text: data['street']);
      code = data['dailCode'];
      getDateDiff();
      notifyListeners();
    });
    getMyPhoto();
  }

  Future<UserModel> getUserById(String phone) async {
    Map<String, dynamic> data = await service.getUser(phone);
    UserModel userModel = UserModel.fromDocument(data);
    return userModel;
  }

  saveToShared(bool isInit) async {
    SharedPreferences pre = await SharedPreferences.getInstance();
    if (isInit == true) {
      pre.setString('phone', '$dailCode${phoneNumber.text}');
    } else {
      pre.setString('phone', phoneNumber.text);
    }
    getUser();
  }

  getSharedData() async {
    SharedPreferences pre = await SharedPreferences.getInstance();
    var ph = pre.getString('phone');
    phoneNumber = TextEditingController(text: ph);
    phone = ph;

    print("=============================----------------$ph");

    if (phone != null || phone != '' || phoneNumber.text != null || phoneNumber.text != '') {
      getUser();
    }
  }

  setShared() async {
    String ph = '+923033374110';
    SharedPreferences pre = await SharedPreferences.getInstance();
    pre.setString('phone', ph);
  }

  logout(BuildContext context) async {
    SharedPreferences pre = await SharedPreferences.getInstance();
    pre.clear();
    Navigator.pushNamedAndRemoveUntil(context, laoding, (route) => false);
  }

  getDateDiff() {
    DateTime d = DateTime.now();
    var daOfBirth = DateTime(d.year, dobFormat.month, dobFormat.day);
    var todayDate = DateTime(d.year, d.month, d.day);
    var io = daOfBirth.difference(todayDate).inDays;
    diffDays = io.toString();
  }

  makeWaitingState() {
    isWaitingCon = true;
    notifyListeners();
  }

  makeWaitingDone() {
    isWaitingCon = false;
    notifyListeners();
  }

  authUserWithPhone() {
    service.verifyPhone('$dailCode${phoneNumber.text}');
  }

  verifyOTP(BuildContext context) async {
    service.verifyOTP(otp!).then((value) async {
      isWaitingCon = false;
      if (!value) {
        otpErro = 'Invalid OTP';
      } else {
        await service.checkIfUserAlready('$dailCode${phoneNumber.text}').then((value) {
          print(value);
          if (value.exists == true) {
            print("USer called Exist");
            saveToShared(true);
            Navigator.pushNamed(context, laoding);
          } else {
            print("USer called Not Exost");
            Navigator.pushNamed(context, dobPage);
          }
        });
      }
      notifyListeners();
    });
  }

  setContacts(String title, Map<String, dynamic> map) {
    service.addContacts(phone!, title, map);
  }

  getMyPhoto() {
    myPosts.clear();
    myPosts.clear();
    service.getMyPhotoy(phone!).then((value) {
      print(phone!);
      for (var i in value.docs) {
        print("docs my post $i");
        myPosts.add(i['image url']);
        print('-------- my posts $myPosts');
        print("docs my post length ${myPosts.length}");
      }
      notifyListeners();
    });
  }
}
