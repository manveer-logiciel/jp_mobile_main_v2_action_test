import 'package:flutter/material.dart';
import 'package:jobprogress/core/constants/widget_keys.dart';
import 'package:jobprogress/modules/files_listing/forms/custom_measurement/add_multiple_measurement/controller.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class MeasurementTableContent extends StatelessWidget {
  const MeasurementTableContent({
    super.key,   
    required this.controller, 
  });
  
  final AddMultipleMeasurementController controller;
  
  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey(WidgetKeys.multipleMeasurementKey),
      children: [
        for(int a = 0; a < controller.measurement.values!.length; a++)
        InkWell(
          key: ValueKey('${WidgetKeys.multipleMeasurementKey}[$a]'),
            onLongPress: (){ 
            controller.showQuickAction(a); 
          },
          onTap:(){
              controller.navigateToEditMultipleMeasurement(index: a);
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: JPAppTheme.themeColors.dimGray
                ),
              )
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for(int i = 0; i< controller.measurement.values![a].length; i++)
                if( controller.measurement.values![a][i].subAttributes?.isEmpty ?? true)...{
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                        right: BorderSide(
                          color: JPAppTheme.themeColors.dimGray
                        ),
                      )
                    ), 
                    width:  controller.measurement.values![a][i].subAttributes?.isEmpty ?? true ?  
                      140 : 
                      controller.measurement.values![a][i].subAttributes!.length * 140,
                    padding: const EdgeInsets.fromLTRB(12,15,12,15),
                      child: JPText(
                        textAlign: TextAlign.left,
                        text: controller.getAttributeValue(a, i)
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
                        for(int j = 0; j < controller.measurement.values![a][i].subAttributes!.length; j++)
                        Container(
                        width: 140,
                          padding: const EdgeInsets.fromLTRB(12,15,12,15),
                          child: JPText(
                            textAlign: TextAlign.left,
                            text: controller.getSubAttributeValue(a, i, j)
                          ),
                        ), 
                      ],
                    )
                  ),
                }                       
              ],
            ),
          ),
        ),
      ],
    );
  }
}
