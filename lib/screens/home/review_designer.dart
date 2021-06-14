import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class ReviewDesigner extends StatefulWidget {
  @override
  _ReviewDesignerState createState() => _ReviewDesignerState();
}

class _ReviewDesignerState extends State<ReviewDesigner> {
  var rating = 0.0;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text('Review Designer'),
        ),
        body: Container(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(10),
                child: Expanded(
                  child: Icon(
                    Icons.account_circle_rounded,
                    size: 100,
                  ),
                ),
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
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Review Designer',
                    ),
                  ),
                )
              ),
              Container(
                child: ElevatedButton(onPressed: (){}, child: Text('Finish')),
              )
            ],
          ),
        ),
      ),
    );
  }
}
