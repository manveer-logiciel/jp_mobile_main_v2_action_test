/// this modal used for returing data with total count
/// from local DB
library;
import 'package:jobprogress/common/models/sql/division/division.dart';
class DivisionResponseModel {
  List<DivisionModel> data;
  int? totalCount;

  DivisionResponseModel({required this.data, this.totalCount});
}