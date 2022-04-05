import 'package:cloud_firestore/cloud_firestore.dart';

class CelebritiesService {
  Future<QuerySnapshot> getCelebritiesList() async {
    Future<QuerySnapshot> snap = FirebaseFirestore.instance.collection('celebrities').get();
    return snap;
  }

  Future<QuerySnapshot> getCelebritiesDataList({
    required String id,
  }) async {
    Future<QuerySnapshot> snap = FirebaseFirestore.instance.collection('celebrities').doc(id).collection('data').get();
    return snap;
  }
}
