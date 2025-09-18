import 'package:get/get.dart';
import 'package:jobprogress/global_widgets/profile_image_widget/index.dart';
import 'package:jp_mobile_flutter_ui/Avatar/size.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/modal.dart';

class UserTypeConstants {

  static const String subs = "subs"; 
  static const String companyCrew = 'company_crew';
  static const String estimator = 'estimators';
  static const String customerRep = 'customer_rep'; 

  static List<JPMultiSelectModel> userTypeList = [
    JPMultiSelectModel(
      label: 'salesmanRep'.tr, 
      suffixLabel: '(${'job_role'.tr})',
      id: '-1', 
      isSelect: false,
      child: const JPProfileImage(
        size: JPAvatarSize.small,
        initial: 'S',
      ),
    ),
    JPMultiSelectModel(
      label: 'job_rep_estimator'.tr,
      suffixLabel: '(${'job_role'.tr})', 
      id: '-2', 
      isSelect: false,
      child: const JPProfileImage(
        size: JPAvatarSize.small,
        initial: 'J',
      ),
    ),
    JPMultiSelectModel(
      label: 'company_crew'.tr,
      id: '-3',
      suffixLabel: '(${'job_role'.tr})',
      isSelect: false,
      child: const JPProfileImage(
        size: JPAvatarSize.small,
        initial: 'C',
      )
    ),
    JPMultiSelectModel(
      label: 'sub_contractor'.tr, 
      suffixLabel: '(${'job_role'.tr})',
      id: '-4', 
      isSelect: false,
      child: const JPProfileImage(
        size: JPAvatarSize.small,
        initial: 'S',
      )
    ),
  ];
}