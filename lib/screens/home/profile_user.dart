// import 'dart:html';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_mask/easy_mask.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/auth.dart';
import 'package:flutter_application_1/services/database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toast/toast.dart';

class ProfileUser extends StatefulWidget {
  @override
  _ProfileUserState createState() => _ProfileUserState();
}

class _ProfileUserState extends State<ProfileUser> {
  final AuthService _auth = AuthService();
  final _formkey = GlobalKey<FormState>();

  final user = FirebaseAuth.instance.currentUser.uid;

  TextEditingController controller;

  // File newProfilePic;
  String _imagePath = '';
  String _userFullName = '';
  String _userAddress = '';
  // String _userUID;
  // String _userEmail;
  // String _userRole;
  String _userPhoneNumber = '';

  Future<File> getImage() async {
    return await ImagePicker.pickImage(source: ImageSource.gallery);
    // var tempImage =  await ImagePicker.pickImage(source: ImageSource.gallery);
    // setState(() {
    //   imagePath = tempImage;
    // });
  }

  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          return StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('user')
                  .doc(snapshot.data.uid)
                  .snapshots(),
              builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                final userName = snapshot.data['fullname'];
                final userAddress = snapshot.data['address'].toString();
                final userPhoneNumber =
                    snapshot.data['phone_number'].toString();
                // final userRole = snapshot.data['role'].toString();
                // final userUID = snapshot.data['user_id'].toString();
                // final userEmail = snapshot.data['name'].toString();
                final userPhoto = snapshot.data['photoUrl'].toString();

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
                    body: Form(
                      key: _formkey,
                      child: SingleChildScrollView(
                        // physics: ClampingScrollPhysics(),
                        reverse: true,
                        child: Container(
                          margin: EdgeInsets.all(20),
                          child: Padding(
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  (userPhoto != '')
                                      ? Container(
                                          width: 200,
                                          height: 200,
                                          // padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  color: Colors.black),
                                              image: DecorationImage(
                                                  image:
                                                      NetworkImage(userPhoto),
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

                                        _imagePath =
                                            await DatabaseService.uploadImage(
                                                file);

                                        setState(() {});
                                      }),
                                  SizedBox(height: 10.0),
                                  TextFormField(
                                    key: Key(userName),
                                    // controller: controller,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Full Name',
                                    ),
                                    initialValue:
                                        (userName == '') ? '' : userName,
                                    onChanged: (val) =>
                                        setState(() => _userFullName = val),
                                  ),
                                  SizedBox(height: 10.0),
                                  TextFormField(
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Address',
                                    ),
                                    initialValue:
                                        (userAddress == '') ? '' : userAddress,
                                    onChanged: (val) =>
                                        setState(() => _userAddress = val),
                                  ),
                                  SizedBox(height: 10.0),
                                  TextFormField(
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Phone Number',
                                    ),
                                    initialValue: (userPhoneNumber == '')
                                        ? ''
                                        : userPhoneNumber,
                                    inputFormatters: [
                                      TextInputMask(
                                          mask: '9999 9999 9999',
                                          reverse: false)
                                    ],
                                    onChanged: (val) =>
                                        setState(() => _userPhoneNumber = val),
                                  ),
                                  SizedBox(height: 30.0),
                                  ElevatedButton(
                                    onPressed: () async {
                                      if (_formkey.currentState.validate()) {
                                        final CollectionReference
                                            collectionReference =
                                            FirebaseFirestore.instance
                                                .collection("user");
                                        collectionReference.doc(user).update({
                                          'fullname': _userFullName,
                                          'address': _userAddress,
                                          'phone_number': _userPhoneNumber,
                                          'photoUrl': _imagePath
                                        });
                                      }

                                      showToast('Profile Updated',
                                          duration: Toast.LENGTH_LONG,
                                          gravity: Toast.BOTTOM);
                                    },
                                    child: Text('Save Profile'),
                                  )
                                ]),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              });
        });
  }
}
