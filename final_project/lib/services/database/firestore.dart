import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreService {
  final CollectionReference orders =
      FirebaseFirestore.instance.collection('users');

  Future<void> SaveOrderToDataBase(String user) async {
    await orders.add({
      ''
    });
  }
}