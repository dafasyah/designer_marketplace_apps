import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/user_store.dart';
import 'package:flutter_application_1/screens/home/home_designer.dart';
import 'package:flutter_application_1/screens/home/user_tile.dart';
import 'package:provider/provider.dart';

class UserList extends StatefulWidget {
  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  FutureOr getDesigner() async {
    final user =  FirebaseAuth.instance.currentUser.uid;
    var _db = FirebaseFirestore.instance;
    QuerySnapshot reqA = await _db
        .collection("request_designer")
        .where("status", isEqualTo: 'waiting').where("designer_id", isEqualTo: user)
        .get();
    return reqA.docs;
  }
  @override
  Widget build(BuildContext context) {

    return Container(
      child: FutureBuilder(
        future: getDesigner(),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Text("Loading..."),
            );
          } else {
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (_, index) {
                  return ListTile(
                    title: FutureBuilder<dynamic>(
                      future: getUserByUserId(snapshot.data[index]['user_id']),
                      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                        if (snapshot.hasData) {
                          if(snapshot.data.length > 1){
                            return Text('Two or more users with the same Id exists');
                          }
                          else{
                            return Text(snapshot.data[0]['name']);
                          }
                        } else {
                          return Text('User not found');
                        }
                      },
                    ),
                    subtitle: Row(
                        children: <Widget>[
                          Expanded(child: RaisedButton(onPressed: () {
                            setState(() {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) => CupertinoAlertDialog(
                                    title: Text("Hire?"),
                                    content: Text("Are you sure you want to Accept ?"),
                                    actions: [
                                      CupertinoDialogAction(
                                        child: Text("No"),
                                        onPressed: () {Navigator.of(context).pop();},),
                                      CupertinoDialogAction(
                                          child: Text("Yes",style: TextStyle(color: Colors.red),),
                                          onPressed: () {
                                            FirebaseFirestore.instance.collection('request_designer').doc(snapshot.data[index].documentID).update({
                                              'status': 'On Progress'
                                            });
                                            setState(() {
                                              Navigator.popUntil(context, ModalRoute.withName("/"));
                                            });
                                          })
                                    ],
                                  )
                              );
                            });
                          },
                            child: Text("Accept", style: TextStyle(fontSize: 12),),
                            color: Colors.blue,textColor: Colors.white,)),
                          Expanded(child: RaisedButton(onPressed: () {
                            setState(() {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) => CupertinoAlertDialog(
                                    title: Text("Hire?"),
                                    content: Text("Are you sure you want to Reject ?"),
                                    actions: [
                                      CupertinoDialogAction(
                                        child: Text("No"),
                                        onPressed: () {Navigator.of(context).pop();},),
                                      CupertinoDialogAction(
                                          child: Text("Yes",style: TextStyle(color: Colors.red),),
                                          onPressed: () {
                                            FirebaseFirestore.instance.collection('request_designer').doc(snapshot.data[index].documentID).update({
                                              'status': 'Reject'
                                            });
                                            setState(() {
                                              Navigator.popUntil(context, ModalRoute.withName("/"));
                                            });
                                          })
                                    ],
                                  )
                              );
                            });
                          },
                            child: Text("Reject", style: TextStyle(fontSize: 12),),
                            color: Colors.red,textColor: Colors.white,)),
                        ]
                    ),
                  );
                });
          }
        },
      ),
    );

  }

  Future<dynamic> getUserByUserId(String userId) async {
    return (await FirebaseFirestore.instance
        .collection("user")
        .where("user_id", isEqualTo: userId)
        .get()
    ).docs;
  }
}