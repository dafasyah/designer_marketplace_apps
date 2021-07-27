import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/auth/register_designer.dart';
import 'package:flutter_application_1/services/auth.dart';
import 'package:flutter_application_1/shared/constants.dart';
import 'package:flutter_application_1/shared/loading.dart';


class Register extends StatefulWidget {

  final Function toggleView;
  Register({ this.toggleView });

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  bool loading = false;


  String email = '';
  String password = '';
  String address = '';
  String fullname = '';
  int phoneNumber = 0;
  String error = '';
  String photoUrl = '';

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0.0,
        title: Text('Sign Up as User'),
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.person),
            label: Text('Sign In'),
            onPressed: () {
              widget.toggleView();
            }
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(height: 20.0),
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: 'Email'),
                validator:  (val) => val.isEmpty ? 'Enter an Email' : null,
                onChanged: (val){
                    setState(() => email = val);
                }
              ),
              SizedBox(height: 20.0),
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: 'Password'),
                obscureText: true,
                validator:  (val) => val.length < 6 ? 'Enter a Password more than 6 characters' : null,
                onChanged: (val){
                    setState(() => password = val);


                }
              ),
              SizedBox(height: 20.0),
              SizedBox(height: 12.0),
              Text(
                error,
                style: TextStyle(color: Colors.red, fontSize: 14.0)
              ),
              RaisedButton(
                color: Colors.blue,
                child: Text('Sign Up as User',
                style: TextStyle(color:Colors.white),
                ),
                onPressed:  () async {
                  if (_formKey.currentState.validate()){
                    setState(() => loading = true);
                    dynamic result = await _auth.registerWithEmailAndPassword(email, password, fullname, address, phoneNumber, photoUrl);
                    if(result == null){
                      setState(() { 
                        error = 'Please enter a valid email';
                        loading = false;

                      });
                    }
                  }
                }
              ),
              
              TextButton(
                child: Text('Become a Designer!',
                style: TextStyle(color:Colors.blue[400]),
                ),
                onPressed:  () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterDesigner()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}