import 'package:caco_cooking/common/const.dart';
import 'package:caco_cooking/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb;
import 'package:map_launcher/map_launcher.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:synchronized/synchronized.dart';

Future<String?> findStringPref(String key, String? def) async {
  if (kIsWeb) {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  } else {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }
}

updateStringPref(String key, String value) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(key, value);
}

removeStringPref(String key) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove(key);
}

logProv(Object? e, {Object tag = ""}) {
  if (kDebugMode) {
    print("$tag===>>> $e");
  }
}

updateStringPrefMuili(String docId, String uid, String email, String password, String messageToken) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(DOC_ID, docId);
  await prefs.setString(USER_ID, uid);
  await prefs.setString(USER_MAIL, email);
  await prefs.setString(PASSWORD, password);
  await prefs.setString(TOKEN, messageToken);
}

removeStringPrefMuili() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove(DOC_ID);
  await prefs.remove(USER_ID);
  await prefs.remove(USER_MAIL);
  await prefs.remove(PASSWORD);
  await prefs.remove(TOKEN);
}

toastFLutter(String ar) {
  Fluttertoast.showToast(
      msg: ar,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0
  );
}

int get currentMilliseconds =>
    DateTime
        .now()
        .millisecondsSinceEpoch;

String timeInFormate(int timeinMilliseconds) => DateFormat("yyyy-MM-dd hh:mm").format(DateTime.fromMillisecondsSinceEpoch(timeinMilliseconds));

launchLocationInMap(GeoPoint geoPoint) async {
  final availableMaps = await MapLauncher.installedMaps;
  await availableMaps.first.showMarker(
    coords: Coords(geoPoint.latitude, geoPoint.longitude),
    title: "Order",
  );
}

Future<GeoPoint> fetchUserLocation() async {
  try {
    return await _determinePosition();
  } catch (e) {
    return Future.error('Location Failed');
  }
}

Future<GeoPoint> _determinePosition() async {
  LocationPermission permission;
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }
  if (permission == LocationPermission.deniedForever) {
    return Future.error('Location permissions are permanently denied, we cannot request permissions.');
  }
  Position position = await Geolocator.getCurrentPosition(forceAndroidLocationManager: true, timeLimit: const Duration(seconds: 5));
  return GeoPoint(position.latitude, position.longitude);
}

List<UserBase> filterUsers(List<UserBase> list, String currentDocid) {
  List<UserBase> newList = [];
  for (UserBase user in list) {
    if (user.idDoc != currentDocid) {
      newList.add(user);
    }
  }
  return newList;
}

double calculateRate(List<DSack<String, int>> r) {
  double a = 5;
  for (var i in r) {
    a = a + i.two;
  }
  return a / (r.length + 1);
}

class DSack<T, R> {
  final T one;
  final R two;

  DSack({required this.one, required this.two});

}

extension FirstWhereExt<T> on List<T> {

  T? get firstOrNull => isEmpty ? null : first;

  List<T> filter(bool Function(T) fil) {
    List<T> newList = [];
    for (T element in this) {
      if (fil(element)) {
        newList.add(element);
      }
    }
    return newList;
  }

  List<T> forEachIndex(Function(T it, int index) fil) {
    for (var index = 0; index < length; index++) {
      fil(this[index], index);
    }
    return this;
  }

  List<T> forEach(Function(T it) fil) {
    for (var index = 0; index < length; index++) {
      fil(this[index]);
    }
    return this;
  }

  T? find(bool Function(T it) fil) {
    for (T it in this) {
      if (fil(it)) {
        return it;
      }
    }
    return null;
  }

  replaceItem({required T oldOne, required T newOne}) async {
    await Lock().synchronized(() async {
      remove(oldOne);
      add(newOne);
    });
  }

  List<T> resort(int Function(T a, T b) set) {
    sort((a, b) => set(a, b));
    return this;
  }

}

extension StringWhereExt<T> on String {

  String get firstUpper {
    if (length > 1) {
      return substring(0, 1).toUpperCase() + substring(1, length);
    } else {
      return this;
    }
  }
}