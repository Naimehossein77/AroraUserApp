import 'package:flutter/material.dart';
import 'dart:async';

class MyImageSlideshow extends StatefulWidget {
  const MyImageSlideshow({
    Key key,
    @required this.children,
    this.width = double.infinity,
    this.height = 200,
    this.initialPage = 0,
    this.indicatorColor,
    this.indicatorBackgroundColor = Colors.grey,
    this.onPageChanged,
    this.autoPlayInterval,
    this.isLoop = false,
  }) : super(key: key);

  /// The widgets to display in the [ImageSlideshow].
  ///
  /// Mainly intended for image widget, but other widgets can also be used.
  final List<Widget> children;

  /// Width of the [ImageSlideshow].
  final double width;

  /// Height of the [ImageSlideshow].
  final double height;

  /// The page to show when first creating the [ImageSlideshow].
  final int initialPage;

  /// The color to paint the indicator.
  final Color indicatorColor;

  /// The color to paint behind th indicator.
  final Color indicatorBackgroundColor;

  /// Called whenever the page in the center of the viewport changes.
  final ValueChanged<int> onPageChanged;

  /// Auto scroll interval.
  ///
  /// Do not auto scroll when you enter null or 0.
  final int autoPlayInterval;

  /// loop to return first slide.
  final bool isLoop;

  @override
  _MyImageSlideshowState createState() => _MyImageSlideshowState();
}

class _MyImageSlideshowState extends State<MyImageSlideshow> {
  final _currentPageNotifier = ValueNotifier(0);
  PageController _pageController;

  void _onPageChanged(int index) {
    _currentPageNotifier.value = index;
    if (widget.onPageChanged != null) {
      final correctIndex = index % widget.children.length;
      widget.onPageChanged(correctIndex);
    }
  }

  void _autoPlayTimerStart() {
    Timer.periodic(
      Duration(milliseconds: widget.autoPlayInterval),
      (timer) {
        int nextPage;
        if (widget.isLoop) {
          nextPage = _currentPageNotifier.value + 1;
        } else {
          if (_currentPageNotifier.value < widget.children.length - 1) {
            nextPage = _currentPageNotifier.value + 1;
          } else {
            return;
          }
        }

        if (_pageController.hasClients) {
          _pageController.animateToPage(
            nextPage,
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeIn,
          );
        }
      },
    );
  }

  @override
  void initState() {
    _pageController = PageController(
      initialPage: widget.initialPage,
    );
    _currentPageNotifier.value = widget.initialPage;

    if (widget.autoPlayInterval != null && widget.autoPlayInterval != 0) {
      _autoPlayTimerStart();
    }
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Stack(
        children: [
          PageView.builder(
            onPageChanged: _onPageChanged,
            itemCount: widget.isLoop ? null : widget.children.length,
            controller: _pageController,
            itemBuilder: (context, index) {
              final correctIndex = index % widget.children.length;
              return widget.children[correctIndex];
            },
          ),
          Positioned(
            left: 10,
            // right: 0,
            bottom: 5,
            child: ValueListenableBuilder<int>(
              valueListenable: _currentPageNotifier,
              builder: (context, value, child) {
                return Indicator(
                  count: widget.children.length,
                  currentIndex: value % widget.children.length,
                  activeColor: widget.indicatorColor,
                  backgroundColor: widget.indicatorBackgroundColor,
                );
              },
            ),
          ),
          // Positioned(
          //     top: 6,
          //     left: 5,
          //     // child: Container(
          //     //   height: 40,
          //     //   width: 40,
          //     //   alignment: Alignment.center,
          //     //   decoration: BoxDecoration(
          //     //       shape: BoxShape.circle, color: Colors.white70),
          //     //   child: IconButton(
          //     //     icon: Icon(
          //     //       Icons.arrow_back_ios_outlined,
          //     //       size: 20,
          //     //     ),
          //     //     onPressed: () {
          //     //       Navigator.pop(context);
          //     //     },
          //     //   ),
          //     // )
          //     )
        ],
      ),
    );
  }
}

class Indicator extends StatelessWidget {
  const Indicator({
    Key key,
    @required this.count,
    @required this.currentIndex,
    this.activeColor,
    this.backgroundColor,
  }) : super(key: key);

  final int count;
  final int currentIndex;
  final Color activeColor;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 4,
      runSpacing: 4,
      alignment: WrapAlignment.center,
      children: List.generate(
        count,
        (index) {
          return Container(
            height: 3,
            width: currentIndex == index ? 15 : 10,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: currentIndex == index ? activeColor : backgroundColor),
          );

          // return CircleAvatar(
          //   radius: 3,
          //   backgroundColor:
          //       currentIndex == index ? activeColor : backgroundColor,
          // );
        },
      ),
    );
  }
}
