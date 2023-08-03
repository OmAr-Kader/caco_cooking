import 'package:caco_cooking/common/colors.dart';
import 'package:caco_cooking/common/lifecyle.dart';
import 'package:caco_cooking/firebase/auth.dart';
import 'package:caco_cooking/firebase/foods.dart';
import 'package:caco_cooking/firebase/orders.dart';
import 'package:caco_cooking/firebase/repo.dart';
import 'package:caco_cooking/models/orders_model.dart';
import 'package:caco_cooking/models/user_model.dart';
import 'package:caco_cooking/views/client/main_client_page.dart';
import 'package:caco_cooking/views/user/food_details.dart';
import 'package:caco_cooking/widgets/cached_image.dart';
import 'package:caco_cooking/widgets/global_state.dart';
import 'package:caco_cooking/widgets/texter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class OrderServerDetails extends StatefulWidget {

  final OrdersModel ordersModel;

  const OrderServerDetails({Key? key, required this.ordersModel}) : super(key: key);

  @override
  State<OrderServerDetails> createState() => OrderServersState();
}

class OrderServersState extends GlobalMainState<OrderServerDetails> {

  navigateToForward() async {
    showDia();
    List<UserBase>? list = await fetchServerUserNow(stateUser.user.idDoc);
    if (list != null && list.isNotEmpty) {
      showForwardDialog(list);
    } else {
      hideDia();
    }
  }

  showForwardDialog(List<UserBase> list) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: const Text("Forward Order To"),
              content: SizedBox(
                height: 300.0, // Change as per your requirement
                width: 300.0, // Change as per your requirement
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: list.length,
                  itemBuilder: (BuildContext context, int index) {
                    UserBase user = list[index];
                    return Container(
                      margin: EdgeInsets.only(left: dim10),
                      child: InkWell(
                          onTap: () {
                            doForward(widget.ordersModel, user);
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              BigText(
                                  text: user.name.toString(),
                                  size: dim15, textAlign: TextAlign.center
                              ),
                              SizedBox(height: dim10),
                              Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: SmallText(
                                    text: user.location.toString(),
                                    size: dim12,
                                  )
                              ),
                              SizedBox(height: dim15),
                            ],
                          )
                      ),
                    );
                  },
                ),
              )
          );
        }
    );
  }

  doForward(OrdersModel ordersModel, UserBase userBase) {
    ordersModel.reciverId = userBase.idDoc;
    updateOrder(ordersModel, doDoneForward, doFaild);
  }

  doDoneForward() {
    hideDia();
    Get.find<RepoControllers>().fetchAllOrdersNotYet(stateUser.user.idDoc, () => {});
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const MainClientPage()), (Route<dynamic> route) => false);
  }

  doFaild(failed) {
    hideDia();
    logProv(failed);
  }

  doSendDone() async {
    showDia();
    widget.ordersModel.orderType = 2;
    updateOrderByReciver(widget.ordersModel, sendMessageToUser, doFaild);
  }

  sendMessageToUser() async {
    UserBase? user = await fetchUserDetails(docID: widget.ordersModel.senderId);
    String messageToken = user?.messageToken ?? "";
    if (messageToken.isNotEmpty) {
      sendDoneNotification(messageToken);
    }
    Get.find<RepoControllers>().fetchAllOrdersNotYet(stateUser.user.idDoc, () => {});
    returnPop();
  }

  returnPop() {
    hideDia();
    Navigator.of(context).pop();
  }

  @override
  Widget buildWid(BuildContext context, bool isPortrait, Size size) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: statusBarHeight),
            padding: EdgeInsets.only(left: dim10, right: dim10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: dim5),
                      child: MainBigText(
                          text: widget.ordersModel.senderName,
                          size: dim30
                      ),
                    ),
                  ],
                ),
                widget.ordersModel.orderType == 1 ? Wrap(
                  children: [
                    Container(
                        width: dim40,
                        height: dim40,
                        margin: EdgeInsets.all(dim5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(dim15),
                            color: hintColor),
                        child: IconButton(
                          iconSize: dim45,
                          onPressed: navigateToForward,
                          icon: Icon(Icons.forward, color: Colors.grey, size: dim24),
                        )
                    ),
                    Container(
                        width: dim40,
                        height: dim40,
                        margin: EdgeInsets.all(dim5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(dim20),
                            color: mainColor
                        ),
                        child: IconButton(
                          iconSize: dim45,
                          onPressed: doSendDone,
                          icon: Icon(Icons.done_outline, color: Colors.white, size: dim24),
                        )
                    )
                  ],
                ) : Container(),
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
                      SmallText(text: "\$${widget.ordersModel.totalPrice}", size: dim15),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(dim5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      BigText(text: "Total Paid: ", size: dim15),
                      SmallText(text: "\$${widget.ordersModel.totalPaid}", size: dim15),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
              child: OrderListBody(
                ordersModel: widget.ordersModel,
              )
          )
        ],
      ),
    );
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
          Order food = widget.ordersModel.orders[index];
          return InkWell(
            onTap: () {
              navigateToRecommended(food);
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
                            imageUrl: food.foodImg,
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
                                  text: food.nameFood,
                                  size: dim15
                              ),
                              SizedBox(height: dim10),
                              Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: SmallText(
                                    text: food.count.toString(),
                                    size: dim12,
                                  )
                              ),
                              SizedBox(height: dim15),
                              BigText(
                                  text: "\$ ${food.price * food.count}",
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

  void navigateToRecommended(Order order) async {
    fetchOnFoods(order.foodId, (food) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PopularFoodDetails(product: food, stateNot: Provider.of<FoodDetialsNot>(context, listen: false))));
    }, (p0) => null
    );
  }

}
