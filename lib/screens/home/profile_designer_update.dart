import 'package:easy_mask/easy_mask.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/user.dart';
import 'package:flutter_application_1/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:toast/toast.dart';
import 'package:flutter_application_1/services/database.dart';


class DesignerProfileUpdate extends StatefulWidget {

  @override
  _DesignerProfileUpdateState createState() => _DesignerProfileUpdateState();
}

class _DesignerProfileUpdateState extends State<DesignerProfileUpdate> {
  final AuthService _auth = AuthService();
  final _formkey = GlobalKey<FormState>();

  final user = FirebaseAuth.instance.currentUser.uid;

  // File newProfilePic;
  String _imagePath = '';
  // String _designerFullName = '';
  // String _designerAddress = '';
  // String _designerPhoneNumber = '';
  // String _designerMinimumPrice = '';

  TextEditingController _designerFullName = TextEditingController();
  // TextEditingController _imagePath = TextEditingController();
  TextEditingController _designerAddress = TextEditingController();
  TextEditingController _designerPhoneNumber = TextEditingController();
  TextEditingController _designerMinimumPrice = TextEditingController();




  Future<File> getImage() async {
    return await ImagePicker.pickImage(source: ImageSource.gallery);
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
                final designerName = snapshot.data['fullname'].toString();
                final designerAddress = snapshot.data['address'].toString();
                final designerPhoneNumber = snapshot.data['phone_number'].toString();
                final designerPhoto = snapshot.data['photoUrl'].toString();
                final designerMinimumPrice = snapshot.data['minimum_price'].toString();

                _designerFullName.text = designerName;
                _designerAddress.text = designerAddress;
                _designerPhoneNumber.text = designerPhoneNumber;
                // _imagePath.value = designerPhoto;
                _designerMinimumPrice.text = designerMinimumPrice;

                    // final userUID = snapshot.data['user_id'].toString();
                    // final userEmail = snapshot.data['name'].toString();
                return Container(
                  child: Scaffold(
                    resizeToAvoidBottomInset: false,
                    appBar: AppBar(title: Text("Update Designer Profile"), actions: <Widget>[
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
                                  (designerPhoto != '')
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
                                                      NetworkImage(designerPhoto),
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
                                  TextField(
                                    key: Key(designerName),
                                    controller: _designerFullName,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Full Name',
                                    ),
                                    // initialValue:  (designerName == '' ) ? '' : designerName,
                                    // onChanged: (val) =>
                                    //     setState(() => _designerFullName = val),
                                  ),
                                  SizedBox(height: 10.0),
                                  TextField(
                                    controller: _designerAddress,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Address',
                                    ),
                                    // initialValue: (designerAddress == '') ? '' : designerAddress,
                                    // onChanged: (val) =>
                                    //     setState(() => _designerAddress = val),
                                  ),
                                  SizedBox(height: 10.0),
                                  TextField(
                                    controller: _designerPhoneNumber,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Phone Number',
                                    ),
                                    // initialValue: (designerPhoneNumber == '') ? '' : designerPhoneNumber,
                                    inputFormatters: [
                                     TextInputMask(mask: '9999 9999 9999', reverse: false)
                                    ],
                                    // onChanged: (val) => setState(
                                    //     () => _designerPhoneNumber = val),
                                  ),SizedBox(height: 10.0),
                                  TextField(
                                    controller: _designerMinimumPrice,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Minimum Price',
                                    ),
                                    // initialValue: (designerMinimumPrice == '') ? '' : designerMinimumPrice,
                                    inputFormatters: [TextInputMask(
                                      mask: '\R!p!.! !9+.999',
                                      reverse: true
                                    )],
                                    // onChanged: (val) => setState(
                                    //     () => _designerMinimumPrice = val),
                                  ),
                                  SizedBox(height: 30.0),
                                  ElevatedButton(
                                    onPressed: () async {
                                      if (_formkey.currentState.validate()) {
                                        final CollectionReference collectionReference = FirebaseFirestore.instance.collection("user");
                                        collectionReference.doc(user).update({
                                          'fullname': _designerFullName.text,
                                          'address': _designerAddress.text,
                                          'phone_number': _designerPhoneNumber.text, 
                                          'photoUrl': _imagePath,
                                          'minimum_price': _designerMinimumPrice.text
                                        });
                                        
                                      }

                                       showToast('Profile Updated', duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                                      
                                     
                                      
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
