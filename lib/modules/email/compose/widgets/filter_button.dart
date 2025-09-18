import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:jobprogress/modules/email/compose/controller.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class FilterButton extends StatelessWidget{
  const FilterButton({super.key, required this.controller});
  final EmailComposeController controller;
  @override
  Widget build(BuildContext context) {
    return  GetBuilder<EmailComposeController>(
      init: controller,
      builder: (controller) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 3,top: 15,left: 16,),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 5),
                child: JPButton(
                  onPressed: () {
                    controller.toggleIsUserSelected();
                    controller.filterSuggestionList();
                  },
                  size: JPButtonSize.size24,
                  text: 'Users'.tr,
                  textColor: controller.isUserSelected ? JPAppTheme.themeColors.base : JPAppTheme.themeColors.tertiary,
                  colorType: controller.isUserSelected ? JPButtonColorType.tertiary : JPButtonColorType.lightGray
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 5),
                child: JPButton(
                  onPressed: (){
                    controller.toggleIsLabourSelected();
                    controller.filterSuggestionList();
                  },
                  size: JPButtonSize.size24,
                  text: 'Labours'.tr,
                  textColor: controller.isLabourSelected? JPAppTheme.themeColors.base: JPAppTheme.themeColors.tertiary,
                  colorType: controller.isLabourSelected? JPButtonColorType.tertiary : JPButtonColorType.lightGray
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 5),
                child: JPButton(
                  onPressed: (){
                    controller.toggleIsCustomerSelected();
                    controller.filterSuggestionList();
                    
                  },
                  size: JPButtonSize.size24,
                  text: 'Customers'.tr,
                  textColor: controller.isCustomerSelected? JPAppTheme.themeColors.base: JPAppTheme.themeColors.tertiary,
                  colorType: controller.isCustomerSelected? JPButtonColorType.tertiary : JPButtonColorType.lightGray
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 5),
                child: JPButton(
                  onPressed: (){
                    controller.toggleIsContactSelected();
                    controller.filterSuggestionList();
                  },
                  size: JPButtonSize.size24,
                  text: 'Contacts'.tr,
                  textColor: controller.isContactSelected? JPAppTheme.themeColors.base: JPAppTheme.themeColors.tertiary,
                  colorType: controller.isContactSelected? JPButtonColorType.tertiary : JPButtonColorType.lightGray
                ),
              ) 
            ],
          ),
        );
      }
    );

    
  }

}

