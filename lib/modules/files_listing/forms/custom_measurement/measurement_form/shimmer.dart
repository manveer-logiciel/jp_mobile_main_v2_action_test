import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/global_widgets/form_builder/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class MeasurementFormShimmer extends StatelessWidget {
  const MeasurementFormShimmer({
    super.key,  
  });
   
  Widget get inputFieldSeparator => SizedBox(
    height: JPAppTheme.formUiHelper.inputVerticalSeparator,
  );

  @override
  Widget build(BuildContext context) {
    return JPFormBuilder(
      title: '',
      footer: JPButton(
        type: JPButtonType.solid,
        text: 'save'.tr.toUpperCase(),
        size: JPButtonSize.large,
        onPressed: (){
        },
      ),
      form: Form(
        child: Column(
          children: [
            for(int i = 0; i< 4; i++)...{
              Material(
                color: JPAppTheme.themeColors.base,
                borderRadius: BorderRadius.circular(JPAppTheme.formUiHelper.sectionBorderRadius), 
                child: Padding(
                  padding: EdgeInsets.only(
                    left: JPAppTheme.formUiHelper.horizontalPadding,
                    right: JPAppTheme.formUiHelper.horizontalPadding,
                    bottom: JPAppTheme.formUiHelper.verticalPadding,
                    top: JPAppTheme.formUiHelper.verticalPadding
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          JPText(
                            text: 'measurement'.tr,
                            fontWeight: JPFontWeight.medium,
                            textColor: JPAppTheme.themeColors.darkGray,
                          ),
                          JPTextButton(
                            textSize: JPTextSize.heading5,
                            color: JPAppTheme.themeColors.primary,
                            fontWeight: JPFontWeight.medium,
                            text: '+ ${'add_multiple'.tr.capitalize!}',
                            isDisabled: false,
                            onPressed: null,
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: JPAppTheme.formUiHelper.inputVerticalSeparator),
                        child: Column(
                          children: [
                            GridView.count(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                              crossAxisSpacing: 13,
                              mainAxisSpacing: 20,
                              childAspectRatio: JPScreen.isTablet ? 6 : JPScreen.isDesktop ? 8 : 2.5,
                              crossAxisCount: 2,
                              children: [
                                for(int j = 0; j < 4; j++)
                                  JPInputBox(
                                    label: 'attribute'.tr,
                                    hintText: '0.0',
                                    maxLength: 9,
                                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                    type: JPInputBoxType.withLabel,
                                    fillColor: JPAppTheme.themeColors.base,
                                    onChanged: (data) { },
                                  ), 
                                ],                 
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20)
            }
          ],
        ),
      ),
    );
  }
}
