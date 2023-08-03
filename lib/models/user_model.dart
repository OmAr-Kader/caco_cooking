import 'package:cloud_firestore/cloud_firestore.dart';

class UserBase {
  String? _id;
  String? _idDoc;

  String? _name;
  String? _email;
  String? _mobile;
  String? _messageToken;
  String? _image;
  int? _userType; // Client ==2 shop == 1

  String? _location;
  GeoPoint? _geoLocation;

  UserBase();

  String get id => _id ?? "";

  String get idDoc => _idDoc ?? "";

  String get name => _name ?? "";

  String get email => _email ?? "";

  String get mobile => _mobile ?? "";

  String get messageToken => _messageToken ?? "";

  String get image => _image ?? "";

  String? get imageNull => _image;

  int get userType => _userType ?? 1;

  String get location => _location ?? "";

  GeoPoint get geoLocation => _geoLocation ?? const GeoPoint(0.0, 0.0);

  GeoPoint? get geoLocationNull => _geoLocation == const GeoPoint(0.0, 0.0) ? null : _geoLocation;

  set id(String newTitle) {
    _id = newTitle;
  }

  set idDoc(String newTitle) {
    _idDoc = newTitle;
  }

  set name(String newTitle) {
    _name = newTitle;
  }

  set email(String newValue) {
    _email = newValue;
  }

  set mobile(String? newValue) {
    _mobile = newValue;
  }

  set messageToken(String? newValue) {
    _messageToken = newValue;
  }

  set image(String? newValue) {
    _image = newValue;
  }

  set userType(int newValue) {
    _userType = newValue;
  }

  set location(String? newLocation) {
    _location = newLocation;
  }

  set geoLocation(GeoPoint? newLocation) {
    _geoLocation = newLocation;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['email'] = email;
    map['mobile'] = mobile;
    map['message_token'] = messageToken;
    map['image'] = image;
    map['userType'] = userType;
    map['location'] = location;
    map['geo_location'] = geoLocation;
    return map;
  }

  UserBase.fromJson(Map<String, dynamic> map, String idDoc) {
    id = map['id'];
    _idDoc = idDoc;
    name = map['name'];
    email = map['email'];
    mobile = map['mobile'];
    messageToken = map['message_token'];
    image = map['image'];
    userType = int.parse(map['userType'].toString());
    location = map['location'];
    _geoLocation = map['geo_location'];
  }

  UserBase.fromJsonWithId(Map<String, dynamic> map, String idDoc) {
    id = map['id'];
    _idDoc = idDoc;
    name = map['name'];
    email = map['email'];
    mobile = map['mobile'];
    messageToken = map['message_token'];
    image = map['image'];
    userType = int.parse(map['userType'].toString());
    location = map['location'];
    _geoLocation = map['geo_location'];
  }

  UserBase.toRegister({
    required String newName,
    required String newEmail,
    required String newMobile,
    required String address,
    required GeoPoint? geoPoint
  }) {
    //_id = newId;
    _name = newName;
    _email = newEmail;
    _mobile = newMobile;
    _location = address;
    _geoLocation = geoPoint;
  }

  UserBase.toUdpate({
    required UserBase user,
    required String newName,
    required String newMobile,
    required String address,
  }) {
    id = user.id;
    name = newName;
    email = user.email;
    mobile = newMobile;
    location = address;
    messageToken = user.messageToken;
    image = user.image;
    userType = user.userType;
    geoLocation = user.geoLocation;
  }

  UserBase.toGmail({
    required String newMobile,
    required String address,
    required GeoPoint? geoPoint
  }) {
    mobile = newMobile;
    location = address;
    geoLocation = geoPoint;
  }

  UserBase.toFullGmail({
    required UserBase user,
    required String newName,
    required String newEmail,
  }) {
    name = newName;
    email = newEmail;
    mobile = user.mobile;
    location = user.location;
    geoLocation = user.geoLocation;
    messageToken = user.messageToken;
    image = user.image;
    userType = user.userType;
  }

  UserBase.toUploadImage(UserBase user, String uri) {
    id = user.id;
    name = user.name;
    email = user.email;
    mobile = user.mobile;
    image = uri;
    messageToken = user.messageToken;
    location = user.location;
    userType = user.userType;
    geoLocation = user.geoLocation;
  }

  UserBase.toRegBack({required String newId, required UserBase user}) {
    id = newId;
    name = user.name;
    email = user.email;
    mobile = user.mobile;
    image = user.image;
    messageToken = user.messageToken;
    location = user.location;
    userType = user.userType;
    geoLocation = user.geoLocation;
  }

  UserBase.toRegBackToken({required String newToken, required UserBase user}) {
    id = user.id;
    name = user.name;
    email = user.email;
    mobile = user.mobile;
    image = user.image;
    messageToken = newToken;
    location = user.location;
    userType = user.userType;
    geoLocation = user.geoLocation;
  }
}
