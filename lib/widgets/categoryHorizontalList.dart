import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:user/Config/config.dart';
import 'package:user/screens/showCategoryProductScreen.dart';
import 'package:user/widgets/customTextWidget.dart';

class CategoryHorizontalList extends StatelessWidget {
  const CategoryHorizontalList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      color: Colors.grey[200],
      child: Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 10, left: 10),
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: EcommerceApp.category.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (_, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                ShowCategoryProduct(
                                    category: EcommerceApp.category[index])));
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.red),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.asset('images/c1.jpg'),
                        ),
                      ),
                      CustomText(
                        text: EcommerceApp.category[index] + '\t',
                        size: 13,
                        color: Colors.black87,
                      ),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }
}
