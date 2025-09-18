import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/models/job/job.dart';
import '../../common/repositories/job.dart';
import '../../global_widgets/bottom_sheet/index.dart';
import '../../global_widgets/loader/index.dart';
import '../../modules/job_financial/widgets/job_price_dialog/index.dart';

class JobPriceUpdateHelper {

  static void openJobPriceDialog ({required int jobId, required VoidCallback onApply})
  => fetchJobDetailForPriceUpdation(jobId, onApply);

  static void fetchJobDetailForPriceUpdation(int jobId, VoidCallback onApply) {
    showJPLoader();
    final jobSummaryParams = <String, dynamic> {
      "id": jobId,
      "includes[0]":"address.state_tax",
      "includes[1]":"parent.address.state_tax",
      "includes[2]":"custom_tax",
      "includes[3]":"financial_details",
      "includes[4]":"job_invoices",
      "includes[5]":"flags.color",
    };
    JobRepository.fetchJob(jobId, params: jobSummaryParams).then((value) {
      Get.back();
      openDialog(value["job"], onApply);
    }).catchError((_) {Get.back();});
  }

  static void openDialog(JobModel jobModel, VoidCallback onApply) {
    showJPGeneralDialog(
        isDismissible: false,
        child: (dialogController) {
          return AbsorbPointer(
            absorbing: dialogController.isLoading,
            child: JobPriceDialog(
              onApply: onApply,
              jobModel: jobModel,
            ),
          );
        }
    );
  }
}