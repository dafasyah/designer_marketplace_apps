class MyUser {
  final String uid;

  MyUser({this.uid});
}

class UserData {
  final String uid;
  final String name;
  final String role;

  UserData({this.uid, this.name, this.role});
}

class Users {
  String name;
  String address;
  String profile;
  String phone;
  final double lat;
  final double lng;
  List<Map<String, dynamic>> data;
  Users({this.name, this.address, this.profile, this.lat, this.lng, this.data});
}

class Portofolio {
  String id;
  String image;
  int time;
  Portofolio({this.image, this.time, this.id});
}
