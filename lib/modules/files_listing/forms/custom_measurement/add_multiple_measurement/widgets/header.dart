import 'package:flutter/material.dart';
import 'package:jobprogress/common/models/forms/measurement/measurement_attribute.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class MeasurementTableHeader extends StatelessWidget {
  const MeasurementTableHeader({
    super.key, 
    required this.attributes,
  });

  final List<MeasurementAttributeModel> attributes;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: JPAppTheme.themeColors.inverse,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for(int i = 0; i< attributes.length; i++)
            Container(
              decoration: BoxDecoration(
                border: attributes[i].subAttributes?.isNotEmpty ?? false ? 
                  Border.all(color: JPAppTheme.themeColors.dimGray) : 
                  null,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(12,15,12,15),
                    width: attributes[i].subAttributes?.isNotEmpty ?? false ?  
                    attributes[i].subAttributes!.length * 140:
                    140,
                    child: JPText(
                      textAlign: attributes[i].subAttributes?.isNotEmpty ?? false ? 
                        TextAlign.center :
                        TextAlign.left,
                      text: attributes[i].name!.toUpperCase()
                    ),
                  ),
                  if(attributes[i].subAttributes?.isNotEmpty ?? false)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    for(int j = 0; j < attributes[i].subAttributes!.length; j++)
                    Container(
                      width: 140,
                      decoration: BoxDecoration(
                        border:Border(
                          top: BorderSide(
                            color: JPAppTheme.themeColors.dimGray
                          )
                        )
                      ),
                      padding: const EdgeInsets.fromLTRB(12,15,12,15),
                      child: JPText(
                        textAlign: TextAlign.left,
                        text: attributes[i].subAttributes![j].name!.toUpperCase()
                      ),
                    ), 
                  ],
                ),
              ],
            ),
          )                 
        ],
      ),
    );
  }
}
