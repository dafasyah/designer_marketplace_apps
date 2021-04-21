import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/models/designer.dart';
import 'package:flutter_application_1/models/user.dart';
import 'package:flutter_application_1/models/user_store.dart';
import 'package:flutter_application_1/services/database.dart';


class AuthService{

  final FirebaseAuth _auth = FirebaseAuth.instance;

  //create user object based on FirebaseUser
  MyUser _userFromFirebaseUser(User myuser){
    return myuser != null ? MyUser(uid: myuser.uid) : null;
  }
  //create designer object based on FirebaseUser
  Designer _designerFromFirebaseUser(User designer){
    return designer != null ? Designer(uid: designer.uid) : null;
  }

  //auth change user stream
  Stream<MyUser> get myuser {
    return _auth.authStateChanges()
    .map(_userFromFirebaseUser);
  }
  //auth change designer stream
  Stream<Designer> get designer {
    return _auth.authStateChanges()
    .map(_designerFromFirebaseUser);
  }

  //sign in anon
  Future signInAnon() async {
    try{
      UserCredential result = await _auth.signInAnonymously();
      User user = result.user;
      return _userFromFirebaseUser(user);
    }catch(e){
      print(e.toString());
      return null;
    }
  }
  //sign in email n pass

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User user = result.user;
      return _userFromFirebaseUser(user);
    }catch(e){
     print(e.toString());
     return null;
    }
  }

  //register email n pass

  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User user = result.user;

      await DatabaseService(uid: user.uid).updateUserData(email, 'user', result.user.uid);
      return _userFromFirebaseUser(user);
    }catch(e){
     print(e.toString());
     return null;
    }
  }

  //register email n pass designer

  Future registerDesignerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User designer = result.user;

      await DatabaseService(uid: designer.uid).updateDesignerData(email, 'designer', result.user.uid);
      return _designerFromFirebaseUser(designer);
    }catch(e){
     print(e.toString());
     return null;
    }
  }

  //sign out

  Future signOut() async{
    try{
      return await _auth.signOut();
    }catch(e){
      print(e.toString());
      return null;
    }
  }
}