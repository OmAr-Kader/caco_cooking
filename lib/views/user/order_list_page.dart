import 'package:caco_cooking/common/colors.dart';
import 'package:caco_cooking/common/lifecyle.dart';
import 'package:caco_cooking/firebase/auth.dart';
import 'package:caco_cooking/firebase/foods.dart';
import 'package:caco_cooking/firebase/orders.dart';
import 'package:caco_cooking/models/orders_model.dart';
import 'package:caco_cooking/models/user_model.dart';
import 'package:caco_cooking/views/user/food_details.dart';
import 'package:caco_cooking/widgets/cached_image.dart';
import 'package:caco_cooking/widgets/global_state.dart';
import 'package:caco_cooking/widgets/texter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';

import 'main_food_page.dart';

class OrderFoodDetails extends StatefulWidget {

  final FoodDetialsNot stateNot;

  final bool fromHistory;

  const OrderFoodDetails({Key? key, required this.stateNot, required this.fromHistory}) : super(key: key);

  @override
  State<OrderFoodDetails> createState() => OrderFoodDetailsState();
}

class OrderFoodDetailsState extends GlobalMainState<OrderFoodDetails> {

  VoidCallback? _callBack;

  VoidCallback get callBack {
    if (_callBack == null) {
      v() {
        setState(() {});
      }
      _callBack = v;
      return _callBack!;
    } else {
      return _callBack!;
    }
  }

  @override
  void initState() {
    super.initState();
    widget.stateNot.addListener(callBack);
  }

  @override
  void dispose() {
    resetStatusBar();
    widget.stateNot.removeListener(callBack);
    super.dispose();
  }

  bool isCash = true;

  @override
  Widget buildWid(BuildContext context, bool isPortrait, Size size) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: statusBarHeight, bottom: dim15),
            padding: EdgeInsets.only(left: dim20, right: dim20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: dim10),
                      child: MainBigText(
                          text: "Cart",
                          size: dim30),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: dim10, right: dim10, top: dim10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.all(dim5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      BigText(text: "Total Price: ", size: dim15),
                      SmallText(text: "\$${widget.stateNot.ordersModel.totalPrice}", size: dim15),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(dim5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      BigText(text: "Total Paid: ", size: dim15),
                      SmallText(text: "\$${widget.stateNot.ordersModel.totalPaid}", size: dim15),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: OrderListBody(
              ordersModel: widget.stateNot.ordersModel,
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: bottomNavigationBarHeigh,
        padding: EdgeInsets.all(dim5),
        decoration: BoxDecoration(
            color: hintColor,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(dim20),
                topRight: Radius.circular(dim20))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ToggleSwitch(
              minWidth: 100.0,
              initialLabelIndex: isCash ? 0 : 1,
              activeBgColor: const [mainColor],
              activeFgColor: Colors.white,
              inactiveBgColor: const Color.fromRGBO(91, 91, 91, 1.0),
              inactiveFgColor: Colors.white,
              totalSwitches: 2,
              labels: const ['Cach', 'Visa'],
              onToggle: (index) {
                isCash = index == 0;
              },
            ),
            Container(
                height: dim50,
                margin: EdgeInsets.all(dim5),
                padding: EdgeInsets.only(top: dim5, bottom: dim5, left: dim10, right: dim10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(dim15),
                    color: mainColor),
                child: InkWell(
                  onTap: () {
                    showDia();
                    sendorder();
                  },
                  child: Center(
                    child: widget.fromHistory ? BigText(text: "Re-order", size: dim15) : BigText(text: "Order", size: dim15),
                  ),
                )
            )
          ],
        ),
      ),
    );
  }

  sendorder() async {
    List<UserBase>? list = await fetchServerUserNow('');
    if (list == null) {
      toastFLutter("Failed");
      return;
    }
    UserBase userBase = stateUser.user;
    sendOrder(
        OrdersModel.toSend(widget.stateNot.ordersModel, userBase, list.first.idDoc, currentMilliseconds), list.first.messageToken, doDone, doFailed
    );
  }

  doDone() async {
    if (!widget.fromHistory) {
      await Provider.of<FoodDetialsNot>(context, listen: false).reset();
      hideDia();
      doBack();
    } else {
      hideDia();
      doBack();
    }
  }

  doBack() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const MainFoodPage()), (Route<dynamic> route) => false
    );
  }

  doFailed(Object? object) {
    toastFLutter("Failed");
    hideDia();
  }

}


class OrderListBody extends StatefulWidget {

  final OrdersModel ordersModel;

  const OrderListBody({Key? key, required this.ordersModel}) : super(key: key);

  @override
  State<OrderListBody> createState() => _OrderListBodyState();
}

class _OrderListBodyState extends GlobalMainState<OrderListBody> {

  final ScrollController _controller = ScrollController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _handleKeyEvent(RawKeyEvent event) {
    var offset = _controller.offset;
    if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
      _controller.animateTo(offset - 100, duration: const Duration(milliseconds: 300), curve: Curves.linear);
    } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      _controller.animateTo(offset + 100, duration: const Duration(milliseconds: 300), curve: Curves.linear);
    } else if (event.logicalKey == LogicalKeyboardKey.pageDown) {
      _controller.animateTo(offset + 400, duration: const Duration(milliseconds: 300), curve: Curves.linear);
    } else if (event.logicalKey == LogicalKeyboardKey.pageUp) {
      _controller.animateTo(offset - 400, duration: const Duration(milliseconds: 300), curve: Curves.linear);
    }
  }

  @override
  Widget buildWid(BuildContext context, bool isPortrait, Size size) {
    return SizedBox(
        height: widget.ordersModel.orders.length * (listViewImage + dim20) + dim45,
        child: RawKeyboardListener(
            autofocus: true,
            focusNode: _focusNode,
            onKey: _handleKeyEvent,
            child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                controller: _controller, child: buildWidScroll(context, isPortrait)
            )
        ));
  }

  double scaleFactor = 0.8;

  Widget buildWidScroll(BuildContext context, bool isPortrait) {
    return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        addAutomaticKeepAlives: false,
        addRepaintBoundaries: false,
        itemCount: widget.ordersModel.orders.length,
        itemBuilder: (context, index) {
          Order order = widget.ordersModel.orders[index];
          return InkWell(
            onTap: () {
              navigateToRecommended(order);
            },
            child: Container(
                height: listViewImage,
                margin: EdgeInsets.only(
                    top: dim10, bottom: dim10, left: dim20, right: dim20),
                child: Row(
                  children: [
                    SizedBox(
                        width: listViewImage,
                        height: listViewImage,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(dim20),
                          child: CustomCachedNetworkImage(
                            height_: listViewImage,
                            imageUrl: order.foodImg,
                            dim30: dim30,
                          ),
                        )),
                    Expanded(
                        child: Container(
                          margin: EdgeInsets.only(left: dim10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              BigText(
                                  text: order.nameFood,
                                  size: dim15
                              ),
                              SizedBox(height: dim10),
                              Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: SmallText(
                                    text: order.count.toString(),
                                    size: dim12,
                                  )
                              ),
                              SizedBox(height: dim15),
                              BigText(
                                  text: "\$ ${order.price * order.count}",
                                  size: dim15
                              )
                            ],
                          ),
                        ))
                  ],
                )),
          );
        });
  }

  navigateToRecommended(Order order) async {
    fetchOnFoods(order.foodId, (food) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  PopularFoodDetails(product: food, stateNot: Provider.of<FoodDetialsNot>(context, listen: false))
          )
      );
    }, (p0) => null
    );
  }

}
