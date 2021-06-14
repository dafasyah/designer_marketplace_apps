import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/home/review_designer.dart';

class UserOrder extends StatefulWidget {
  @override
  _UserOrder createState() => new _UserOrder();
}

class _UserOrder extends State<UserOrder> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.brown[400],
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
          return ListView(
            children: snapshot.data.docs.map((document) {
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
                        onPressed: () {},
                        child: Text('Chat'),
                      )
                    : document['status'] == 'Finish'
                        ? ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                context, MaterialPageRoute(builder: (context) => ReviewDesigner()));
                            },
                            child: Text('Review'),
                          )
                        : null,
              );
            }).toList(),
          );
        });
  }
}
