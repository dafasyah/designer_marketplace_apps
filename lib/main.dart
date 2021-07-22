import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/designer.dart';
import 'package:flutter_application_1/models/user.dart';
import 'package:flutter_application_1/screens/auth/authenticate.dart';
import 'package:flutter_application_1/screens/home/home.dart';
import 'package:flutter_application_1/screens/home/home_designer.dart';
import 'package:flutter_application_1/screens/wrapper.dart';
import 'package:flutter_application_1/screens/wrapper_designer.dart';
import 'package:flutter_application_1/services/auth.dart';
import 'package:flutter_application_1/services/database.dart';
import 'package:flutter_application_1/shared/loading.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:rxdart/rxdart.dart';

// void main() {
//   runApp(MyApp());
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

// Stream<DocumentSnapshot> getData() {
//   Stream stream1 = FirebaseFirestore.instance.collection('user').where('role', isEqualTo: 'type1').snapshots();
//   Stream stream2 = FirebaseFirestore.instance.collection('designer').where('type', isEqualTo: 'type2').snapshots();
//   return Observable.merge(([stream2, stream1]));
// }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Designer Apps',
      home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (ctx, userSnapshot) {
            if (userSnapshot.hasData) {
              return StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('user')
                    .doc(userSnapshot.data.uid)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshotUser) {
                  // return StreamBuilder<DocumentSnapshot>(
                  //   stream: FirebaseFirestore.instance.collection("designer").doc(userSnapshot.data.uid).snapshots(),
                  //   builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshotDesigner)
                  // {
                  if (snapshotUser.hasData && snapshotUser.data != null) {
                    final user = snapshotUser.data.data();
                    // final designer = snapshotDesigner.data.data();

                    if (user['role'] == 'designer') {
                      return HomeDesigner();
                    } else {
                      return Home();
                    }
                  } else {
                    return Material(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  // }
                  // );
                },
              );
            }
            return Authenticate();
          }),
      builder: Loading.init(),
    );
    // final user = Provider.of<User>(context);
    // final designer = Provider.of<Designer>(context);

    // return StreamProvider.value(
    //   value: AuthService().designer,
    //   child: MaterialApp(
    //   home: StreamBuilder(
    //     stream: FirebaseAuth.instance.onAuthStateChanged,
    //     builder: (context, snapshot) {
    //       if (snapshot.hasData) {
    //           return StreamBuilder<DocumentSnapshot>(
    //             stream: Firestore.instance.collection("user").document(snapshot.data.uid).snapshots(),
    //             builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot){

    //             if(snapshot.hasData && snapshot.data != null){
    //                 final userData = snapshot.data.data;

    //                 if(userData['role'] == 'designer'){
    //                  return HomeDesigner();
    //                 }
    //                 else{
    //                   return Home();
    //                 }

    //               }else{
    //                   return Material(
    //                   child: Center(child: CircularProgressIndicator(),),
    //                 );
    //               }
    //             }
    //           );
    //         }
    //         return Authenticate();
    //       }),
    //       builder: (context, state)
    //           {
    //             return Authenticate();
    //           }

    //   )
    // );

    // return StreamProvider<Designer>.value(
    //       value: AuthService().designer,
    //           child: MaterialApp(
    //       home: WrapperDesigner(),
    //       ),
    //     );
    //
  }
}
