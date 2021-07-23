import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/maps_controller.dart';
import 'package:flutter_application_1/controllers/user_controller.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class FindDesigner extends StatefulWidget {
  @override
  FindDesignerState createState() => FindDesignerState();
}

class FindDesignerState extends State<FindDesigner> {
  final userController = Get.find<UserController>();
  final mapsController = Get.put(MapsController());
  StreamSubscription _locationSubscription;
  Location _locationTracker = Location();
  Marker marker;
  Circle circle;
  double selectedLat;
  double selectedLng;

  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController _controller1;

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

  void updateMarkerAndCircle(LocationData newLocalData) {
    setState(() {
      selectedLat = newLocalData.latitude;
      selectedLng = newLocalData.longitude;
    });
    LatLng latLng = LatLng(newLocalData.latitude, newLocalData.longitude);
    this.setState(() {
      marker = Marker(
          markerId: MarkerId('home'),
          position: latLng,
          rotation: newLocalData.heading,
          draggable: false,
          zIndex: 2,
          flat: true,
          anchor: Offset(0.5, 0.5),
          icon: BitmapDescriptor.defaultMarker);
      circle = Circle(
          circleId: CircleId('point'),
          radius: newLocalData.accuracy,
          zIndex: 1,
          strokeColor: Colors.blue,
          center: latLng,
          fillColor: Colors.blue.withAlpha(70));
    });
  }

  Future<void> getCurrentLocation() async {
    try {
      var location = await _locationTracker.getLocation();

      updateMarkerAndCircle(location);

      if (_locationSubscription != null) {
        _locationSubscription.cancel();
      }

      _locationSubscription =
          _locationTracker.onLocationChanged.listen((newLocalData) {
        if (_controller1 != null) {
          _controller1.animateCamera(CameraUpdate.newCameraPosition(
              new CameraPosition(
                  bearing: 192.8334901395799,
                  target: LatLng(newLocalData.latitude, newLocalData.longitude),
                  tilt: 0,
                  zoom: 19.151926040649414)));
          updateMarkerAndCircle(newLocalData);
        }
      });
    } catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint('Permission Denied');
      }
    }
  }

  @override
  void dispose() {
    if (_locationSubscription != null) {
      _locationSubscription.cancel();
    }

    super.dispose();
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
          Padding(
            padding: const EdgeInsets.only(right: 24, bottom: 120),
            child: Align(
              alignment: Alignment.bottomRight,
              child: CircleAvatar(
                radius: 24,
                child: IconButton(
                  icon: Icon(Icons.location_searching),
                  onPressed: () async {
                    await getCurrentLocation();
                    mapsController.getAddress(selectedLat, selectedLng);
                    _gotoLocation(selectedLat, selectedLng);
                    print(selectedLat.toString() + " LAT");
                    print(selectedLng.toString() + " LAT");
                  },
                ),
              ),
            ),
          ),
          Obx(
            () => (userController.locations.isEmpty)
                ? CircularProgressIndicator()
                : Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 20.0),
                      height: 85,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          ...userController.locations.map((element) {
                            //print(element.data.toString());
                            return _boxes(
                                element.lat, element.lng, element.name);
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

  Widget _boxes(double lat, double long, String restaurantName) {
    return GestureDetector(
      onTap: () {
        _gotoLocation(lat, long);
      },
      child: Container(
        width: Get.width * 0.55,
        padding: EdgeInsets.only(left: 24),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(8)),
        margin: EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Container(
            //   width: 120,
            //   height: 140,
            //   child: ClipRRect(
            //     borderRadius: new BorderRadius.circular(8),
            //     child: Image(
            //       fit: BoxFit.cover,
            //       image: NetworkImage(_image),
            //     ),
            //   ),
            // ),
            Icon(Icons.person),
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
