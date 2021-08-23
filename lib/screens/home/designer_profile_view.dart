import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/user_controller.dart';
import 'package:flutter_application_1/screens/home/profile_designer_update.dart';
import 'package:get/get.dart';

class ProfileDesigner extends StatelessWidget {
  final String userId;
  ProfileDesigner({this.userId});
  @override
  Widget build(BuildContext context) {
    final userController = Get.find<UserController>();
    userController.buildStramPorto(id: userId, isUser: true);
    userController.getCurrentUser(userId);
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Designer Profile'),
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
                      child: Text(userController.currentUser.value.name,
                          textAlign: TextAlign.center),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(userController.currentUser.value.address,
                          textAlign: TextAlign.center),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(userController.currentUser.value.phone,
                          textAlign: TextAlign.center),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(userController.currentUser.value.minimumPrice,
                          textAlign: TextAlign.center),
                    ),
                    SizedBox(height: 24),
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
                            child: Text('There is no portofolio yet',
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
        // SingleChildScrollView(
        //   child:
        // ),
      ),
    );
  }
}
