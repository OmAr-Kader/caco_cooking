import 'package:caco_cooking/common/colors.dart';
import 'package:caco_cooking/common/lifecyle.dart';
import 'package:caco_cooking/firebase/orders.dart';
import 'package:caco_cooking/firebase/repo.dart';
import 'package:caco_cooking/models/orders_model.dart';
import 'package:caco_cooking/models/food_model.dart';
import 'package:caco_cooking/views/edit_user.dart';
import 'package:caco_cooking/views/user/food_details.dart';
import 'package:caco_cooking/views/user/order_list_page.dart';
import 'package:caco_cooking/widgets/cached_image.dart';
import 'package:caco_cooking/widgets/global_state.dart';
import 'package:caco_cooking/widgets/texter.dart';
import 'package:caco_cooking/widgets/web_key_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:provider/provider.dart';

import 'cart_history.dart';

class MainFoodPage extends StatefulWidget {

  const MainFoodPage({super.key});

  @override
  State<MainFoodPage> createState() => _MainFoodPageState();
}

class _MainFoodPageState extends GlobalMainState<MainFoodPage> {

  @override
  Widget buildWid(BuildContext context, bool isPortrait, Size size) {
    return GetBuilder<RepoControllers>(builder: (repoControllers) {
      return Scaffold(
        body: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: statusBarHeight, bottom: dim15, left: dim5, right: dim5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Center(
                    child: MainBigText(
                        text: "Coco Cooking",
                        size: dim30),
                  ),
                  Wrap(
                    children: [
                      Container(
                        width: dim40,
                        height: dim40,
                        margin: EdgeInsets.all(dim5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(dim15),
                            color: mainColor
                        ),
                        child: Icon(Icons.search, color: Colors.white, size: dim24),
                      ),
                      Container(
                          width: dim40,
                          height: dim40,
                          margin: EdgeInsets.all(dim5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(dim40 / 2),
                            color: const Color(0xd2fcf4e4),
                          ),
                          child: Center(
                            child:
                            IconButton(
                              iconSize: dim45,
                              onPressed: navigatToCart,
                              icon: Icon(Icons.shopping_cart_outlined, color: const Color(0xFF756d54), size: dim40 / 2),
                            ),
                          )
                      ),
                      PopupMenuButton<int>(
                        itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<int>>[
                          PopupMenuItem<int>(
                            value: 0,
                            child: SmallText(text: "Profile", size: dim15),
                          ),
                          PopupMenuItem<int>(
                            value: 1,
                            child: SmallText(text: "Cart history", size: dim15),
                          ),
                        ],
                        onSelected: (i) {
                          if (i == 0) {
                            navigateToProfile();
                          } else {
                            displayCartHistory();
                          }
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(dim20),
                        ),
                        elevation: 20,
                        color: hintColorFull,
                        child: Container(
                            width: dim40,
                            height: dim40,
                            margin: EdgeInsets.all(dim5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(dim20),
                                color: hintColor
                            ),
                            child: Icon(Icons.menu, color: Colors.grey, size: dim24)
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            /*Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Center(),
                Wrap(
                  children: [
                  ],
                ),
              ],
            ),*/
            Expanded(
                child: FoodPageBody(
                  foodNormal: repoControllers.foodsList.resort((a, b) => b.createdAt.compareTo(a.createdAt)),
                  foodRecommended: repoControllers.foodsListRecommended.resort((a, b) => b.createdAt.compareTo(a.createdAt)),
                )
            )
          ],
        ),
      );
    });
  }

  navigateToProfile() async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) {
              return const EditProfilePage();
            }));
  }

  navigatToCart() {
    FoodDetialsNot stateNot = Provider
        .of<FoodDetialsNot>(context, listen: false);

    OrdersModel? ordersModel = stateNot.ordersModel_;
    if (ordersModel != null && ordersModel.orders.isNotEmpty) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => OrderFoodDetails(stateNot: stateNot, fromHistory: false,)));
    } else {
      toastFLutter("Cart is empty");
    }
  }

  displayCartHistory() {
    showDia();
    fetchAllOrdersForOneUser(stateUser.user.idDoc, navigatToCartHistory, (p0) => hideDia());
  }

  navigatToCartHistory(list) {
    hideDia();
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => CardHistoryPage(orders: list,)));
  }

}

class FoodPageBody extends StatefulWidget {
  final List<FoodModel> foodNormal;
  final List<FoodModel> foodRecommended;

  const FoodPageBody({Key? key, required this.foodNormal, required this.foodRecommended}) : super(key: key);

  @override
  State<FoodPageBody> createState() => _FoodPageBodyState();
}

class _FoodPageBodyState extends WebKeyWidgetDim<FoodPageBody> {
  PageController pageController = PageController(initialPage: 0, keepPage: true, viewportFraction: 0.85);

  late PageNotifierFood stateNot;

  double scaleFactor = 0.8;

  @override
  void initState() {
    stateNot = emptyStateNot();
    super.initState();
    pageController.addListener(() {
      try {
        stateNot.currentPage = pageController.page ?? 0;
      } catch (_) {}
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  PageNotifierFood emptyStateNot() => PageNotifierFood(update: setState);

  @override
  Widget buildWidScroll(BuildContext context, bool isPortrait, Size size) {
    return Column(
      children: [
        SizedBox(
          height: pageViewAllContainer,
          child: PageView.builder(
              physics: const BouncingScrollPhysics(),
              controller: pageController,
              itemCount: widget.foodRecommended.length,
              itemBuilder: (context, pos) {
                return widPageItm(pos);
              }),
        ),
        SizedBox(height: dim20),
        Container(
            margin: EdgeInsets.only(left: dim10, right: dim10),
            child: DotsIndicator(
                mainAxisAlignment: MainAxisAlignment.center,
                dotsCount: widget.foodRecommended.isEmpty ? 1 : widget.foodRecommended.length,
                position: stateNot.currentPage,
                decorator: DotsDecorator(
                  activeColor: mainColor,
                  size: const Size.square(9.0),
                  activeSize: const Size(18.0, 9.0),
                  activeShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                ))),
        SizedBox(height: dim30),
        Container(
          margin: EdgeInsets.only(
            left: dim30,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              BigText(text: "Popular", size: dim20),
              SizedBox(width: dim10),
              Container(
                  margin: const EdgeInsets.only(bottom: 2),
                  child: BigText(text: ".", size: dim20)),
              SizedBox(width: dim10),
              Container(
                  margin: const EdgeInsets.only(bottom: 2),
                  child: SmallText(
                      text: "Food Pairing",
                      size: dim12
                  )),
            ],
          ),
        ),
        downList()
      ],
    );
  }

  FoodModel findNormal(int index) => widget.foodNormal[index];

  FoodModel findRecommended(int index) => widget.foodRecommended[index];

  Widget downList() {
    return SizedBox(
        height: widget.foodNormal.length * (listViewImage + dim20) + dim45,
        child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            addAutomaticKeepAlives: false,
            addRepaintBoundaries: false,
            itemCount: widget.foodNormal.length,
            itemBuilder: (context, index) {
              FoodModel food = findNormal(index);
              return InkWell(
                onTap: () {
                  navigateToDetail(food);
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
                                imageUrl: food.picOne,
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
                                  BigText(text: food.nameFood, size: dim20),
                                  SizedBox(height: dim5),
                                  Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: SmallText(
                                        text: food.description.toString(),
                                        size: dim12,
                                        maxLines: 2,
                                        overflow: TextOverflow.clip,
                                      )
                                  ),
                                  SizedBox(height: dim15),
                                  Row(
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
                                ],
                              ),
                            ))
                      ],
                    )),
              );
            }));
  }

  /*Widget widPageItm(int index) {
    FoodModel normalFood = findRecommended(index);
    return Transform(
      transform: transEffect(index),
      child: Stack(
        children: [
          Container(
            height: pageViewContainer,
            margin: EdgeInsets.only(left: dim10, right: dim10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(dim30),
              child: Center(
                child: CustomCachedNetworkImage(
                  height_: pageViewContainer,
                  imageUrl: normalFood.img,
                  dim30: dim30,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Card(
                elevation: 10,
                margin: EdgeInsets.only(left: dim30, right: dim30, bottom: dim20),
                shadowColor: mainColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(dim30),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.all(Radius.circular(dim30)),
                  onTap: () {
                    navigateToDetail(normalFood);
                  },
                  child: SizedBox(
                    height: pageViewTextContainer,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                            padding: EdgeInsets.only(
                                top: dim20, right: dim20, left: dim20
                            ),
                            child: BigText(text: normalFood.nameFood, size: dim15)
                        ),
                        SizedBox(height: dim10),
                        Padding(
                            padding: EdgeInsets.only(
                                right: dim15, left: dim15
                            ),
                            child: Row(
                              children: [
                                Wrap(
                                    children: List.generate(normalFood.stars, (index) => const Icon(Icons.star, color: mainColor, size: 15))
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                SmallText(
                                    text: normalFood.stars.toString(),
                                    size: dim12
                                ),
                                SizedBox(width: dim10),
                                SmallText(text: "1287", size: dim12),
                                SizedBox(width: dim10),
                                SmallText(text: "comments", size: dim12)
                              ],
                            )
                        ),
                        SizedBox(height: dim10),
                        Padding(
                          padding: EdgeInsets.only(
                              right: dim10, left: dim10
                          ),
                          child: LoactionTimeWidget(
                              product: normalFood,
                              dim20: dim20,
                              dim12: dim12
                          ),
                        )
                        ,
                        SizedBox(height: dim10),
                      ],
                    ),
                  ),
                )),
          )
        ],
      ),
    );
  }*/

  Widget widPageItm(int index) {
    FoodModel food = findRecommended(index);
    return Transform(
      transform: transEffect(index),
      child: InkWell(
        onTap: () {
          navigateToDetail(food);
        },
        child: Stack(
          children: [
            Container(
              height: pageViewContainer,
              margin: EdgeInsets.only(left: dim10, right: dim10, bottom: pageViewTextContainer + 5),
              child: ClipRRect(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(dim30), topRight: Radius.circular(dim30)),
                child: Center(
                  child: CustomCachedNetworkImage(
                    height_: double.infinity,
                    imageUrl: food.picOne,
                    dim30: dim30,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Card(
                  elevation: 7,
                  margin: EdgeInsets.only(left: dim10, right: dim10, bottom: dim10),
                  shadowColor: mainColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(dim30), bottomRight: Radius.circular(dim30)),
                  ),
                  child: SizedBox(
                    height: pageViewTextContainer,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                            padding: EdgeInsets.only(
                                top: dim5, right: dim20, left: dim20
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                BigText(text: food.nameFood, size: dim15),
                                Wrap(
                                  children: [
                                    Center(
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
                              ],
                            )
                        ),
                        SizedBox(height: dim5 / 2),
                        Padding(
                            padding: EdgeInsets.only(left: dim30, right: dim30),
                            child: SmallText(
                              text: food.description.toString(),
                              size: dim12,
                              maxLines: 2,
                              overflow: TextOverflow.clip,
                            )
                        ),
                      ],
                    ),
                  )
              ),
            )
          ],
        ),
      ),
    );
  }

  void navigateToDetail(FoodModel product) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                PopularFoodDetails(product: product, stateNot: Provider.of<FoodDetialsNot>(context, listen: false)
                )
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
      var currentScale =
          scaleFactor + (stateNot.currentPage - index + 1) * (1 - scaleFactor);
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

class PageNotifierFood {
  Function update;

  PageNotifierFood({required this.update});

  double _currentPage = 0.0;

  double get currentPage => _currentPage;

  set currentPage(double newValue) {
    update(() => { _currentPage = newValue});
  }
}
