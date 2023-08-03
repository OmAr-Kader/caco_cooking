import 'package:caco_cooking/common/lifecyle.dart';

class FoodModel {

  String? _id;

  String get id => _id ?? "";

  set id(String newTitle) {
    _id = newTitle;
  }

  String? _nameFood;

  String get nameFood => _nameFood ?? "";

  set nameFood(String newTitle) {
    _nameFood = newTitle;
  }

  String? _description;

  String get description => _description ?? "";

  set description(String newDescription) {
    _description = newDescription;
  }

  double? _price;

  double get price => _price ?? 0.0;

  set price(double newprice) {
    _price = newprice;
  }

  int? _stars;

  int get stars => _stars ?? 0;

  set stars(int newStars) {
    _stars = newStars;
  }

  List<String>? _pics;

  List<String> get pics => _pics ?? [];

  String get picOne => pics.isEmpty ? '' : pics.first;

  set pics(List<String> newImg) {
    _pics = newImg;
  }

  List<DSack<String, int>>? _foodRates;

  List<DSack<String, int>> get foodRates {
    _foodRates ??= [];
    return _foodRates ?? [];
  }

  set foodRates(List<DSack<String, int>> newValue) {
    _foodRates = newValue;
  }

  int? _picColor;

  int get picColor => _picColor ?? 0;

  set picColor(int newCreatedAt) {
    _picColor = newCreatedAt;
  }

  int? _createdAt;

  int get createdAt => _createdAt ?? 0;

  set createdAt(int newCreatedAt) {
    _createdAt = newCreatedAt;
  }

  int? _updateAt;

  int get updateAt => _updateAt ?? 0;

  set updateAt(int newUpdateAt) {
    _updateAt = newUpdateAt;
  }

  int? _typeId; // Recommended ==2 normal == 1

  int get typeId => _typeId ?? 1;

  set typeId(int newUpdateAt) {
    _typeId = newUpdateAt;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['nameFood'] = nameFood;
    map['description'] = description;
    map['price'] = price;
    map['stars'] = stars;
    map['pics'] = mapFromList(pics);
    map['food_rates'] = mapFromRates(foodRates);
    map['image_color'] = picColor;
    map['created_at'] = createdAt;
    map['update_at'] = updateAt;
    map['type_id'] = typeId;
    return map;
  }

  Map<String, dynamic> mapFromList(List<String> a) {
    Map<String, dynamic> ord = {};
    for (var index = 0; index < a.length; index++) {
      ord[index.toString()] = a[index];
    }
    return ord;
  }

  Map<String, dynamic> mapFromRates(List<DSack<String, int>> a) {
    Map<String, dynamic> ord = {};
    for (DSack<String, int> rate in a) {
      ord[rate.one] = rate.two;
    }
    return ord;
  }

  FoodModel.fromJson(String iD, Map<String, dynamic> map) {
    id = iD;
    nameFood = map['nameFood'];
    description = map['description'];
    price = map['price'].toDouble();
    stars = int.parse(map['stars'].toString());
    pics = listToMap(map['pics']);
    foodRates = listToMapRates(map['food_rates']);
    picColor = int.parse(map['image_color'].toString());
    createdAt = int.parse(map['created_at'].toString());
    updateAt = int.parse(map['update_at'].toString());
    typeId = int.parse(map['type_id'].toString());
  }

  List<String> listToMap(Map<String, dynamic> a) {
    List<String> ord = [];
    for (String el in a.values) {
      ord.add(el);
    }
    return ord;
  }

  List<DSack<String, int>> listToMapRates(Map<String, dynamic> a) {
    List<DSack<String, int>> ord = [];
    for (var el in a.entries) {
      ord.add(DSack<String, int>(one: el.key.toString(), two: int.parse(el.value.toString())));
    }
    return ord;
  }

  FoodModel.toAdd({
    required String nam,
    required String newDes,
    required double pri,
    required int star,
    required List<String> picS,
    required int dat,
    required int type,
    required int color,
  }) {
    nameFood = nam;
    description = newDes;
    price = pri;
    stars = star;
    pics = picS;
    createdAt = dat;
    updateAt = dat;
    typeId = type;
    picColor = color;
  }

}
