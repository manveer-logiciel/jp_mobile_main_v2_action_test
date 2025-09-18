import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/global_widgets/listview/index.dart';
import 'package:jobprogress/global_widgets/safearea/safearea.dart';
import 'package:jobprogress/modules/call_logs/controller.dart';
import 'package:jobprogress/modules/call_logs/tile.dart';
import 'package:jp_mobile_flutter_ui/AnimatedSpinKit/fading_circle.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../common/models/customer/customer.dart';
import '../../global_widgets/no_data_found/index.dart';
import 'header.dart';
import 'shimmer.dart';

class CallLogListingBottomSheet extends StatelessWidget {  
  final CustomerModel customer;

  const CallLogListingBottomSheet({super.key, required this.customer});

  @override
  Widget build(BuildContext context) {

   final controller = Get.put(CallLogListingController());
   controller.customer = customer;
   controller.getCallLogList();
   return GetBuilder<CallLogListingController>(
     builder: (_) {
       return Container(
         width: MediaQuery.of(context).size.width,
         decoration: BoxDecoration(
             color: JPAppTheme.themeColors.base,
             borderRadius: JPResponsiveDesign.bottomSheetRadius),
         child: JPSafeArea(
           child: Column(               
             mainAxisSize: MainAxisSize.min,
             children: [
               const CallLogListingHeader(),
               Flexible(
                 child: AnimatedContainer(
                   width: MediaQuery.of(context).size.width,
                   constraints: BoxConstraints(
                     maxHeight: controller.isLoading ? MediaQuery.of(context).size.height * 0.30 : MediaQuery.of(context).size.height * 0.80,
                   ),
                   duration: const Duration(milliseconds: 200),
                   child: controller.isLoading ? const CallLogShimmer() : controller.callLogList.isNotEmpty ?
                   Column(
                     mainAxisSize: MainAxisSize.min,
                     children: [
                       JPListView(
                           listCount: controller.callLogList.length,
                           padding: const EdgeInsets.only(top: 10),
                           onLoadMore: controller.canShowLoadMore ? controller.loadMore : null,
                           itemBuilder: (_, index) {
                             if (index < controller.callLogList.length) {
                               return CallLogListingTile(
                                  callLogList: controller.callLogList,
                                  index: index,
                                  callLog:controller.callLogList[index],
                                  loggedInUser: controller.loggedInUser
                               );
                             } else if (controller.canShowLoadMore) {
                               return Center(
                                 child: Padding(
                                   padding: const EdgeInsets.all(16.0),
                                   child: FadingCircle(
                                     size: 25,
                                     color: JPAppTheme.themeColors.primary,
                                   ),
                                 ),
                               );
                             } else {
                               return const SizedBox.shrink();
                             }
                           },
                         ),
                     ],
                   )
                   :
                   NoDataFound(
                     icon: Icons.call_made_outlined,
                     title: 'no_call_log_found'.tr.capitalize,
                   ),
                 ),
               )
             ],
           ),
         ),
       );
     }
   );
 }
}
