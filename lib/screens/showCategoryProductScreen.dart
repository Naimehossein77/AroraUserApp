import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:user/model/item.dart';
import 'package:user/widgets/categoryProductCard.dart';
import 'package:user/widgets/customTextWidget.dart';
import 'package:user/widgets/productCard.dart';

class ShowCategoryProduct extends StatefulWidget {
  const ShowCategoryProduct({Key key, @required this.category})
      : super(key: key);
  final String category;
  @override
  _ShowCategoryProductState createState() => _ShowCategoryProductState();
}

class _ShowCategoryProductState extends State<ShowCategoryProduct> {
  List<ItemModel> model = [];
  bool productAvailable = true;
  void initState() {
    super.initState();
    _searchCategoryProduct();
  }

  void _searchCategoryProduct() async {
    if (widget.category != 'All')
      FirebaseFirestore.instance
          .collection('products')
          .where('category', isEqualTo: widget.category)
          .get()
          .then((value) {
        if (value.docs.isNotEmpty) {
          value.docs.forEach((element) {
            model.add(ItemModel.fromJson(element.data()));
          });
        } else {
          setState(() {
            productAvailable = false;
          });
        }
      }).then((value) {
        setState(() {});
      });
    else {
      FirebaseFirestore.instance.collection('products').get().then((value) {
        if (value.docs.isNotEmpty) {
          value.docs.forEach((element) {
            model.add(ItemModel.fromJson(element.data()));
          });
        } else {
          setState(() {
            productAvailable = false;
          });
        }
      }).then((value) {
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomText(
                    text: 'Category: ' + widget.category,
                    size: 18,
                    color: Colors.blueGrey[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                !productAvailable
                    ? Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          child: CustomText(
                            text: 'No products to Show',
                            size: 14,
                            color: Colors.grey,
                          ),
                        ),
                      )
                    : model.length == 0 || model == null
                        ? Container(
                            height: MediaQuery.of(context).size.height * .80,
                            width: MediaQuery.of(context).size.width,
                            alignment: Alignment.center,
                            child: CircularProgressIndicator())
                        : Expanded(
                            child: GridView.builder(
                                shrinkWrap: true,
                                itemCount: model.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 1,
                                        childAspectRatio: .69),
                                itemBuilder: (_, index) {
                                  return CategoryProductCard(
                                    model: model[index],
                                  );
                                }))
              ],
            )),
      ),
    );
  }
}
