import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/notif_controller.dart';
import 'package:flutter_application_1/controllers/rete_controller.dart';
import 'package:flutter_application_1/controllers/user_controller.dart';
import 'package:get/get.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class ReviewDesigner extends StatefulWidget {
  final String userId;
  final String requestId;
  final String email;
  final String image;
  final String orderId;
  ReviewDesigner(
      {this.userId, this.requestId, this.email, this.image, this.orderId});
  @override
  _ReviewDesignerState createState() => _ReviewDesignerState();
}

class _ReviewDesignerState extends State<ReviewDesigner> {
  var rating = 0.0;
  @override
  Widget build(BuildContext context) {
    final userController = Get.put(UserController());
    final rateController = Get.put(RateController());
    final controller = Get.find<NotifController>();
    print(widget.orderId + 'order');
    userController.getCurrentUser(widget.userId);
    rateController.getCurrentDesigner(widget.requestId);
    return Obx(
      () => Scaffold(
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
              (rateController.currentDesinger.value.profile == null)
                  ? Container(
                      padding: const EdgeInsets.all(10),
                      child: Expanded(
                          child: CircularProgressIndicator(
                              backgroundColor: Colors.white)),
                    )
                  : CircleAvatar(
                      radius: 65,
                      backgroundImage: NetworkImage(
                          rateController.currentDesinger.value.profile),
                    ),
              Container(
                padding: const EdgeInsets.all(15),
                child: Text(widget.email),
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
              (userController.isLoading.value == true)
                  ? CircularProgressIndicator()
                  : Container(
                      child: ElevatedButton(
                          onPressed: () {
                            print(userController.currentUser.value.email);
                            print('userid:${widget.userId}');
                            print('reqId:${widget.requestId}');
                            userController.addRating(
                              email: userController.currentUser.value.email,
                              rating: rating,
                              id: widget.userId,
                              requestId: widget.requestId,
                              orderId: widget.orderId,
                            );
                            controller.showNotification('Reviewed',
                                'Anda telah memberikan rating $rating');
                          },
                          child: Text('Finish')),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
