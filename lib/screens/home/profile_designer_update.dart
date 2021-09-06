import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/user_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/screens/home/designer_portofolio.dart';
import 'package:flutter_application_1/screens/home/profile_designer_form.dart';
import 'package:flutter_application_1/services/auth.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class DesignerProfileUpdate extends StatelessWidget {
  final user = FirebaseAuth.instance.currentUser.uid;
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    final userController = Get.find<UserController>();
    userController.buildStramPorto(id: user, isUser: true);
    userController.getCurrentUser(user);
    return Container(
      child: Scaffold(
        appBar: AppBar(title: Text('Designer Profile'), 
        // actions: <Widget>[
        //   FlatButton.icon(
        //       icon: Icon(Icons.person),
        //       label: Text('Log Out'),
        //       onPressed: () async {
        //         await _auth.signOut();
        //         Navigator.of(context).pop();
        //       }),
        // ]
        ),
        body: Obx(
          () => (userController.currentUser.value.name == null)
              ? Center(child: CircularProgressIndicator())
              : ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: userController.currentUser.value.profile == ""
                          ? Icon(Icons.person, size: 65)
                          : CircleAvatar(
                              radius: 65,
                              backgroundImage: NetworkImage(
                                  userController.currentUser.value.profile),
                            ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                          userController.currentUser.value.name == null ||
                                  userController.currentUser.value.name == ''
                              ? userController.currentUser.value.email
                              : userController.currentUser.value.name,
                          textAlign: TextAlign.center),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                          userController.currentUser.value.address ?? '',
                          textAlign: TextAlign.center),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(userController.currentUser.value.phone ?? '',
                          textAlign: TextAlign.center),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text("Minimum Price: " +
                          userController.currentUser.value.minimumPrice
                              .toString(),
                          textAlign: TextAlign.center),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                      child: ElevatedButton(
                        onPressed: () {
                          Get.to(() => ProfileDesignerForm());
                        },
                        child: Text('Update Profile'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: Text(
                        'Portofolio',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    (userController.portofolio.isEmpty)
                        ? Padding(
                            padding: const EdgeInsets.only(top: 80),
                            child: Text('There is no portofolio yet, upload now!',
                                textAlign: TextAlign.center),
                          )
                        : Container(
                            height: Get.height,
                            child: GridView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: userController.portofolio.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2),
                              itemBuilder: (context, index) => GestureDetector(
                                onTap: () => Get.to(
                                  () => ZoomPortofolio(
                                    userController.portofolio[index].image,
                                    userController.portofolio[index].id,
                                    isUser: true,
                                  ),
                                ),
                                child: Container(
                                  margin: EdgeInsets.all(8),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                        userController.portofolio[index].image,
                                        fit: BoxFit.cover),
                                  ),
                                ),
                              ),
                            ),
                          ),
                  ],
                ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            userController.getImage(ImageSource.gallery);
            Get.to(() => DesignerPortofolio());
          },
          child: Icon(Icons.add_a_photo_rounded),
        ),
      ),
    );
  }
}

class ZoomPortofolio extends GetView<UserController> {
  final String imageUrl;
  final String id;
  final bool isUser;
  ZoomPortofolio(this.imageUrl, this.id, {this.isUser = false});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          width: double.infinity,
        ),
      ),
      floatingActionButton: isUser
          ? FloatingActionButton(
              onPressed: () => controller.deletePortofolio(id),
              child: Icon(Icons.delete),
            )
          : SizedBox(),
    );
  }
}
