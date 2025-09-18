import 'package:jobprogress/common/models/call_logs/call_log.dart';
import 'package:jobprogress/common/models/sql/user/user.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/common/services/permission.dart';
import 'package:jobprogress/core/constants/permission.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import '../../common/repositories/call_log.dart';

class SaveCallLogHelper {
  static saveCallLogs(CallLogCaptureModel callParam) async {
    bool isPrimeSubUser = AuthService.isPrimeSubUser();
    UserModel? loggedInUser = AuthService.getUserDetails();

    if(isPrimeSubUser && loggedInUser!.dataMasking) return;

    if(callParam.phoneNumber.contains("****") && PermissionService.hasUserPermissions([PermissionConstants.enableMasking])) return;

    Helper.launchCall(callParam.phoneNumber);

    Map<String, dynamic> params = {
      'customer_id' : callParam.customerId,
      'phone_number' : callParam.phoneNumber,
      'phone_label' : callParam.phoneLabel,
      'job_id' : callParam.jobId,
      'job_contact_id' : callParam.jobContactId
    };
    await CallLogListRepository().saveCallLog(params);
  }
}