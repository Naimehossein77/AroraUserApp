import 'package:flutter/material.dart';
import 'package:user/Config/method.dart';
import 'package:user/model/item.dart';
import 'package:user/screens/product_page.dart';
import 'package:user/widgets/customTextWidget.dart';

class ProductCard extends StatelessWidget {
  final ItemModel model;
  ProductCard({this.model});
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      elevation: 7.0,
      margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
      clipBehavior: Clip.antiAlias,
      child: Container(
        height: 180,
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 8),
              child: Container(
                height: 170,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        Route route = MaterialPageRoute(
                            builder: (_) => ProductPage(itemModel: model));
                        Navigator.push(context, route);
                      },
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(
                              model.thumbnailUrl[0],
                              height: 120,
                              width: 120,
                              fit: BoxFit.fill,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: Container(
                              height: 110,
                              //color: Colors.white,
                              padding: EdgeInsets.all(8),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    text: model.title,
                                    size: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  // CustomText(
                                  //   text: '${model.shortInfo}',
                                  //   size: 8,
                                  // ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.shopping_bag_outlined,
                                        size: 16,
                                        color: Colors.grey,
                                      ),
                                      CustomText(
                                        text: '999+ | ',
                                        size: 10,
                                        color: Colors.grey,
                                      ),
                                      Icon(
                                        Icons.favorite_outline_outlined,
                                        color: Colors.grey,
                                        size: 16,
                                      ),
                                      CustomText(
                                        text: '120',
                                        color: Colors.grey,
                                        size: 10,
                                      )
                                    ],
                                  ),
                                  CustomText(
                                    text: 'DisCount: ${model.discount}',
                                    size: 12,
                                  ),
                                  if (model.discount != 0)
                                    RichText(
                                      text: new TextSpan(
                                        children: <TextSpan>[
                                          new TextSpan(
                                            text: '₹${model.price}',
                                            style: new TextStyle(
                                              color: Colors.grey[500],
                                              fontSize: 13,
                                              decoration:
                                                  TextDecoration.lineThrough,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  CustomText(
                                    text: '₹${model.price}',
                                    size: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      thickness: 1,
                    ),
                    Container(
                      height: 30,
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Icon(Icons.favorite_border_outlined),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Container(
                                child: TextButton(
                                  onPressed: () {
                                    checkItemInCart(model, model.shortInfo,
                                        model.price.toString(), context, false);
                                  },
                                  child: Container(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        CustomText(
                                          text: 'ADD TO CART',
                                          size: 14,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 0, left: 8),
                                          child: Icon(
                                            Icons.shopping_cart,
                                            color: Colors.deepOrange,
                                            size: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
