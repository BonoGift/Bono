import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class SignUpService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  static String? verId;
  String otp = '';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String smsCode = '123456';

  verifyPhone(String phone) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (PhoneAuthCredential credential) {
        print("Navigatte");
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          print('The provided phone number is not valid.');
        }
      },
      timeout: const Duration(seconds: 60),
      codeSent: (String verificationId, int? resendToken) async {
        print(verificationId);
        print(resendToken);
        verId = verificationId;
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
            verificationId: verificationId, smsCode: smsCode);
        print(credential.smsCode);
        print("USer id valid");
        verId = verificationId;
        print("varer id $verId");
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        print("auto time out");
      },
    );
  }

  Future<bool> verifyOTP(String otp) async {
    print(verId);
    try {
      final PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verId!,
        smsCode: otp,
      );
      final UserCredential user = await _auth.signInWithCredential(credential);
      print("USer id Ok");
      return true;
    } catch (e) {
      print("USer Not Ok");
      return false;
    }
  }

  Future<DocumentSnapshot> checkIfUserAlready(String phone) async {
    Future<DocumentSnapshot> val =
        firestore.collection('users').doc(phone).get();
    return val;
  }

  Future<bool> saveToFirebase(Map<String, dynamic> map) async {
    String defaultImage =
        "https://firebasestorage.googleapis.com/v0/b/bonogifts.appspot.com/o/profile.png?alt=media&token=dec6afee-44f3-4876-8f2b-dbb2be0dd4d8";
    final DocumentReference ref =
        FirebaseFirestore.instance.collection('users').doc(map['phone']);

    if (map['image'] == null) {
      print("Image null");
      var userData = {
        'name': map['name'],
        'email': map['email'],
        'phone': map['phone'],
        'profile_url': defaultImage,
        'image url': defaultImage,
        'timestamp': DateTime.now(),
        'dobFormat': map['dobFormat'],
        'country': map['country'],
        'villa': map['villa'],
        'buildingName': map['buildingName'],
        'area': map['area'],
        'city': map['city'],
        'street': map['street'],
        'searchPhone': map['searchPhone'],
        'searchPhone1':
            '00${map['phone'].toString().substring(1, map['phone'].length)}'
      };

      await ref.set(userData);
    } else {
      print("Image NOT null");
      var snapshot = await FirebaseStorage.instance
          .ref()
          .child('Profile Pictures/${map['phone']}')
          .putData(map['image']);

      var url = (await snapshot.ref.getDownloadURL()).toString();
      var userData = {
        'name': map['name'],
        'email': map['email'],
        'phone': map['phone'],
        'profile_url': url,
        'image url': url,
        'timestamp': DateTime.now(),
        'dobFormat': map['dobFormat'],
        'country': map['country'],
        'city': map['city'],
        'villa': map['villa'],
        'buildingName': map['buildingName'],
        'area': map['area'],
        'street': map['street'],
        'searchPhone': map['searchPhone'],
        'searchPhone1':
            '00${map['phone'].toString().substring(1, map['phone'].length)}'
      };
      await ref.set(userData);
    }
    return true;
  }

  Future<bool> updateUserProfile(Map<String, dynamic> map, String phone) async {
    String defaultImage =
        "https://firebasestorage.googleapis.com/v0/b/bonogifts.appspot.com/o/profile.png?alt=media&token=dec6afee-44f3-4876-8f2b-dbb2be0dd4d8";
    final DocumentReference ref =
        FirebaseFirestore.instance.collection('users').doc(map['phone']);

    if (map['image'] == null) {
      print("Image null");
      var userData = {
        'name': map['name'],
        'email': map['email'],
        'phone': map['phone'],
        'timestamp': DateTime.now(),
        'dobFormat': map['dobFormat'],
        'country': map['country'],
        'city': map['city'],
        'villa': map['villa'],
        'buildingName': map['buildingName'],
        'area': map['area'],
        'street': map['street'],
      };
      await ref.update(userData);
    } else {
      print("Image NOT null");
      var snapshot = await FirebaseStorage.instance
          .ref()
          .child('Profile Pictures/${map['phone']}')
          .putData(map['image']);

      var url = (await snapshot.ref.getDownloadURL()).toString();
      var userData = {
        'name': map['name'],
        'email': map['email'],
        'phone': map['phone'],
        'profile_url': url,
        'image url': url,
        'timestamp': DateTime.now(),
        'dobFormat': map['dobFormat'],
        'country': map['country'],
        'city': map['city'],
        'villa': map['villa'],
        'buildingName': map['buildingName'],
        'area': map['area'],
        'street': map['street'],
      };
      await ref.update(userData);
    }
    return true;
  }

  Future<Map<String, dynamic>> getUser(String phone) async {
    Map<String, dynamic>? data;
    await firestore.collection('users').doc(phone).get().then((value) {
      data = value.data()!;
    });
    return data!;
  }

  addContacts(String ref, String title, Map<String, dynamic> map) {
    firestore.collection('users').doc(ref).collection(title).add({
      'name': map['name'],
      'image': map['image'],
      'phone': map['phone'],
    });
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getMyPhotoy(String phone) async {
    Future<QuerySnapshot<Map<String, dynamic>>> data = FirebaseFirestore
        .instance
        .collection('userPosts')
        .where('phone', isEqualTo: phone)
        .get();
    return data;
  }
}
