import 'package:flutter/material.dart';
import 'package:user/widgets/customAddTextField.dart';
import 'package:user/widgets/customAppBar.dart';
import 'package:user/widgets/customButton.dart';
import 'package:user/widgets/mydrawer.dart';

class ShippingDetails extends StatefulWidget {
  //const ProfilePage({ Key? key }) : super(key: key);

  @override
  _ShippingDetailsState createState() => _ShippingDetailsState();
}

class _ShippingDetailsState extends State<ShippingDetails> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(),
        drawer: MyDrawer(),
        body: Container(
          padding: EdgeInsets.all(30.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Shipping Details',
                  style: TextStyle(fontSize: 20.0),
                ),
                CustomAddProduct(
                  hintname: 'Name',
                ),
                CustomAddProduct(
                  hintname: 'Phone Number',
                ),
                SizedBox(
                  height: 30.0,
                ),
                Container(
                  padding: EdgeInsets.all(5.0),
                  margin: EdgeInsets.symmetric(horizontal: 10.0),
                  child: TextField(
                    textAlign: TextAlign.start,
                    maxLines: 4,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 1,
                        ),
                      ),
                      alignLabelWithHint: true,
                      labelText: 'Address',
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9.0),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Text(
                        "Confirm",
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,
                        ),
                      ),
                      color: Colors.deepOrange,
                      onPressed: () {
                        // if (_shortInfoTextEditingController.text.isEmpty ||
                        //     _titleTextEditingController.text.isEmpty ||
                        //     _descriptionTextEditingController.text.isEmpty ||
                        //     _quantityOfProduct.text.isEmpty ||
                        //     _priceTextEditingController.text.isEmpty ||
                        //     _selectedCategory == null ||
                        //     _mrpTextEditingController.text.isEmpty) {
                        //   Fluttertoast.showToast(
                        //       msg: "Please Fill all Fields",
                        //       toastLength: Toast.LENGTH_SHORT,
                        //       gravity: ToastGravity.CENTER,
                        //       backgroundColor: Colors.red,
                        //       textColor: Colors.white,
                        //       fontSize: 16.0);
                        // } else
                        //   uploading
                        //       ? print("No Data Enter")
                        //       : uploadImageAndSaveItemInfo();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
