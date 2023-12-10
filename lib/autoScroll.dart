import 'dart:async';
import 'package:flutter/material.dart';

class AutoScrollPageView extends StatefulWidget {
  @override
  _AutoScrollPageViewState createState() => _AutoScrollPageViewState();
}

class _AutoScrollPageViewState extends State<AutoScrollPageView> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPage);
    _startAutoScroll();
  }

  void _startAutoScroll() {
    Timer.periodic(Duration(seconds: 2), (timer) {
      if (_currentPage < 2) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 1000),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: PageView(
        controller: _pageController,
        scrollDirection: Axis.horizontal,
        children: [
          Image.asset(
            "images/daisy.jpg",
            fit: BoxFit.cover,
          ),
          Image.asset(
            "images/flower.jpg",
            fit: BoxFit.cover,
          ),
          Image.asset(
            "images/field.jpg",
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

