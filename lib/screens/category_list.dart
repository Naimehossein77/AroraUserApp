import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user/Config/config.dart';
import 'package:user/Counters/cartitemcounter.dart';
import 'package:user/Widgets/myDrawer.dart';
import 'package:user/screens/category_products.dart';

class CategoryList extends StatelessWidget {
  static var selectedCategory;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        
        flexibleSpace: Container(
          decoration: new BoxDecoration(
            gradient: new LinearGradient(
              colors: [Colors.deepOrangeAccent, Colors.deepOrange],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            ),
          ),
        ),
        title: Text(
          "Arora Brush",
          style: TextStyle(
            fontSize: 22.0,
            color: Colors.white,
            //fontFamily: "NotoSerifBold",
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 4, top: 4),
            child: Stack(
              children: [
                IconButton(
                    icon: Icon(
                      Icons.shopping_cart,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      // Route route =
                      //     MaterialPageRoute(builder: (c) => CartPage());
                      // Navigator.push(context, route);
                    }),
                Positioned(
                  child: Stack(
                    children: [
                      Icon(
                        Icons.brightness_1_outlined,
                        size: 20.0,
                        color: Colors.white,
                      ),
                      Positioned(
                        top: 3.0,
                        bottom: 4.0,
                        left: 6.0,
                        child: Consumer<CartItemCounter>(
                          builder: (context, counter, _) {
                            return Text(
                              counter.count.toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.0,
                                fontWeight: FontWeight.w500,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      drawer: MyDrawer(),
      body: ListView.builder(
          itemCount: EcommerceApp.category.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: Icon(Icons.category),
              title: Text(EcommerceApp.category[index]),
              onTap: () {
                selectedCategory = EcommerceApp.category[index];
                print(EcommerceApp.category[index]);
                Route route =
                    MaterialPageRoute(builder: (c) => CategoryProducts());
                Navigator.push(context, route);
              },
            );
          }),
    );
  }
}
