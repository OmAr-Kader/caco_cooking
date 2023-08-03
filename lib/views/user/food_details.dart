import 'package:caco_cooking/common/colors.dart';
import 'package:caco_cooking/common/lifecyle.dart';
import 'package:caco_cooking/firebase/foods.dart';
import 'package:caco_cooking/models/orders_model.dart';
import 'package:caco_cooking/models/food_model.dart';
import 'package:caco_cooking/views/user/order_list_page.dart';
import 'package:caco_cooking/widgets/global_state.dart';
import 'package:caco_cooking/widgets/app_icon.dart';
import 'package:caco_cooking/widgets/texter.dart';
import 'package:caco_cooking/widgets/cached_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_view/photo_view.dart';
import 'package:synchronized/synchronized.dart';

class PopularFoodDetails extends StatefulWidget {

  final FoodModel product;
  final FoodDetialsNot stateNot;

  const PopularFoodDetails({Key? key, required this.product, required this.stateNot}) : super(key: key);

  @override
  State<PopularFoodDetails> createState() => PopularFoodDetailsState();
}

class PopularFoodDetailsState extends GlobalMainState<PopularFoodDetails> {

  Order? newOrder;

  FoodDetialsNot get stateNot => widget.stateNot;

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
    if (!isTooDark(Color(widget.product.picColor))) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent, // optional
        statusBarIconBrightness: Brightness.dark, // Dark == white status bar -- for IOS.
      ));
    }
    super.initState();
    stateNot.ordersModel_ ??= OrdersModel.buildBase(stateUser.user.idDoc);
    stateNot.addListener(callBack);
  }

  @override
  void dispose() {
    resetStatusBar();
    stateNot.removeListener(callBack);
    super.dispose();
  }

  @override
  Widget buildWid(BuildContext context, isPortrait, Size size) {
    FoodModel normalFood = widget.product;
    if (isPortrait) {
      return buildPortrait(normalFood, size);
    } else {
      return buildLandscape(normalFood, size);
    }
  }

  navigatorToOrderList() {
    if (stateNot.ordersModel.orders.isNotEmpty) {
      resetStatusBar();
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => OrderFoodDetails(stateNot: stateNot, fromHistory: false,)));
    } else {
      toastFLutter("Cart is empty");
    }
  }

  navigatorToPhotos() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => FoodImagesPage(images: widget.product.pics)));
  }

  doUpdateStars(int rate, DSack<String, int>? currentRate) async {
    if (currentRate == null) {
      Lock().synchronized(() async {
        await addRate(rate);
        updateFoodsStars(widget.product);
        setState(() {});
      });
    } else {
      Lock().synchronized(() async {
        await updateRate(rate, currentRate);
        updateFoodsStars(widget.product);
        setState(() {});
      });
    }
  }

  addRate(int rate) async {
    widget.product.foodRates.add(DSack(one: stateUser.user.idDoc, two: rate));
    widget.product.stars = calculateRate(widget.product.foodRates).toInt();
  }

  updateRate(int rate, DSack<String, int> currentRate) async {
    await widget.product.foodRates.replaceItem(oldOne: currentRate, newOne: DSack(one: stateUser.user.idDoc, two: rate));
    widget.product.stars = calculateRate(widget.product.foodRates).toInt();
  }

  Widget buildPortrait(FoodModel food, Size size) {
    Order? order = stateNot.ordersModel
        .isContainsThatFood(food.nameFood);
    newOrder = order;
    int count = order?.count ?? 0;
    String userId = stateUser.user.idDoc;
    DSack<String, int>? currentRate = food.foodRates.find((it) => it.one == userId);

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            child: Container(
              width: double.maxFinite,
              height: popularFoodImg,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(dim40),
                    bottomLeft: Radius.circular(dim40)
                ),
              ),
              child: InkWell(
                onTap: navigatorToPhotos,
                child: CustomCachedNetworkImage(
                  height_: popularFoodImg,
                  imageUrl: food.picOne,
                  dim30: dim30,
                ),
              ),
            ),
          ),
          Positioned(
              top: statusBarHeight + dim10,
              left: dim20,
              right: dim20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    child: AppIcon(icon: Icons.arrow_back_ios, size: dim40),
                    onTap: () async {
                      Navigator.pop(context, true);
                    },
                  ),
                  InkWell(
                    onTap: navigatorToOrderList,
                    child: AppIcon(icon: Icons.shopping_cart_outlined, size: dim40),
                  )
                ],
              )),
          Positioned(
              top: popularFoodImg,
              left: 0,
              right: 0,
              height: size.height - popularFoodImg,
              child: Container(
                padding: EdgeInsets.only(left: dim20, right: dim20, top: dim10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        BigText(text: food.nameFood, size: dim20),
                        Padding(
                            padding: EdgeInsets.only(
                                top: dim10, right: dim20, left: dim20
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.monetization_on, color: iconColor3, size: dim20),
                                const SizedBox(
                                  width: 2,
                                ),
                                SmallText(text: food.price.toString(), size: dim15),
                                const SizedBox(
                                  width: 2,
                                ),
                              ],
                            )
                        )
                      ],
                    ),
                    Expanded(
                        flex: 1,
                        child: Container(
                          padding: EdgeInsets.only(bottom: pageEditTextContainer),
                          height: double.infinity,
                          child:
                          SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child:
                            Column(
                              children: [
                                ExpansionTile(
                                  title: Row(
                                    children: [
                                      Wrap(
                                          children: List.generate(5, (index) {
                                            if (index < food.stars) {
                                              return const Icon(Icons.star, color: goldColor, size: 15);
                                            } else {
                                              return const Icon(Icons.star_border, color: iconColor3, size: 15);
                                            }
                                          }
                                          )
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      SmallText(text: "${food.stars}", size: dim12),
                                      SizedBox(width: dim10),
                                      food.foodRates.isNotEmpty ? SmallText(text: "(${food.foodRates.length})", size: dim12) : Container(),
                                    ],
                                  ),
                                  tilePadding: EdgeInsets.zero,
                                  childrenPadding: EdgeInsets.zero,
                                  children: [
                                    Wrap(
                                        children: List.generate(5, (index) {
                                          if (currentRate != null) {
                                            if (index < currentRate.two) {
                                              return Padding(
                                                padding: EdgeInsets.only(bottom: dim5),
                                                child: IconButton(
                                                    icon: const Icon(Icons.star, color: goldColor, size: 50),
                                                    onPressed: () {
                                                      doUpdateStars(index + 1, currentRate);
                                                    }
                                                ),
                                              );
                                            } else {
                                              return Padding(
                                                padding: EdgeInsets.only(bottom: dim5),
                                                child: IconButton(
                                                    icon: const Icon(Icons.star_border, color: iconColor3, size: 50),
                                                    onPressed: () {
                                                      doUpdateStars(index + 1, currentRate);
                                                    }
                                                ),
                                              );
                                            }
                                          } else {
                                            return Padding(
                                              padding: EdgeInsets.only(bottom: dim5),
                                              child: IconButton(
                                                  icon: const Icon(Icons.star_border, color: iconColor3, size: 50),
                                                  onPressed: () {
                                                    doUpdateStars(index + 1, currentRate);
                                                  }
                                              ),
                                            );
                                          }
                                        }
                                        )
                                    )
                                  ],
                                ),
                                SizedBox(height: dim10),
                                SmallTextMulti(text: food.description, size: dim15),
                              ],
                            ),
                          ),
                        )
                    ),
                  ],
                ),
              ))
        ],
      ),
      bottomNavigationBar: Container(
        height: bottomNavigationBarHeigh,
        padding: EdgeInsets.only(
            top: dim10, bottom: dim10, left: dim10, right: dim10),
        decoration: BoxDecoration(
            color: hintColor,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(dim30),
                topRight: Radius.circular(dim30))
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Card(
              elevation: 10,
              color: fetchBackColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(dim30),
              ),
              child: Padding(
                padding: EdgeInsets.all(dim5),
                child: Row(
                  children: [
                    InkWell(
                      customBorder: const CircleBorder(),
                      child: SizedBox(height: 50, width: 50, child: Icon(Icons.remove, color: findTextColor, size: 35)),
                      onTap: () {
                        stateNot.removeFromOrders(food);
                      },
                    ),
                    SizedBox(width: dim10),
                    BigText(
                      text: count.toString(),
                      size: dim20,
                    ),
                    SizedBox(width: dim10),
                    InkWell(
                      customBorder: const CircleBorder(),
                      child: SizedBox(height: 50, width: 50, child: Icon(Icons.add, color: findTextColor, size: 35)),
                      onTap: () {
                        stateNot.addFromOrders(food);
                      },
                    )
                  ],
                ),
              ),
            ),
            Card(
              elevation: 10,
              color: mainColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(dim20),
              ),
              child: InkWell(
                  borderRadius: BorderRadius.all(Radius.circular(dim20)),
                  onTap: navigatorToOrderList,
                  child: Padding(
                    padding: EdgeInsets.all(dim5),
                    child: SizedBox(
                      height: 50,
                      child: Center(
                        child: BigText(
                          text: "\$ ${count * (order?.price ?? 0)} In Cart",
                          size: dim20,
                          col: mainTxtColor,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  )
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildLandscape(FoodModel food, Size size) {
    Order? order = stateNot.ordersModel
        .isContainsThatFood(food.nameFood);
    int count = order?.count ?? 0;

    String userId = stateUser.user.idDoc;
    DSack<String, int>? currentRate = food.foodRates.find((it) => it.one == userId);

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            child: Container(
              width: double.maxFinite,
              height: popularFoodImg,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(dim40),
                    bottomLeft: Radius.circular(dim40)
                ),
              ),
              child: InkWell(
                onTap: navigatorToPhotos,
                child: CustomCachedNetworkImage(
                  height_: popularFoodImg,
                  imageUrl: food.picOne,
                  dim30: dim30,
                ),
              ),
            ),
          ),
          Positioned(
              top: statusBarHeight + dim10,
              left: dim20,
              right: dim20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    child: AppIcon(icon: Icons.arrow_back_ios, size: dim40),
                    onTap: () async {
                      Navigator.pop(context, true);
                    },
                  ),
                  InkWell(
                    onTap: navigatorToOrderList,
                    child: AppIcon(icon: Icons.shopping_cart_outlined, size: dim40),
                  )
                ],
              )),
          Positioned(
              top: popularFoodImg,
              left: 0,
              right: 0,
              height: size.height - popularFoodImg,
              child: Container(
                padding: EdgeInsets.only(left: dim20, right: dim20, top: dim10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        BigText(text: food.nameFood, size: dim20),
                        Row(
                          children: [
                            Icon(Icons.monetization_on, color: iconColor3, size: dim20),
                            const SizedBox(
                              width: 2,
                            ),
                            SmallText(text: food.price.toString(), size: dim15),
                          ],
                        ),
                      ],
                    ),
                    Expanded(
                        flex: 1,
                        child: Container(
                          padding: EdgeInsets.only(bottom: pageEditTextContainer),
                          height: double.infinity,
                          child:
                          SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child:
                            Column(
                              children: [
                                ExpansionTile(
                                  title: Row(
                                    children: [
                                      Wrap(
                                          children: List.generate(5, (index) {
                                            if (index < food.stars) {
                                              return const Icon(Icons.star, color: goldColor, size: 15);
                                            } else {
                                              return const Icon(Icons.star_border, color: iconColor3, size: 15);
                                            }
                                          }
                                          )
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      SmallText(text: "${food.stars}", size: dim12),
                                      SizedBox(width: dim10),
                                      food.foodRates.isNotEmpty ? SmallText(text: "(${food.foodRates.length})", size: dim12) : Container(),
                                    ],
                                  ),
                                  tilePadding: EdgeInsets.zero,
                                  childrenPadding: EdgeInsets.zero,
                                  children: [
                                    Wrap(
                                        children: List.generate(5, (index) {
                                          if (currentRate != null) {
                                            if (index < currentRate.two) {
                                              return Padding(
                                                padding: EdgeInsets.only(bottom: dim5),
                                                child: IconButton(
                                                    icon: const Icon(Icons.star, color: goldColor, size: 50),
                                                    onPressed: () {
                                                      doUpdateStars(index + 1, currentRate);
                                                    }
                                                ),
                                              );
                                            } else {
                                              return Padding(
                                                padding: EdgeInsets.only(bottom: dim5),
                                                child: IconButton(
                                                    icon: const Icon(Icons.star_border, color: iconColor3, size: 50),
                                                    onPressed: () {
                                                      doUpdateStars(index + 1, currentRate);
                                                    }
                                                ),
                                              );
                                            }
                                          } else {
                                            return Padding(
                                              padding: EdgeInsets.only(bottom: dim5),
                                              child: IconButton(
                                                  icon: const Icon(Icons.star_border, color: iconColor3, size: 50),
                                                  onPressed: () {
                                                    doUpdateStars(index + 1, currentRate);
                                                  }
                                              ),
                                            );
                                          }
                                        }
                                        )
                                    )
                                  ],
                                ),
                                SmallTextMulti(text: food.description, size: dim15),
                              ],
                            ),
                          ),
                        )),
                  ],
                ),
              ))
        ],
      ),
      bottomNavigationBar: Container(
        height: pageEditTextContainer,
        padding: EdgeInsets.all(dim5),
        decoration: BoxDecoration(
            color: hintColor,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(dim10),
                topRight: Radius.circular(dim10))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Card(
              elevation: 10,
              color: fetchBackColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(dim20),
              ),
              child: Padding(
                padding: EdgeInsets.all(dim5),
                child: Row(
                  children: [
                    InkWell(
                      customBorder: const CircleBorder(),
                      child: SizedBox(height: dim30, width: dim30, child: Icon(Icons.remove, color: findTextColor, size: dim20)),
                      onTap: () {
                        stateNot.removeFromOrders(food);
                      },
                    ),
                    SizedBox(width: dim10),
                    BigText(
                      text: count.toString(),
                      size: dim20,
                    ),
                    SizedBox(width: dim10),
                    InkWell(
                      customBorder: const CircleBorder(),
                      child: SizedBox(height: dim30, width: dim30, child: Icon(Icons.add, color: findTextColor, size: dim20)),
                      onTap: () {
                        stateNot.addFromOrders(food);
                      },
                    )
                  ],
                ),
              ),
            ),
            Card(
              elevation: 10,
              color: mainColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(dim20),
              ),
              child: InkWell(
                onTap: navigatorToOrderList,
                borderRadius: BorderRadius.all(Radius.circular(dim20)),
                child: Padding(
                  padding: EdgeInsets.all(dim5),
                  child: SizedBox(
                    height: dim30,
                    child: Center(
                      child: BigText(
                        text: "\$ ${count * (order?.price ?? 0)} In Cart",
                        size: dim20,
                        col: mainTxtColor,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

}

class FoodImagesPage extends StatefulWidget {

  final List<String> images;

  const FoodImagesPage({Key? key, required this.images}) : super(key: key);

  @override
  State<FoodImagesPage> createState() => FoodImagesState();
}

class FoodImagesState extends GlobalMainState<FoodImagesPage> {

  @override
  Widget buildWid(BuildContext context, bool isPortrait, Size size) {
    return PageView.builder(
        itemCount: widget.images.length,
        itemBuilder: (context, pos) {
          return isPortrait ? SizedBox(
            width: size.width,
            child: CustomCachedNetworkImage(
              imageUrl: widget.images[pos],
              height_: pageViewContainer,
              dim30: dim30,
              imageBuilder: (_, image) {
                return PhotoView(
                  imageProvider: image,
                  tightMode: false,
                  minScale: PhotoViewComputedScale.contained,
                );
              },
            ),
          ) : SizedBox(
            height: size.height,
            child: CustomCachedNetworkImage(
              imageUrl: widget.images[pos],
              height_: pageViewContainer,
              dim30: dim30,
              imageBuilder: (_, image) {
                return PhotoView(
                  imageProvider: image,
                  enablePanAlways: true,
                );
              },
            ),
          );
        }
    );
  }

}

class FoodDetialsNot extends ChangeNotifier {
  OrdersModel? ordersModel_;

  FoodDetialsNot({required this.ordersModel_});

  OrdersModel get ordersModel => ordersModel_!;

  reset() async {
    ordersModel.orders = [];
    ordersModel.totalPaid = 0;
    ordersModel.totalPrice = 0;
    ordersModel.totalPrice = 0;
    notifyListeners();
  }

  addFromOrders(FoodModel food) {
    Order? order = ordersModel.isContainsThatFood(food.nameFood);
    if (order != null) {
      order.count = order.count + 1;
      ordersModel.totalPrice = ordersModel.totalPrice + food.price;
      notifyListeners();
    } else {
      ordersModel.orders.add(Order.builder(food));
      ordersModel.totalPrice = ordersModel.totalPrice + food.price;
      notifyListeners();
    }
  }

  removeFromOrders(FoodModel food) {
    if (ordersModel.orders.isEmpty) {
      toastFLutter("Not added Yet");
      return;
    }
    Order? order = ordersModel.isContainsThatFood(food.nameFood);
    if (order != null) {
      if (order.count > 1) {
        order.count = order.count - 1;
        ordersModel.totalPrice = ordersModel.totalPrice - food.price;
        notifyListeners();
      } else {
        if (ordersModel.orders.length != 1) {
          ordersModel.orders.remove(order);
        } else {
          ordersModel.orders = [];
        }
        ordersModel.totalPrice = ordersModel.totalPrice - food.price;
        notifyListeners();
      }
    } else {
      toastFLutter("Not added Yet");
    }
  }
}
