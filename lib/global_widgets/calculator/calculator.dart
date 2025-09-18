import 'package:flutter/material.dart';
import 'package:flutter_simple_calculator/flutter_simple_calculator.dart';
import 'package:get/get.dart';
import 'package:jobprogress/global_widgets/calculator/controller.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class FloatingCalculator extends StatelessWidget {
  const FloatingCalculator({super.key});

  @override
  Widget build(BuildContext context) {
    
    return GetBuilder<FloatingCalculatorController>(
      init: FloatingCalculatorController(),
      builder: (floatingCalculatorController) {
        return Stack(
          children: [
            AnimatedPositioned(
              duration: Duration(milliseconds: floatingCalculatorController.animationDuration),
              left: floatingCalculatorController.floatingClockOffsets.dx,
              top: floatingCalculatorController.floatingClockOffsets.dy,
              curve: Curves.fastOutSlowIn,
              child: GestureDetector(
                onPanStart: floatingCalculatorController.onPanStart,
                onPanUpdate: floatingCalculatorController.onPanUpdate,
                onPanEnd: (_) => floatingCalculatorController.onPanEnd(),
                child: Dialog(
                  alignment:Alignment.bottomCenter,
                  insetPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
                  child: SizedBox(
                    width: JPScreen.width,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        getHeader(context),
                          SizedBox(
                          height: 320,
                          child: SimpleCalculator(
                            theme:CalculatorThemeData(
                              commandColor: JPAppTheme.themeColors.inverse,
                              operatorColor: JPAppTheme.themeColors.primary,
                            ),
                          )
                        ),
                      ],
                    ),
                  ),
                ) 
              ),
            ),
          ],
        );
      },
    );
  }

  Widget getHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 22, right: 5, top: 15, bottom: 15),
      child: SizedBox(
        height: 21,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            JPText(
              text: 'calculator'.tr.toUpperCase(),
              textSize: JPTextSize.heading3,
              fontWeight: JPFontWeight.bold,
              textAlign: TextAlign.left,
            ),
            IconButton(
              padding: EdgeInsets.zero,
              splashRadius: 20,
              onPressed:Get.back<void>,
              icon: const JPIcon(Icons.clear)
            )
          ],
        ),
      ),
    );
  }
}




