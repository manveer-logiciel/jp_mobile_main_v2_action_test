import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/global_widgets/will_pop_scope/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../../../../common/models/forms/eagleview_order/eagle_view_form_param.dart';
import '../../../../../core/constants/widget_keys.dart';
import '../../../../../core/utils/helpers.dart';
import '../../../../../global_widgets/form_builder/index.dart';
import '../../../../../global_widgets/loader/index.dart';
import '../controller.dart';
import 'section/claim_information.dart';
import 'section/insurance_information.dart';
import 'section/other_information.dart';
import 'section/product_information.dart';

class EagleViewForm extends StatelessWidget {
  const EagleViewForm({
    super.key,
    required this.eagleViewFormParam
  });

  final EagleViewFormParam? eagleViewFormParam;

  // parent controller will be null when opened from bottom sheet
  bool get isBottomSheet => eagleViewFormParam?.controller == null;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: Helper.hideKeyboard,
        child: GetBuilder<EagleViewFormController> (
            init: eagleViewFormParam?.controller ?? EagleViewFormController(eagleViewFormParam: eagleViewFormParam),
            global: false,
            builder: (controller) {
              return JPWillPopScope(
                  onWillPop: controller.onWillPop,
                  child: JPFormBuilder(
                    title: controller.pageTitle,
                    controller: controller.formBuilderController,
                    onClose: controller.onWillPop,
                    isWithMap : true,
                    initialAddress : controller.selectedAddress,
                    onAddressUpdate: controller.onAddressUpdate,
                    form: Form(
                      key: controller.formKey,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: EagleViewProductSection(
                                controller: controller
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: controller.formUiHelper.sectionSeparator),
                            child: EagleViewInsuranceSection(
                                controller: controller
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: controller.formUiHelper.sectionSeparator),
                            child: EagleViewClaimSection(
                                controller: controller
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: controller.formUiHelper.sectionSeparator),
                            child: EagleViewOtherSection(
                                controller: controller
                            ),
                          ),

                          SizedBox(
                              height: controller.formUiHelper.sectionSeparator
                          ),
                        ],
                      ),
                    ),
                    footer: JPButton(
                      key: const ValueKey(WidgetKeys.placeOrder),
                      type: JPButtonType.solid,
                      text: controller.isSavingForm
                          ? ""
                          : controller.saveButtonText,
                      size: JPButtonSize.small,
                      disabled: controller.isSavingForm,
                      suffixIconWidget: showJPConfirmationLoader(
                        show: controller.isSavingForm,
                      ),
                      onPressed: controller.createEagleViewOrder,
                    ),
                    inBottomSheet: isBottomSheet,
                  )
              );
            })
    );
  }
}
