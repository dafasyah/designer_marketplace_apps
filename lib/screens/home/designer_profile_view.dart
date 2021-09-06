import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/user_controller.dart';
import 'package:flutter_application_1/models/user.dart';
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
    //userController.buildStreamRate(id: userId);
    userController.calculationRate();

    return WillPopScope(
      onWillPop: () {
        userController.total.value = 0.0;
        userController.resultRate.value = 0.0;
        Get.back();
        return;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                userController.total.value = 0.0;
                userController.resultRate.value = 0.0;
                Get.back();
              }),
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
                    TextButton.icon(
                      onPressed: (userController.resultRate.value.isNaN ||
                              userController.resultRate.value.isInfinite)
                          ? null
                          : () {
                              Get.to(() => RatingPage());
                            },
                      label: Icon(Icons.star_rate_rounded,
                          color: Colors.yellow[700]),
                      icon: Text(
                        userController.resultRate.value.isNaN ||
                                userController.resultRate.value.isInfinite
                            ? '0.0'
                            : '${userController.resultRate.value}',
                        style: TextStyle(fontWeight: FontWeight.bold),
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
                      child: Text("Minimum Price: "+userController.currentUser.value.minimumPrice,
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
      ),
    );
  }
}

class RatingPage extends GetView<UserController> {
  @override
  Widget build(BuildContext context) {
    controller.calculationRate();
    return WillPopScope(
      onWillPop: () {
        controller.total.value = 0.0;
        controller.resultRate.value = 0.0;
        Get.back();
        return;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                controller.total.value = 0.0;
                controller.resultRate.value = 0.0;
                Get.back();
              }),
          title: Text('Review & Rating'),
        ),
        body: ListView(
          children: [
            (controller.ratings.isEmpty)
                ? Text('No Rate')
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: controller.ratings
                          .map((element) => Container(
                                margin: EdgeInsets.all(8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      element.rating,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 8),
                                    Text(element.text),
                                    SizedBox(height: 8),
                                    Text('Reviewed by ${element.email}')
                                  ],
                                ),
                              ))
                          .toList(),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
