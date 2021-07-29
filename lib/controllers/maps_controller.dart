import 'package:flutter/cupertino.dart';
import 'package:geocoder/geocoder.dart';
import 'package:get/get.dart';

class MapsController extends GetxController {
  var currentLocation = ''.obs;
  var latitude = 0.0.obs;
  var longitude = 0.0.obs;
  var addressController = TextEditingController();
  getAddress(double lat, double lng) async {
    try {
      final coordinates = Coordinates(lat, lng); //-7.1937564, 108.2025172);
      latitude = lat.obs;
      longitude = lng.obs;
      var address =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);
      currentLocation = address.first.addressLine.obs;
      addressController =
          TextEditingController(text: currentLocation.toString());
      print(currentLocation + "LAT E");
    } catch (e) {
      print(e);
    } finally {
      print(currentLocation + "LAT E");
    }
  }
}
