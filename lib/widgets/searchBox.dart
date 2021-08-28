// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';

// // import '../Store/Search.dart';

// class SearchBoxDelegate extends SliverPersistentHeaderDelegate {
//   @override
//   Widget build(
//           BuildContext context, double shrinkOffset, bool overlapsContent) =>
//       InkWell(
//         onTap: () {
//           // Route route = MaterialPageRoute(builder: (c) => SearchProduct());
//           // Navigator.push(context, route);
//         },
//         child: Container(
//           decoration: new BoxDecoration(
//             gradient: new LinearGradient(
//               colors: [Colors.deepOrangeAccent, Colors.deepOrange],
//               begin: const FractionalOffset(0.0, 0.0),
//               end: const FractionalOffset(1.0, 0.0),
//               stops: [0.0, 1.0],
//               tileMode: TileMode.clamp,
//             ),
//           ),
//           alignment: Alignment.center,
//           width: MediaQuery.of(context).size.width,
//           height: 80.0,
//           child: InkWell(
//             child: Container(
//               margin: EdgeInsets.only(left: 10.0, right: 10.0),
//               width: MediaQuery.of(context).size.width,
//               height: 50.0,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(6.0),
//               ),
//               child: Row(
//                 children: [
//                   Padding(
//                     padding: EdgeInsets.only(left: 8.0),
//                     child: Icon(
//                       Icons.search,
//                       color: Colors.deepOrange,
//                     ),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.only(left: 8.0),
//                     child: Text("Search here..."),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       );

//   @override
//   double get maxExtent => 80;

//   @override
//   double get minExtent => 80;

//   @override
//   bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
// }
import 'package:flutter/material.dart';
import 'package:user/screens/Search.dart';

class SearchBox extends StatelessWidget {
  //const SearchBox({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Route route = MaterialPageRoute(builder: (c) => SearchProduct());
        Navigator.push(context, route);
      },
      child: Container(
        height: 50,
        margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: TextFormField(
          style: TextStyle(fontSize: 18.0),
          textAlignVertical: TextAlignVertical.center,

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
      ),
    );
  }
}
