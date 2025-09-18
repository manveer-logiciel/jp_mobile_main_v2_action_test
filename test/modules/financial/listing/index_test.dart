import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/enums/job_financial_listing.dart';
import 'package:jobprogress/modules/job_financial/listing/controller.dart';

void main() {
  final controller = JobFinancialListingModuleController();

  group('JobFinancialListingModuleController@isShowThisList should return true or false for specific listing types ', () {
    test('when listing type is commission, jobInvoicesWithoutThumb, jobPriceHistory', () {
      expect(controller.isShowList(JFListingType.commission), false);
      expect(controller.isShowList(JFListingType.jobInvoicesWithoutThumb), false);
      expect(controller.isShowList(JFListingType.jobPriceHistory), false);
    });

    test('when listing type is accountspayable, bill', () {
      expect(controller.isShowList(JFListingType.accountspayable), true);
      expect(controller.isShowList(JFListingType.bill), true);
    });
  });
}