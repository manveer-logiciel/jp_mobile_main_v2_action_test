/// this modal used for returing data with total count
/// from local DB
library;
import 'package:jobprogress/common/models/sql/referral_source/referral_source.dart';
class ReferralSourceResponseModel {
  List<ReferralSourcesModel> data;
  int? totalCount;

  ReferralSourceResponseModel({required this.data, this.totalCount});
}