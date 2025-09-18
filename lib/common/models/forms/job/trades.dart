
import 'package:get/get.dart';
import 'package:jobprogress/common/models/job/job_type.dart';
import 'package:jobprogress/common/services/forms/value_selector.dart';
import 'package:jobprogress/core/constants/common_constants.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/modal.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class JobFormTradeWorkTypeData {

  JPInputBoxController tradeController = JPInputBoxController();
  JPInputBoxController workTypeController = JPInputBoxController();
  JPInputBoxController otherTradeDescriptionController = JPInputBoxController();

  List<JPMultiSelectModel> workTypeList = [];

  String selectedTradeId = "";

  /// [isTradeScheduled] is used to disable trade selector, in case trade is scheduled
  bool isTradeScheduled = false;
  /// [showOtherField] is used to show/hide `Other Trade Description` input
  bool showOtherField = false;

  List<JPMultiSelectModel> get selectedWorkTypes =>
      FormValueSelectorService.getSelectedMultiSelectValues(workTypeList);

  /// [setInitialData] initializes trade and work-type fields with data
  void setInitialData(JPSingleSelectModel trade, {required List<JobTypeModel> workTypes, required bool isScheduled}) {
    selectedTradeId = trade.id;
    tradeController.text = trade.label;
    isTradeScheduled = isScheduled;

    setDoShowOtherField(trade);
    setWorkTypesFromTrade(trade);

    // filling in work-types field
    for (var workType in workTypes) {
      workTypeList
          .firstWhereOrNull((type) => type.id == workType.id.toString())
          ?.isSelect = true;
    }
  }

  void setWorkTypesFromTrade(JPSingleSelectModel trade) {
    selectedTradeId = trade.id;
    setDoShowOtherField(trade);
    workTypeController.text = "";
    workTypeList.clear();
    workTypeList.addAll(trade.additionalData ?? []);
  }

  void setDoShowOtherField(JPSingleSelectModel trade) {
    showOtherField = trade.label.toLowerCase() == CommonConstants.otherOptionId;
  }
}