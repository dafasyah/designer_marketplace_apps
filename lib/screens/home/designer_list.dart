import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/notif_controller.dart';
import 'package:flutter_application_1/controllers/user_controller.dart';
import 'package:flutter_application_1/models/designer_store.dart';
import 'package:flutter_application_1/screens/home/designer_profile_view.dart';
import 'package:flutter_application_1/screens/home/designer_tile.dart';
import 'package:flutter_application_1/screens/home/user_tile.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class DesignerList extends StatefulWidget {
  @override
  _DesignerListState createState() => new _DesignerListState();
}

class _DesignerListState extends State<DesignerList> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      // appBar: AppBar(
      //   iconTheme: IconThemeData(color: Colors.black),
      //   backgroundColor: Colors.white,
      //   title: Center(
      //       child: Text(
      //     "Hire Designer",
      //     textAlign: TextAlign.center,
      //     style: TextStyle(color: Colors.black),
      //   )),
      // ),
      body: ListPageDesigner(),
    );
  }
}

class ListPageDesigner extends StatefulWidget {
  @override
  _ListPageDesignerState createState() => _ListPageDesignerState();
}

class _ListPageDesignerState extends State<ListPageDesigner> {
  FutureOr getPost() async {
    var _db = FirebaseFirestore.instance;
    QuerySnapshot reqA =
        await _db.collection("user").where("role", isEqualTo: 'designer').get();
    return reqA.docs;
  }

  Widget build(BuildContext context) {
    final controller = Get.find<NotifController>();
    final userController = Get.find<UserController>();
    return Container(
      child: FutureBuilder(
        future: getPost(),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Text("Loading..."),
            );
          } else {
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (_, index) {
                  return Container(
                    // margin: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        // SizedBox(
                        //   height: 10.0,
                        // ),
                        Card(
                          margin: const EdgeInsets.all(10),
                          child: ListTile(
                            title: TextButton(
                              onPressed: () => Get.to(
                                () =>
                                    Splash(snapshot.data[index]['designer_id']),
                              ),
                              //  Get.to(
                              //   () => ProfileDesigner(
                              //     userId: snapshot.data[index]['designer_id'],
                              //   ),
                              // ),
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => ProfileDesigner())),
                              child: Row(
                                children: <Widget>[
                                  Text(snapshot.data[index]['name'])
                                ],
                              ),
                            ),
                            trailing:
                                // Row(
                                //     children: <Widget>[

                                Expanded(
                                    child: RaisedButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                          title: Text("Hire?"),
                                          content: Text(
                                              "Are you sure you want to hire " +
                                                  snapshot.data[index]['name'] +
                                                  ' ?'),
                                          actions: [
                                            TextButton(
                                              child: Text("No",
                                                  style: TextStyle(
                                                      color: Colors.red)),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            TextButton(
                                                child: Text("Yes"),
                                                onPressed: () {
                                                  controller.showNotification(
                                                      'Order Berhasil',
                                                      'Status orderan waiting, harap menunggu kami sedang menghubungkan ke pada designer yang Anda pilih');
                                                  FirebaseFirestore.instance
                                                      .collection(
                                                          'request_designer')
                                                      .doc()
                                                      .set({
                                                    'designer_id':
                                                        snapshot.data[index]
                                                            ['designer_id'],
                                                    'designer_name': snapshot
                                                        .data[index]['name'],
                                                    'user_id': FirebaseAuth
                                                        .instance
                                                        .currentUser
                                                        .uid,
                                                    'user_name': FirebaseAuth
                                                        .instance
                                                        .currentUser
                                                        .email,
                                                    'status': 'Waiting'
                                                  });
                                                  Navigator.popUntil(context,
                                                      ModalRoute.withName("/"));
                                                })
                                          ],
                                        ));
                              },
                              child: Text("Hire"),
                              color: Colors.blue,
                              textColor: Colors.white,
                            )),
                            // ]
                            // ),
                          ),
                        ),
                      ],
                    ),
                  );
                });
          }
        },
      ),
    );
  }
}

class Splash extends GetView<UserController> {
  final String userId;
  Splash(this.userId);
  @override
  Widget build(BuildContext context) {
    print(userId);
    controller.splash(userId);
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
          child: CircularProgressIndicator(
        backgroundColor: Colors.white,
      )),
    );
  }
}
