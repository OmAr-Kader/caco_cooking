import 'package:caco_cooking/common/lifecyle.dart';

import 'food_model.dart';
import 'user_model.dart';

class OrdersModel {
  OrdersModel();

  String? _id;

  String get id => _id ?? "";

  set id(String newTitle) => _id = newTitle;

  String? _reciverId;

  String get reciverId => _reciverId ?? "";

  set reciverId(String newTitle) => _reciverId = newTitle;

  String? _senderId;

  String get senderId => _senderId ?? "";

  set senderId(String newValue) {
    _senderId = newValue;
  }

  String? _senderName;

  String get senderName => _senderName ?? "";

  set senderName(String newValue) {
    _senderName = newValue;
  }

  String? _senderLocation;

  String get senderLocation => _senderLocation ?? "";

  set senderLocation(String newValue) {
    _senderLocation = newValue;
  }

  List<Order>? _orders;

  List<Order> get orders => _orders ?? [];

  set orders(List<Order> newValue) {
    _orders = newValue;
  }

  double? _totalPrice;

  double get totalPrice => _totalPrice ?? 0;

  set totalPrice(double newprice) {
    _totalPrice = newprice;
  }

  double? _totalPaid;

  double get totalPaid => _totalPaid ?? 0;

  set totalPaid(double newprice) {
    _totalPaid = newprice;
  }

  int? _createdAt;

  int get createdAt => _createdAt ?? 0;

  set createdAt(int newCreatedAt) {
    _createdAt = newCreatedAt;
  }

  String get createdAtString => timeInFormate(createdAt);

  int? _updateAt;

  int get updateAt => _updateAt ?? 0;

  set updateAt(int newUpdateAt) {
    _updateAt = newUpdateAt;
  }

  int? _orderType; // Done ==2 Not yet == 1

  int get orderType => _orderType ?? 1;

  set orderType(int? newTypeId) {
    _orderType = newTypeId;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['sender_id'] = senderId;
    map['sender_name'] = senderName;
    map['sender_location'] = senderLocation;
    map['reciver_id'] = reciverId;
    map['orders'] = mapFromList(orders);
    map['total_price'] = totalPrice;
    map['total_paid'] = totalPaid;
    map['created_at'] = createdAt;
    map['update_at'] = updateAt;
    map['order_type'] = orderType;
    return map;
  }

  Map<String, Map<String, dynamic>> mapFromList(List<Order> a) {
    Map<String, Map<String, dynamic>> ord = {};
    a.forEachIndex((element, index) => ord[index.toString()] = element.toJson());
    return ord;
  }

  OrdersModel.fromJson(String iD, Map<String, dynamic> map) {
    id = iD;
    orders = listToMap(map['orders']);
    reciverId = map['reciver_id'];
    totalPrice = map['total_price'].toDouble();
    totalPaid = map['total_paid'].toDouble();
    createdAt = int.parse(map['created_at'].toString());
    updateAt = int.parse(map['update_at'].toString());
    orderType = int.parse(map['order_type'].toString());
    senderId = map['sender_id'];
    senderName = map['sender_name'];
    senderLocation = map['sender_location'];
  }

  List<Order> listToMap(Map<String, dynamic> a) => a.values.map((el) => Order.fromJson(el)).toList();

  Order? isContainsThatFood(String foodName) => orders.find((it) => it.nameFood.contains(foodName));

  OrdersModel.buildBase(String idDoc) {
    reciverId = idDoc;
    orders = [];
    orderType = 1;
  }

  OrdersModel.toSend(OrdersModel ordersModel, UserBase currentOne, String resiverId, int currentMilliseconds) {
    orders = ordersModel.orders;
    reciverId = resiverId;
    totalPrice = ordersModel.totalPrice;
    totalPaid = ordersModel.totalPaid;
    createdAt = currentMilliseconds;
    updateAt = currentMilliseconds;
    orderType = ordersModel.orderType;
    senderId = currentOne.idDoc;
    senderName = currentOne.name;
    senderLocation = currentOne.location;
  }

}

class Order {

  Order();

  String? _nameFood;

  String get nameFood => _nameFood ?? "";

  set nameFood(String newTitle) {
    _nameFood = newTitle;
  }

  double? _price;

  double get price => _price ?? 0;

  set price(double newprice) {
    _price = newprice;
  }

  int? _count;

  int get count => _count ?? 0;

  set count(int newprice) {
    _count = newprice;
  }

  String? _foodImg;

  String get foodImg => _foodImg ?? "";

  set foodImg(String newTitle) {
    _foodImg = newTitle;
  }

  String? _foodId;

  String get foodId => _foodId ?? "";

  String? get foodNull => _foodId;

  set foodId(String newTitle) {
    _foodId = newTitle;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['name_food'] = nameFood;
    map['price'] = price;
    map['count'] = count;
    map['food_img'] = foodImg;
    map['food_id'] = foodId;
    return map;
  }

  Order.fromJson(Map<String, dynamic> map) {
    nameFood = map['name_food'];
    price = map['price'].toDouble();
    count = int.parse(map['count'].toString());
    foodImg = map['food_img'];
    foodId = map['food_id'];
  }

  Order.builder(FoodModel food) {
    nameFood = food.nameFood;
    price = food.price;
    count = 1;
    foodImg = food.picOne;
    foodId = food.id;
  }

}
