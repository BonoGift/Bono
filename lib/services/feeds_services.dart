import 'package:bono_gifts/provider/sign_up_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class FeedsService{

  Future<bool> savePost(Map<String,dynamic> map,String randVal) async {
    final CollectionReference ref = FirebaseFirestore.instance.collection('userPosts');
    // final CollectionReference comRef = FirebaseFirestore.instance.collection('userPosts').doc(map['phone']).collection('comments');
      var snapshot = await FirebaseStorage.instance.ref().child('Posts Pictures').child('${map['phone']}/$randVal').putData(map['image']);
      var url = (await snapshot.ref.getDownloadURL()).toString();
      var userData = {
        'title': map['title'],
        'des': map['des'],
        'image url': url,
        'like':0,
        'share':0,
        'timestamp': DateTime.now(),
        'phone':map['phone'],
        'profileImage': map['profileImage'],
        'profileName':map['profileName'],
      };
      await ref.add(userData).then((value){
        print("Posted");
      });
    return true;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getFeedsPosts()async{
    Future<QuerySnapshot<Map<String, dynamic>>> data = FirebaseFirestore.instance.collection('userPosts').orderBy('timestamp',descending: true).get();
    return data;
  }
  
  addComments(String docRed,BuildContext context,String text){
    final pro = Provider.of<SignUpProvider>(context,listen: false);
    FirebaseFirestore.instance.collection('userPosts').doc(docRed).collection('comments').add({
      'name':pro.name,
      'image':pro.userImage,
      'text': text,
    });
  }

  Future<bool> getLikePost(String userDoc,String postDoc)async{
    bool val = false;
    await FirebaseFirestore.instance.collection('users').doc(userDoc).collection('likedPosts').doc(postDoc).get().then((value){
      print("like post valeu $value");
      if(value.exists){
        val = true;
      }else{
        val = false;
      }
    });
    return val;
  }

  addLike(String docRed,int like,String userDoc){
    FirebaseFirestore.instance.collection('users').doc(userDoc).collection('likedPosts').doc(docRed).get().then((value){
      if(value.exists){
        FirebaseFirestore.instance.collection('userPosts').doc(docRed).update({
          'like':like == 0 ? 0 : like-1
        });
        FirebaseFirestore.instance.collection('users').doc(userDoc).collection('likedPosts').doc(docRed).delete();
        print("Exist");

      }else{
        print("Exist Not");
        FirebaseFirestore.instance.collection('userPosts').doc(docRed).update({
          'like':like+1
        });
        FirebaseFirestore.instance.collection('users').doc(userDoc).collection('likedPosts').doc(docRed).set({
          'id':docRed,
        });
      }
    });
  }

  Future<Map<String,dynamic>> getNetworkProfile(String phone)async{
    Map<String,dynamic>? data;
    await FirebaseFirestore.instance.collection('users').doc(phone).get().then((value){
      data = value.data()!;
    });
    return data!;
  }
  Future<QuerySnapshot<Map<String, dynamic>>> getUsersPost(String phone)async{
    Future<QuerySnapshot<Map<String, dynamic>>> data = FirebaseFirestore.instance.collection('userPosts').where('phone',isEqualTo: phone).get();
    return data;
  }



}