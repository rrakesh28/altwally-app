import 'package:flutter/material.dart';

class GlobalVariables {
  // COLORS

  static const primaryColor = Color.fromARGB(0, 245, 14, 245);
  static const backgroundColor = Colors.black;
  static const whiteColor = Colors.white;
  static const grayColor = Color(0xFF808080);
  static const grayDarkColor = Color.fromARGB(255, 30, 30, 30);

  static const List<Map<String, String>> categoryImages = [
    {
      'title': 'Mobiles',
      'image': 'assets/images/mobiles.jpeg',
    },
    {
      'title': 'Essentials',
      'image': 'assets/images/essentials.jpeg',
    },
    {
      'title': 'Appliances',
      'image': 'assets/images/appliances.jpeg',
    },
    {
      'title': 'Books',
      'image': 'assets/images/books.jpeg',
    },
    {
      'title': 'Fashion',
      'image': 'assets/images/fashion.jpeg',
    },
  ];
}
