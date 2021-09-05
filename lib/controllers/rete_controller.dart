import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/models/user.dart';
import 'package:get/get.dart';

class RateController extends GetxController {
  Rx<Users> currentDesinger = Users().obs;
   CollectionReference _userCollection =
      FirebaseFirestore.instance.collection('user');

  
  getCurrentDesigner(String id) async {
    DocumentSnapshot snapshot = await _userCollection.doc(id).get();
    return currentDesinger.update((val) {
      val.name = snapshot.data()['fullname'] ?? "";
      val.address = snapshot.data()['address'];
      val.profile = snapshot.data()['photoUrl'];
      val.phone = snapshot.data()['phone_number'];
      val.minimumPrice = snapshot.data()['minimum_price'];
      val.email = snapshot.data()['name'];
    });
  }

  
}