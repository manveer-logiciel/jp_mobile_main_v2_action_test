import 'package:get/get.dart';
import 'package:jobprogress/common/models/email/profile_detail.dart';
import 'package:jobprogress/core/utils/helpers.dart';

class EmailButtonController extends GetxController {

  void tapHandle({String? email, String? fullName, int? jobId, int? customerId, int? contactId, String? actionFrom}) {
    Map<String, dynamic> args = {};

    if(jobId != null) {
      args = {'jobId': jobId};
    }

    if(customerId != null) {
      args['customer_id'] = customerId;
    }

    if(contactId != null) {
      args = {'contact_id': contactId, 'to' : EmailProfileDetail(name: fullName!, email: email!)};
    }

    if(email != null && fullName != null){
      args['to'] = EmailProfileDetail(name: fullName, email: email);
    }

    args['action'] = actionFrom;
    
    Helper.navigateToComposeScreen(arguments: args);
  }
}

