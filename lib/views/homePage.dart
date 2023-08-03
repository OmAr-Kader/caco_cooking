// ignore_for_file: depend_on_referenced_packages, file_names
/*
import 'package:caco_cooking/common/const.dart';
import 'package:caco_cooking/common/lifecyle.dart';
import 'package:caco_cooking/firebase/cloud_messaging.dart';
import 'package:caco_cooking/firebase/fire_real_time.dart';
import 'package:caco_cooking/models/notification.dart';
import 'package:caco_cooking/models/user_model.dart';
import 'package:caco_cooking/views/log_register.dart';
import 'package:caco_cooking/widgets/global_state.dart';
import 'package:caco_cooking/widgets/app_icon.dart';
import 'package:caco_cooking/widgets/texter.dart';
import 'package:caco_cooking/widgets/cached_image.dart';
import 'package:caco_cooking/widgets/web_key_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

/*
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => HomePageState();
}
*/
class HomePageState extends WebKeyWidget<MyHomePage, PageNotifier> {
  double scaleFactor = 0.8;

  @override
  void postFrameCallback() {
    //Future.delayed(const Duration(milliseconds: 1000), () => loadImage());
  }

  signOut() async {
    await removeStringPrefMuili();
    navigatToLogIn();
  }

  navigatToLogIn() {
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const LogInPage()), (Route<dynamic> route) => false);
  }

  @override
  PageNotifier emptyStateNot() => PageNotifier();

  @override
  Widget buildWidScroll(BuildContext context) {
    //Future.delayed(const Duration(milliseconds: 1000), () => loadImage());
    return GetBuilder<AllUsersControllers>(builder: (popularProducts) {
      return Stack(
        children: [
          Padding(
              padding: EdgeInsets.only(top: dim10 + statusBarHeight, left: dim10, right: dim10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: signOut,
                    child: AppIcon(icon: Icons.arrow_back_ios, size: dim40),
                  ),
                ],
              )),
          Padding(padding: EdgeInsets.only(top: dim10 + dim40 + statusBarHeight), child: downList(popularProducts.usersList)),
        ],
      );
    });
  }

  Widget downList(List<UserBase> usersList) {
    return SizedBox(
        height: usersList.length * (listViewImage + dim20) + dim45,
        child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            addAutomaticKeepAlives: false,
            addRepaintBoundaries: false,
            itemCount: usersList.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  navigateToRecommended(usersList[index]);
                },
                child: Container(
                    height: listViewImage,
                    margin: EdgeInsets.only(top: dim10, bottom: dim10, left: dim20, right: dim20),
                    child: Row(
                      children: [
                        usersList[index].imageNull != null
                            ? SizedBox(
                            width: listViewImage,
                            height: listViewImage,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(dim20),
                              child: CustomCachedNetworkImage(
                                height_: listViewImage,
                                imageUrl: usersList[index].image,
                                circleDim: dim30,
                              ),
                            ))
                            : Container(),
                        Expanded(
                            child: Container(
                              margin: EdgeInsets.only(left: dim10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  BigText(text: usersList[index].name, size: dim15),
                                  SizedBox(height: dim10),
                                  Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: SmallText(text: usersList[index].email.toString(), color: Colors.black26)),
                                  SizedBox(height: dim15),
                                ],
                              ),
                            ))
                      ],
                    )),
              );
            }));
  }

  void navigateToRecommended(UserBase user) async {
    await sendPushMessage(
        pushNotification: PushNotification.builderForOne(
            sendTo: user.messageToken, tit: "hi", body: "say hi back", tok: await findStringPref(TOKEN, null)
        )
    );
  }

  Matrix4 transEffect(int index) {
    Matrix4 matrix4 = Matrix4.identity();
    if (index == stateNot.currentPage.floor()) {
      var currentScale = 1 - (stateNot.currentPage - index) * (1 - scaleFactor);
      var currentTrans = pageViewContainer * (1 - currentScale) / 2;
      matrix4 = Matrix4.diagonal3Values(1, currentScale, 1)
        ..setTranslationRaw(0, currentTrans, 0);
    } else if (index == stateNot.currentPage.floor() + 1) {
      var currentScale = scaleFactor + (stateNot.currentPage - index + 1) * (1 - scaleFactor);
      var currentTrans = pageViewContainer * (1 - currentScale) / 2;
      matrix4 = Matrix4.diagonal3Values(1, currentScale, 1)
        ..setTranslationRaw(0, currentTrans, 0);
    } else if (index == stateNot.currentPage.floor() - 1) {
      var currentScale = 1 - (stateNot.currentPage - index) * (1 - scaleFactor);

      var currentTrans = pageViewContainer * (1 - currentScale) / 2;
      matrix4 = Matrix4.diagonal3Values(1, currentScale, 1)
        ..setTranslationRaw(0, currentTrans, 0);
    } else {
      var currentScale = 0.8;
      var currentTrans = pageViewContainer * (1 - currentScale) / 2;

      matrix4 = Matrix4.diagonal3Values(1, currentScale, 1)
        ..setTranslationRaw(0, currentTrans, 0);
    }
    return matrix4;
  }
}

class PageNotifier extends ChangeNotifier {
  double _currentPage = 0.0;

  double get currentPage => _currentPage;

  set currentPage(double newValue) {
    _currentPage = newValue;
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => MyHomePageState();
}

class MyHomePageState extends GlobalState<MyHomePage, HomeNotifier> {

  late bool anchorToBottom = false;
  late HomeRealTime homeRealTime;

  @override
  void initState() {
    homeRealTime = HomeRealTime(initialized: initialized, error: error);
    homeRealTime.init();
    super.initState();
  }

  initialized(bool newValue) {
    stateNot.initialized = newValue;
  }

  error(FirebaseException? newValue) {
    stateNot.error = newValue;
  }

  @override
  void dispose() {
    super.dispose();
    homeRealTime.dispose();
  }

  void _setAnchorToBottom(bool? value) {
    if (value == null) {
      return;
    }

    setState(() {
      anchorToBottom = value;
    });
  }

  @override
  Widget buildWid(BuildContext context) {
    if (!stateNot.initialized) return Container();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Database Example'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 30),
          Center(
            child: stateNot.error == null
                ? const Text(
              'Button tapped time\n\n'
                  'This includes all devices, ever.',
            )
                : Text(
              'Error retrieving button tap count:\n${stateNot.error!.message}',
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () => homeRealTime.addItem(),
            child: const Text('Increment as transaction'),
          ),
          const SizedBox(height: 30),
          ListTile(
            leading: Checkbox(
              onChanged: _setAnchorToBottom,
              value: anchorToBottom,
            ),
            title: const Text('Anchor to bottom'),
          ),
          Flexible(
            child: FirebaseAnimatedList(
              //key: ValueKey<bool>(anchorToBottom),
              query: homeRealTime.messagesRef,
              reverse: anchorToBottom,
              sort: (a, b) {
                PusRealLive one = PusRealLive.fromJsonTwo(a.value as Map);
                PusRealLive two = PusRealLive.fromJsonTwo(b.value as Map);
                if (one.createdAt <= two.createdAt) {
                  return 1;
                } else {
                  return -1;
                }
              },
              duration: const Duration(microseconds: 150),
              itemBuilder: (context, snapshot, animation, index) {
                PusRealLive cr = PusRealLive.fromJsonTwo(snapshot.value as Map);
                return SizeTransition(
                  sizeFactor: animation,
                  child: ListTile(
                    trailing: IconButton(
                      onPressed: () => homeRealTime.deleteItem(snapshot),
                      icon: const Icon(Icons.delete),
                    ),
                    title: Text(cr.message),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  HomeNotifier emptyStateNot() => HomeNotifier();
}


class HomeNotifier extends ChangeNotifier {
  bool? _initialized;

  FirebaseException? _error;


  bool get initialized => _initialized ?? false;

  FirebaseException? get error => _error;

  set initialized(bool newValue) {
    _initialized = newValue;
    notifyListeners();
  }

  set error(FirebaseException? newValue) {
    _error = newValue;
    notifyListeners();
  }

}

/*
class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  late DatabaseReference _counterRef;
  late DatabaseReference _messagesRef;
  late StreamSubscription<DatabaseEvent> _counterSubscription;
  late StreamSubscription<DatabaseEvent> _messagesSubscription;
  bool _anchorToBottom = false;

  FirebaseException? _error;
  bool initialized = false;

  @override
  void initState() {
    init();
    super.initState();
  }

  Future<void> init() async {
    _counterRef = FirebaseDatabase.instance.ref('counter');

    final database = FirebaseDatabase.instance;

    _messagesRef = database.ref('messages');

    database.setLoggingEnabled(false);

    if (!kIsWeb) {
      database.setPersistenceEnabled(true);
      database.setPersistenceCacheSizeBytes(10000000);
    }

    if (!kIsWeb) {
      await _counterRef.keepSynced(true);
    }

    setState(() {
      initialized = true;
    });

    try {
      final counterSnapshot = await _counterRef.get();

      print(
        'Connected to directly configured database and read '
            '${counterSnapshot.value}',
      );
    } catch (err) {
      print(err);
    }

    _counterSubscription = _counterRef.onValue.listen(
          (DatabaseEvent event) {
        setState(() {
          _error = null;
          _counter = (event.snapshot.value ?? 0) as int;
        });
      },
      onError: (Object o) {
        final error = o as FirebaseException;
        setState(() {
          _error = error;
        });
      },
    );

    final messagesQuery = _messagesRef.limitToLast(10);

    _messagesSubscription = messagesQuery.onChildAdded.listen(
          (DatabaseEvent event) {
        print('Child added: ${event.snapshot.value}');
      },
      onError: (Object o) {
        final error = o as FirebaseException;
        print('Error: ${error.code} ${error.message}');
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _messagesSubscription.cancel();
    _counterSubscription.cancel();
  }

  Future<void> _incrementAsTransaction() async {
    try {
      final transactionResult = await _counterRef.runTransaction((mutableData) {
        return Transaction.success((mutableData as int? ?? 0) + 1);
      });

      if (transactionResult.committed) {
        await _messagesRef.push().set(
            PusRealLive.builder('world ${transactionResult.snapshot.value}', currentMilliseconds).toJson()
        );
      }
    } on FirebaseException catch (e) {
      print(e.message);
    }
  }

  Future<void> deleteItem(DataSnapshot snapshot) async {
    await _messagesRef.child(snapshot.key!).remove();
  }

  void _setAnchorToBottom(bool? value) {
    if (value == null) {
      return;
    }

    setState(() {
      _anchorToBottom = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!initialized) return Container();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Database Example'),
      ),
      body: Column(
        children: [
          Flexible(
            child: Center(
              child: _error == null
                  ? Text(
                'Button tapped $_counter time${_counter == 1 ? '' : 's'}.\n\n'
                    'This includes all devices, ever.',
              )
                  : Text(
                'Error retrieving button tap count:\n${_error!.message}',
              ),
            ),
          ),
          ElevatedButton(
            onPressed: _incrementAsTransaction,
            child: const Text('Increment as transaction'),
          ),
          ListTile(
            leading: Checkbox(
              onChanged: _setAnchorToBottom,
              value: _anchorToBottom,
            ),
            title: const Text('Anchor to bottom'),
          ),
          Flexible(
            child: FirebaseAnimatedList(
              key: ValueKey<bool>(_anchorToBottom),
              query: _messagesRef,
              reverse: _anchorToBottom,
              sort: (a, b) {
                PusRealLive one = PusRealLive.fromJsonTwo(a.value as Map);
                PusRealLive two = PusRealLive.fromJsonTwo(b.value as Map);
                if (one.createdAt <= two.createdAt) {
                  return 1;
                } else {
                  return -1;
                }
              },
              itemBuilder: (context, snapshot, animation, index) {
                PusRealLive cr = PusRealLive.fromJsonTwo(snapshot.value as Map);
                return SizeTransition(
                  sizeFactor: animation,
                  child: ListTile(
                    trailing: IconButton(
                      onPressed: () => deleteItem(snapshot),
                      icon: const Icon(Icons.delete),
                    ),
                    title: Text(cr.message),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementAsTransaction,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

}*/
*/ /**/