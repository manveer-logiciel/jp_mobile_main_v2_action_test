import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/enums/file_listing.dart';
import 'package:jobprogress/common/enums/job_financial_listing.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/job_financial/financial_listing.dart';
import 'package:jobprogress/common/services/company_settings.dart';
import 'package:jobprogress/common/services/connected_third_party.dart';
import 'package:jobprogress/common/services/job_financial/quick_action_list.dart';
import 'package:jobprogress/common/services/job_financial/quick_action_options.dart';
import 'package:jobprogress/common/services/permission.dart';
import 'package:jobprogress/core/constants/company_seetings.dart';
import 'package:jobprogress/core/constants/connected_third_party_constants.dart';
import 'package:jobprogress/core/constants/permission.dart';
import 'package:jp_mobile_flutter_ui/QuickAction/model.dart';

void main(){
  group('JobFinancialListingQuickActionsList@getAction different cases ',(){
    test('Should return function getPaymentReceivedActionList() when param type is JFListingType.paymentsReceived',(){
      List<JPQuickActionModel> quickActionList = JobFinancialListingQuickActionsList.getActions(model: FinancialListingModel(), type: JFListingType.paymentsReceived);
      expect(quickActionList,JobFinancialListingQuickActionsList.getPaymentReceivedActionList(FinancialListingModel()));
    });
    test('Should return function getChangeorderActionList when param type is JFListingType.changeOrders',(){
      List<JPQuickActionModel> quickActionList = JobFinancialListingQuickActionsList.getActions(type: JFListingType.changeOrders, model:FinancialListingModel(invoiceId: 123456)); 
      expect(quickActionList,JobFinancialListingQuickActionsList.getChangeorderActionList(model:FinancialListingModel(invoiceId: 123456)));
    });
    test('Should return function getCreditActionList when param type isJFListingType.credits',(){
      List<JPQuickActionModel> quickActionList = JobFinancialListingQuickActionsList.getActions(type: JFListingType.credits); 
      expect(quickActionList,JobFinancialListingQuickActionsList.getCreditActionList());
    });
  });

  group('JobFinancialListingQuickActionsList@getChangeorderActionList different cases', (){
    test('Should include JobFinancialListingQuickActionOptions.viewInvoice and printInvoice when param modal has invoice id',(){
      List<JPQuickActionModel> quickActionList = JobFinancialListingQuickActionsList.getChangeorderActionList(model: FinancialListingModel(invoiceId: 123)); 
      expect(quickActionList.contains(JobFinancialListingQuickActionOptions.viewInvoice),true);
      expect(quickActionList.contains(JobFinancialListingQuickActionOptions.printInvoice),true);
    });
  
    test('Should not include JobFinancialListingQuickActionOptions.viewInvoice and printInvoice when param modal  invoice id is null',(){
      List<JPQuickActionModel> quickActionList = JobFinancialListingQuickActionsList.getChangeorderActionList(model: FinancialListingModel()); 
      expect(quickActionList.contains(JobFinancialListingQuickActionOptions.viewInvoice),false);
      expect(quickActionList.contains(JobFinancialListingQuickActionOptions.printInvoice),false);
    });
  });

  group("Payment quick actions should be displayed correctly", () {
    group("Cancel action should not be displayed", () {
      test("When pay is a LeapPay Payment", () {
        final actions = JobFinancialListingQuickActionsList.getPaymentReceivedActionList(
            FinancialListingModel(isLeapPayPayment: true),
        );
        expect(actions.contains(JobFinancialListingQuickActionOptions.cancelWithReason), isFalse);
      });

      test("When user does not have Manage Financial permission", () {
        PermissionService.permissionList.clear();
        final actions = JobFinancialListingQuickActionsList.getPaymentReceivedActionList(
            FinancialListingModel(),
        );
        expect(actions.contains(JobFinancialListingQuickActionOptions.cancelWithReason), isFalse);
      });
    });

    test("Cancel action should be displayed when payment is not LeapPay Payment & has Manage Financial Permission", () {
      PermissionService.permissionList.add(PermissionConstants.manageFinancial);
      final actions = JobFinancialListingQuickActionsList.getPaymentReceivedActionList(
          FinancialListingModel(),
      );
      expect(actions.contains(JobFinancialListingQuickActionOptions.cancelWithReason), isTrue);
    });
  });

  group("LeapPay QuickAction should be displayed conditionally", () {
    group("LeapPay QuickAction should not be displayed", () {
      test("When LeapPay is not enabled", () {
        ConnectedThirdPartyService.connectedThirdParty = {
          ConnectedThirdPartyConstants.leapPay: {'status': ''},
        };
        List<JPQuickActionModel> quickActionList = JobFinancialListingQuickActionsList
            .getJobInvoicesActionList(modal: FinancialListingModel());
        expect(quickActionList.contains(JobFinancialListingQuickActionOptions.leapPay), isFalse);
      });

      test("When LeapPay is not default payment method", () {
        CompanySettingsService.companySettings = {
          CompanySettingConstants.defaultPaymentOption : {"value": "qb",}
        };
        List<JPQuickActionModel> quickActionList = JobFinancialListingQuickActionsList
            .getJobInvoicesActionList(modal: FinancialListingModel());
        expect(quickActionList.contains(JobFinancialListingQuickActionOptions.leapPay), isFalse);
      });

      test("When Invoice balance is 0", () {
        List<JPQuickActionModel> quickActionList = JobFinancialListingQuickActionsList
            .getJobInvoicesActionList(modal: FinancialListingModel(openBalance: '0'));
        expect(quickActionList.contains(JobFinancialListingQuickActionOptions.leapPay), isFalse);
      });

      test("When current job is Multi Project job", () {
        List<JPQuickActionModel> quickActionList = JobFinancialListingQuickActionsList.getJobInvoicesActionList(
            modal: FinancialListingModel(),
            job: JobModel(id: 1, customerId: 2, isMultiJob: true),
        );
        expect(quickActionList.contains(JobFinancialListingQuickActionOptions.leapPay), isFalse);
      });

      test("When project is selected", () {
        List<JPQuickActionModel> quickActionList = JobFinancialListingQuickActionsList.getJobInvoicesActionList(
          modal: FinancialListingModel(),
          job: JobModel(id: 1, customerId: 2, parentId: 3),
        );
        expect(quickActionList.contains(JobFinancialListingQuickActionOptions.leapPay), isFalse);
      });

      test("When user does not have manage financial permission", () {
        PermissionService.permissionList.clear();
        List<JPQuickActionModel> quickActionList = JobFinancialListingQuickActionsList
            .getJobInvoicesActionList(modal: FinancialListingModel());
        expect(quickActionList.contains(JobFinancialListingQuickActionOptions.leapPay), isFalse);
      });
    });

    test("LeapPay Action should be displayed when all the conditions are satisfied", () {
      PermissionService.permissionList.add(PermissionConstants.manageFinancial);
      ConnectedThirdPartyService.connectedThirdParty = {
        ConnectedThirdPartyConstants.leapPay: {
          'status': 'enabled'
        },
      };
      CompanySettingsService.companySettings = {
        CompanySettingConstants.defaultPaymentOption : {
          "value": "leappay",
        }
      };
      List<JPQuickActionModel> quickActionList = JobFinancialListingQuickActionsList.getJobInvoicesActionList(
        modal: FinancialListingModel(openBalance: '50'),
      );
      expect(quickActionList.contains(JobFinancialListingQuickActionOptions.leapPay), isTrue);
    });
  });


  group('JobFinancialListingQuickActionsList@getJobInvoicesActionList different cases', (){
    test('Should include Record Payment, Leap pay and apply credit options when invoice open balance is greater than 0',(){
      PermissionService.permissionList.add(PermissionConstants.manageFinancial);
      List<JPQuickActionModel> quickActionList = JobFinancialListingQuickActionsList.getJobInvoicesActionList(modal: FinancialListingModel(invoiceId: 123, openBalance: "20", ), type: FLModule.financialInvoice, job: JobModel(id: 1, customerId: 1, isMultiJob: false)); 
      expect(quickActionList.contains(JobFinancialListingQuickActionOptions.recordPayment), isTrue);
      expect(quickActionList.contains(JobFinancialListingQuickActionOptions.leapPay), isTrue);
      expect(quickActionList.contains(JobFinancialListingQuickActionOptions.applyCredit), isTrue);
    });
  
    test('Should not include Record Payment, Leap pay and apply credit options when invoice open balance is not greater than 0',(){
      PermissionService.permissionList.add(PermissionConstants.manageFinancial);
      List<JPQuickActionModel> quickActionList = JobFinancialListingQuickActionsList.getJobInvoicesActionList(modal: FinancialListingModel(invoiceId: 123, openBalance: "-20", ), type: FLModule.financialInvoice, job: JobModel(id: 1, customerId: 1, isMultiJob: false)); 
      expect(quickActionList.contains(JobFinancialListingQuickActionOptions.recordPayment), isFalse);
      expect(quickActionList.contains(JobFinancialListingQuickActionOptions.leapPay), isFalse);
      expect(quickActionList.contains(JobFinancialListingQuickActionOptions.applyCredit), isFalse);
    });

     test('Should include Edit, Delete invoice, qbPay, Record Payment, Leap pay and apply credit options when user have manage financial permission',(){
      PermissionService.permissionList.add(PermissionConstants.manageFinancial);
      ConnectedThirdPartyService.connectedThirdParty = {
        ConnectedThirdPartyConstants.quickbook: {
          ConnectedThirdPartyConstants.quickbookCompanyId : "123"
        }
      };
      List<JPQuickActionModel> quickActionList = JobFinancialListingQuickActionsList.getJobInvoicesActionList(modal: FinancialListingModel(invoiceId: 123, openBalance: "20",)..type = 'job', type: FLModule.financialInvoice, job: JobModel(id: 1, customerId: 1, isMultiJob: false));

      expect(quickActionList.contains(JobFinancialListingQuickActionOptions.edit), isTrue);
      expect(quickActionList.contains(JobFinancialListingQuickActionOptions.deleteInvoice), isTrue);
      expect(quickActionList.contains(JobFinancialListingQuickActionOptions.qbPay), isTrue); 
      expect(quickActionList.contains(JobFinancialListingQuickActionOptions.recordPayment), isTrue);
      expect(quickActionList.contains(JobFinancialListingQuickActionOptions.leapPay), isTrue);
      expect(quickActionList.contains(JobFinancialListingQuickActionOptions.applyCredit), isTrue);
    });

    test('Should not include Edit, Delete invoice, qbPay, Record Payment, Leap pay and apply credit options when user does not have manage financial permission',(){
      PermissionService.permissionList.clear();
      ConnectedThirdPartyService.connectedThirdParty = {
        ConnectedThirdPartyConstants.quickbook: {
          ConnectedThirdPartyConstants.quickbookCompanyId : "123"
        }
      };
      List<JPQuickActionModel> quickActionList = JobFinancialListingQuickActionsList.getJobInvoicesActionList(modal: FinancialListingModel(invoiceId: 123, openBalance: "20",)..type = 'job', type: FLModule.financialInvoice, job: JobModel(id: 1, customerId: 1, isMultiJob: false));

      expect(quickActionList.contains(JobFinancialListingQuickActionOptions.edit), isFalse);
      expect(quickActionList.contains(JobFinancialListingQuickActionOptions.deleteInvoice), isFalse);
      expect(quickActionList.contains(JobFinancialListingQuickActionOptions.qbPay), isFalse); 
      expect(quickActionList.contains(JobFinancialListingQuickActionOptions.recordPayment), isFalse);
      expect(quickActionList.contains(JobFinancialListingQuickActionOptions.leapPay), isFalse);
      expect(quickActionList.contains(JobFinancialListingQuickActionOptions.applyCredit), isFalse);
    });


    test('Should include Unlink Proposal and View Linked Proposal options when user have manage proposal permission',(){
      PermissionService.permissionList.add(PermissionConstants.manageProposals);
      
      List<JPQuickActionModel> quickActionList = JobFinancialListingQuickActionsList.getJobInvoicesActionList(modal: FinancialListingModel(invoiceId: 123, openBalance: "20",proposalId: 12)..type = 'job', type: FLModule.financialInvoice, job: JobModel(id: 1, customerId: 1, parent: null));

      //expect(quickActionList.contains(JobFinancialListingQuickActionOptions.linkProposal), isTrue);
      expect(quickActionList.contains(JobFinancialListingQuickActionOptions.unlinkProposal), isTrue);
      expect(quickActionList.contains(JobFinancialListingQuickActionOptions.viewLinkedProposal), isTrue); 
      
    });

    test('Should not include Unlink Proposal and View Linked Proposal options when user does not have manage proposal permission',(){
      PermissionService.permissionList.add(PermissionConstants.manageProposals);
      
      List<JPQuickActionModel> quickActionList = JobFinancialListingQuickActionsList.getJobInvoicesActionList(modal: FinancialListingModel(invoiceId: 123, openBalance: "20",)..type = 'job', type: FLModule.financialInvoice, job: JobModel(id: 1, customerId: 1, parent: null));

      expect(quickActionList.contains(JobFinancialListingQuickActionOptions.unlinkProposal), isFalse);
      expect(quickActionList.contains(JobFinancialListingQuickActionOptions.viewLinkedProposal), isFalse); 
      
    });

    test('Should include Link Proposal options when user have manage proposal permission and proposal id is null',(){
      PermissionService.permissionList.add(PermissionConstants.manageProposals);
      
      List<JPQuickActionModel> quickActionList = JobFinancialListingQuickActionsList.getJobInvoicesActionList(modal: FinancialListingModel(invoiceId: 123, openBalance: "20",)..type = 'job', type: FLModule.financialInvoice, job: JobModel(id: 1, customerId: 1, parent: null));

      expect(quickActionList.contains(JobFinancialListingQuickActionOptions.linkProposal), isTrue); 
      
    });

    test('Should not include Link Proposal options when user does not have manage proposal permission and proposal id is not null',(){
      PermissionService.permissionList.clear();
      
      List<JPQuickActionModel> quickActionList = JobFinancialListingQuickActionsList.getJobInvoicesActionList(modal: FinancialListingModel(invoiceId: 123, openBalance: "20", proposalId: 12)..type = 'job', type: FLModule.financialInvoice, job: JobModel(id: 1, customerId: 1, parent: null));

      expect(quickActionList.contains(JobFinancialListingQuickActionOptions.linkProposal), isFalse); 
      
    });

    test('Should include qbPay options qb is connected and qbInvoice id is not null',(){
      PermissionService.permissionList.add(PermissionConstants.manageFinancial);
      ConnectedThirdPartyService.connectedThirdParty = {
        ConnectedThirdPartyConstants.quickbook: {
          ConnectedThirdPartyConstants.quickbookCompanyId : "123"
        }
      };
      
      List<JPQuickActionModel> quickActionList = JobFinancialListingQuickActionsList.getJobInvoicesActionList(modal: FinancialListingModel(invoiceId: 123, openBalance: "20", qbInvoiceId: "12")..type = 'job', type: FLModule.financialInvoice, job: JobModel(id: 1, customerId: 1, parent: null));

      expect(quickActionList.contains(JobFinancialListingQuickActionOptions.qbPay), isTrue); 
      
    });

    test('Should not include qbPay options qb is not connected and qbInvoice id is null',(){
      PermissionService.permissionList.clear();
      ConnectedThirdPartyService.connectedThirdParty.clear();
      
      List<JPQuickActionModel> quickActionList = JobFinancialListingQuickActionsList.getJobInvoicesActionList(modal: FinancialListingModel(invoiceId: 123, openBalance: "20", qbInvoiceId: null)..type = 'job', type: FLModule.financialInvoice, job: JobModel(id: 1, customerId: 1, parent: null));

      expect(quickActionList.contains(JobFinancialListingQuickActionOptions.qbPay), isFalse); 
      
    });

  });
}


