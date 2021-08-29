import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:user/widgets/customTextWidget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

class ContactUs extends StatelessWidget {
  const ContactUs({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mheight = MediaQuery.of(context).size.height;
    final mwidth = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset('images/whatsapp.jpg'),
                SizedBox(
                  height: 8,
                ),
                CustomText(
                  text: 'Contact Us',
                  size: 16,
                  color: Colors.black87,
                ),
                SizedBox(
                  height: 20,
                ),
                // Icon(
                //   Icons.whatshot,
                //   color: Colors.red,
                // ),
                // SizedBox(
                //   height: 5,
                // ),
                // CustomText(
                //   text: '+99214534343',
                //   size: 13,
                //   color: Colors.black87,
                // ),
                SizedBox(
                  height: 15,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: mheight * .07,
                    width: mwidth * .50,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(20)),
                    child: ElevatedButton(
                        onPressed: () async {
                          final link = WhatsAppUnilink(
                            phoneNumber: '+919310949504',
                            text: "",
                          );
                          // Convert the WhatsAppUnilink instance to a string.
                          // Use either Dart's string interpolation or the toString() method.
                          // The "launch" method is part of "url_launcher".
                          await launch('$link');
                        },
                        style: ButtonStyle(
                            // padding: MaterialStateProperty.all<EdgeInsets>(
                            //     EdgeInsets.all(10)),
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.green),
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.red),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ))),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              FontAwesomeIcons.whatsapp,
                              color: Colors.white,
                              size: mwidth * .08,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  text: 'WhatsApp Chat',
                                  color: Colors.white,
                                  size: 15,
                                ),
                                CustomText(
                                  text: 'Click to Chat',
                                  color: Colors.white,
                                  size: 10,
                                ),
                              ],
                            )
                          ],
                        )),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 40, bottom: 15),
                  child: Icon(
                    FontAwesomeIcons.solidClock,
                    size: 18,
                    color: Colors.red,
                  ),
                ),
                CustomText(
                  text: 'Monday - Saturday',
                  size: 14,
                  color: Colors.black87,
                ),
                SizedBox(height: 3),
                CustomText(
                  text: '10:00 AM - 6:00 PM',
                  size: 13,
                  color: Colors.black87,
                ),
                SizedBox(height: 10),

                CustomText(
                  text: 'Sunday',
                  size: 14,
                  color: Colors.black87,
                ),
                SizedBox(
                  height: 3,
                ),
                CustomText(
                  text: 'Closed',
                  size: 13,
                  color: Colors.red[400],
                )
              ],
            ),
            Positioned(
                top: 6,
                left: 5,
                child: Container(
                  height: 40,
                  width: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Colors.white70),
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios_outlined,
                      size: 20,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ))
          ],
        ),
      ),
    ));
  }
}
