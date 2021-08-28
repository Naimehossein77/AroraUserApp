import 'package:flutter/material.dart';
import 'package:user/Config/method.dart';
import 'package:user/model/item.dart';
import 'package:user/screens/product_page.dart';
import 'package:user/widgets/customTextWidget.dart';

class CategoryProductCard extends StatelessWidget {
  final ItemModel model;
  CategoryProductCard({this.model});
  @override
  Widget build(BuildContext context) {
    // double discount1 = ((model.mrp.toDouble() - model.price.toDouble()) /
    //         model.mrp.toDouble()) *
    //     100.0;
    // int discount = discount1.toInt().ceil();
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 8),
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(5)),
                  height: 230,
                  width: 140,
                  child: InkWell(
                    onTap: () {
                      Route route = MaterialPageRoute(
                          builder: (_) => ProductPage(itemModel: model));
                      Navigator.push(context, route);
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      // mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5),
                              topRight: Radius.circular(5)),
                          child: Image.network(
                            model.thumbnailUrl[0],
                            height: 150,
                            width: 140,
                            fit: BoxFit.fill,
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            SizedBox(
                              width: 5,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5.0, top: 8),
                              child: CustomText(
                                overflow: TextOverflow.ellipsis,
                                text: model.title,
                                size: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            // RichText(
                            //   text: new TextSpan(
                            //     children: <TextSpan>[
                            //       new TextSpan(
                            //         text: 'MRP: ₹${model.price}',
                            //         style: new TextStyle(
                            //           color: Colors.grey[500],
                            //           fontSize: 12,
                            //           decoration: TextDecoration.lineThrough,
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5, bottom: 5),
                              child: RichText(
                                text: new TextSpan(
                                  children: <TextSpan>[
                                    new TextSpan(
                                      text: 'MRP: ₹${model.mrp}',
                                      style: new TextStyle(
                                        color: Colors.grey[500],
                                        fontSize: 11,
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            RichText(
                              text: new TextSpan(
                                children: <TextSpan>[
                                  new TextSpan(
                                    text: 'Price: ',
                                    style: new TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  new TextSpan(
                                    text: '₹ ${model.price}',
                                    style: new TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Padding(
                            //     padding: const EdgeInsets.only(left: 5.0, top: 0),
                            //     child: CustomText(
                            //       overflow: TextOverflow.ellipsis,
                            //       text: model.longDescription,
                            //       size: 12,
                            //     )),
                            SizedBox(
                              height: 12,
                            ),
                          ],
                        ),

                        // Padding(
                        //   padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //     children: [
                        //       CustomText(
                        //         text: '₹' + (model.price).toString(),
                        //         color: Theme.of(context).primaryColor,
                        //         size: 14,
                        //         fontWeight: FontWeight.w500,
                        //       ),
                        //       Container(
                        //         alignment: Alignment.center,
                        //         height: 20,
                        //         width: 60,
                        //         decoration: BoxDecoration(
                        //             borderRadius: BorderRadius.circular(5),
                        //             color: Colors.red.withOpacity(.1)),
                        //         child: CustomText(
                        //           text: '₹' +
                        //               (model.discount).toString() +
                        //               ' Off',
                        //           color: Theme.of(context).primaryColor,
                        //           size: 12,
                        //           fontWeight: FontWeight.normal,
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // )
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    alignment: Alignment.center,
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black.withOpacity(.65)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomText(
                          text: '${model.discount}%',
                          size: 10,
                          color: Colors.white,
                        ),
                        CustomText(
                          text: 'OFF',
                          size: 10,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
