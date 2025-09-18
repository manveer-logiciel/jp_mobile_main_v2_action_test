import 'package:get/get.dart';

import '../../../../../common/enums/form_fields_sections.dart';
import '../../../../../common/models/forms/quick_measure/index.dart';
import '../../../../../common/repositories/quick_measure.dart';
import '../../../../../core/utils/helpers.dart';

class QuickMeasureOrderVerificationDialogueController extends GetxController {

  QuickMeasureOrderVerificationDialogueController(this.formData, this.isDefaultLocation);

  final QuickMeasureFormData formData;

  bool isSavingForm = false;
  final bool isDefaultLocation;

  String get getFormattedAddress => "${"${formData.selectedAddress?.address ?? ""}, ${formData.selectedAddress?.addressLine1 ?? ""}"}, "
      "${formData.selectedAddress?.city}, "
      "${formData.selectedAddress?.state?.code}, "
      "${formData.selectedAddress?.country?.name}, "
      "${formData.selectedAddress?.zip}";

  String get getPinLocation => formData.selectedAddress?.lat == null ? "pin_is_yet_to_be_placed_on_map".tr : isDefaultLocation ? "default".tr.capitalize! : "custom".tr.capitalize!;

  bool get isSaveDisable => formData.selectedAddress?.lat == null || isSavingForm;

  void saveForm(Function(bool) onFinish) async {
    try {
      toggleIsSavingForm();
      await createQuickMeasureAPICall(getFormParams(), onFinish);
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
    Map<String, dynamic> temp = formData.quickMeasureFormJson();
    temp.removeWhere((dynamic key, dynamic value) =>
      (key == null || key == "product_name") || value == null || value == "");
    return temp;
  }

  Future<void> createQuickMeasureAPICall(Map<String, dynamic> params, Function(bool) onFinish) async {
    try {
      final result = await QuickMeasureRepository().createQuickMeasure(params);
      if (result["status"]) {
        Helper.showToastMessage('quick_measure_created'.tr);
        onFinish(result["status"]);
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
        return formData.selectedProduct?.label.isNotEmpty ?? false;
      case FormFieldsSections.other:
        return (formData.emailController.text.isNotEmpty)
            ||  (formData.specialInfoController.text.isNotEmpty);
      default:
        return true;
    }
  }
}