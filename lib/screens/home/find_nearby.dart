import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/controllers/maps_controller.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class FindNearby extends StatefulWidget {
  const FindNearby({Key key}) : super(key: key);

  @override
  _FindNearbyState createState() => _FindNearbyState();
}

class _FindNearbyState extends State<FindNearby> {
  StreamSubscription _locationSubscription;
  Location _locationTracker = Location();
  Marker marker;
  Circle circle;
  GoogleMapController _controller;
  double selectedLat;
  double selectedLng;
  static final CameraPosition initialLocation = CameraPosition(
      target: LatLng(37.42796133580664, -122.085749655962), zoom: 14.4746);

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
        if (_controller != null) {
          _controller.animateCamera(CameraUpdate.newCameraPosition(
              new CameraPosition(
                  bearing: 192.8334901395799,
                  target: LatLng(newLocalData.latitude, newLocalData.longitude),
                  tilt: 0,
                  zoom: 19.151926040649414)));
          updateMarkerAndCircle(newLocalData);
        }
      });
    } on PlatformException catch (e) {
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

  @override
  Widget build(BuildContext context) {
    final mapsController = Get.put(MapsController());
    return Scaffold(
      appBar: AppBar(
        title: Text('Find Your Location'),
      ),
      body: GoogleMap(
        initialCameraPosition: initialLocation,
        mapType: MapType.hybrid,
        markers: Set.of((marker != null) ? [marker] : []),
        circles: Set.of((circle != null) ? [circle] : []),
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.location_searching),
        onPressed: () async {
          await getCurrentLocation();
          mapsController.getAddress(selectedLat, selectedLng);
          print(selectedLat.toString() + " LAT");
          print(selectedLng.toString() + " LAT");
        },
      ),
    );
  }
}
