import 'package:flutter/material.dart';

const Color color1 = Color(0xFF1F2633);
const Color colorBottomNavBar = Color.fromARGB(255, 21, 26, 35);
const Color color2 = Color(0xFF7229D9);
const Color color3 = Color(0xFFE052F2);
const Color colorText = Color(0xFFfffffF);

class CustomColor {
  MaterialColor getMaterialColor(int r, int g, int b, int colorCode) {
    Map<int, Color> colorMap = {
      50: Color.fromRGBO(r, g, b, .1),
      100: Color.fromRGBO(r, g, b, .2),
      200: Color.fromRGBO(r, g, b, .3),
      300: Color.fromRGBO(r, g, b, .4),
      400: Color.fromRGBO(r, g, b, .5),
      500: Color.fromRGBO(r, g, b, .6),
      600: Color.fromRGBO(r, g, b, .7),
      700: Color.fromRGBO(r, g, b, .8),
      800: Color.fromRGBO(r, g, b, .9),
      900: Color.fromRGBO(r, g, b, 1),
    };

    return MaterialColor(colorCode, colorMap);
  }
}
