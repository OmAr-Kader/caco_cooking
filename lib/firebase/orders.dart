import 'package:caco_cooking/common/const.dart';
import 'package:caco_cooking/common/lifecyle.dart';
import 'package:caco_cooking/models/notification.dart';
import 'package:caco_cooking/models/orders_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'cloud_messaging.dart';

fetchAllOrders(int eq, String reciverId, Function(List<OrdersModel> list) done, Function(Object?) failed) {
  FirebaseFirestore.instance
      .collection(COLLECTION_ORDERS)
      .where('order_type', isEqualTo: eq)
      .where('reciver_id', isEqualTo: reciverId)
      .get()
      .then((value) => ensureFetchAllFoods(value, done, failed))
      .catchError((error) => failed(error));
}

fetchAllOrdersForOneUser(String senderID, Function(List<OrdersModel> list) done, Function(Object?) failed) {
  FirebaseFirestore.instance
      .collection(COLLECTION_ORDERS)
      .where('sender_id', isEqualTo: senderID)
      .get()
      .then((value) => ensureFetchAllFoods(value, done, failed))
      .catchError((error) => failed(error));
}

ensureFetchAllFoods(QuerySnapshot<Map<String, dynamic>> value, Function(List<OrdersModel> list) done, Function(Object?) failed) async {
  if (value.docs.isNotEmpty) {
    done(list(value).resort((a, b) => b.createdAt.compareTo(a.createdAt)));
  } else {
    done([]);
  }
}

List<OrdersModel> list(QuerySnapshot<Map<String, dynamic>> a) => a.docs.map((e) => OrdersModel.fromJson(e.id, e.data())).toList();

sendOrder(OrdersModel ordersModel, String messageToken, Function() done, Function(Object?) failed) {
  FirebaseFirestore.instance
      .collection(COLLECTION_ORDERS)
      .add(ordersModel.toJson())
      .then((value) => sendNotForClient(messageToken, done))
      .catchError((error) => failed(error));
}

sendNotForClient(String messageToken, Function() done) {
  try {
    sendPushMessage(pushNotification: PushNotification.builderForOne(
        sendTo: messageToken, tit: 'New Order', body: "", tok: null)
    ).then((value) => sendRealTimeOrser(messageToken, done))
        .catchError((onError) => sendRealTimeOrser(messageToken, done));
  } catch (e) {
    logProv(e);
    sendRealTimeOrser(messageToken, done);
  }
}

sendRealTimeOrser(String messageToken, Function() done) {
  FirebaseDatabase.instance.ref(COLLECTION_REAL_TIME_ORDERS)
      .set(ServerValue.increment(1))
      .then((value) => done())
      .catchError((onError) => done());
}

updateOrder(OrdersModel ordersModel, Function() done, Function(Object?) failed) {
  FirebaseFirestore.instance
      .collection(COLLECTION_ORDERS)
      .doc(ordersModel.id)
      .update(ordersModel.toJson())
      .then((value) => done())
      .catchError((error) => failed(error));
}

updateOrderByReciver(OrdersModel ordersModel, Function() done, Function(Object?) failed) {
  FirebaseFirestore.instance
      .collection(COLLECTION_ORDERS)
      .doc(ordersModel.id)
      .update(ordersModel.toJson())
      .then((value) => done())
      .catchError((error) => failed(error));
}

Future<void> sendDoneNotification(String messageToken) async {
  try {
    sendPushMessage(pushNotification: PushNotification.builderForOne(
        sendTo: messageToken, tit: 'Your order is on Way', body: "", tok: null)
    );
  } catch (e) {
    logProv(e);
  }
}