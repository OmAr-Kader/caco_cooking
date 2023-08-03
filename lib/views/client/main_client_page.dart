import 'package:caco_cooking/common/colors.dart';
import 'package:caco_cooking/firebase/fire_real_time.dart';
import 'package:caco_cooking/views/client/order_details.dart';
import 'package:caco_cooking/firebase/repo.dart';
import 'package:caco_cooking/models/orders_model.dart';
import 'package:caco_cooking/views/edit_user.dart';
import 'package:caco_cooking/widgets/global_state.dart';
import 'package:caco_cooking/widgets/texter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'edit_foods_page.dart';
import 'package:caco_cooking/widgets/web_key_widget.dart';
import 'package:toggle_switch/toggle_switch.dart';

class MainClientPage extends StatefulWidget {

  const MainClientPage({Key? key}) : super(key: key);

  @override
  State<MainClientPage> createState() => _MainFoodPageState();
}

class _MainFoodPageState extends GlobalMainState<MainClientPage> {

  late RealTimeUpdater realTimeUpdater;

  @override
  initState() {
    super.initState();
    realTimeUpdater = RealTimeUpdater(update: refresh);
    realTimeUpdater.initRealTime();
  }

  @override
  void dispose() {
    realTimeUpdater.cancel();
    super.dispose();
  }

  refresh() {
    RepoControllers e = Get.find<RepoControllers>();
    if (!e.ordersList.two) {
      e.fetchAllOrdersNotYet(stateUser.user.idDoc, () => hideDia());
    }
  }

  @override
  Widget buildWid(BuildContext context, bool isPortrait, Size size) {
    return GetBuilder<RepoControllers>(builder: (repoControllers) {
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
                        child: repoControllers.ordersList.two ? BigText(
                          text: "Orders",
                          size: dim30,
                          col: iconColor3,
                        ) : MainBigText(
                            text: "Orders",
                            size: dim30
                        ),
                      ),
                    ],
                  ),
                  Wrap(
                    children: [
                      Container(
                          width: dim40,
                          height: dim40,
                          margin: EdgeInsets.all(dim5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(dim15),
                              color: repoControllers.ordersList.two ? iconColor3 : mainColor),
                          child: IconButton(
                            iconSize: dim45,
                            onPressed: navigateToEdit,
                            icon: Icon(Icons.edit, color: Colors.white, size: dim24),
                          )
                      ),
                      Container(
                          width: dim40,
                          height: dim40,
                          margin: EdgeInsets.all(dim5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(dim20),
                              color: hintColor
                          ),
                          child: IconButton(onPressed: navigateToProfile, icon: Icon(Icons.perm_identity, color: Colors.grey, size: dim24))
                      )
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
                  Container(),
                  Wrap(
                    children: [
                      ToggleSwitch(
                        minWidth: 120.0,
                        initialLabelIndex: repoControllers.ordersList.two ? 1 : 0,
                        activeBgColor: [repoControllers.ordersList.two ? iconColor3 : mainColor],
                        activeFgColor: Colors.white,
                        inactiveBgColor: const Color.fromRGBO(91, 91, 91, 1.0),
                        inactiveFgColor: Colors.white,
                        totalSwitches: 2,
                        labels: const ['Pending Orders', 'Older Orders'],
                        onToggle: (index) {
                          showDia();
                          if (!repoControllers.ordersList.two) {
                            Get.find<RepoControllers>().fetchAllOrdersDone(stateUser.user.idDoc, () => hideDia());
                          } else {
                            Get.find<RepoControllers>().fetchAllOrdersNotYet(stateUser.user.idDoc, () => hideDia());
                          }
                        },
                      )
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
                child: OrdersPageBody(
                    products: repoControllers.ordersList.one
                )
            )
          ],
        ),
      );
    });
  }


  navigateToEdit() {
    Get.find<RepoControllers>().fetchAllFoods();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const EditFoodsPage()));
  }

  navigateToProfile() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const EditProfilePage()));
  }

}


class OrdersPageBody extends StatefulWidget {
  final List<OrdersModel> products;

  const OrdersPageBody({Key? key, required this.products}) : super(key: key);

  @override
  State<OrdersPageBody> createState() => OrdersPageBodyState();
}

class OrdersPageBodyState extends WebKeyWidgetDim<OrdersPageBody> {


  @override
  Widget buildWidScroll(BuildContext context, bool isPortrait, Size size) => downList(size);

  OrdersModel findProduct(int index) => widget.products[index];

  Widget downList(Size size) {
    return SizedBox(
        child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            addAutomaticKeepAlives: false,
            addRepaintBoundaries: false,
            itemCount: widget.products.length,
            itemBuilder: (context, index) {
              OrdersModel ordersModel = findProduct(index);
              return InkWell(
                onTap: () {
                  navigateToRecommended(ordersModel);
                },
                child: Container(
                    margin: EdgeInsets.only(bottom: dim10, left: dim20, right: dim20),
                    child: Row(
                      children: [
                        Expanded(
                            child: Container(
                              margin: EdgeInsets.only(left: dim10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  BigText(
                                      text: ordersModel.senderLocation.toString(),
                                      size: dim15),
                                  SizedBox(height: dim10),
                                  Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Center(
                                              child: SmallText(
                                                text: ordersModel.createdAtString,
                                                size: dim12,
                                              )
                                          ),
                                          Center(
                                              child: SmallText(
                                                text: "\$${ordersModel.totalPrice}",
                                                size: dim12,
                                              )
                                          ),
                                        ],
                                      )
                                  ),
                                  SizedBox(height: dim15),
                                ],
                              ),
                            )
                        )
                      ],
                    )),
              );
            }));
  }

  void navigateToRecommended(OrdersModel product) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => OrderServerDetails(ordersModel: product)));
  }

}
