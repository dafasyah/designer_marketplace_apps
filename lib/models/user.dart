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
  String email;
  final double lat;
  final double lng;
  String minimumPrice;
  Users(
      {this.name,
      this.address,
      this.profile,
      this.email,
      this.lat,
      this.lng,
      this.minimumPrice});
}

class Portofolio {
  String id;
  String image;
  int time;
  Portofolio({this.image, this.time, this.id});
}

class Location {
  String address;
  String designerId;
  double lat;
  double lng;
  String name;
  Location({this.address, this.designerId, this.lat, this.lng, this.name});
}

class Rating {
  String email;
  String from;
  String rating;
  String text;
  Rating({this.email,this.from, this.rating, this.text});
}
