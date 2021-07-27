import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/user_controller.dart';
import 'package:flutter_application_1/models/designer_store.dart';
import 'package:flutter_application_1/screens/home/designerorder.dart';
import 'package:flutter_application_1/screens/home/profile_designer_update.dart';
import 'package:flutter_application_1/screens/home/user_list.dart';
import 'package:flutter_application_1/services/auth.dart';
import 'package:flutter_application_1/services/database.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class HomeDesigner extends StatelessWidget {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    Get.put(UserController());
    return StreamProvider<List<DesignerStore>>.value(
      value: DatabaseService().designerstore,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Designer Home'),
          backgroundColor: Colors.blue,
          elevation: 0.0,
          actions: <Widget>[
            FlatButton.icon(
                icon: Icon(Icons.person),
                label: Text('My Profile'),
                onPressed: () => Get.to(() => DesignerProfileUpdate())
                //  Navigator.push(context,
                //     MaterialPageRoute(builder: (context) => DesignerProfileUpdate()))
                )
          ],
        ),
        body: UserList(),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.design_services),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => DesignerOrder()));
          },
        ),
        //  Column(
        //    children: [
        //      Text('test'),
        //    ],
        //  )
      ),
    );
  }
}
