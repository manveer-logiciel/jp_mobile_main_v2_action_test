import 'package:flutter/material.dart';

class ColorHelper {
  // For changing color name into hexa color code 
  static getHexColor(String color) {
    if (!color.contains('#')) {
      Map<String, String> defaultUserColors = {
          'blue': '#0000FF',
          'green': '#008000', 
          'red': '#FF0000', 
          'purple': '#800080',
          'magenta': '#ff00ff',
          'gray': '#808080',
          'black': '#000000'};
      color = defaultUserColors[color].toString();
    }
    
    color = color.replaceAll("#", "");
    Color converted = Colors.white;
    if (color.length == 6) {
      converted = Color(int.parse("0xFF$color"));
    } else if (color.length == 8) {
      converted = Color(int.parse("0x$color"));
    }

    return converted;
  }

  static List<Color> companyContactAvatarColors = [
    const Color(0xffff8b66),
    const Color(0xff58bc8a),
    const Color(0xff5f91d0),
    const Color(0xffa8c499),
    const Color(0xffd8b37f),
    const Color(0xffbc7fd8),
    const Color(0xff57e667),
    const Color(0xff76784f),
  ];
}