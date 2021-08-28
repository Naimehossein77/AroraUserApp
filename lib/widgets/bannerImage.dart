import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:user/Counters/ImageBannerProvider.dart';
import 'my_Image_slidshow.dart';

class ImageBannerShimmer extends StatelessWidget {
  const ImageBannerShimmer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaquery = MediaQuery.of(context).size;

    return Container(
      height: 150,
      color: Colors.blue,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0),
        child: Shimmer.fromColors(
            period: Duration(milliseconds: 500),
            baseColor: Colors.white,
            highlightColor: Colors.grey[200],
            child: SizedBox(
              height: 200,
              width: 200,
              child: Container(
                decoration: BoxDecoration(color: Colors.black),
              ),
            )),
      ),
    );
  }
}

class BannerImage extends StatefulWidget {
  BannerImage({Key key, this.imgList, this.imageSliders, this.images})
      : super(key: key);
  final List<Widget> imageSliders;
  final List<String> imgList;
  final List<Image> images;
  @override
  _BannerImageState createState() => _BannerImageState();
}

class _BannerImageState extends State<BannerImage> {
  int currentPos = 0;

  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.images.forEach((element) {
      precacheImage(element.image, context);
    });
  }

  @override
  Widget build(BuildContext context) {
    print(widget.images[0].image);
    return MyImageSlideshow(
      width: double.infinity,

      height: 185,
      initialPage: 0,

      indicatorColor: Colors.white,

      indicatorBackgroundColor: Colors.grey[400],
      children: widget.images
          .map(
            (e) => InkWell(
              onTap: () {
                print('pressed');
              },
              child: e,
            ),
          )
          .toList(),

      isLoop: true,

      /// Called whenever the page in the center of the viewport changes.
      onPageChanged: (value) {
        //print('Page changed: $value');
      },

      /// Auto scroll interval.
      /// Do not auto scroll with null or 0.
      autoPlayInterval: 4000,
    );
  }
}
