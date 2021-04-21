import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/designer.dart';
import 'package:flutter_application_1/models/user.dart';
import 'package:flutter_application_1/services/database.dart';
import 'package:flutter_application_1/shared/constants.dart';
import 'package:flutter_application_1/shared/loading.dart';
import 'package:provider/provider.dart';

class SettingsForm extends StatefulWidget {
  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {

  final _formKey = GlobalKey<FormState>();


  String _currentName;
  String _currentRole;


  @override
  Widget build(BuildContext context) {
    
    final user = Provider.of<Designer>(context);

    return StreamBuilder<DesignerData>(
      stream: DatabaseService(uid: user.uid).designerData,
      builder: (context, snapshot) {
        if(snapshot.hasData){

          DesignerData userData = snapshot.data;

          return Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Text(
                  'Update your profile settings',
                  style: TextStyle(fontSize: 18.0)
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  initialValue: userData.name,
                  decoration: textInputDecoration,
                  validator: (val) => val.isEmpty ? 'Please enter a name' : null,
                  onChanged: (val) => setState(() => _currentName = val),
                ),
                SizedBox(height: 20.0),
                RaisedButton(
                  color: Colors.pink[400],
                  child: Text('Update',
                  style: TextStyle(color: Colors.white)),
                  onPressed: () async {
                    if(_formKey.currentState.validate()){
                      await DatabaseService(uid: user.uid).updateUserData(
                        _currentName ?? userData.name,
                        _currentRole ?? userData.role,
                        userData.uid
                      );
                      Navigator.pop(context);                    
                    }
                  },
                )
                
              ]
            ),
        );
        }else{
          return Loading();
        }
        
      }
    );
  }
}
