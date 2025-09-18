import 'package:flutter/material.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class TemplateTableStyleModel {
  Color? color;
  Color? background;
  String? colorString;
  String? backgroundString;
  String? width;
  String? textAlignString;
  String? verticalAlignString;
  TextAlign? textAlign;
  TextAlignVertical? textAlignVertical;

  TemplateTableStyleModel({
    this.color,
    this.background,
    this.width,
    this.textAlign = TextAlign.start,
    this.textAlignString = "start",
    this.textAlignVertical = TextAlignVertical.top,
    this.verticalAlignString = 'top',
  });

  TemplateTableStyleModel.fromJson(Map<String, dynamic>? json) {
    colorString = json?['color'];
    color = getColor(colorString, defaultColor: JPAppTheme.themeColors.text);
    backgroundString = json?['background'] ?? json?[' background'];
    background = getColor(backgroundString, defaultColor: JPAppTheme.themeColors.base);
    width = json?['width'] ?? 'auto';
    textAlignString = json?['text-align'] ?? 'start';
    verticalAlignString = json?['vertical-align'] ?? 'top';
    setAlignment(textAlignString);
    setVerticalAlignment(verticalAlignString);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['color'] = colorString;
    data['background'] = backgroundString;
    if (textAlignString != null) data['text-align'] = textAlignString;
    if (verticalAlignString != null) data['vertical-align'] = verticalAlignString;
    data['width'] = width;
    return data;
  }

  Color getColor(String? rgbString, {required Color defaultColor}) {

    if (rgbString == null) return defaultColor;

    List<String> rgbList = rgbString.replaceAll("rgb(", "").replaceAll(")", "").split(", ");
    int red = int.parse(rgbList[0]);
    int green = int.parse(rgbList[1]);
    int blue = int.parse(rgbList[2]);
    return Color.fromRGBO(red, green, blue, 1);
  }

  void setAlignment(String? alignment) {
    if (alignment == "center") {
      textAlign = TextAlign.center;
    } else if (alignment == "right") {
      textAlign = TextAlign.right;
    } else {
      textAlign = TextAlign.start;
    }
    textAlignString = alignment;
  }

  void setVerticalAlignment(String? alignment) {
    if (alignment == "middle") {
      textAlignVertical = TextAlignVertical.center;
    } else if (alignment == "bottom") {
      textAlignVertical = TextAlignVertical.bottom;
    } else {
      textAlignVertical = TextAlignVertical.top;
    }
    verticalAlignString = alignment;
  }

  @override
  String toString() {
    String styleString = "";
    Map<String, dynamic> styleJson = toJson();
    styleJson.removeWhere((key, value) => value == null);

    styleJson.forEach((key, value) {
      styleString = "$styleString${key.trim()}: ${value.toString().trim()}; ";
    });

    return styleString.trim();
  }
}
