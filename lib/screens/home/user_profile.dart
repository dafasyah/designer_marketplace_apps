import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/user_controller.dart';
import 'package:get/get.dart';

class ProfileUserDisplay extends StatelessWidget {
  final userId;
  ProfileUserDisplay({this.userId});

  @override
  Widget build(BuildContext context) {
    final userController = Get.put(UserController());
    userController.getCurrentUser(userId);
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile User'),
      ),
      body: Obx(() => (userController.currentUser.value.address == null)
          ? CircularProgressIndicator()
          : Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 24),
                  CircleAvatar(
                    radius: 65,
                    backgroundImage:
                        NetworkImage(userController.currentUser.value.profile),
                  ),
                  SizedBox(height: 45),
                  Text(userController.currentUser.value.name),
                  Text(userController.currentUser.value.address),
                  Text(userController.currentUser.value.phone),
                ],
              ),
            )),
    );
  }
}
