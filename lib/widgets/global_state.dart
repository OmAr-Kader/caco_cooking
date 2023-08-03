import 'dart:math';
import 'dart:ui';
import 'package:caco_cooking/common/colors.dart';
import 'package:caco_cooking/common/const.dart';
import 'package:caco_cooking/common/lifecyle.dart';
import 'package:caco_cooking/firebase/auth.dart';
import 'package:caco_cooking/models/user_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

abstract class GlobalMainState<T extends StatefulWidget> extends State<T> {

  GlobalStateForDim? _stateForDim;

  GlobalStateForDim get stateForDim {
    _stateForDim ??= Provider.of<GlobalStateForDim>(context, listen: false);
    return _stateForDim!;
  }

  GlobalUserDetials? _stateUser;

  GlobalUserDetials get stateUser {
    _stateUser ??= Provider.of<GlobalUserDetials>(context, listen: false);
    return _stateUser!;
  }

  Color get fetchBackColor =>
      Theme
          .of(context)
          .primaryColor;


  Color get fetchBackColorAlpha =>
      Theme
          .of(context)
          .primaryColor
          .withAlpha(150);

  //final double statusBarHeight = Get.statusBarHeight;
  double get statusBarHeight =>
      MediaQueryData
          .fromWindow(window)
          .padding
          .top;

  double get navBarHeight =>
      MediaQueryData
          .fromWindow(window)
          .padding
          .bottom;

  bool get isThereCurrentDialogShowing =>
      ModalRoute
          .of(context)
          ?.isCurrent != true;

  showDia() {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(mainColor)));
        });
  }

  hideDia() {
    if (isThereCurrentDialogShowing) {
      Navigator.of(context).pop();
    }
  }


  double get pageViewAllContainer => sizer(250);

  double get pageViewContainer => sizer(190);

  double get pageViewTextContainer => sizer(71.5);

  double get bottomNavigationBarHeigh => sizer(90);

  double get listViewImage => sizer(110);

  double get popularFoodImg => sizior.height * 0.35;

  double get pageEditTextContainer => sizior.height * 0.15;

  double get dim10 => sizer(10);

  double get dim5 => sizer(5);

  double get dim2 => sizer(2);

  double get dim15 => sizer(15);

  double get dim20 => sizer(20);

  double get dim12 => sizer(12);

  double get dim24 => sizer(24);

  double get dim30 => sizer(30);

  double get dim40 => sizer(40);

  double get dim45 => sizer(45);

  double get dim50 => sizer(50);

  bool get isPortrait =>
      MediaQuery
          .of(context)
          .orientation == Orientation.portrait;

  @override
  Widget build(BuildContext context) {
    bool isPortrait = this.isPortrait;
    Size size;
    if (isPortrait != stateForDim._isPortrait) {
      stateForDim._isPortrait = isPortrait;
      size = updateDim();
    } else {
      size = sizior;
    }
    return buildWid(context, isPortrait, size);
  }

  @protected
  Widget buildWid(BuildContext context, bool isPortrait, Size size);

  Size updateDim() {
    Size size = MediaQuery
        .of(context)
        .size;
    stateForDim.size = size;
    return size;
  }

  Size get sizior {
    if (stateForDim.size.height == 0) {
      return updateDim();
    } else {
      return stateForDim.size;
    }
  }

  double get minWidth => min(sizior.height, sizior.width);

  double sizer(double dim) {
    double w = minWidth;
    if (w < 400) {
      return dim;
    } else if (w >= 400.0 && w < 600.0) {
      return dim * 1.375;
    } else if (w >= 600.0 && w < 700.0) {
      return dim * 1.5;
    } else if (w >= 700.0 && w < 800.0) {
      return dim * 1.6;
    } else if (w >= 800.0 && w < 900.0) {
      return dim * 1.7;
    } else {
      return dim * 1.75;
    }
  }

}

class GlobalStateForDim extends ChangeNotifier {
  Size size = const Size(0, 0);
  bool? _isPortrait;
}

class GlobalUserDetials extends ChangeNotifier {

  UserBase? user_;

  UserBase get user => user_!;

  set user(UserBase newValue) => user_ = newValue;

  GlobalUserDetials({required this.user_});

  Future<UserBase?> userAs() async {
    UserBase? currentUser = user_;
    if (currentUser != null) {
      return currentUser;
    } else {
      UserBase? us = await fetchUserDetails(docID: await findStringPref(DOC_ID, null));
      return us;
    }
  }
}
