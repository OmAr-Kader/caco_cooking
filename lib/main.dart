import 'dart:ui';
import 'package:caco_cooking/common/colors.dart';
import 'package:caco_cooking/firebase/auth.dart';
import 'package:caco_cooking/firebase/cloud_messaging.dart';
import 'package:caco_cooking/firebase/repo.dart';
import 'package:caco_cooking/models/user_model.dart';
import 'package:caco_cooking/views/log_register.dart';
import 'package:caco_cooking/widgets/global_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'common/const.dart';
import 'common/lifecyle.dart';
import 'firebase/firebase_options.dart';
import 'views/client/main_client_page.dart';
import 'views/user/main_food_page.dart';
import 'views/user/food_details.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final UserBase? user = await fetchUserDetails(docID: await findStringPref(DOC_ID, null));
  if (user != null) {
    await intiMessage(user.userType);
  }
  await intiRepo();
  runApp(MyApp(user: user));
}

class MyApp extends StatelessWidget {

  final UserBase? user;

  const MyApp({super.key, required this.user});

  StatefulWidget fetchFirstsScreen(UserBase? userBase) {
    if (userBase != null) {
      if (userBase.userType == 1) {
        Get.find<RepoControllers>().fetchAllFoodsNormal();
        Get.find<RepoControllers>().fetchAllFoodsRecommended();
        return const MainFoodPage();
      } else {
        Get.find<RepoControllers>().fetchAllOrdersNotYet(userBase.idDoc, () => {});
        return const MainClientPage();
      }
    } else {
      return const LogInPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<GlobalStateForDim>(create: (_) => GlobalStateForDim()),
        ChangeNotifierProvider<GlobalUserDetials>(create: (_) => GlobalUserDetials(user_: user)),
        ChangeNotifierProvider<FoodDetialsNot>(create: (_) => FoodDetialsNot(ordersModel_: null)),
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        scrollBehavior: AppScrollBehavior(),
        title: 'Coco cooking',
        theme: ThemeData(
            primaryColor: mainColor,
            brightness: fetchLight(),
            textTheme: const TextTheme(
              titleLarge: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Roboto', color: textColor),
              titleMedium: TextStyle(fontWeight: FontWeight.w400, fontFamily: 'Roboto', color: textColor),
              bodySmall: TextStyle(fontWeight: FontWeight.w400, fontFamily: 'Hind', color: smallTextColor),
            )
        ),
        darkTheme: ThemeData(
          brightness: fetchDark(),
          textTheme: const TextTheme(
            titleLarge: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Roboto', color: textColorDark),
            titleMedium: TextStyle(fontWeight: FontWeight.w400, fontFamily: 'Roboto', color: textColorDark),
            bodySmall: TextStyle(fontWeight: FontWeight.w400, fontFamily: 'Hind', color: smallTextColorDark),
          ),
        ),
        home: fetchFirstsScreen(user),
      ),
    );
  }

  Brightness fetchDark() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.transparent, // optional
      statusBarIconBrightness: Brightness.light, // Dark == white status bar -- for IOS.
    ));
    return Brightness.dark;
  }

  Brightness fetchLight() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent, // optional
      statusBarIconBrightness: Brightness.dark, // Dark == white status bar -- for IOS.
    ));
    return Brightness.light;
  }
}

class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices {
    return {
      PointerDeviceKind.touch,
      PointerDeviceKind.mouse,
      PointerDeviceKind.trackpad,
      PointerDeviceKind.stylus,
      PointerDeviceKind.invertedStylus,
      PointerDeviceKind.unknown,
    };
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State {
  @override
  Widget build(BuildContext context) {
    var data = ['data1', 'data2', 'data3', 'data4', 'data5', 'data6', 'data7'];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expansion Tile'),
      ),
      body: Column(
        children: [
          ExpansionTile(
            title: const Text('ExpansionTile'),
            children: data.map((data) {
              return ListTile(title: Text(data));
            }).toList(),
          ),
        ],
      ),
    );
  }
}