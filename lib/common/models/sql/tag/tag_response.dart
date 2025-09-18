/// this modal used for returing data with total count
/// from local DB
library;
import 'package:jobprogress/common/models/sql/tag/tag.dart';
class TagResponseModel {
  List<TagModel> data;
  int? totalCount;

  TagResponseModel({required this.data, this.totalCount});
}