// import 'dart:html' as html;
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_application_1/models/designer.dart';
import 'package:flutter_application_1/models/designer_store.dart';
import 'package:flutter_application_1/models/user_store.dart';
import 'package:flutter_application_1/models/user.dart';
import 'package:path/path.dart';


class DatabaseService {

  final String uid;
  DatabaseService({ this.uid });

  // collection reference
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('user');
  // final CollectionReference designerCollection = FirebaseFirestore.instance.collection('designer');
  

  Future updateUserData(String name, String role, String uid, String fullname, String address, int phoneNumber, String photoUrl) async {
    return await userCollection.doc(uid).set({
        'name': name,
        'role': role,
        'user_id' : uid,
        'fullname' : fullname,
        'address' : address,
        'phone_number' : phoneNumber,
        'photoUrl' : photoUrl
    });
  }

  Future updateUserProfile(String name, String role, String uid, String fullname, String address, int phoneNumber) async{
    return await userCollection.doc(uid).update({    
      'fullname' : fullname,
      'address' : address,
      'phone_number' : phoneNumber
    });
  }

  Future updateDesignerData(String name, String role, String uid) async {
    return await userCollection.doc(uid).set({
      'name': name,
      'role': role,
      'user_id' : uid,
    });
  }

  //image picker
  static Future uploadImage(File imageFile) async{
    String fileName = basename(imageFile.path);

    Reference ref = FirebaseStorage.instance.ref().child(fileName);
    await ref.putFile(imageFile);
    return await ref.getDownloadURL();

    // final String downloadUrl =  await ref.getDownloadURL();
    // return await FirebaseFirestore.instance.collection('user').doc(uid).update({
    //   'url': downloadUrl,
    //   'name': imageFile,
    // });

  }

  

  //user list from snapshot
  List<UserStore> _userListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.docs.map((doc){
      return UserStore(
        name: doc.data()['name'] ?? '',
        role: doc.data()['role'] ?? ''
        );
    }).toList();
  }

  //designer list from snapshot
  List<DesignerStore> _designerListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.docs.map((doc){
      return DesignerStore(
        name: doc.data()['name'] ?? '',
        // rating: doc.data()['rating'] ?? 0,
        role: doc.data()['role'] ?? ''
        );
    }).toList();
  }

  //userdata from snapshow
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot){
    return UserData(
      uid: uid,
      name: snapshot.data()['name'],
      role: snapshot.data()['role']
    );
  }

  //designerdata from snapshow
  DesignerData _designerDataFromSnapshot(DocumentSnapshot snapshot){
    return DesignerData(
      uid: uid,
      name: snapshot.data()['name'],
      role: snapshot.data()['role']
    );
  }

  //get user stream
  Stream<List<UserStore>> get userstore{
    return userCollection.snapshots()
    .map(_userListFromSnapshot);
  }

  //get user doc stream
  Stream<UserData> get userData {
    return userCollection.doc(uid).snapshots()
    .map(_userDataFromSnapshot);
  }

  //get designer stream
  Stream<List<DesignerStore>> get designerstore{
    return userCollection.snapshots()
    .map(_designerListFromSnapshot);
  }

  //get designer doc stream
  Stream<DesignerData> get designerData {
    return userCollection.doc(uid).snapshots()
    .map(_designerDataFromSnapshot);
  }

}