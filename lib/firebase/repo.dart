import 'package:caco_cooking/common/lifecyle.dart';
import 'package:caco_cooking/models/orders_model.dart';
import 'package:caco_cooking/models/food_model.dart';
import 'package:caco_cooking/models/user_model.dart';
import 'package:get/get.dart';

import 'auth.dart';
import 'foods.dart';
import 'orders.dart';

Future<void> intiRepo() async {
  Get.lazyPut(() => Repo());

  Get.lazyPut(() => RepoControllers(repo: Get.find()));
}

class Repo extends GetxService {

  Repo();

  doFetchAllOrders(int eq, reciverId, Function(List<OrdersModel> list) done, Function(Object?) failed) => fetchAllOrders(eq, reciverId, done, failed);

  doFetchAllUser(Function(List<UserBase> list) done, Function(Object?) failed) => fetchAllUser(done, failed);

  doFetchFoodList(Function(List<FoodModel> list) done, Function(Object?) failed) => fetchAllFoods(done, failed);

  doFetchFoodListNormal(Function(List<FoodModel> list) done, Function(Object?) failed) => fetchAllFoodsNormal(done, failed);

  doFetchFoodListRecommended(Function(List<FoodModel> list) done, Function(Object?) failed) => fetchAllRecommendedFoods(done, failed);

}

class RepoControllers extends GetxController {
  final Repo repo;

  RepoControllers({required this.repo});


  DSack<List<OrdersModel>, bool> _ordersList = DSack(one: [], two: false); //isOlder

  List<UserBase> _usersList = [];

  List<FoodModel> _foodsList = [];

  List<FoodModel> _foodsListRecommended = [];

  DSack<List<OrdersModel>, bool> get ordersList => _ordersList;

  List<UserBase> get usersList => _usersList;

  List<FoodModel> get foodsList => _foodsList;

  List<FoodModel> get foodsListRecommended => _foodsListRecommended;

  set ordersList(DSack<List<OrdersModel>, bool> newValue) {
    _ordersList = newValue;
    update();
  }

  set usersList(List<UserBase> newValue) {
    _usersList = newValue;
    update();
  }

  set foodsList(List<FoodModel> newValue) {
    _foodsList = newValue;
    update();
  }

  set foodsListRecommended(List<FoodModel> newValue) {
    _foodsListRecommended = newValue;
    update();
  }

  fetchAllUser() => repo.doFetchAllUser((list) => usersList = list, (failed) => {logProv(failed)});

  fetchAllOrdersNotYet(String reciverId, Function() f) {
    repo.doFetchAllOrders(1, reciverId, (list) {
      f();
      ordersList = DSack<List<OrdersModel>, bool>(one: list, two: false);
    }, (failed) {
      f();
      logProv(failed);
    });
  }

  fetchAllOrdersDone(String recId, Function() f) {
    repo.doFetchAllOrders(2, recId, (list) {
      f();
      ordersList = DSack<List<OrdersModel>, bool>(one: list, two: true);
    }, (failed) {
      f();
      logProv(failed);
    });
  }

  fetchAllFoods() => repo.doFetchFoodList((list) => foodsList = list, (failed) => {logProv(failed)});

  fetchAllFoodsNormal() => repo.doFetchFoodListNormal((list) => foodsList = list, (failed) => {logProv(failed)});

  fetchAllFoodsRecommended() => repo.doFetchFoodListRecommended((list) => foodsListRecommended = list, (failed) => {logProv(failed)});

}
