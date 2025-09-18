import 'package:get/get.dart';
import 'package:jobprogress/common/models/srs_smart_template/branch_order_history_templates_model.dart';
import 'package:jobprogress/core/constants/navigation_parms_constants.dart';

import '../../common/models/srs_smart_template/srs_smart_template_model.dart';
import '../../common/repositories/worksheet.dart';

class SrsSmartTemplateController extends GetxController {
  String? branchCode = Get.arguments?[NavigationParams.srsBranch];
  SrsSmartTemplateModel? srsSmartTemplateModel;

  bool isLoading = false;

  @override
  void onInit() {
    super.onInit();
    fetchSrsTemplates();
  }

  Future<void> fetchSrsTemplates() async {
    try {
      toggleLoading();
      final Map<String, dynamic> params = {
            'branch_code': branchCode,
            'limit': 0
          };
      srsSmartTemplateModel = await WorksheetRepository.fetchSrsSmartTemplates(params);
      update();
    } catch (e) {
      rethrow;
    } finally {
      toggleLoading();
    }
  }

  void toggleLoading() {
    isLoading = !isLoading;
    update();
  }

  void onSelectItem(BranchOrderHistoryTemplatesModel model) {
    Get.back(result: model.templateProducts);
  }

}