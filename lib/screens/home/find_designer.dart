import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/user_controller.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FindDesigner extends StatefulWidget {
  @override
  FindDesignerState createState() => FindDesignerState();
}

class FindDesignerState extends State<FindDesigner> {
  final userController = Get.put(UserController());
  Completer<GoogleMapController> _controller = Completer();

  Map<MarkerId, Marker> markers1 = <MarkerId, Marker>{};
  populateClients() {
    FirebaseFirestore.instance.collection('location').get().then((docs) {
      if (docs.docs.isNotEmpty) {
        for (int i = 0; i < docs.docs.length; ++i) {
          initMarker(docs.docs[i], docs.docs[i].id);
        }
      }
    });
  }

  void initMarker(tomb, tombId) {
    var markerIdVal = tombId;
    final MarkerId markerId = MarkerId(markerIdVal);

    final Marker marker = Marker(
        markerId: markerId,
        position: LatLng(tomb.data()['lat'], tomb.data()['lng']),
        icon: BitmapDescriptor.defaultMarker,
        infoWindow: InfoWindow(title: tomb.data()['name']));
    setState(() {
      markers1[markerId] = marker;
    });
  }

  @override
  void initState() {
    populateClients();
    super.initState();
  }

  double zoomVal = 5.0;
  @override
  Widget build(BuildContext context) {
    userController.buildStream();
    return Scaffold(
      appBar: AppBar(
        title: Text("Find Designer"),
      ),
      body: Stack(
        children: <Widget>[
          _buildGoogleMap(context),
          Obx(
            () => (userController.users.isEmpty)
                ? CircularProgressIndicator()
                : Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 20.0),
                      height: 150.0,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          ...userController.users.map((element) {
                            //print(element.data.toString());
                            return _boxes(element.profile, element.lat,
                                element.lng, element.name);
                          }),
                        ],
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _boxes(String _image, double lat, double long, String restaurantName) {
    return GestureDetector(
      onTap: () {
        _gotoLocation(lat, long);
      },
      child: Container(
        width: Get.width * 0.75,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(8)),
        margin: EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 120,
              height: 140,
              child: ClipRRect(
                borderRadius: new BorderRadius.circular(8),
                child: Image(
                  fit: BoxFit.cover,
                  image: NetworkImage(_image),
                ),
              ),
            ),
            Expanded(
                child: Padding(
              padding: EdgeInsets.only(top: 8, left: 8),
              child: Text(restaurantName),
            ))
          ],
        ),
      ),
    );
  }

  Widget _buildGoogleMap(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: CameraPosition(
            target: LatLng(-6.175157730727777, 106.82760340780803), zoom: 12),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: Set<Marker>.of(markers1.values),
        //Set.from(    markers) //{gramercyMarker, bernardinMarker}, //userController.markers,
      ),
    );
  }

  Future<void> _gotoLocation(double lat, double long) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(lat, long),
      zoom: 15,
      tilt: 50.0,
      bearing: 45.0,
    )));
  }
}
