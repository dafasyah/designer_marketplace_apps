import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/user_controller.dart';
import 'package:flutter_application_1/shared/loading.dart';
import 'package:get/get.dart';

class DesignerPortofolio extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userController = Get.find<UserController>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Portofolio'),
      ),
      body: Obx(
        () => (userController.selectedImagePath.value == null)
            ? SizedBox()
            : Column(
                children: [
                  Expanded(
                    child: Image.file(
                      File(userController.selectedImagePath.value),
                      height: 250,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SafeArea(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(),
                          (userController.isLoading.value == true)
                              ? CircularProgressIndicator()
                              : buttonChat(
                                  icon: Icons.send,
                                  onTap: () async {
                                    var image =
                                        await userController.postImage();
                                    userController.addPortofolio(image);
                                    Get.back();
                                  }),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

Widget buttonChat({IconData icon, Function() onTap}) {
  return Container(
    margin: EdgeInsets.only(left: 8),
    decoration: BoxDecoration(
      color: Colors.grey.shade200,
      borderRadius: BorderRadius.circular(16.0),
    ),
    child: IconButton(
      onPressed: onTap,
      icon: Icon(
        icon,
        color: Colors.lightBlue[600],
      ),
      disabledColor: Colors.blueGrey,
    ),
  );
}
