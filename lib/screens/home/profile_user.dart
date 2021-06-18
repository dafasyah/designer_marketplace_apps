import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/user.dart';
import 'package:flutter_application_1/screens/auth/sign_in.dart';
import 'package:flutter_application_1/services/auth.dart';
import 'package:flutter_application_1/services/database.dart';
import 'package:flutter_application_1/shared/constants.dart';
import 'package:image_picker/image_picker.dart';

class ProfileUser extends StatefulWidget {
  @override
  _ProfileUserState createState() => _ProfileUserState();
}

class _ProfileUserState extends State<ProfileUser> {
  final AuthService _auth = AuthService();
  String imagePath;

  
Future<File> getImage() async {
  return await ImagePicker.pickImage(source: ImageSource.gallery);
  // var tempImage =  await ImagePicker.pickImage(source: ImageSource.gallery);
  // setState(() {
  //   imagePath = tempImage;
  // });
}
  
  // String userID = '';


  // @override
  // void initState() {
  //   super.initState();
  //   fetchUserInfo();
  // }
  // fetchUserInfo() async{
  //   User getUser = await FirebaseAuth.instance.currentUser;
  //   userID = getUser.uid;
  // }

 
  // updateData(String name, String role, String fullname, String address, int phoneNumber, String userID ) async{
  //   await DatabaseService().updateUserProfile(name, role, userID, fullname, address, phoneNumber);

  // }

  // Future<dynamic> getUserByUserId(String userId) async {
  //   return (await FirebaseFirestore.instance
  //           .collection("user")
  //           .where("user_id", isEqualTo: userId)
  //           .get())
  //       .docs;
  // }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserData>(
        stream: null,
        builder: (context, snapshot) {
          return Container(
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(title: Text("My Profile"), actions: <Widget>[
                FlatButton.icon(
                    icon: Icon(Icons.person),
                    label: Text('Log Out'),
                    onPressed: () async {
                      await _auth.signOut();
                      Navigator.of(context).pop();
                    }),
              ]),
              body: SingleChildScrollView(
                // physics: ClampingScrollPhysics(),
                reverse: true,
                child: Container(
                  margin: EdgeInsets.all(20),
                  child: Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          (imagePath != null)
                              ? Container(
                                  width: 200,
                                  height: 200,
                                  // padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.black),
                                      image: DecorationImage(
                                          image: NetworkImage(imagePath),
                                          fit: BoxFit.cover)),
                                )
                              : Container(
                                  width: 200,
                                  height: 200,
                                  // padding: const EdgeInsets.all(10),
                                  child: Expanded(
                                    child: Icon(
                                      Icons.account_circle_rounded,
                                      size: 200,
                                    ),
                                  ),
                                ),
                          RaisedButton(
                              child: Text('Change Profile Picture'),
                              onPressed: () async {
                                File file = await getImage();

                                imagePath =
                                    await DatabaseService.uploadImage(file);

                                setState(() {});
                              }),
                          SizedBox(height: 10.0),
                          TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Name',
                            ),
                          ),
                          SizedBox(height: 10.0),
                          TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Address',
                            ),
                          ),
                          SizedBox(height: 10.0),
                          TextField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Phone Number',
                            ),
                          ),
                          SizedBox(height: 30.0),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Save Profile'),
                          )
                        ]),
                  ),
                ),
              ),
            ),
          );
        });
  }
 
}

