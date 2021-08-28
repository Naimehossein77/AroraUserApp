import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:user/Widgets/myDrawer.dart';
import 'package:user/model/item.dart';
import 'package:user/widgets/customAppBar.dart';
import 'package:user/widgets/productCard.dart';

var inputText = "";

class SearchProduct extends StatefulWidget {
  @override
  _SearchProductState createState() => new _SearchProductState();
}

class _SearchProductState extends State<SearchProduct> {
  Future<QuerySnapshot> docList;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: MyAppBar(),
            drawer: MyDrawer(),
            body: SingleChildScrollView(
              child: ListView(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: [searchWidget(), SearchList()],
              ),
            )));
  }

  Widget searchWidget() {
    return Container(
      height: 50,
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: TextFormField(
        style: TextStyle(fontSize: 18.0),
        textAlignVertical: TextAlignVertical.center,
        onChanged: (value) {
          setState(() {
            inputText = value.toLowerCase();
          });
        },
        // maxLength: maxLength,
        keyboardType: TextInputType.url,
        // controller: controller,
        // obscureText: isObsecure,
        cursorColor: Theme.of(context).primaryColor,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 15.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(
              color: Colors.grey,
              style: BorderStyle.solid,
              width: 1,
            ),
          ),
          suffixIcon: IconButton(
            splashRadius: 1.0,
            padding: EdgeInsets.all(.0),
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
          focusColor: Theme.of(context).primaryColor,
          hintText: 'Search Here',
        ),
      ),
    );
    // return Container(
    //   alignment: Alignment.center,
    //   width: MediaQuery.of(context).size.width,
    //   height: 80.0,
    //   decoration: new BoxDecoration(
    //     gradient: new LinearGradient(
    //       colors: [Colors.deepOrangeAccent, Colors.deepOrange],
    //       begin: const FractionalOffset(0.0, 0.0),
    //       end: const FractionalOffset(1.0, 0.0),
    //       stops: [0.0, 1.0],
    //       tileMode: TileMode.clamp,
    //     ),
    //   ),
    //   child: Container(
    //     width: MediaQuery.of(context).size.width - 40.0,
    //     height: 50.0,
    //     decoration: BoxDecoration(
    //       color: Colors.white,
    //       borderRadius: BorderRadius.circular(6.0),
    //     ),
    //     child: Row(
    //       children: [
    //         Padding(
    //           padding: EdgeInsets.only(left: 8.0),
    //           child: Icon(
    //             Icons.search,
    //             color: Colors.grey,
    //           ),
    //         ),
    //         Flexible(
    //             child: Padding(
    //           padding: EdgeInsets.only(left: 8.0),
    //           child: TextField(

    //             decoration: InputDecoration.collapsed(
    //                 hintText: "Search Products Here..."),
    //           ),
    //         )),
    //       ],
    //     ),
    //   ),
    // );
  }

  Future startSearching(String query) async {
    setState(() {
      docList = FirebaseFirestore.instance
          .collection("products")
          .where("shortInfo", isGreaterThanOrEqualTo: query)
          .get();
    });
  }
}

class SearchList extends StatefulWidget {
  //const SearchList({ Key? key }) : super(key: key);

  @override
  _SearchListState createState() => _SearchListState();
}

class _SearchListState extends State<SearchList> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("products")
            .where("shortInfo", isGreaterThanOrEqualTo: inputText)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snap) {
          return snap.hasData
              ? ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: snap.data.docs.length,
                  itemBuilder: (context, index) {
                    ItemModel model =
                        ItemModel.fromJson(snap.data.docs[index].data());
                    return ProductCard(
                      model: model,
                    );
                  },
                )
              : Text("No data available");
        });
  }
}
