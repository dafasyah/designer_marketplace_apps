import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/models/designer.dart';
import 'package:flutter_application_1/models/designer_store.dart';
import 'package:flutter_application_1/models/user_store.dart';
import 'package:flutter_application_1/models/user.dart';


class DatabaseService {

  final String uid;
  DatabaseService({ this.uid });

  // collection reference
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('user');
  // final CollectionReference designerCollection = FirebaseFirestore.instance.collection('designer');
  

  Future updateUserData(String name, String role, String uid) async {
    return await userCollection.doc(uid).set({
      'name': name,
      'role': role,
      'user_id' : uid,
    });
  }

  Future updateDesignerData(String name, String role, String uid) async {
    return await userCollection.doc(uid).set({
      'name': name,
      'role': role,
      'user_id' : uid,
    });
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