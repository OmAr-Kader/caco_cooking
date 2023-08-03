import 'package:caco_cooking/common/colors.dart';
import 'package:caco_cooking/common/lifecyle.dart';
import 'package:caco_cooking/firebase/auth.dart';
import 'package:caco_cooking/models/user_model.dart';
import 'package:caco_cooking/views/client/main_client_page.dart';
import 'package:caco_cooking/views/log_register.dart';
import 'package:caco_cooking/views/user/main_food_page.dart';
import 'package:caco_cooking/widgets/web_key_widget.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProfilePage extends StatefulWidget {

  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => EditProfileState();

}

class EditProfileState extends WebKeyWidgetDim<EditProfilePage> {
  TextEditingController emailCon = TextEditingController();
  TextEditingController nameCon = TextEditingController();
  TextEditingController mobileCon = TextEditingController();
  TextEditingController locationCon = TextEditingController();

  late RegisterNotifier stateNot;

  @override
  void initState() {
    stateNot = RegisterNotifier(update: setState);
    super.initState();
  }

  void doFailedUpdate(object) {
    hideDia();
    stateNot.isFailedUpdate = true;
  }

  void doLocationFetching() async {
    showDia();
    fetchUserLocation().then((value) {
      setState(() {
        stateUser.user.geoLocation = value;
      });
      hideDia();
    }).catchError((onError) {
      toastFLutter('failed');
      hideDia();
    });
  }

  showLocaiton(GeoPoint? geoPoint) {
    if (geoPoint != null) {
      launchLocationInMap(geoPoint);
    }
  }

  void doUpdate() async {
    String namT = nameCon.text;
    String mobileT = mobileCon.text;
    String locationT = locationCon.text;
    if (namT.isEmpty) {
      stateNot.isErrorName = true;
    } else {
      stateNot.isErrorName = false;
    }
    if (mobileT.isEmpty) {
      stateNot.isErrorMobile = true;
    } else {
      stateNot.isErrorMobile = false;
    }
    if (locationT.isEmpty && stateUser.user.geoLocationNull == null) {
      stateNot.isLocationError = true;
      return;
    } else {
      stateNot.isLocationError = false;
    }
    stateUser.user.name = namT;
    stateUser.user.mobile = mobileT;
    stateUser.user.location = locationT;
    showDia();
    udpaterUser(stateUser.user, navigateToHome, doFailedUpdate);
  }

  navigateToHome(UserBase userBase) {
    hideDia();
    if (userBase.userType == 1) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const MainFoodPage()), (Route<dynamic> route) => false);
    } else {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const MainClientPage()), (Route<dynamic> route) => false);
    }
  }

  doSignOut() async {
    await showDia();
    await removeStringPrefMuili();
    await signOut();
    await navigateToLogIn();
  }

  navigateToLogIn() async {
    hideDia();
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const LogInPage()), (Route<dynamic> route) => false);
  }


  @override
  Widget buildWidScroll(BuildContext context, bool isPortrait, Size size) => buildPortrait(size);

  Widget buildPortrait(Size size) {
    UserBase userBase = stateUser.user;
    nameCon.text = userBase.name;
    mobileCon.text = userBase.mobile;
    locationCon.text = userBase.location;
    emailCon.text = userBase.email;
    return Container(
      padding: EdgeInsets.only(top: (statusBarHeight + dim30) * 2, right: 30, left: 30, bottom: 30),
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
                color: hintColor,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [BoxShadow(color: Color.fromRGBO(143, 148, 251, .2), blurRadius: 20.0, offset: Offset(0, 10))]),
            child: Column(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Name",
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        errorText: stateNot.isErrorName ? "Should not be Empty" : null),
                    controller: nameCon,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    readOnly: true,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Email or Phone number",
                        hintStyle: TextStyle(color: Colors.grey[400])
                    ),
                    autocorrect: false,
                    controller: emailCon,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Phone",
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        errorText: stateNot.isErrorMobile ? "Should not be Empty" : null),
                    controller: mobileCon,
                    autocorrect: false,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Address",
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        errorText: stateNot.isLocationError ? "Address or Location Required" : null),
                    controller: locationCon,
                    autocorrect: false,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                            child: userBase.geoLocationNull != null ? InkWell(
                              onTap: () {
                                showLocaiton(userBase.geoLocationNull);
                              },
                              child: Container(
                                height: 50,
                                constraints: BoxConstraints(maxWidth: sizer(120)),
                                margin: EdgeInsets.only(left: dim10, right: dim10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    gradient: const LinearGradient(colors: [
                                      Color.fromRGBO(143, 148, 251, 1),
                                      Color.fromRGBO(143, 148, 251, .6),
                                    ])),
                                child: const Center(
                                  child: Text(
                                    'Show Location',
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ) : Container(height: 50,
                              margin: EdgeInsets.only(left: dim10, right: dim10),
                              constraints: BoxConstraints(maxWidth: sizer(120)),
                            )
                        ),
                        Flexible(
                            child: InkWell(
                              onTap: doLocationFetching,
                              child: Container(
                                height: 50,
                                constraints: BoxConstraints(maxWidth: sizer(120)),
                                margin: EdgeInsets.only(left: dim10, right: dim10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    gradient: const LinearGradient(colors: [
                                      Color.fromRGBO(143, 148, 251, 1),
                                      Color.fromRGBO(143, 148, 251, .6),
                                    ])),
                                child: Center(
                                  child: Text(
                                    userBase.geoLocationNull != null ? "update" : "Location",
                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            )
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: doUpdate,
              child: Container(
                height: 50,
                constraints: BoxConstraints(maxWidth: sizer(120)),
                margin: EdgeInsets.only(left: dim10, right: dim10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    gradient: const LinearGradient(colors: [
                      Color.fromRGBO(143, 148, 251, 1),
                      Color.fromRGBO(143, 148, 251, .6),
                    ])),
                child: Center(
                  child: Text(
                    stateNot.isFailedUpdate ? 'Retry' : 'Save',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          InkWell(
            onTap: doSignOut,
            child: Container(
              height: 50,
              width: 100,
              margin: EdgeInsets.only(left: dim10, right: dim10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: const LinearGradient(colors: [
                    Color(0xffff0000),
                    Color(0xdfb90000),
                  ])),
              child: const Center(
                child: Text(
                  'Log Out',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 40,
          ),
        ],
      ),
    );
  }

}

class RegisterNotifier {

  Function update;

  RegisterNotifier({required this.update});

  bool _isErrorName = false;

  bool get isErrorName => _isErrorName;

  set isErrorName(bool newValue) {
    update(() => { _isErrorName = newValue});
  }

  bool _isErrorMobile = false;

  bool get isErrorMobile => _isErrorMobile;

  set isErrorMobile(bool newValue) {
    update(() => { _isErrorMobile = newValue});
  }

  bool _isLocationError = false;

  bool get isLocationError => _isLocationError;

  set isLocationError(bool newValue) {
    update(() => { _isLocationError = newValue});
  }

  bool _isFailedUpdate = false;

  bool get isFailedUpdate => _isFailedUpdate;

  set isFailedUpdate(bool newValue) {
    update(() => { _isFailedUpdate = newValue});
  }
}
