import 'package:flutter/material.dart';

import 'package:easy_mask/easy_mask.dart';
import 'package:flutter_application_1/controllers/maps_controller.dart';
import 'package:flutter_application_1/controllers/user_controller.dart';
import 'package:flutter_application_1/screens/auth/sign_in.dart';
import 'package:flutter_application_1/screens/home/designer_portofolio.dart';
import 'package:flutter_application_1/screens/home/find_nearby.dart';
import 'package:flutter_application_1/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:toast/toast.dart';
import 'package:flutter_application_1/services/database.dart';

class ProfileDesignerForm extends StatefulWidget {
  @override
  _ProfileDesignerFormState createState() => _ProfileDesignerFormState();
}

class _ProfileDesignerFormState extends State<ProfileDesignerForm> {
  File image;
  final user = FirebaseAuth.instance.currentUser.uid;
  final userController = Get.put(UserController());
  final mapsController = Get.put(MapsController());

  @override
  void initState() {
    userController.fullname =
        TextEditingController(text: '${userController.currentUser.value.name}');
    userController.phone = TextEditingController(
        text: '${userController.currentUser.value.phone}');
    userController.price = TextEditingController(
        text: '${userController.currentUser.value.minimumPrice}');
    // mapsController.addressController = TextEditingController(
    //     text: '${userController.currentUser.value.address}');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => ListView(
          children: [
            (userController.currentUser.value.profile != '' &&
                    userController.selectedImagePath.value == '')
                ? Container(
                    width: 200,
                    height: 200,
                    // padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black),
                        image: DecorationImage(
                            image: NetworkImage(
                                userController.currentUser.value.profile),
                            fit: BoxFit.cover)),
                  )
                : (userController.selectedImagePath.value != '' &&
                            userController.currentUser.value.profile == '' ||
                        userController.currentUser.value.profile != '')
                    ? CircleAvatar(
                        radius: 65,
                        backgroundColor: Colors.blue,
                        backgroundImage: FileImage(
                            File(userController.selectedImagePath.value)),
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
                  userController.getImage(ImageSource.gallery);

                  var images = await userController.postImage();
                  userController.updateImage(image: images);
                  setState(() {});
                }),
            SizedBox(height: 10.0),
            TextField(
              controller: userController.fullname,
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
              onTap: () {
                Get.to(() => FindNearby());
              },
              controller: mapsController.addressController,
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
              controller: userController.phone,
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
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: userController.price,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Minimum Price',
              ),
              // initialValue: (designerMinimumPrice == '') ? '' : designerMinimumPrice,
              inputFormatters: [
                TextInputMask(mask: '\R!p!.! !9+.999', reverse: true)
              ],
              // onChanged: (val) => setState(
              //     () => _designerMinimumPrice = val),
            ),
            SizedBox(height: 30.0),
            ElevatedButton(
              onPressed: () {
                userController.updateUser(
                  address: mapsController.addressController.text,
                  fullname: userController.fullname.text,
                  phone: userController.phone.text,
                  price: userController.price.text,
                );
                userController.currentUsers();
                Get.back();
              },
              child: Text('Save Profile'),
            ),
          ],
        ),
      ),
    );
  }
}

// class ProfileDesignerForm extends StatefulWidget {
//   @override
//   _ProfileDesignerFormState createState() => _ProfileDesignerFormState();
// }

// class _ProfileDesignerFormState extends State<ProfileDesignerForm> {
//   final AuthService _auth = AuthService();
//   final _formkey = GlobalKey<FormState>();

//   final user = FirebaseAuth.instance.currentUser.uid;

//   // File newProfilePic;
//   String _imagePath = '';
//   // String _designerFullName = '';
//   // String _designerAddress = '';
//   // String _designerPhoneNumber = '';
//   // String _designerMinimumPrice = '';

//   TextEditingController _designerFullName = TextEditingController();
//   // TextEditingController _imagePath = TextEditingController();
//   TextEditingController _designerAddress = TextEditingController();
//   TextEditingController _designerPhoneNumber = TextEditingController();
//   TextEditingController _designerMinimumPrice = TextEditingController();

//   Future<File> getImage() async {
//     return await ImagePicker.pickImage(source: ImageSource.gallery);
//   }

//   void showToast(String msg, {int duration, int gravity}) {
//     Toast.show(msg, context, duration: duration, gravity: gravity);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final mapsController = Get.put(MapsController());
//     final userController = Get.find<UserController>();
//     final user = FirebaseAuth.instance.currentUser.uid;

//     return StreamBuilder(
//         stream: FirebaseAuth.instance.authStateChanges(),
//         builder: (context, snapshot) {
//           return StreamBuilder<DocumentSnapshot>(
//               stream: FirebaseFirestore.instance
//                   .collection('user')
//                   .doc(snapshot.data.uid)
//                   .snapshots(),
//               builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
//                 final designerName = snapshot.data['fullname'].toString();
//                 final designerAddress = snapshot.data['address'].toString();
//                 final designerPhoneNumber =
//                     snapshot.data['phone_number'].toString();
//                 final designerPhoto = snapshot.data['photoUrl'].toString();
//                 final designerMinimumPrice =
//                     snapshot.data['minimum_price'].toString();

//                 _designerFullName.text = designerName;
//                 _designerAddress.text = designerAddress;
//                 _designerPhoneNumber.text = designerPhoneNumber;
//                 // _imagePath.value = designerPhoto;
//                 _designerMinimumPrice.text = designerMinimumPrice;

//                 // final userUID = snapshot.data['user_id'].toString();
//                 // final userEmail = snapshot.data['name'].toString();
//                 return Container(
//                   child: Scaffold(
//                     resizeToAvoidBottomInset: false,
//                     appBar: AppBar(
//                         title: Text("Update Designer Profile"),
//                         actions: <Widget>[
//                           FlatButton.icon(
//                               icon: Icon(Icons.person),
//                               label: Text('Log Out'),
//                               onPressed: () async {
//                                 await _auth.signOut();
//                                 Get.offAll(() => SignIn());
//                               }),
//                         ]),
//                     body: Form(
//                       key: _formkey,
//                       child: SingleChildScrollView(
//                         // physics: ClampingScrollPhysics(),
//                         reverse: true,
//                         child: Container(
//                           margin: EdgeInsets.all(20),
//                           child: Padding(
//                             padding: EdgeInsets.only(
//                                 bottom:
//                                     MediaQuery.of(context).viewInsets.bottom),
//                             child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 children: [
//                                   (designerPhoto != '')
//                                       ? Container(
//                                           width: 200,
//                                           height: 200,
//                                           // padding: const EdgeInsets.all(10),
//                                           decoration: BoxDecoration(
//                                               shape: BoxShape.circle,
//                                               border: Border.all(
//                                                   color: Colors.black),
//                                               image: DecorationImage(
//                                                   image: NetworkImage(
//                                                       designerPhoto),
//                                                   fit: BoxFit.cover)),
//                                         )
//                                       : Container(
//                                           width: 200,
//                                           height: 200,
//                                           // padding: const EdgeInsets.all(10),
//                                           child: Expanded(
//                                             child: Icon(
//                                               Icons.account_circle_rounded,
//                                               size: 200,
//                                             ),
//                                           ),
//                                         ),
//                                   RaisedButton(
//                                       child: Text('Change Profile Picture'),
//                                       onPressed: () async {
//                                         File file = await getImage();

//                                         _imagePath =
//                                             await DatabaseService.uploadImage(
//                                                 file);

//                                         setState(() {});
//                                       }),
//                                   SizedBox(height: 10.0),
//                                   TextField(
//                                     key: Key(designerName),
//                                     controller: _designerFullName,
//                                     decoration: InputDecoration(
//                                       border: OutlineInputBorder(),
//                                       labelText: 'Full Name',
//                                     ),
//                                     // initialValue:  (designerName == '' ) ? '' : designerName,
//                                     // onChanged: (val) =>
//                                     //     setState(() => _designerFullName = val),
//                                   ),
//                                   SizedBox(height: 10.0),
//                                   TextField(
//                                     onTap: () {
//                                       Get.to(() => FindNearby());
//                                     },
//                                     controller:
//                                         mapsController.addressController,
//                                     decoration: InputDecoration(
//                                       border: OutlineInputBorder(),
//                                       labelText: 'Address',
//                                     ),
//                                     // initialValue: (designerAddress == '') ? '' : designerAddress,
//                                     // onChanged: (val) =>
//                                     //     setState(() => _designerAddress = val),
//                                   ),
//                                   SizedBox(height: 10.0),
//                                   TextField(
//                                     controller: _designerPhoneNumber,
//                                     keyboardType: TextInputType.number,
//                                     decoration: InputDecoration(
//                                       border: OutlineInputBorder(),
//                                       labelText: 'Phone Number',
//                                     ),
//                                     // initialValue: (designerPhoneNumber == '') ? '' : designerPhoneNumber,
//                                     inputFormatters: [
//                                       TextInputMask(
//                                           mask: '9999 9999 9999',
//                                           reverse: false)
//                                     ],
//                                     // onChanged: (val) => setState(
//                                     //     () => _designerPhoneNumber = val),
//                                   ),
//                                   SizedBox(height: 10.0),
//                                   TextField(
//                                     controller: _designerMinimumPrice,
//                                     keyboardType: TextInputType.number,
//                                     decoration: InputDecoration(
//                                       border: OutlineInputBorder(),
//                                       labelText: 'Minimum Price',
//                                     ),
//                                     // initialValue: (designerMinimumPrice == '') ? '' : designerMinimumPrice,
//                                     inputFormatters: [
//                                       TextInputMask(
//                                           mask: '\R!p!.! !9+.999',
//                                           reverse: true)
//                                     ],
//                                     // onChanged: (val) => setState(
//                                     //     () => _designerMinimumPrice = val),
//                                   ),
//                                   SizedBox(height: 30.0),
//                                   ElevatedButton(
//                                     onPressed: () async {
//                                       userController.updateUser(
//                                         address: mapsController
//                                             .addressController.text,
//                                         latitude:
//                                             mapsController.latitude.toDouble(),
//                                         longitude:
//                                             mapsController.longitude.toDouble(),
//                                       );
//                                       userController.addLocation(
//                                         lat: mapsController.latitude.toDouble(),
//                                         lng:
//                                             mapsController.longitude.toDouble(),
//                                         address: mapsController
//                                             .addressController.text,
//                                         name: _designerFullName.text,
//                                         designerId: user,
//                                       );
//                                       if (_formkey.currentState.validate()) {
//                                         final CollectionReference
//                                             collectionReference =
//                                             FirebaseFirestore.instance
//                                                 .collection("user");
//                                         collectionReference.doc(user).update({
//                                           'fullname': _designerFullName.text,
//                                           // 'address': mapsController
//                                           //     .addressController.text,
//                                           'phone_number':
//                                               _designerPhoneNumber.text,
//                                           'photoUrl': _imagePath,
//                                           'minimum_price':
//                                               _designerMinimumPrice.text,
//                                           // 'latitude': mapsController.latitude,
//                                           // 'longitude': mapsController.longitude,
//                                         });
//                                       }
//                                       userController.getCurrentUser(user);
//                                       showToast('Profile Updated',
//                                           duration: Toast.LENGTH_LONG,
//                                           gravity: Toast.BOTTOM);
//                                     },
//                                     child: Text('Save Profile'),
//                                   ),
//                                 ]),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 );
//               });
//         });
//   }
// }
