import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/user_controller.dart';
import 'package:get/get.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class ReviewDesigner extends StatefulWidget {
  final String userId;
  final String requestId;
  ReviewDesigner({this.userId, this.requestId});
  @override
  _ReviewDesignerState createState() => _ReviewDesignerState();
}

class _ReviewDesignerState extends State<ReviewDesigner> {
  var rating = 0.0;
  @override
  Widget build(BuildContext context) {
    final userController = Get.put(UserController());
    userController.getCurrentUser(widget.userId);
    return Container(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text('Review Designer'),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Obx(
                () => (userController.currentUser.value.profile == null)
                    ? Container(
                        padding: const EdgeInsets.all(10),
                        child: Expanded(
                          child: Icon(
                            Icons.account_circle_rounded,
                            size: 100,
                          ),
                        ),
                      )
                    : CircleAvatar(
                        radius: 65,
                        backgroundImage: NetworkImage(
                            userController.currentUser.value.profile),
                      ),
              ),
              Container(
                padding: const EdgeInsets.all(15),
                child: 
                Text(userController.currentUser.value.name),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                child: Expanded(
                  child: SmoothStarRating(
                    rating: rating,
                    size: 60,
                    starCount: 5,
                    allowHalfRating: false,
                    filledIconData: Icons.star,
                    defaultIconData: Icons.star_border,
                    spacing: 2.0,
                    onRated: (value) {
                      print("rating value -> $value");
                      setState(() => rating = value);
                      // print("rating value dd -> ${value.truncate()}");
                    },
                  ),
                ),
              ),
              Container(
                  padding: const EdgeInsets.all(20),
                  child: Expanded(
                    child: TextField(
                      maxLines: 5,
                      minLines: 2,
                      enabled: true,
                      controller: userController.ratingController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Review Designer',
                      ),
                    ),
                  )),
              Obx(() => (userController.isLoading.value == true)
                  ? CircularProgressIndicator()
                  : Container(
                      child: ElevatedButton(
                          onPressed: () {
                            userController.addRating(widget.userId, rating, widget.requestId);
                          },
                          child: Text('Finish')),
                    ))
            ],
          ),
        ),
      ),
    );
  }
}
