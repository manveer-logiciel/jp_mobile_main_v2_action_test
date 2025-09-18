import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/enums/job_financial_listing.dart';
import 'package:jobprogress/common/services/job_financial/quick_action_repo/quick_action_dialogs.dart';


void main(){
  test('FinancialListQuickActionPopups@getConfirmationmessageforBottomSheet should return String you_are_about_to_cancel_credit.respective_amount_will_be_readjusted when params type is JFListingType.credits',(){
    String message = FinancialListQuickActionPopups.getConfirmationmessageforBottomSheet(type: JFListingType.credits); 
   expect(message, 'you_are_about_to_cancel_credit.respective_amount_will_be_readjusted');
  });
  test('FinancialListQuickActionPopups@getConfirmationmessageforBottomSheet should return String you_are_about_to_cancel_order.respective_amount_will_be_re_adjuststed when params type is JFListingType.changeOrders',(){
    String message = FinancialListQuickActionPopups.getConfirmationmessageforBottomSheet(type: JFListingType.changeOrders); 
   expect(message, 'you_are_about_to_cancel_order.respective_amount_will_be_re_adjuststed');
  });

}

