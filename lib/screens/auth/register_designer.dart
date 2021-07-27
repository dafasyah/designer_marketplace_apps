import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/auth.dart';
import 'package:flutter_application_1/shared/constants.dart';
import 'package:flutter_application_1/shared/loading.dart';


class RegisterDesigner extends StatefulWidget {

  // final Function toggleView;
  // RegisterDesigner({ this.toggleView });

  @override
  _RegisterDesignerState createState() => _RegisterDesignerState();
}

class _RegisterDesignerState extends State<RegisterDesigner> {
  
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  bool loading = false;


  String email = '';
  String password = '';
  String confirmPassword = '';
  String address = 'NO ADDRESS';
  String fullname = 'NO NAME';
  String phoneNumber = '0';
  String error = '';
  String photoUrl = '';
  String minimumPrice = '0';

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0.0,
        title: Text('Sign Up as Designer'),
        // actions: <Widget>[
        //   FlatButton.icon(
        //     icon: Icon(Icons.person),
        //     label: Text('Sign In'),
        //     onPressed: () {
        //       widget.toggleView();
        //     }
        //   )
        // ],
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
                 TextFormField(
                decoration: textInputDecoration.copyWith(hintText: 'Confirm Password'),
                obscureText: true,
                validator:  (val) {
                 if(val.length < 6) {
                   return 'Enter a Password more than 6 characters';
                 }else if (confirmPassword != password){
                   return 'Your Password does not match';
                 }
                 else{
                   return null;
                 }
                },
                onChanged: (val){
                    setState(() => confirmPassword = val);
                }
              ),
              SizedBox(height: 12.0),
              Text(
                error,
                style: TextStyle(color: Colors.red, fontSize: 14.0)
              ),
              RaisedButton(
                color: Colors.blue,
                child: Text('Sign Up as Designer',
                style: TextStyle(color:Colors.white),
                ),
                onPressed:  () async {
                  if (_formKey.currentState.validate()){
                    setState(() => loading = true);
                    dynamic result = await _auth.registerDesignerWithEmailAndPassword(email, password, fullname, address, phoneNumber, photoUrl, minimumPrice);
                    if(result == null){
                      setState(() { 
                        error = 'Please enter a valid email';
                        loading = false;

                      });
                    }
                  }
                }
              ),
              
              
            ],
          ),
        ),
      ),
    );
  }
}