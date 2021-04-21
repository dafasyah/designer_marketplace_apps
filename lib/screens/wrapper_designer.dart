import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/designer.dart';
import 'package:flutter_application_1/models/user.dart';
import 'package:flutter_application_1/screens/auth/authenticate.dart';
import 'package:flutter_application_1/screens/home/home.dart';
import 'package:flutter_application_1/screens/home/home_designer.dart';
import 'package:provider/provider.dart';


class WrapperDesigner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final designer = Provider.of<Designer>(context);
    // print(user);

    //return Home or Auth
    if(designer == null){
      return Authenticate();
    }else{
      return HomeDesigner();
    }
  }
}