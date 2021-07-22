import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/home/user_profile.dart';
import 'package:get/get.dart';

import 'chat_page.dart';

class DesignerOrder extends StatefulWidget {
  @override
  _DesignerOrder createState() => new _DesignerOrder();
}

class _DesignerOrder extends State<DesignerOrder> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.brown[400],
        title: Row(
          children: <Widget>[
            Text(
              "My Job List",
              style: TextStyle(color: Colors.white),
            )
          ],
        ),
      ),
      body: ListPage(),
    );
  }
}

class ListPage extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  FutureOr getDesigner() async {
    final user = FirebaseAuth.instance.currentUser.uid;
    var _db = FirebaseFirestore.instance;
    QuerySnapshot reqA = await _db
        .collection("request_designer")
        .where("status", isEqualTo: 'On Progress')
        .where("designer_id", isEqualTo: user)
        .get();
    return reqA.docs;
  }

  // Future<dynamic> getUserByUserId(String userId) async {
  //   return (await FirebaseFirestore.instance
  //           .collection("user")
  //           .where("user_id", isEqualTo: userId)
  //           .get())
  //       .docs;
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: FutureBuilder(
          // stream: FirebaseFirestore.instance
          //     .collection('request_designer')
          //     .where('designer_id',
          //         isEqualTo: FirebaseAuth.instance.currentUser.uid)
          //     .snapshots(),
          future: getDesigner(),
          // (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot)
          builder: (_, snapshot) {
            // if (!snapshot.hasData) {
            //   return Center(
            //     child: Text("Loading..."),
            //   );
            // }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Text("Loading..."),
              );
            } else {
              return SafeArea(
                child: Column(
                  // mainAxisSize: MainAxisSize.max,
                  // crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (_, index) {
                            var requestId = snapshot.data[index].id;
                            var fromId = snapshot.data[index]['designer_id'];
                            var toId = snapshot.data[index]['user_id'];
                            return ListTile(
                              // isThreeLine: true,
                              title:
                                  // FutureBuilder<dynamic>(
                                  //   future: getUserByUserId(
                                  //       snapshot.data[index]['user_id']),
                                  //   builder: (BuildContext context,
                                  //       AsyncSnapshot<dynamic> snapshot) {
                                  //     if (snapshot.hasData) {
                                  //       if (snapshot.data.length > 1) {
                                  //         return Text(
                                  //             'Two or more users with the same Id exists');
                                  //       } else {

                                  //         return Text(snapshot.data[0]['name']);
                                  //       }
                                  //     } else {
                                  //       return Text('User not found');
                                  //     }
                                  //   },
                                  // ),
                                  Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton(
                                    onPressed: () => Get.to(
                                        () => ProfileUserDisplay(userId: toId)),
                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (context) =>
                                    //             ProfileUserDisplay())),
                                    child: Row(
                                      children: <Widget>[
                                        Text(snapshot.data[index]['user_name'])
                                      ],
                                    ),
                                    // snapshot.data[index]['user_name']
                                  ),
                                  Text(
                                    'Status : ' +
                                        snapshot.data[index]['status'],
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 12),
                                  ),
                                ],
                              ),

                              subtitle: Container(
                                padding: const EdgeInsets.only(top: 10),
                                child: Row(
                                  // crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    // Expanded(

                                    //   child:

                                    //    Text('Status : ' + document['status']),

                                    // ),
                                    // Expanded(
                                    //   child: Row(
                                    //     mainAxisAlignment:
                                    //         MainAxisAlignment.spaceBetween,
                                    //     children: [
                                    //       // Text(snapshot.data[index]['user_name']),
                                    //       Text(
                                    //         'Status : ' +
                                    //             snapshot.data[index]['status'],
                                    //         style: TextStyle(
                                    //             color: Colors.grey, fontSize: 12),
                                    //       ),
                                    //     ],
                                    //   ),
                                    // ),
                                    // SizedBox(height: 30,),
                                    snapshot.data[index]['status'] == 'Waiting'
                                        ? Expanded(
                                            child: SizedBox(),
                                          )
                                        : Expanded(
                                            child: Row(children: [
                                              Expanded(
                                                child: ElevatedButton(
                                                    onPressed: () {
                                                      Get.to(
                                                        () => ChatPage(
                                                          requestId: requestId,
                                                          fromId: fromId,
                                                          toId: toId,
                                                        ),
                                                      );
                                                    },
                                                    child: Text('Chat')),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                child: ElevatedButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        showDialog(
                                                            context: context,
                                                            builder: (BuildContext
                                                                    context) =>
                                                                AlertDialog(
                                                                  title: Text(
                                                                      "Finish?"),
                                                                  content: Text(
                                                                      "Are you sure your job has finished yet?"),
                                                                  actions: [
                                                                    TextButton(
                                                                      child: Text(
                                                                          "No",
                                                                          style:
                                                                              TextStyle(color: Colors.red)),
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      },
                                                                    ),
                                                                    TextButton(
                                                                        child: Text(
                                                                            "Yes"),
                                                                        onPressed:
                                                                            () {
                                                                          FirebaseFirestore.instance.collection('request_designer').doc(snapshot.data[index].documentID).update({
                                                                            'status':
                                                                                'Finish'
                                                                          });
                                                                          setState(
                                                                              () {
                                                                            Navigator.popUntil(context,
                                                                                ModalRoute.withName("/"));
                                                                          });
                                                                        })
                                                                  ],
                                                                ));
                                                      });
                                                    },
                                                    child: Text('Finish')),
                                              ),
                                            ]),
                                          )
                                  ],
                                ),
                              ),
                              // trailing: document['status'] == 'On Progress'
                              //     ? ElevatedButton(
                              //         onPressed: () {},
                              //         child: Text('Chat'),
                              //       )
                              //     : document['status'] == 'Finish'
                              //         ? ElevatedButton(
                              //             onPressed: () {},
                              //             child: Text('Review'),
                              //           )
                              //         : null,
                            );
                          }),
                    ),
                    // ),
                  ],
                ),
              );
            }
          }),
    );
  }
}
