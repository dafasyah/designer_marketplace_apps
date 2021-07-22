import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/chat.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ChatController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final textController = TextEditingController();
  RxList<Chat> chats = <Chat>[].obs;
  var selectedImagePath = ''.obs;
  File pickedFile;

  buildStream(String requestId) => chats.bindStream(listChat(requestId));

  void addChat(String requsetId, String fromId, String toId, {String image}) {
    CollectionReference chat = firestore
        .collection('request_designer')
        .doc(requsetId)
        .collection('chatting');
    try {
      chat.add({
        'from': fromId,
        'chat': textController.text,
        'to': toId,
        'time_stamp': DateTime.now().millisecondsSinceEpoch,
        'image': (image != null) ? image : 'no image',
      });
    } catch (e) {
      print(e);
    } finally {
      textController.clear();
    }
  }

  Stream<List<Chat>> listChat(String requestId) {
    Stream<QuerySnapshot> stream = firestore
        .collection('request_designer')
        .doc(requestId)
        .collection('chatting')
        .orderBy('time_stamp')
        .snapshots();
    return stream.map((event) => event.docs
        .map(
          (e) => Chat(
            chat: e.data()['chat'],
            from: e.data()['from'],
            to: e.data()['to'],
            timeStamp: e.data()['time_stamp'],
            image: e.data()['image'],
          ),
        )
        .toList());
  }

  void getImage(ImageSource source) async {
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
    String fileName = pickedFile.path.split("/").last;
    firebase_storage.Reference reference =
        firebase_storage.FirebaseStorage.instance.ref().child('chat/$fileName');
    final data = await reference.putFile(pickedFile);
    String photoPath = await data.ref.getDownloadURL();
    print(photoPath);
    return photoPath;
  }
}
