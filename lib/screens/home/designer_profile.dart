import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/auth.dart';
import 'package:provider/provider.dart';

class ProfileDesigner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(title: Text('Designer Profile'),),
        body: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Icon(Icons.account_circle_rounded, size: 100,),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Text('Nama'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Text('Alamat'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}