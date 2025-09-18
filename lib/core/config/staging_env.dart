import 'package:jobprogress/core/constants/common_constants.dart';

class StagingEnv {
  static Map<String, dynamic> config = {
    "API_URL_PREFIX": "https://staging.jobprogress.com/api/public/api/v1/",
    "API_URL_PREFIX_V2": "https://staging.jobprogress.com/api/public/api/v2/",
    CommonConstants.suppliersIds: {
      CommonConstants.srsId: 3,
      CommonConstants.srsV2Id: 181,
      CommonConstants.abcId: 1
    },
  };
}