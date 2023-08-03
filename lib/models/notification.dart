import 'package:caco_cooking/common/const.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class PushNotification {
  NotificationData? _data;
  String? _to;
  String? _token;

  PushNotification();

  NotificationData get data => _data ?? NotificationData();

  String get to => _to ?? "";

  String get token => _token ?? "";

  set data(NotificationData newValue) {
    _data = newValue;
  }

  set to(String newValue) {
    _to = newValue;
  }

  set token(String newValue) {
    _token = newValue;
  }

  PushNotification.builderForOne({required String sendTo, required String tit, required String body, required String? tok}) {
    data = NotificationData.builder(tit: tit, bod: body, tok: tok);
    to = "/$sendTo";
    token = sendTo;
  }

  PushNotification.builderForTopic({required String sendTo, required String tit, required String body, required String? tok}) {
    data = NotificationData.builder(tit: tit, bod: body, tok: tok);
    to = TOPIC_EST;
    token = sendTo;
  }

  factory PushNotification.fromJson(Map<String, dynamic> json) => PushNotification.fromJson_(json);

  Map<String, dynamic> toJson() => toJson_();

  // Convert a Note object into a Map object
  Map<String, dynamic> toJson_() {
    var map = <String, dynamic>{};
    map['data'] = data;
    map['to'] = to;
    map['token'] = token;
    return map;
  }

  PushNotification.fromJson_(Map<String, dynamic> map) {
    data = map['data'];
    to = map['to'];
    token = map['token'];
  }
}

@JsonSerializable()
class NotificationData {
  String? _title;
  String? _body;
  String? _token;

  NotificationData();

  String get title => _title ?? "";

  String get body => _body ?? "";

  String get token => _token ?? "";

  set title(String newValue) {
    _title = newValue;
  }

  set body(String newValue) {
    _body = newValue;
  }

  set token(String newValue) {
    _token = newValue;
  }

  factory NotificationData.fromJson(Map<String, dynamic> json) => NotificationData.fromJson_(json);

  Map<String, dynamic> toJson() => toJson_();

  // Convert a Note object into a Map object
  Map<String, dynamic> toJson_() {
    var map = <String, dynamic>{};
    map['title'] = title;
    map['body'] = body;
    map['token'] = _token;
    return map;
  }

  NotificationData.fromJson_(Map<String, dynamic> map) {
    title = map['title'];
    body = map['body'];
    _token = map['token'];
  }

  NotificationData.builder({required tit, required bod, required String? tok}) {
    title = tit;
    body = bod;
    _token = tok;
  }
}


@JsonSerializable()
class PusRealLive {
  String? _message;
  int? _createdAt;

  PusRealLive();

  String get message => _message ?? "";

  int get createdAt => _createdAt ?? -1;

  set message(String newValue) {
    _message = newValue;
  }

  set createdAt(int newValue) {
    _createdAt = newValue;
  }

  factory PusRealLive.fromJson(Map<String, dynamic> json) => PusRealLive.fromJson_(json);

  Map<String, dynamic> toJson() => toJson_();

  // Convert a Note object into a Map object
  Map<String, dynamic> toJson_() {
    var map = <String, dynamic>{};
    map['message'] = message;
    map['createdAt'] = createdAt;
    return map;
  }

  PusRealLive.fromJson_(Map<String, dynamic> map) {
    message = map['message'];
    createdAt = int.parse(map['createdAt'].toString());
  }

  PusRealLive.fromJsonTwo(Map map) {
    message = map['message'];
    createdAt = map['createdAt'];
  }

  PusRealLive.builder(String mess, int create) {
    message = mess;
    createdAt = create;
  }
}
