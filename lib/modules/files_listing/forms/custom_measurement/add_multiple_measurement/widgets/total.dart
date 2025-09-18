import 'package:flutter/material.dart';
import 'package:jobprogress/modules/files_listing/forms/custom_measurement/add_multiple_measurement/controller.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class MeasurementTotal extends StatelessWidget {
  const MeasurementTotal({
    super.key, 
    required this.controller,  
  });

  final AddMultipleMeasurementController controller;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: JPAppTheme.themeColors.dimGray
              ),
              top: BorderSide(
                color: JPAppTheme.themeColors.dimGray
              ), 
            )
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for(int i = 0; i< (controller.totalMeasurement?.length ?? 0); i++)
                if(controller.totalMeasurement![i].subAttributes?.isEmpty ?? true)...{
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                      right: BorderSide(
                        color: JPAppTheme.themeColors.dimGray
                      ),
                    )
                  ), 
                    width:  controller.totalMeasurement![i].subAttributes?.isEmpty ?? true ?  
                      140 : 
                      controller.totalMeasurement![i].subAttributes!.length * 140,
                    padding: const EdgeInsets.fromLTRB(12,15,12,15),
                    child: JPText(
                      fontWeight: JPFontWeight.medium,
                      textAlign: TextAlign.left,
                      text: controller.getAttributeTotal(i)
                    ),
                  )
                } else...{
                Container(
                decoration: BoxDecoration(
                 border: Border(right: BorderSide(color: JPAppTheme.themeColors.dimGray)) 
                ),
                child:
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  for(int j = 0; j < controller.totalMeasurement![i].subAttributes!.length; j++)
                  Container(
                    width: 140,
                    padding: const EdgeInsets.fromLTRB(12,15,12,15),
                    child:  JPText(
                      textAlign: TextAlign.left,
                      text: controller.getSubAttributeTotal(i, j)
                    ),
                  ), 
                ],
              )),
            }                       
            ],
          ),
        ),
      ],
    );
  }
}
