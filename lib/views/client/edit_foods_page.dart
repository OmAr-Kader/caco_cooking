import 'package:caco_cooking/common/colors.dart';
import 'package:caco_cooking/common/lifecyle.dart';
import 'package:caco_cooking/firebase/repo.dart';
import 'package:caco_cooking/models/food_model.dart';
import 'package:caco_cooking/widgets/cached_image.dart';
import 'package:caco_cooking/widgets/global_state.dart';
import 'package:caco_cooking/widgets/texter.dart';
import 'package:caco_cooking/widgets/web_key_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'add_foods_page.dart';

class EditFoodsPage extends StatefulWidget {

  const EditFoodsPage({Key? key}) : super(key: key);

  @override
  State<EditFoodsPage> createState() => EditFoodsPageState();
}


class EditFoodsPageState extends GlobalMainState<EditFoodsPage> {

  @override
  Widget buildWid(BuildContext context, bool isPortrait, Size size) {
    return GetBuilder<RepoControllers>(builder: (repoControllers) {
      return Scaffold(
        body: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: statusBarHeight),
              padding: EdgeInsets.only(left: dim20, right: dim20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: dim10),
                        child: MainBigText(
                            text: "Edit Foods",
                            size: dim30),
                      ),
                    ],
                  ),
                  Wrap(
                    children: [
                      InkWell(
                          onTap: navigateToAdd,
                          child: Container(
                            width: dim40,
                            height: dim40,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(dim15),
                                color: mainColor),
                            child: Icon(Icons.add, color: Colors.white, size: dim24),
                          ))
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
                child: FoodEditBody(
                    products: repoControllers.foodsList.resort((a, b) => b.createdAt.compareTo(a.createdAt))
                )
            )
          ],
        ),
      );
    });
  }

  navigateToAdd() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const AddFoodsPage()));
  }

}

class FoodEditBody extends StatefulWidget {
  final List<FoodModel> products;

  const FoodEditBody({Key? key, required this.products}) : super(key: key);

  @override
  State<FoodEditBody> createState() => _FoodPageBodyState();
}

class _FoodPageBodyState extends WebKeyWidgetDim<FoodEditBody> {

  double scaleFactor = 0.8;

  @override
  Widget buildWidScroll(BuildContext context, bool isPortrait, Size size) {
    return SizedBox(
        child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            addAutomaticKeepAlives: false,
            addRepaintBoundaries: false,
            itemCount: widget.products.length,
            itemBuilder: (context, index) {
              FoodModel food = widget.products[index];
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
                                  SizedBox(height: dim5),
                                  Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: SmallText(
                                        text: food.description.toString(),
                                        size: dim12,
                                      )
                                  ),
                                  SizedBox(height: dim15),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          right: dim15, left: dim15
                                      ),
                                      child: Row(
                                        children: [
                                          Wrap(
                                              children: List.generate(food.stars, (index) => const Icon(Icons.star, color: mainColor, size: 15))
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          SmallText(
                                              text: food.stars.toString(),
                                              size: dim12
                                          ),
                                          SizedBox(width: dim10),
                                          food.foodRates.isNotEmpty ? SmallText(text: "(${food.foodRates.length})", size: dim12) : Container(),
                                        ],
                                      )
                                  )
                                ],
                              ),
                            ))
                      ],
                    )),
              );
            }));
  }

  void navigateToDetail(FoodModel product) async {
    /*await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PopularFoodDetails(product: product)));*/
  }

  void navigateToRecommended(FoodModel product) async {
    /*await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => RecommendedFoodDetails(product: product)));*/
  }

}
