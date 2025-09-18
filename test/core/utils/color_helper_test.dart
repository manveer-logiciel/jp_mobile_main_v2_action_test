import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/core/utils/color_helper.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

void main () { 
   test('ColorHelper should given colorname green changed in greencolor hexacode',  () {
       String color =  'green';
       final colorChange = ColorHelper.getHexColor(color); 
       expect(colorChange, const Color(0xff008000));
  });

  test('ColorHelper should given colorname red changed in redcolor hexacode',  () {
       String color =  'red';
       final colorChange = ColorHelper.getHexColor(color); 
       expect(colorChange, const Color(0xffff0000));
  });

  test('ColorHelper should given colorname blue changed in bluecolor hexacode',  () {
       String color =  'blue';
       final colorChange = ColorHelper.getHexColor(color); 
       expect(colorChange, const Color(0xff0000FF));
  });
  test('ColorHelper should given colorname purple changed in purplecolor hexacode',  () {
       String color =  'purple';
       final colorChange = ColorHelper.getHexColor(color); 
       expect(colorChange, const Color(0xff800080));
  });test('ColorHelper should given colorname gray changed in graycolor hexacode',  () {
       String color =  'gray';
       final colorChange = ColorHelper.getHexColor(color); 
       expect(colorChange, const Color(0xff808080));
  });
  test('ColorHelper should given colorname black changed in blackcolor hexacode',  () {
       String color =  'black';
       final colorChange = ColorHelper.getHexColor(color); 
       expect(colorChange, const Color(0xff000000));
  });

   test('ColorHelper should given colorname lightBlue changed in lightBluecolor hexacode',  () {
       Color color =  JPColor.lightBlue;
       final colorChange = ColorHelper.getHexColor(color.toString()); 
       expect(colorChange, const Color(0xffffffff));
  });
}