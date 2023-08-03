import 'package:caco_cooking/common/colors.dart';
import 'package:caco_cooking/common/lifecyle.dart';
import 'package:caco_cooking/firebase/cloud_messaging.dart';
import 'package:caco_cooking/firebase/auth.dart';
import 'package:caco_cooking/firebase/repo.dart';
import 'package:caco_cooking/models/user_model.dart';
import 'package:caco_cooking/views/client/main_client_page.dart';
import 'package:caco_cooking/views/user/main_food_page.dart';
import 'package:caco_cooking/widgets/texter.dart';
import 'package:caco_cooking/widgets/web_key_widget.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  State<LogInPage> createState() => LogPageState();
}

class LogPageState extends WebKeyWidgetDim<LogInPage> {
  TextEditingController emailCon = TextEditingController();
  TextEditingController passCon = TextEditingController();

  late LogNotifier stateNot;

  @override
  void initState() {
    stateNot = emptyStateNot();
    super.initState();
  }

  void doSignIn() async {
    String emT = emailCon.text;
    String pasT = passCon.text;
    if (emT.isEmpty) {
      stateNot.isErrorEmail = true;
      return;
    } else {
      stateNot.isErrorEmail = false;
    }
    if (pasT.isEmpty) {
      stateNot.isErrorPass = true;
      return;
    } else {
      stateNot.isErrorPass = false;
    }
    showDia();
    signIn(emT, pasT, doDoneSignIn, doFailed);
  }

  Future<void> doDoneSignIn(uid, String? docId) async {
    final UserBase? user = await fetchUserDetails(docID: docId);
    if (user == null || docId == null) {
      doFailed("");
    } else {
      await updateStringPrefMuili(docId, uid, user.email, passCon.text, user.messageToken);
      await intiMessage(user.userType);
      navigateToHome(user, docId);
    }
  }

  void navigateToHome(UserBase user, String docId) {
    stateNot.isFailedError = false;
    hideDia();
    if (user.userType == 1) {
      stateUser.user = user;
      Get.find<RepoControllers>().fetchAllFoodsNormal();
      Get.find<RepoControllers>().fetchAllFoodsRecommended();
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const MainFoodPage()), (Route<dynamic> route) => false);
    } else {
      stateUser.user = user;
      Get.find<RepoControllers>().fetchAllOrdersNotYet(docId, () => {});
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const MainClientPage()), (Route<dynamic> route) => false);
    }
  }

  void doFailed(object) {
    hideDia();
    stateNot.isFailedError = true;
  }

  void navigateToRegister() async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterPage()));
  }

  doSignInWithGmail() {
    showDia();
    signInWithGmail(doDoneSignIn, doFailed);
  }

  LogNotifier emptyStateNot() => LogNotifier(update: setState);

  @override
  Widget buildWidScroll(BuildContext context, bool isPortrait, Size size) {
    if (isPortrait) {
      return buildPortrait(size);
    } else {
      return buildLandscape(size);
    }
  }

  Widget buildPortrait(Size size) {
    return Column(
      children: <Widget>[
        Container(
          height: size.height * 0.4,
          decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/image/background.png'), fit: BoxFit.fill)),
          child: Stack(
            children: <Widget>[
              Positioned(
                left: 30,
                width: 80,
                height: 200,
                child: Container(
                  decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/image/light-1.png'))),
                ),
              ),
              Positioned(
                left: 140,
                width: 80,
                height: 150,
                child: Container(
                  decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/image/light-2.png'))),
                ),
              ),
              Positioned(
                right: 40,
                top: 40,
                width: 80,
                height: 150,
                child: Container(
                  decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/image/clock.png'))),
                ),
              ),
              Positioned(
                child: Container(
                  margin: const EdgeInsets.only(top: 50),
                  child: Center(
                    child: BigText(
                      text: "Login",
                      size: dim40,
                      col: mainTxtColor,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(30.0),
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
                            hintText: "Email or Phone number",
                            hintStyle: TextStyle(color: Colors.grey[400]),
                            errorText: stateNot.isErrorEmail ? "Should not be Empty" : null),
                        controller: emailCon,
                        autocorrect: false,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Password",
                            hintStyle: TextStyle(color: Colors.grey[400]),
                            errorText: stateNot.isErrorPass ? "Should not be Empty" : null),
                        controller: passCon,
                        autocorrect: false,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: dim20,
              ),
              Container(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible(
                        child: Center(
                          child: InkWell(
                            onTap: doSignIn,
                            child: Container(
                              height: 50,
                              constraints: BoxConstraints(maxWidth: sizer(140)),
                              margin: EdgeInsets.only(left: dim10, right: dim10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: const LinearGradient(colors: [
                                    Color.fromRGBO(143, 148, 251, 1),
                                    Color.fromRGBO(143, 148, 251, .6),
                                  ])),
                              child: Center(
                                child: Text(
                                  stateNot.isFailedError ? "Retry" : "Login",
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        )
                    ),
                    Flexible(
                        child: Center(
                          child: InkWell(
                            onTap: doSignInWithGmail,
                            child: Container(
                              margin: EdgeInsets.only(left: dim10, right: dim10),
                              height: 50,
                              constraints: BoxConstraints(maxWidth: sizer(140)),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: LinearGradient(colors: findGradientColors)),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Image.asset('assets/image/google.png'),
                                ),
                              ),
                            ),
                          ),
                        )
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: dim20,
              ),
              Padding(
                padding: EdgeInsets.all(dim10),
                child: Text(
                  "Forgot Password?",
                  style: largeTextStyle(context, dim15, mainColor),
                ),
              ),
              SizedBox(
                height: dim20,
              ),
              InkWell(
                onTap: navigateToRegister,
                child: Padding(
                  padding: EdgeInsets.all(dim10),
                  child: Text(
                    "Register",
                    style: largeTextStyle(context, dim15, mainColor),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget buildLandscape(Size size) {
    return Column(
      children: <Widget>[
        Container(
          height: size.height * 0.4,
          decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/image/background.png'), fit: BoxFit.fill)),
          child: Stack(
            children: <Widget>[
              Positioned(
                left: 30,
                width: 80,
                height: 200,
                child: Container(
                  decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/image/light-1.png'))),
                ),
              ),
              Positioned(
                left: 140,
                width: 80,
                height: 150,
                child: Container(
                  decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/image/light-2.png'))),
                ),
              ),
              Positioned(
                right: 40,
                top: 40,
                width: 80,
                height: 150,
                child: Container(
                  decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/image/clock.png'))),
                ),
              ),
              Positioned(
                child: Container(
                  margin: const EdgeInsets.only(top: 50),
                  child: Center(
                    child: BigText(
                      text: "Login",
                      size: dim40,
                      col: mainTxtColor,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: <Widget>[
              Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible(
                        flex: 3,
                        child: Container(
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
                                      hintText: "Email or Phone number",
                                      hintStyle: TextStyle(color: Colors.grey[400]),
                                      errorText: stateNot.isErrorEmail ? "Should not be Empty" : null),
                                  controller: emailCon,
                                  autocorrect: false,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Password",
                                      hintStyle: TextStyle(color: Colors.grey[400]),
                                      errorText: stateNot.isErrorPass ? "Should not be Empty" : null),
                                  controller: passCon,
                                  autocorrect: false,
                                ),
                              )
                            ],
                          ),
                        )),
                    Flexible(
                        flex: 2,
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Center(
                                child: InkWell(
                                  onTap: doSignIn,
                                  child: Container(
                                    height: 50,
                                    constraints: BoxConstraints(maxWidth: sizer(140)),
                                    margin: EdgeInsets.only(left: dim10, right: dim10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        gradient: const LinearGradient(colors: [
                                          Color.fromRGBO(143, 148, 251, 1),
                                          Color.fromRGBO(143, 148, 251, .6),
                                        ])),
                                    child: Center(
                                      child: Text(
                                        stateNot.isFailedError ? "Retry" : "Login",
                                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: dim10),
                              Center(
                                child: InkWell(
                                  onTap: doSignInWithGmail,
                                  child: Container(
                                    margin: EdgeInsets.only(left: dim10, right: dim10),
                                    height: 50,
                                    constraints: BoxConstraints(maxWidth: sizer(140)),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        gradient: LinearGradient(colors: findGradientColors)),
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(5),
                                        child: Image.asset('assets/image/google.png'),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ))
                  ]
              ),
              SizedBox(
                height: dim20,
              ),
              Padding(
                padding: EdgeInsets.all(dim10),
                child: Text(
                  "Forgot Password?",
                  style: largeTextStyle(context, dim15, mainColor),
                ),
              ),
              SizedBox(
                height: dim20,
              ),
              InkWell(
                onTap: navigateToRegister,
                child: Padding(
                  padding: EdgeInsets.all(dim10),
                  child: Text(
                    "Register",
                    style: largeTextStyle(context, dim15, mainColor),
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}

class LogNotifier {

  Function update;

  LogNotifier({required this.update});

  bool _isErrorEmail = false;

  bool get isErrorEmail => _isErrorEmail;

  set isErrorEmail(bool newValue) {
    update(() => { _isErrorEmail = newValue});
  }

  bool _isErrorPass = false;

  bool get isErrorPass => _isErrorPass;

  set isErrorPass(bool newValue) {
    update(() => { _isErrorPass = newValue});
  }

  bool _isFailedError = false;

  bool get isFailedError => _isFailedError;

  set isFailedError(bool newValue) {
    update(() => { _isFailedError = newValue});
  }
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => RegisterPageState();
}

class RegisterPageState extends WebKeyWidgetDim<RegisterPage> {
  TextEditingController nameCon = TextEditingController();
  TextEditingController emailCon = TextEditingController();
  TextEditingController passCon = TextEditingController();
  TextEditingController mobileCon = TextEditingController();
  TextEditingController locationCon = TextEditingController();
  GeoPoint? geoPoint;

  late RegisterNotifier stateNot;

  @override
  void initState() {
    stateNot = emptyStateNot();
    super.initState();
  }

  void doFailedRegister(object) {
    hideDia();
    stateNot.isFailedRegisterError = true;
  }

  void doLocationFetching() async {
    showDia();
    fetchUserLocation().then((value) {
      setState(() {
        geoPoint = value;
      });
      hideDia();
    }).catchError((onError) {
      toastFLutter('failed');
      hideDia();
    });
  }

  void doRegister() async {
    String namT = nameCon.text;
    String emT = emailCon.text;
    String pasT = passCon.text;
    String mobileT = mobileCon.text;
    String locationT = locationCon.text;
    if (namT.isEmpty) {
      stateNot.isErrorName = true;
    } else {
      stateNot.isErrorName = false;
    }
    if (emT.isEmpty) {
      stateNot.isErrorEmail = true;
    } else {
      stateNot.isErrorEmail = false;
    }
    if (pasT.isEmpty) {
      stateNot.isErrorPass = true;
    } else {
      stateNot.isErrorPass = false;
    }
    if (mobileT.isEmpty) {
      stateNot.isErrorMobile = true;
    } else {
      stateNot.isErrorMobile = false;
    }
    if (locationT.isEmpty && geoPoint == null) {
      stateNot.isLocationError = true;
      return;
    } else {
      stateNot.isLocationError = false;
    }
    showDia();
    UserBase user = UserBase.toRegister(newName: namT,
        newEmail: emT,
        newMobile: mobileT,
        address: locationT,
        geoPoint: geoPoint
    );
    register(user, pasT, doDoneRegister, doFailedRegister);
  }

  doDoneRegister(UserBase? user, String? docId) async {
    if (user?.email == null || docId == null) {
      stateNot.isFailedAlreadyRegisterError = true;
    } else {
      await updateStringPrefMuili(docId, user!.id, user.email, passCon.text, user.messageToken);
      done(user, docId);
      //pickImage(user, docId, done, failed);
    }
  }

  done(UserBase user, String docId) async {
    await intiMessage(user.userType);
    navigateToHome(user, docId);
  }

  RegisterNotifier emptyStateNot() => RegisterNotifier(update: setState);

  void navigateToHome(UserBase user, String docId) {
    stateNot.isFailedRegisterError = false;
    hideDia();
    if (user.userType == 1) {
      stateUser.user = user;
      Get.find<RepoControllers>().fetchAllFoodsNormal();
      Get.find<RepoControllers>().fetchAllFoodsRecommended();
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const MainFoodPage()), (Route<dynamic> route) => false);
    } else {
      stateUser.user = user;
      Get.find<RepoControllers>().fetchAllOrdersNotYet(docId, () => {});
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const MainClientPage()), (Route<dynamic> route) => false);
    }
  }

  void navigateToSignIn() {
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const LogInPage()), (Route<dynamic> route) => false);
  }

  String fetchStringForSign() {
    if (stateNot.isFailedRegisterError) {
      return "Retry";
    } else if (stateNot.isFailedAlreadyRegisterError) {
      return "Already Registered";
    } else {
      return "Sign Up";
    }
  }

  doSignUpWithGmail() {
    String mobileT = mobileCon.text;
    String locationT = locationCon.text;
    if (mobileT.isEmpty) {
      stateNot.isErrorMobile = true;
    } else {
      stateNot.isErrorMobile = false;
    }
    if (locationT.isEmpty) {
      stateNot.isLocationError = true;
      return;
    } else {
      stateNot.isLocationError = false;
    }
    showDia();
    registerWithGmail(UserBase.toGmail(newMobile: mobileT, address: locationT, geoPoint: geoPoint), doDoneRegister, doFailedRegister);
  }

  showLocaiton(GeoPoint? geoPoint) {
    if (geoPoint != null) {
      launchLocationInMap(geoPoint);
    }
  }

  @override
  void dispose() {
    geoPoint = null;
    super.dispose();
  }

  @override
  Widget buildWidScroll(BuildContext context, bool isPortrait, Size size) => isPortrait ? buildPortrait(size) : buildLandscape(size);

  Widget buildPortrait(Size size) {
    return Column(
      children: <Widget>[
        Container(
          height: size.height * 0.4,
          decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/image/background.png'), fit: BoxFit.fill)),
          child: Stack(
            children: <Widget>[
              Positioned(
                  left: 30,
                  width: 80,
                  height: 200,
                  child: Container(
                    decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/image/light-1.png'))),
                  )),
              Positioned(
                left: 140,
                width: 80,
                height: 150,
                child: Container(
                  decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/image/light-2.png'))),
                ),
              ),
              Positioned(
                right: 40,
                top: 40,
                width: 80,
                height: 150,
                child: Container(
                  decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/image/clock.png'))),
                ),
              ),
              Positioned(
                child: Container(
                  margin: const EdgeInsets.only(top: 50),
                  child: Center(
                      child: BigText(
                        text: "Register",
                        size: dim40,
                        col: mainTxtColor,
                      )
                  ),
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(30.0),
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
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Email or Phone number",
                            hintStyle: TextStyle(color: Colors.grey[400]),
                            errorText: stateNot.isErrorEmail ? "Should not be Empty" : null),
                        controller: emailCon,
                        autocorrect: false,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Password",
                            hintStyle: TextStyle(color: Colors.grey[400]),
                            errorText: stateNot.isErrorPass ? "Should not be Empty" : null),
                        controller: passCon,
                        autocorrect: false,
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
                              errorText: stateNot.isLocationError ? "Should not be Empty" : null),
                          controller: locationCon,
                          autocorrect: false,
                        )
                    ),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                                child: geoPoint != null ? InkWell(
                                  onTap: () {
                                    showLocaiton(geoPoint);
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
                                        geoPoint != null ? "update" : "Location",
                                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                )
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: dim20,
              ),
              Container(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible(
                        child: Center(
                          child: InkWell(
                            onTap: doRegister,
                            child: Container(
                              height: 50,
                              constraints: BoxConstraints(maxWidth: sizer(140)),
                              margin: EdgeInsets.only(left: dim10, right: dim10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: const LinearGradient(colors: [
                                    Color.fromRGBO(143, 148, 251, 1),
                                    Color.fromRGBO(143, 148, 251, .6),
                                  ])),
                              child: Center(
                                child: Text(
                                  fetchStringForSign(),
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        )
                    ),
                    Flexible(
                        child: Center(
                          child: InkWell(
                            onTap: doSignUpWithGmail,
                            child: Container(
                              height: 50,
                              constraints: BoxConstraints(maxWidth: sizer(140)),
                              margin: EdgeInsets.only(left: dim10, right: dim10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: LinearGradient(colors: findGradientColors)),
                              child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Image.asset('assets/image/google.png'),
                                  )
                              ),
                            ),
                          ),
                        )
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: dim20,
              ),
              InkWell(
                onTap: navigateToSignIn,
                child: Padding(
                  padding: EdgeInsets.all(dim10),
                  child: Text(
                    "Login",
                    style: largeTextStyle(context, dim15, mainColor),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget buildLandscape(Size size) {
    return Column(
      children: <Widget>[
        Container(
          height: size.height * 0.4,
          decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/image/background.png'), fit: BoxFit.fill)),
          child: Stack(
            children: <Widget>[
              Positioned(
                  left: 30,
                  width: 80,
                  height: 200,
                  child: Container(
                    decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/image/light-1.png'))),
                  )),
              Positioned(
                left: 140,
                width: 80,
                height: 150,
                child: Container(
                  decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/image/light-2.png'))),
                ),
              ),
              Positioned(
                right: 40,
                top: 40,
                width: 80,
                height: 150,
                child: Container(
                  decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/image/clock.png'))),
                ),
              ),
              Positioned(
                child: Container(
                  margin: const EdgeInsets.only(top: 50),
                  child: Center(
                      child: BigText(
                        text: "Register",
                        size: dim40,
                        col: mainTxtColor,
                      )
                  ),
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: <Widget>[
              Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 3,
                      child: Container(
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
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Email or Phone number",
                                    hintStyle: TextStyle(color: Colors.grey[400]),
                                    errorText: stateNot.isErrorEmail ? "Should not be Empty" : null),
                                controller: emailCon,
                                autocorrect: false,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Password",
                                    hintStyle: TextStyle(color: Colors.grey[400]),
                                    errorText: stateNot.isErrorPass ? "Should not be Empty" : null),
                                controller: passCon,
                                autocorrect: false,
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
                                )
                            ),
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Flexible(
                                        child: geoPoint != null ? InkWell(
                                          onTap: () {
                                            showLocaiton(geoPoint);
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
                                                geoPoint != null ? "update" : "Location",
                                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        )
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            InkWell(
                              onTap: doRegister,
                              child: Center(
                                child: Container(
                                  height: 50,
                                  constraints: BoxConstraints(maxWidth: sizer(140)),
                                  margin: EdgeInsets.only(left: dim10, right: dim10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      gradient: const LinearGradient(colors: [
                                        Color.fromRGBO(143, 148, 251, 1),
                                        Color.fromRGBO(143, 148, 251, .6),
                                      ])),
                                  child: Center(
                                    child: Text(
                                      fetchStringForSign(),
                                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: dim10),
                            InkWell(
                              onTap: doSignUpWithGmail,
                              child: Center(
                                child: Container(
                                  height: 50,
                                  constraints: BoxConstraints(maxWidth: sizer(140)),
                                  margin: EdgeInsets.only(left: dim10, right: dim10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      gradient: LinearGradient(colors: findGradientColors)),
                                  child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(5),
                                        child: Image.asset('assets/image/google.png'),
                                      )
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ]
              ),
              SizedBox(
                height: dim20,
              ),
              InkWell(
                onTap: navigateToSignIn,
                child: Padding(
                  padding: EdgeInsets.all(dim10),
                  child: Text(
                    "Login",
                    style: largeTextStyle(context, dim15, mainColor),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
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

  bool _isErrorEmail = false;

  bool get isErrorEmail => _isErrorEmail;

  set isErrorEmail(bool newValue) {
    update(() => { _isErrorEmail = newValue});
  }

  bool _isErrorPass = false;

  bool get isErrorPass => _isErrorPass;

  set isErrorPass(bool newValue) {
    update(() => { _isErrorPass = newValue});
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

  bool _isFailedRegisterError = false;

  bool get isFailedRegisterError => _isFailedRegisterError;

  set isFailedRegisterError(bool newValue) {
    update(() => { _isFailedRegisterError = newValue});
  }

  bool _isFailedAlreadyRegisterError = false;

  bool get isFailedAlreadyRegisterError => _isFailedAlreadyRegisterError;

  set isFailedAlreadyRegisterError(bool newValue) {
    update(() => { _isFailedAlreadyRegisterError = newValue});
  }

  bool _isFailedMessageError = false;

  bool get isFailedMessageError => _isFailedMessageError;

  set isFailedMessageError(bool newValue) {
    update(() => { _isFailedMessageError = newValue});
  }
}
