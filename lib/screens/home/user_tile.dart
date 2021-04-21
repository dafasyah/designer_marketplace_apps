import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/user_store.dart';
import 'package:flutter_application_1/screens/home/settings_forms.dart';


class UserTile extends StatelessWidget {

  final UserStore userstore;
  
  UserTile({this.userstore});


  @override
  Widget build(BuildContext context) {

      void _showSettingsPanel(){
      showModalBottomSheet(context: context, builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
          child:  SettingsForm(),
        );
      });
    }

    return Padding(
      padding:  EdgeInsets.only(top: 8.0),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 0),
        child: FlatButton(
          onPressed: () { _showSettingsPanel(); },
          color: Colors.brown[200],
          // margin:  EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
          child: ListTile(
            leading: CircleAvatar(
              radius: 20.0,
              backgroundColor: Colors.brown[500],
            ),
            title: Text(userstore.name)
          ),
        ),
      ),
    );
  }
}