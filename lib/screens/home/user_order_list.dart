import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/home/chat_page.dart';
import 'package:flutter_application_1/screens/home/review_designer.dart';
import 'package:get/get.dart';

class UserOrder extends StatefulWidget {
  @override
  _UserOrder createState() => new _UserOrder();
}

class _UserOrder extends State<UserOrder> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue,
        title: Row(
          children: <Widget>[
            Text(
              "My Order",
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
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('request_designer')
            .where('user_id', isEqualTo: FirebaseAuth.instance.currentUser.uid)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: Text("Loading..."),
            );
          }
          return snapshot.data.docs.length == 0
              ? Center(
                  child: Text('You have no order list yet'),
                )
              : ListView(
                  children: snapshot.data.docs.map((document) {
                    final fullname = document['fullname'];
                    final email = document['name'];
                    return ListTile(
                      title: Text(document['designer_name']),
                      subtitle: Row(
                        children: <Widget>[
                          Expanded(
                            child: Text('Status : ' + document['status']),
                          )
                        ],
                      ),
                      trailing: document['status'] == 'On Progress'
                          ? ElevatedButton(
                              onPressed: () {
                                Get.to(() => ChatPage(
                                  email: email,
                                  fullname: fullname,
                                      requestId: document.id,
                                      toId: document['designer_id'],
                                      fromId:
                                          FirebaseAuth.instance.currentUser.uid,
                                    ));
                              },
                              child: Text('Chat'),
                            )
                          : document['status'] == 'Finish'
                              ? ElevatedButton(
                                  onPressed: () {
                                    Get.to(() => ReviewDesigner(
                                          userId: document['designer_id'],
                                          requestId: document.id,
                                        ));
                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (context) => ReviewDesigner()));
                                  },
                                  child: Text('Review'),
                                )
                              : SizedBox(),
                    );
                  }).toList(),
                );
        });
  }
}
