import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/auth/sign_in.dart';
import 'package:flutter_application_1/services/auth.dart';
import 'package:flutter_application_1/shared/constants.dart';

class DesignerProfileUpdate extends StatefulWidget {
  @override
  _DesignerProfileUpdateState createState() => _DesignerProfileUpdateState();
}

class _DesignerProfileUpdateState extends State<DesignerProfileUpdate> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(title: Text("My Profile"), actions: <Widget>[
          FlatButton.icon(
              icon: Icon(Icons.person),
              label: Text('Log Out'),
              onPressed: () async {
                await _auth.signOut();
                Navigator.of(context).pop();
              }),
        ]),
        body: Container(
          margin: EdgeInsets.all(20),
          child: Center(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Full Name',
                    ),
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Full Address',
                    ),
                  ),
                  SizedBox(height: 10.0),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text('Save Profile'),
                  )
                ]),
          ),
        ),
      ),
    );
  }
}
