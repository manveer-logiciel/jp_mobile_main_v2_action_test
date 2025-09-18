
import 'package:jobprogress/common/models/subscriber/subscriber_details.dart';

class SubscriberDetailsService {
  static SubscriberDetailsModel? subscriberDetails;

  static setSubscriberDetails(SubscriberDetailsModel? data) {
    subscriberDetails = data;
  }
}