/// this modal used for returing data with total count
/// from local DB
library;
import 'package:jobprogress/common/models/sql/trade_type/trade_type.dart';
class TradeTypeResponseModel {
  List<TradeTypeModel> data;
  int? totalCount;

  TradeTypeResponseModel({required this.data, this.totalCount});
}