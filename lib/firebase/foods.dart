import 'package:caco_cooking/common/const.dart';
import 'package:caco_cooking/common/lifecyle.dart';
import 'package:caco_cooking/models/food_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

fetchAllFoods(Function(List<FoodModel> list) done, Function(Object?) failed) {
  FirebaseFirestore.instance
      .collection(COLLECTION_FOODS)
      .get()
      .then((value) => ensureFetchAllFoods(value, done, failed))
      .catchError((error) => failed(error));
}

fetchAllFoodsNormal(Function(List<FoodModel> list) done, Function(Object?) failed) {
  FirebaseFirestore.instance
      .collection(COLLECTION_FOODS)
      .where('type_id', isEqualTo: 1)
      .get()
      .then((value) => ensureFetchAllFoods(value, done, failed))
      .catchError((error) => failed(error));
}

fetchAllRecommendedFoods(Function(List<FoodModel> list) done, Function(Object?) failed) {
  FirebaseFirestore.instance
      .collection(COLLECTION_FOODS)
      .where('type_id', isEqualTo: 2)
      .get()
      .then((value) => ensureFetchAllFoods(value, done, failed))
      .catchError((error) => failed(error));
}

fetchOnFoods(String docId, Function(FoodModel food) done, Function(Object?) failed) {
  FirebaseFirestore.instance
      .collection(COLLECTION_FOODS)
      .doc(docId)
      .get()
      .then((value) => value.data() != null ? done(FoodModel.fromJson(value.id, value.data()!)) : failed(null))
      .catchError((error) => failed(error));
}

saveFoods(FoodModel product, Function() done, Function(Object?) failed) async {
  FirebaseFirestore.instance
      .collection(COLLECTION_FOODS)
      .add(product.toJson())
      .then((value) => done())
      .catchError((error) => failed(error));
}

saveFoodsList(List<FoodModel> productList, Function() done, Function(Object?) failed) async {
  CollectionReference<Map<String, dynamic>> a = FirebaseFirestore.instance
      .collection(COLLECTION_FOODS);
  List<int> asw = await doSaveFloodsList(a, productList);
  if (asw.isEmpty) {
    done();
  } else {
    failed(asw);
  }
}

doSaveFloodsList(CollectionReference<Map<String, dynamic>> a, List<FoodModel> productList) async {
  List<int> asw = [];
  for (FoodModel product in productList) {
    try {
      await a.add(product.toJson());
    } catch (e) {
      asw.add(productList.indexOf(product));
    }
  }
}

updateFoods(FoodModel product, String docID, String password, Function(String, String, String? docId) done, Function(Object?) failed) async {
  FirebaseFirestore.instance
      .collection(COLLECTION_FOODS)
      .doc(docID)
      .update(product.toJson())
      .then((value) => done(product.id, password, docID))
      .catchError((error) => failed(error));
}


updateFoodsStars(FoodModel product) async {
  FirebaseFirestore.instance
      .collection(COLLECTION_FOODS)
      .doc(product.id)
      .update(product.toJson())
      .catchError((error) => logProv(error, tag: "updateFoodsStars"));
}

ensureFetchAllFoods(QuerySnapshot<Map<String, dynamic>> value, Function(List<FoodModel> list) done, Function(Object?) failed) {
  if (value.docs.isNotEmpty) {
    done(list(value));
  } else {
    failed(null);
  }
}

List<FoodModel> list(QuerySnapshot<Map<String, dynamic>> a) => a.docs.map((e) => FoodModel.fromJson(e.id, e.data())).toList();
