import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/user.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class UserController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference _userCollection =
      FirebaseFirestore.instance.collection('user');
  final user = FirebaseAuth.instance.currentUser.uid;
  final ratingController = TextEditingController();
  TextEditingController fullname = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController price = TextEditingController();
  RxList<Location> locations = <Location>[].obs;
  Rx<Users> currentUser = Users().obs;
  RxList<Portofolio> portofolio = <Portofolio>[].obs;
  var selectedImagePath = ''.obs;
  File pickedFile;
  RxBool isLoading = false.obs;
  String image =
      'https://i.pinimg.com/originals/a8/33/04/a833045c828009d7e4d68f214ac13aad.jpg';

  buildStream() => locations.bindStream(listDesigner());
  buildStramPorto({String id, bool isUser = false}) =>
      portofolio.bindStream(listPortofolio(id: id, isUser: isUser));

  Stream<List<Location>> listDesigner() {
    Stream<QuerySnapshot> stream = firestore.collection('location').snapshots();
    return stream.map((event) => event.docs
        .map((e) => Location(
              name: e.data()['name'],
              address: e.data()['address'],
              lat: e.data()['lat'],
              lng: e.data()['lng'],
            ))
        .toList());
  }

  Stream<List<Portofolio>> listPortofolio({String id, bool isUser = false}) {
    portofolio.clear();
    Stream<QuerySnapshot> stream = firestore
        .collection('user')
        .doc((isUser == true) ? id : user)
        .collection('portofolio')
        .orderBy('time_stamp', descending: true)
        .snapshots();
    return stream.map((event) => event.docs
        .map(
          (e) => Portofolio(
            image: e.data()['image'],
            time: e.data()['time_stamp'],
            id: e.id,
          ),
        )
        .toList());
  }

  updateUser({String address, String fullname, String phone, String price}) {
    CollectionReference users = firestore.collection('user');
    users.doc(user).update({
      'address': address,
      'fullname': fullname,
      'phone_number': phone,
      'minimum_price': price,
    });
  }

  updateImage({String image}) {
    CollectionReference users = firestore.collection('user');
    users.doc(user).update({
      'photoUrl': image,
    });
    selectedImagePath = ''.obs;
  }

  addPortofolio(String image) {
    CollectionReference portofolio =
        firestore.collection('user').doc(user).collection('portofolio');
    try {
      isLoading.toggle();
      portofolio.add({
        'image': image,
        'time_stamp': DateTime.now().millisecondsSinceEpoch,
      });
    } catch (e) {
      print(e);
    } finally {
      isLoading.toggle();
    }
  }

  void deletePortofolio(String id) {
    CollectionReference portofolio =
        firestore.collection('user').doc(user).collection('portofolio');
    portofolio.doc(id).delete();
    Get.back();
  }

  addRating(String id, double rating, String requestId) {
    CollectionReference portofolio =
        firestore.collection('user').doc(id).collection('rating');
    CollectionReference request = firestore.collection('request_designer');
    try {
      isLoading.toggle();
      portofolio.add({
        'from': user,
        'rating': '$rating',
        'text': ratingController.text,
        'time_stamp': DateTime.now().millisecondsSinceEpoch,
      });
      request.doc(requestId).update({'status': 'Reviewed'});
    } catch (e) {
      print(e);
    } finally {
      Get.back();
      isLoading.toggle();
      ratingController.clear();
    }
  }

  addLocation(
      {double lat, lng, String name, String address, String designerId}) {
    CollectionReference location = firestore.collection('location');
    location.add({
      'lat': lat,
      'lng': lng,
      'name': name,
      'address': address,
      'designer_id': designerId,
    });
  }

  currentUsers() {
    getCurrentUser(user);
    print('update');
    update();
  }

  getCurrentUser(String id) async {
    DocumentSnapshot snapshot = await _userCollection.doc(id).get();
    return currentUser.update((val) {
      val.name = snapshot.data()['fullname'];
      val.address = snapshot.data()['address'];
      val.profile = snapshot.data()['photoUrl'];
      val.phone = snapshot.data()['phone_number'];
      val.minimumPrice = snapshot.data()['minimum_price'];
      val.email = snapshot.data()['name'];
    });
  }

  void getImage(ImageSource source) async {
    selectedImagePath = ''.obs;
    // ignore: deprecated_member_use
    pickedFile = await ImagePicker.pickImage(
        source: source); //().getImage(source: source);
    if (pickedFile != null) {
      selectedImagePath.value = pickedFile.path;
    } else {
      print('no image selected');
    }
  }

  Future<String> postImage() async {
    isLoading.toggle();
    String fileName = pickedFile.path.split("/").last;
    firebase_storage.Reference reference = firebase_storage
        .FirebaseStorage.instance
        .ref()
        .child('portofolio/$fileName');
    final data = await reference.putFile(pickedFile);
    String photoPath = await data.ref.getDownloadURL();
    isLoading.toggle();
    print(photoPath);
    return photoPath;
  }
}
