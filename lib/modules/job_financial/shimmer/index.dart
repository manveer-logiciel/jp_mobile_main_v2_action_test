import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/core/utils/job_financial_helper.dart';
import 'package:jobprogress/modules/job_financial/shimmer/circular_progress_bar_tile_shimmer.dart';
import 'package:jobprogress/modules/job_financial/shimmer/comman_tile_shimmer.dart';
import 'package:jobprogress/modules/job_financial/shimmer/main_tile_shimmer/index.dart';
import 'package:jobprogress/modules/job_financial/shimmer/note_tile_shimmer.dart';
import 'package:jobprogress/modules/job_financial/shimmer/price_tile_shimmer.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class JobFinancialShimmer extends StatelessWidget {
  const JobFinancialShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return  Expanded(
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Stack(
          children: [
            Container(
              height: 167,
              width: Get.width,
              color: JPAppTheme.themeColors.secondary,
            ),
            Column(
              children: [
                JobFinanacialJobPriceTileShimmer(title: 'total_job_price'.tr),
                const FinancialMainTileShimmer(),
                JobFinancialCommanTileShimmer(
                  circleAvtarBackgroundColor: const Color(0xffF4D9D9), 
                  circleAvtarIcon: Icons.currency_exchange_outlined, 
                  circleAvtarIconColor: const Color(0xffA47070), 
                  title: '${'change_orders'.tr} / ${'other_charges'.tr}',
                ),
                JobFinancialCircularProgresBarTileShimmer(
                  title: 'payments'.tr,
                  amount: '0.0',
                  appliedAmount: '0.0',
                  unappliedAmount: '0.0',
                ),
                JobFinancialCircularProgresBarTileShimmer(
                  title: 'credits'.tr, 
                  showInfoButton: true,
                  amount: '0.0',
                  unappliedAmount: '0.0',
                  appliedAmount: '0.0',
                ),
                JobFinancialCommanTileShimmer(
                  showInfoButton: true,
                  circleAvtarBackgroundColor: const Color(0xffF3F3D5), 
                  circleAvtarIcon: JobFinancialHelper.getCurrencyIcon(), 
                  circleAvtarIconColor: const Color(0xffBCBC8B), 
                  title: 'amount_owed'.tr, 
                  amountColor: JPAppTheme.themeColors.warning
                ),               
                JobFinancialCommanTileShimmer(
                  circleAvtarBackgroundColor: const Color(0xffD8F8DA), 
                  circleAvtarIcon: Icons.account_balance_wallet_outlined, 
                  circleAvtarIconColor: const Color(0xff9CC39F), 
                  title: 'refunds'.tr, 
                ),
                JobFinancialCommanTileShimmer(
                  circleAvtarBackgroundColor: const Color(0xffCFDFFF), 
                  circleAvtarIcon: Icons.payments_outlined, 
                  circleAvtarIconColor: const Color(0xff889CC6), 
                  title: 'commissions'.tr,
                ),
                JobFinancialCommanTileShimmer(
                  circleAvtarBackgroundColor: const Color(0xffC5E6FF), 
                  circleAvtarIcon: Icons.request_quote_outlined, 
                  circleAvtarIconColor: const Color(0xff92C5EC), 
                  title: "accounts_payable".tr, 
                ),
                const JobFinancialNoteTileShimmer(topMargin: 103),
                const SizedBox(height:205),
              ],
            ),
          ],
        ),
      ),
    );  
  }
}
