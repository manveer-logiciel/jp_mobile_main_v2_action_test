import 'package:get/get.dart';
import 'package:jobprogress/common/models/sql/user/user.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/common/services/subscriber_details.dart';

class MainDrawerController extends GetxController {
  UserModel? get loggedInUser => AuthService.userDetails;
  final subscriberDetails = SubscriberDetailsService.subscriberDetails;
}
