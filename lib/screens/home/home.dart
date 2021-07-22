import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/designer_store.dart';
import 'package:flutter_application_1/models/user_store.dart';
import 'package:flutter_application_1/screens/home/designer_list.dart';
import 'package:flutter_application_1/screens/home/find_designer.dart';
import 'package:flutter_application_1/screens/home/find_nearby.dart';
import 'package:flutter_application_1/screens/home/profile_user.dart';
import 'package:flutter_application_1/screens/home/settings_forms.dart';
import 'package:flutter_application_1/screens/home/user_list.dart';
import 'package:flutter_application_1/screens/home/user_order_list.dart';
import 'package:flutter_application_1/services/auth.dart';
import 'package:flutter_application_1/services/database.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    // void _showSettingsPanel(){
    //   showModalBottomSheet(context: context, builder: (context) {
    //     return Container(
    //       padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
    //       child:  SettingsForm(),
    //     );
    //   });
    // }

    return StreamProvider<List<DesignerStore>>.value(
      value: DatabaseService().designerstore,
      child: Scaffold(
        // backgroundColor: Colors.brown[50],
        appBar: AppBar(
          title: Text('User Home'),
          backgroundColor: Colors.brown[400],
          elevation: 0.0,
          actions: <Widget>[
            //  FlatButton.icon(
            //    icon:  Icon(Icons.person),
            //    label: Text('Log Out'),
            //    onPressed: () async {
            //      await _auth.signOut();
            //    }
            //  ),
            FlatButton.icon(
              icon: Icon(Icons.person),
              label: Text('Profile'),
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ProfileUser())),
            )
          ],
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                child: ElevatedButton(
                    onPressed: () {
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => FindDesigner()));
                      Get.to(() => FindDesigner());
                    },
                    child: Text('Find Nearby Designer')),
              ),
              Expanded(child: DesignerList()),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.design_services),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => UserOrder()));
          },
        ),
      ),
    );
  }
}
