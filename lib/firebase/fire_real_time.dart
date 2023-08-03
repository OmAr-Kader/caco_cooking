import 'dart:async';
import 'package:caco_cooking/common/const.dart';
import 'package:caco_cooking/common/lifecyle.dart';
import 'package:caco_cooking/models/notification.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:intl/intl.dart';
import 'package:firebase_core/firebase_core.dart';

class HomeRealTime {
  Function(bool newValue) initialized;

  Function(FirebaseException? newValue) error;

  HomeRealTime({required this.initialized, required this.error });

  late DatabaseReference _messagesRef;
  late StreamSubscription<DatabaseEvent> _messagesSubscription;

  DatabaseReference get messagesRef => _messagesRef;


  init() async {
    final database = FirebaseDatabase.instance;

    _messagesRef = database.ref('messages');
    if (!kIsWeb) {
      database.setPersistenceEnabled(true);
      database.setPersistenceCacheSizeBytes(10000000);
    }
    initialized(true);

/*
    _counterSubscription = _counterRef.onValue.listen(
          (DatabaseEvent event) {
        _counter = (event.snapshot.value ?? 0) as int;
        stateNot.error = null;
      },
      onError: (Object o) {
        final error = o as FirebaseException;
        stateNot.error = error;
      },
    );

    final messagesQuery = _messagesRef.limitToLast(10);

    _messagesSubscription = messagesQuery.onChildAdded.listen(
          (DatabaseEvent event) {},
      onError: (Object o) {},
    );*/
  }

  dispose() {
    _messagesSubscription.cancel();
  }

  Future<void> addItem() async {
    await _messagesRef
        .push()
        .set(
        PusRealLive.builder('world ${DateFormat("hh:mm:ss").format(DateTime.now())}', currentMilliseconds).toJson()
    );
  }

  /*Future<void> addItemTrans() async {
    try {
      final transactionResult = await _counterRef.runTransaction((mutableData) {
        return Transaction.success((mutableData as int? ?? 0) + 1);
      });

      if (transactionResult.committed) {
        await _messagesRef
            .push()
            .set(
            PusRealLive.builder('world ${transactionResult.snapshot.value}', currentMilliseconds).toJson()
        );
      }
    } on FirebaseException catch (_) {}
  }*/

  Future<void> deleteItem(DataSnapshot snapshot) async {
    await _messagesRef.child(snapshot.key!).remove();
  }


/*Future<void> _increment() async {
    await _counterRef.set(ServerValue.increment(1));
    await _messagesRef
        .push()
        .set(
        PusRealLive.builder('world $_counter', currentMilliseconds).toJson()
    );
  }*/

}

class RealTimeUpdater {

  late StreamSubscription<DatabaseEvent> _counterSubscription;

  late DatabaseReference counterRef;
  Function() update;

  RealTimeUpdater({required this.update});

  initRealTime() async {
    final database = FirebaseDatabase.instance;
    counterRef = database.ref(COLLECTION_REAL_TIME_ORDERS);
    if (!kIsWeb) {
      database.setPersistenceEnabled(true);
      database.setPersistenceCacheSizeBytes(10000000);
    }
    if (!kIsWeb) {
      await counterRef.keepSynced(true);
    }
    _counterSubscription = counterRef.onValue.listen(
          (DatabaseEvent event) {
        update();
      },
      onError: (Object o) {},
    );
  }

  cancel() {
    _counterSubscription.cancel();
    counterRef.onDisconnect();
  }
}