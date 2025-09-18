
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/global_widgets/message/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'package:jobprogress/common/models/call_logs/call_log.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/services/phone_masking.dart';
import 'package:jobprogress/global_widgets/call_log/index.dart';

class  JobSummaryCustomerRepTile extends StatelessWidget {
  const  JobSummaryCustomerRepTile({
    super.key,
    required this.job,
  });

  final JobModel job;

  @override
  Widget build(BuildContext context) {
    return 
    job.customer!.rep != null ? 
    Container(
      padding: const EdgeInsets.only(top: 21,left: 16,bottom: 20,right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: JPText(
              fontWeight: JPFontWeight.medium,
              textAlign:TextAlign.left ,
              text: '${'customer'.tr.toUpperCase()} ${'rep'.tr.toUpperCase()}'
            ),
          ),
          JPText(
            text: job.customer!.rep!.fullName,
            fontWeight: JPFontWeight.medium,
            isSelectable: true
          ),
          if(job.customer!.rep!.phones!.isNotEmpty)
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: job.customer!.rep!.phones!.length,
            itemBuilder: (context, index) => 
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  JPText(
                    text: PhoneMasking.maskPhoneNumber(job.customer!.rep!.phones![index].number ?? ''),
                    isSelectable: true
                  ),
                  Row(
                    children: [
                      JPSaveCallLog(
                        callLogs: CallLogCaptureModel(
                          customerId: job.customerId,
                          phoneNumber: job.customer!.rep!.phones![index].number!,
                          phoneLabel: job.customer!.rep!.phones![index].label!,
                        )
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      JPSaveMessageLog(
                          phone: job.customer!.rep!.phones![index].number!,
                          customerModel: job.customer,
                          phoneModel: job.customer!.rep!.phones![index],
                      )
                    ],
                  ),
                ],
              ),
            )
          ), 
        ],
      ),
    ):
    const SizedBox.shrink();
  }
}
