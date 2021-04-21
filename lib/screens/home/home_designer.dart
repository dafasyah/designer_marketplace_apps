import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/designer_store.dart';
import 'package:flutter_application_1/screens/home/designer_list.dart';
import 'package:flutter_application_1/screens/home/user_list.dart';
import 'package:flutter_application_1/services/auth.dart';
import 'package:flutter_application_1/services/database.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/models/user_store.dart';

class HomeDesigner extends StatelessWidget {

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {

     return StreamProvider<List<DesignerStore>>.value(
          value: DatabaseService().designerstore,
          child: Scaffold(
         backgroundColor: Colors.brown[50],
         appBar: AppBar(
           title:  Text('Designer Home'),
           backgroundColor: Colors.brown[400],
           elevation: 0.0,
           actions: <Widget>[
             FlatButton.icon(
               icon:  Icon(Icons.person),
               label: Text('Log Out'),
               onPressed: () async {
                 await _auth.signOut();
               }
             )
           ],
         ),
         body: UserList()
       ),
     );
  }
}