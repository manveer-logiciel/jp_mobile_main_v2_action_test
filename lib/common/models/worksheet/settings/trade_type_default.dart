import 'package:jobprogress/common/models/company_trades/company_trades_model.dart';
import 'package:jobprogress/core/utils/helpers.dart';

class WorksheetTradeTypeDefault {

  ///[inheritFromJob]  Indicates whether the trade type should be inherited from the job.
  bool? inheritFromJob;

  /// [isNone] Indicates whether there is no trade type.
  bool? isNone;

  /// [trade] The trade associated with the worksheet.
  CompanyTradesModel? trade;

  WorksheetTradeTypeDefault({
    this.inheritFromJob,
    this.isNone,
    this.trade,
  });

  WorksheetTradeTypeDefault.fromJson(Map<String, dynamic>? json) {
    inheritFromJob = Helper.isTrue(json?['inherit_from_job']);
    isNone = Helper.isTrue(json?['none']);
    if (json?['trade'] is Map) {
      trade = CompanyTradesModel.fromJson(json?['trade']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['inherit_from_job'] = inheritFromJob;
    data['none'] = isNone;
    if (trade != null) {
      data['trade'] = trade!.toJson();
    }
    return data;
  }
}
