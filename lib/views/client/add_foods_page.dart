import 'package:caco_cooking/common/colors.dart';
import 'package:caco_cooking/common/lifecyle.dart';
import 'package:caco_cooking/firebase/firebase_storage.dart';
import 'package:caco_cooking/firebase/foods.dart';
import 'package:caco_cooking/firebase/repo.dart';
import 'package:caco_cooking/models/food_model.dart';
import 'package:caco_cooking/widgets/cached_image.dart';
import 'package:caco_cooking/widgets/web_key_widget.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddFoodsPage extends StatefulWidget {

  const AddFoodsPage({Key? key}) : super(key: key);

  @override
  State<AddFoodsPage> createState() => AddFoodsPageState();
}

class AddFoodsPageState extends WebKeyWidgetDim<AddFoodsPage> {
  TextEditingController nameCon = TextEditingController();
  TextEditingController deslCon = TextEditingController();
  TextEditingController priCon = TextEditingController();
  List<String> imageUris = [];
  int imgColor = mainColor.value;
  late double xAlign = 1;
  int foodType = 1;

  late AddFoodNotifier stateNot;

  @override
  void initState() {
    stateNot = emptyStateNot();
    super.initState();
  }

  void doSave() async {
    String namT = nameCon.text;
    String desT = deslCon.text;
    String priT = priCon.text.toString();
    if (namT.isEmpty) {
      stateNot.isErrorName = true;
      return;
    } else {
      stateNot.isErrorName = false;
    }
    if (desT.isEmpty) {
      stateNot.isErrorDes = true;
      return;
    } else {
      stateNot.isErrorDes = false;
    }
    if (priT.isEmpty) {
      stateNot.isErrorPri = true;
      return;
    } else {
      try {
        double.parse(priT);
      } on FormatException catch (_) {
        stateNot.isErrorPri = true;
        return;
      }
      stateNot.isErrorPri = false;
    }
    if (imageUris.isEmpty) {
      toastFLutter('Pick at least one Food Image');
      return;
    }
    showDia();
    saveFoods(
        FoodModel.toAdd(
          nam: namT,
          newDes: desT,
          pri: double.parse(priT),
          star: 5,
          picS: imageUris,
          dat: currentMilliseconds,
          type: foodType,
          color: imgColor,
        ), doDoneSave, doFailedRegister);
  }

  doDoneSave() async {
    hideDia();
    Get.find<RepoControllers>().fetchAllFoods();
    Navigator.of(context).pop();
    //Navigator.of(context).popUntil(ModalRoute.withName('/EditFoodsPage'));
  }

  void doFailedRegister(object) {
    hideDia();
    stateNot.isSaveError = true;
  }

  AddFoodNotifier emptyStateNot() => AddFoodNotifier(update: setState);

  String fetchStringForSign() {
    if (stateNot.isSaveError) {
      return "Retry";
    } else {
      return "Save";
    }
  }

  pickPicture() async {
    final DSack<List<String>, int> list = await pickImageForFood(showDia, (e) => {});
    doDonePicture(list);
  }

  doDonePicture(DSack<List<String>, int> imgUris) {
    hideDia();
    setState(() {
      imgColor = imgUris.two;
      imageUris.addAll(imgUris.one);
    });
  }

  @override
  Widget buildWidScroll(BuildContext context, bool isPortrait, Size size) {
    return Column(
      children: <Widget>[
        InkWell(
          onTap: pickPicture,
          child: SizedBox(
            height: 200,
            child: imageUris.isNotEmpty
                ? Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(dim20),
                  child: CustomCachedNetworkImage(
                    height_: 200,
                    imageUrl: imageUris.firstOrNull ?? "",
                    dim30: dim30,
                  ),
                ))
                : Center(
                child: Card(
                  elevation: 5,
                  shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(3.0))),
                  child: Icon(Icons.image, color: hintColor, size: 100),
                )),
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
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Description",
                            hintStyle: TextStyle(color: Colors.grey[400]),
                            errorText: stateNot.isErrorDes ? "Should not be Empty" : null),
                        controller: deslCon,
                        autocorrect: false,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "price",
                            hintStyle: TextStyle(color: Colors.grey[400]),
                            errorText: stateNot.isErrorPri ? "Should not be Empty" : null),
                        controller: priCon,
                        autocorrect: false,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              ToggleSwitch(
                minWidth: 120.0,
                initialLabelIndex: foodType - 1,
                activeBgColor: const [mainColor],
                activeFgColor: Colors.white,
                inactiveBgColor: hintColor,
                inactiveFgColor: findTextColor,
                totalSwitches: 2,
                labels: const ['Normal', 'Recommended'],
                onToggle: (index) {
                  if (index == 0) {
                    foodType = 1;
                  } else {
                    foodType = 2;
                  }
                },
              ),
              const SizedBox(
                height: 30,
              ),
              InkWell(
                onTap: doSave,
                child: Container(
                  height: 50,
                  constraints: BoxConstraints(maxWidth: sizer(200)),
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
              const SizedBox(
                height: 40,
              ),
            ],
          ),
        )
      ],
    );
  }

}

class AddFoodNotifier {

  Function update;

  AddFoodNotifier({required this.update});

  bool _isErrorName = false;

  bool get isErrorName => _isErrorName;

  set isErrorName(bool newValue) {
    update(() => { _isErrorName = newValue});
  }

  bool _isErrorDes = false;

  bool get isErrorDes => _isErrorDes;

  set isErrorDes(bool newValue) {
    update(() => { _isErrorDes = newValue});
  }

  bool _isErrorPri = false;

  bool get isErrorPri => _isErrorPri;

  set isErrorPri(bool newValue) {
    update(() => { _isErrorPri = newValue});
  }

  bool _isSaveError = false;

  bool get isSaveError => _isSaveError;

  set isSaveError(bool newValue) {
    update(() => { _isSaveError = newValue});
  }

}
