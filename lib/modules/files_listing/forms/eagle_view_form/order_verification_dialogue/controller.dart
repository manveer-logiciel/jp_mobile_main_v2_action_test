import 'package:get/get.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/modal.dart';

import '../../../../../common/enums/form_fields_sections.dart';
import '../../../../../common/models/forms/eagleview_order/index.dart';
import '../../../../../common/repositories/eagle_view_order_form.dart';
import '../../../../../core/utils/helpers.dart';

class EagleViewOrderVerificationDialogueController extends GetxController {

  EagleViewOrderVerificationDialogueController(this.formData, this.isDefaultLocation);

  final EagleViewFormData formData;

  bool isSavingForm = false;
  final bool isDefaultLocation;

  String get getFormattedAddress => "${(formData.selectedAddress?.address ?? "") + (formData.selectedAddress?.addressLine1 ?? "")}, "
      "${formData.selectedAddress?.city}, "
      "${formData.selectedAddress?.state?.code}, "
      "${formData.selectedAddress?.zip}";

  String get getPinLocation => formData.selectedAddress?.lat == null ? "pin_is_yet_to_be_placed_on_map".tr : isDefaultLocation ? "default".tr.capitalize! : "custom".tr.capitalize!;

  bool get isSaveDisable => formData.selectedAddress?.lat == null || isSavingForm;

  void saveForm(Function(bool) onFinish) async {
    try {
      toggleIsSavingForm();
      await createEagleViewOrderAPICall(getFormParams(), onFinish);
    } catch (e) {
      toggleIsSavingForm();
      rethrow;
    }
  }

  void toggleIsSavingForm() {
    isSavingForm = !isSavingForm;
    update();
  }

  Map<String, dynamic> getFormParams() {
    Map<String, dynamic> temp = formData.eagleViewFormJson();
    temp.removeWhere((dynamic key, dynamic value) =>
    (key == null || key == "MeasurementInstructionName"|| key == "AddOnProductNames[]") || value == null|| value == "");
    return temp;
  }

  Future<void> createEagleViewOrderAPICall(Map<String, dynamic> params, Function(bool) onFinish) async {
    try {
      final result = await EagleViewOrderFormRepository.createEagleViewOrder(params);
      if (result) {
        Helper.showToastMessage('eagle_view_order_created'.tr);
        onFinish(result);
        Get.back();
      }
    } catch (e) {
      rethrow;
    }
  }

  ////////////////////////////   UI MANAGEMENT   ///////////////////////////////

  bool isVisible(FormFieldsSections type) {
    switch(type) {
      case FormFieldsSections.address:
        return getFormattedAddress.isNotEmpty;
      case FormFieldsSections.product:
        return (formData.selectedProduct?.label.isNotEmpty ?? false)
            ||  (formData.selectedDelivery?.label.isNotEmpty ?? false)
            ||  (formData.selectedAddOnProductsList.isNotEmpty)
            ||  (formData.selectedMeasurements?.label.isNotEmpty ?? false)
            ||  (formData.productsController.text.isNotEmpty);
      case FormFieldsSections.insurance:
        return (formData.insuredNameController.text.isNotEmpty)
            ||  (formData.referenceIdController.text.isNotEmpty)
            ||  (formData.batchIdController.text.isNotEmpty)
            ||  (formData.policyNoController.text.isNotEmpty);
      case FormFieldsSections.claim:
        return (formData.claimNumberController.text.isNotEmpty)
            ||  (formData.claimNumberController.text.isNotEmpty)
            ||  (formData.poNumberController.text.isNotEmpty)
            ||  (formData.catIdController.text.isNotEmpty)
            ||  (formData.dateOfLossController.text.isNotEmpty);
      case FormFieldsSections.other:
        return (formData.sendCopyToController.text.isNotEmpty);
    }
  }

  List<JPMultiSelectModel> getOtherProducts() {
    List<JPMultiSelectModel> list = [];
    for (var element in formData.addOnProductList) {
      if(element.isSelect) list.add(element);
    }
    return list;
  }

}