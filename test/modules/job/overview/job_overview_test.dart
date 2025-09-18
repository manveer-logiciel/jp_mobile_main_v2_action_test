import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/run_mode.dart';
import 'package:jobprogress/common/models/clock_summary/clock_summary_time_log_details.dart';
import 'package:jobprogress/common/models/customer/customer.dart';
import 'package:jobprogress/common/models/job/customer_info.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/job/job_invoices.dart';
import 'package:jobprogress/common/models/job/job_production_board.dart';
import 'package:jobprogress/common/models/job/request_params.dart';
import 'package:jobprogress/common/models/job_financial/financial_details.dart';
import 'package:jobprogress/common/models/launchdarkly/flags.dart';
import 'package:jobprogress/common/models/phone.dart';
import 'package:jobprogress/common/models/sql/user/user.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/common/services/clock_in_clock_out.dart';
import 'package:jobprogress/common/services/feature_flag.dart';
import 'package:jobprogress/common/services/job/job_summary/quick_actions.dart';
import 'package:jobprogress/common/services/permission.dart';
import 'package:jobprogress/common/services/run_mode/index.dart';
import 'package:jobprogress/core/constants/feature_flag_constant.dart';
import 'package:jobprogress/core/constants/launchdarkly/flag_keys.dart';
import 'package:jobprogress/core/constants/permission.dart';
import 'package:jobprogress/core/constants/user_roles.dart';
import 'package:jobprogress/global_widgets/plus_button_sheet/widgets/index.dart';
import 'package:jobprogress/modules/job/job_summary/controller.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/modal.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../../../integration_test/core/test_helper.dart';

void main() {

  RunModeService.setRunMode(RunMode.unitTesting);

  final controller = JobSummaryController();

  JobModel jobModel = mockedJob;

  late Map<String, dynamic> requestParams;

  setUpAll(() {
    requestParams = JobRequestParams.forJobSummary(jobModel.id);
    controller.job = jobModel;
    controller.jobId = jobModel.id;
    controller.customerId = jobModel.customerId;
  });

  test('JobSummaryController should be initialized with these values', () {
    controller.onInit();
    expect(controller.job, jobModel);
    expect(controller.workFlowStagesParams, null);
    expect(controller.selectedSlug, 'job_overview');
    expect(controller.isLoading, true);
    expect(controller.isJobDetailExpanded, true);
    expect(controller.customerId, jobModel.customerId);
    expect(controller.jobId, jobModel.id);
    expect(controller.tabController.length, 3);
    expect(controller.tabController.index, 0);
    expect(controller.customerInfo, <CustomerInfo>[]);
    expect(controller.users, <JPMultiSelectModel>[]);
  });

  test('Api should request params while loading data from api', () {
    expect(JobRequestParams.forJobSummary(controller.jobId), requestParams);
  });

  test('On job change new job data should be loaded', () {
    controller.handleChangeJob(1);
    expect(controller.jobId, 1);
    expect(controller.isLoading, true);
    expect(controller.tabController.index, 0);
  });

  group('On Refresh same job should be reloaded again', () {

    test('Loader/shimmer should be displayed', () {
      controller.refreshPage(showLoading: true);
      expect(controller.isLoading, true);
    });

    test('Loader/shimmer should not be displayed', () {
      controller.refreshPage();
      expect(controller.isLoading, false);
    });
  });

  group('setUpCustomerInfo() should set up available user information', () {

    test('Customer email should be added', () {
      jobModel.customer?.email = '1@gmail.com';
      controller.setUpCustomerInfo();
      expect(controller.customerInfo.length, 1);
    });

    test('Additional emails should be added', () {
      jobModel.customer?.additionalEmails = ['2@gmail.com', '3@c.com'];
      controller.setUpCustomerInfo();
      expect(controller.customerInfo.length, 3);
    });

    test('Phones should be added', () {
      jobModel.customer?.phones = [PhoneModel(number: '33')];
      controller.setUpCustomerInfo();
      expect(controller.customerInfo.length, 4);
    });

    test('Address should be added', () {
      jobModel.customer?.addressString = 'New york city';
      controller.setUpCustomerInfo();
      expect(controller.customerInfo.length, 5);
    });

    group('Lead source should be based on referred type', () {

      test("When not referred by", () {
        controller.setUpCustomerInfo();
        expect(controller.customerInfo.length, 5);
      });

      test('When referred by customer', () {
        jobModel.customer?.referredByType = "customer";
        controller.setUpCustomerInfo();
        expect(controller.customerInfo.length, 6);
      });

      test('When referred by referral', () {
        jobModel.customer?.referredByType = "referral";
        controller.setUpCustomerInfo();
        expect(controller.customerInfo.length, 5);
      });

      test('When referred by other', () {
        jobModel.customer?.referredByType = "other";
        controller.setUpCustomerInfo();
        expect(controller.customerInfo.length, 5);
      });

    });

  });

  group('JobSummaryService@quickActions', () {
    setUpAll(() {
      AuthService.userDetails = UserModel(
          id: 1,
          firstName: '',
          fullName: '',
          email: ''
      );
    });
    group('JobSummaryActions@Call/Text', () {
      group('Call & Text option should be visible', () {
        testWidgets('In case isPrimeSubUser is true', (widgetTester) async {
          isPrimeSubUser = true;
          isDataMasking = false;
          await widgetTester.pumpWidget(getJPPlusButtonSheet(jobModel));

          expect(findByLabel('call'.tr), findsOneWidget);
          expect(findByLabel('text'), findsOneWidget);
        });

        testWidgets('In case isDataMasking is true', (widgetTester) async {
          isPrimeSubUser = false;
          isDataMasking = true;
          await widgetTester.pumpWidget(getJPPlusButtonSheet(jobModel));

          expect(findByLabel('call'.tr), findsOneWidget);
          expect(findByLabel('text'.tr), findsOneWidget);
        });

        testWidgets('In case isPrimeSubUser & isDataMasking both are false', (widgetTester) async {
          isPrimeSubUser = false;
          isDataMasking = false;
          await widgetTester.pumpWidget(getJPPlusButtonSheet(jobModel));

          expect(findByLabel('call'.tr), findsOneWidget);
          expect(findByLabel('text'.tr), findsOneWidget);
        });
      });

      testWidgets('Call & Text option should not be visible', (widgetTester) async {
        isPrimeSubUser = true;
        isDataMasking = true;
        await widgetTester.pumpWidget(getJPPlusButtonSheet(jobModel));

        expect(findByLabel('call'.tr), findsNothing);
        expect(findByLabel('text'.tr), findsNothing);
      });
    });

    testWidgets('JobSummaryActions@email option should be visible', (widgetTester) async {
      await widgetTester.pumpWidget(getJPPlusButtonSheet(jobModel));
      expect(findByLabel('email'.tr), findsOneWidget);
    });

    testWidgets('JobSummaryActions@task option should be visible', (widgetTester) async {
      await widgetTester.pumpWidget(getJPPlusButtonSheet(jobModel));
      expect(findByLabel('task'.tr), findsOneWidget);
    });

    group('JobSummaryActions@jobProjectNote', () {

      group('Job notes', () {
        testWidgets('Should be visible when Job does not have a parent job', (widgetTester) async {
          jobModel.parentId = null;
          await widgetTester.pumpWidget(getJPPlusButtonSheet(jobModel));
          expect(findByLabel('job_notes'.tr.capitalize!), findsOneWidget);
        });

        testWidgets('Should not be visible when Job has a parent job', (widgetTester) async {
          jobModel.parentId = 12;
          await widgetTester.pumpWidget(getJPPlusButtonSheet(jobModel));
          expect(findByLabel('job_notes'.tr.capitalize!), findsNothing);
        });
      });

      group('Project notes', () {
        testWidgets('When the option is visible', (widgetTester) async {
          jobModel.parentId = 12;
          await widgetTester.pumpWidget(getJPPlusButtonSheet(jobModel));
          expect(findByLabel('project_notes'.tr.capitalize!), findsOneWidget);
        });

        testWidgets('When the option is not visible', (widgetTester) async {
          jobModel.parentId = null;
          await widgetTester.pumpWidget(getJPPlusButtonSheet(jobModel));
          expect(findByLabel('project_notes'.tr.capitalize!), findsNothing);
        });
      });
    });

    group('JobSummaryActions@followUps', () {
      testWidgets('Follow-Up option should be visible', (widgetTester) async {
        isPrimeSubUser = false;
        await widgetTester.pumpWidget(getJPPlusButtonSheet(jobModel));
        expect(findByLabel('follow_up'.tr), findsOneWidget);
      });

      testWidgets('Follow-Up option should not be visible', (widgetTester) async {
        isPrimeSubUser = true;
        await widgetTester.pumpWidget(getJPPlusButtonSheet(jobModel));
        expect(findByLabel('follow_up'.tr), findsNothing);
      });
    });

    group('JobSummaryActions@appointment', () {
      testWidgets('Appointment option should be visible', (widgetTester) async {
        jobModel.parentId = null;
        await widgetTester.pumpWidget(getJPPlusButtonSheet(jobModel));
        expect(findByLabel('appointment'), findsOneWidget);
      });

      testWidgets('Appointment option should not be visible', (widgetTester) async {
        jobModel.parentId = 21;
        await widgetTester.pumpWidget(getJPPlusButtonSheet(jobModel));
        expect(findByLabel('appointment'.tr), findsNothing);
      });
    });

    testWidgets('JobSummaryActions@message option should be visible', (widgetTester) async {
      await widgetTester.pumpWidget(getJPPlusButtonSheet(jobModel));
      expect(findByLabel('message'.tr), findsOneWidget);
    });

    testWidgets('JobSummaryActions@photo option should be visible', (widgetTester) async {
      await widgetTester.pumpWidget(getJPPlusButtonSheet(jobModel));
      expect(findByLabel('photo'.tr), findsOneWidget);
    });

    testWidgets('JobSummaryActions@measurement option should be visible', (widgetTester) async {

      await widgetTester.pumpWidget(getJPPlusButtonSheet(jobModel));
      expect(findByLabel('measurement'.tr), findsOneWidget);
    });

    group('JobSummaryActions@estimating', () {
      testWidgets('Estimate option should be visible', (widgetTester) async {
        if(!PermissionService.hasUserPermissions([PermissionConstants.manageEstimates])) {
          PermissionService.permissionList.add(
              PermissionConstants.manageEstimates);
        }

        await widgetTester.pumpWidget(getJPPlusButtonSheet(jobModel));

        expect(findByLabel('estimate'.tr), findsOneWidget);
      });

      testWidgets('Estimate option should not be visible', (widgetTester) async {
        PermissionService.permissionList.remove(PermissionConstants.manageEstimates);

        await widgetTester.pumpWidget(getJPPlusButtonSheet(jobModel));

        expect(findByLabel('estimating'.tr), findsNothing);
      });
    });

    group('JobSummaryActions@formProposal', () {
      testWidgets('FormProposal option should be visible', (widgetTester) async {
        if(!PermissionService.hasUserPermissions([PermissionConstants.manageProposals])) {
          PermissionService.permissionList.add(
              PermissionConstants.manageProposals);
        }
        jobModel.parentId = null;

        await widgetTester.pumpWidget(getJPPlusButtonSheet(jobModel));

        expect(findByLabel('form_proposals'.tr), findsOneWidget);
      });

      testWidgets("FormProposal option label should be 'Documents'", (widgetTester) async {
        if(!PermissionService.hasUserPermissions([PermissionConstants.manageProposals])) {
          PermissionService.permissionList.add(
              PermissionConstants.manageProposals);
        }
        jobModel.parentId = null;

        await widgetTester.pumpWidget(getJPPlusButtonSheet(jobModel));
        final formProposalLabel = (find.byType(JPText).at(9).evaluate().single.widget as JPText).text.trim();

        expect(findByLabel('form_proposals'.tr), findsOneWidget);
        expect(formProposalLabel, 'Documents');
      });

      group('FormProposal option should not be visible', () {
        testWidgets('In case PermissionService.permissionList has no value for managerProposals', (widgetTester) async {
          PermissionService.permissionList.remove(PermissionConstants.manageProposals);
          jobModel.parentId = null;

          await widgetTester.pumpWidget(getJPPlusButtonSheet(jobModel));

          expect(findByLabel('form_proposals'.tr), findsNothing);
        });

        testWidgets('In case JobModel@parentId has value', (widgetTester) async {
          if(!PermissionService.hasUserPermissions([PermissionConstants.manageProposals])) {
            PermissionService.permissionList.add(
                PermissionConstants.manageProposals);
          }
          jobModel.parentId = 12;

          await widgetTester.pumpWidget(getJPPlusButtonSheet(jobModel));

          expect(findByLabel('form_proposals'.tr), findsNothing);
        });
      });
    });

    group('JobSummaryActions@jobProjectPrice', () {

      group('JobPrice', () {

        setUpAll(() {
          jobModel.parentId = null;
        });

        setUp(() {
          isSubUser = false;
          jobModel.isMultiJob = false;
          PermissionService.permissionList = [];
        });

        group('Job price option should be visible', () {

          setUp(() {
            PermissionService.permissionList = [];
          });

          testWidgets('When job has single job and user is not a sub user and user have permission to manage financial', (widgetTester) async {
            if(!PermissionService.hasUserPermissions([PermissionConstants.manageFinancial])) {
              PermissionService.permissionList.add(
                  PermissionConstants.manageFinancial);
            }

            await widgetTester.pumpWidget(getJPPlusButtonSheet(jobModel));

            await widgetTester.scrollUntilVisible(findByLabel('job_price'.tr), 100);

            expect(findByLabel('job_price'.tr), findsOneWidget);
          });

          testWidgets('When job is not multi job for other than sub user with view financial & update price permission', (widgetTester) async {
            if(!PermissionService.hasUserPermissions([PermissionConstants.viewFinancial,
              PermissionConstants.updateJobPrice])) {
              PermissionService.permissionList.addAll([
                PermissionConstants.viewFinancial,
                PermissionConstants.updateJobPrice
              ]);
            }

            await widgetTester.pumpWidget(getJPPlusButtonSheet(jobModel));

            await widgetTester.scrollUntilVisible(findByLabel('job_price'.tr), 100);

            expect(findByLabel('job_price'.tr), findsOneWidget);
          });
        });

        group('Job price option should not be visible', () {
          setUp(() {
            jobModel.isMultiJob = false;
            isSubUser = false;
            PermissionService.permissionList = [
              PermissionConstants.manageFinancial,
              PermissionConstants.viewFinancial,
              PermissionConstants.updateJobPrice
            ];
          });
          testWidgets('In case user has multi job', (widgetTester) async {
            jobModel.isMultiJob = true;

            await widgetTester.pumpWidget(getJPPlusButtonSheet(jobModel));

            expect(findByLabel('job_price'.tr), findsNothing);
          });

          testWidgets('In case user is sub user', (widgetTester) async {
            isSubUser = true;

            await widgetTester.pumpWidget(getJPPlusButtonSheet(jobModel));

            expect(findByLabel('job_price'.tr), findsNothing);
          });

          testWidgets('In case user have no permission to manage financial and to view financial and to update the price', (widgetTester) async {
            PermissionService.permissionList.removeWhere((element) {
              return element == PermissionConstants.manageFinancial ||
                  element == PermissionConstants.viewFinancial ||
                  element == PermissionConstants.updateJobPrice;
            });
            await widgetTester.pumpWidget(getJPPlusButtonSheet(jobModel));

            expect(findByLabel('job_price'.tr), findsNothing);
          });

        });
      });

      group('ProjectPrice', () {

        setUpAll(() {
          jobModel.parentId = 32;
        });

        setUp(() {
          isSubUser = false;
          jobModel.isMultiJob = false;
          PermissionService.permissionList = [];
        });

        group('Project price option should be visible', () {

          setUp(() {
            PermissionService.permissionList = [];
          });

          testWidgets('When job has single job and user is not a sub user and user have permission to manage financial', (widgetTester) async {
            if(!PermissionService.hasUserPermissions([PermissionConstants.manageFinancial])) {
              PermissionService.permissionList.add(
                  PermissionConstants.manageFinancial);
            }

            await widgetTester.pumpWidget(getJPPlusButtonSheet(jobModel));

            expect(findByLabel('project_price'.tr), findsOneWidget);
          });

          testWidgets('When job has single job and user is not a sub user and user have permission to view financial and update the price', (widgetTester) async {
            if(!PermissionService.hasUserPermissions([
              PermissionConstants.viewFinancial,
              PermissionConstants.updateJobPrice
            ])) {
              PermissionService.permissionList.addAll([
                PermissionConstants.viewFinancial,
                PermissionConstants.updateJobPrice
              ]);
            }

            await widgetTester.pumpWidget(getJPPlusButtonSheet(jobModel));

            expect(findByLabel('project_price'.tr), findsOneWidget);
          });
        });

        group('Project price option should not be visible', () {
          setUp(() {
            jobModel.isMultiJob = false;
            isSubUser = false;
            PermissionService.permissionList = [
              PermissionConstants.manageFinancial,
              PermissionConstants.viewFinancial,
              PermissionConstants.updateJobPrice
            ];
          });
          testWidgets('In case user has multi job', (widgetTester) async {
            jobModel.isMultiJob = true;

            await widgetTester.pumpWidget(getJPPlusButtonSheet(jobModel));

            expect(findByLabel('project_price'.tr), findsNothing);
          });

          testWidgets('In case user is sub user', (widgetTester) async {
            isSubUser = true;

            await widgetTester.pumpWidget(getJPPlusButtonSheet(jobModel));

            expect(findByLabel('project_price'.tr), findsNothing);
          });

          testWidgets('In case user have no permission to manage financial and to view financial and to update the price', (widgetTester) async {
            PermissionService.permissionList.removeWhere((element) {
              return element == PermissionConstants.manageFinancial ||
                  element == PermissionConstants.viewFinancial ||
                  element == PermissionConstants.updateJobPrice;
            });
            await widgetTester.pumpWidget(getJPPlusButtonSheet(jobModel));

            expect(findByLabel('job_price'.tr), findsNothing);
          });

        });
      });
    });

    group('JobSummaryActions@workCrew', () {

      testWidgets('WorkCrew option should be visible', (widgetTester) async {
        isFeatureEnabled = true;
        isPrimeSubUser = false;
        isSubUser = false;
        jobModel.isMultiJob = false;

        await widgetTester.pumpWidget(getJPPlusButtonSheet(jobModel));

        expect(findByLabel('work_crew'.tr), findsOneWidget);
      });

      group('WorkCrew option should not be visible', () {

        setUpAll(() {
          isFeatureEnabled = false;
          isPrimeSubUser = false;
          isSubUser = false;
          jobModel.isMultiJob = false;
        });

        testWidgets('When user is prime sub user', (widgetTester) async {
          isPrimeSubUser = true;

          await widgetTester.pumpWidget(getJPPlusButtonSheet(jobModel));

          expect(findByLabel('work_crew'.tr), findsNothing);
        });

        testWidgets('When user is not a prime and user is sub user but job has single job and production feature is not allowed', (widgetTester) async {
          isFeatureEnabled = false;
          isPrimeSubUser = false;
          isSubUser = true;
          jobModel.isMultiJob = false;

          await widgetTester.pumpWidget(getJPPlusButtonSheet(jobModel));

          expect(findByLabel('work_crew'.tr), findsNothing);
        });

        testWidgets('When user is not prime sub user but user is sub user and job has multiple jobs and production feature is not allowed', (widgetTester) async {
          isFeatureEnabled = false;
          isPrimeSubUser = false;
          isSubUser = true;
          jobModel.isMultiJob = true;

          await widgetTester.pumpWidget(getJPPlusButtonSheet(jobModel));

          expect(findByLabel('work_crew'.tr), findsNothing);
        });
      });
    });

    group('JobSummaryActions@scheduleJobProject', () {

      setUpAll(() {
        isFeatureEnabled = true;
      });

      group('Job Schedule', () {

        setUpAll(() {
          jobModel.parentId = null;
        });

        testWidgets('Schedule option should be visible', (widgetTester) async {
          if(!PermissionService.hasUserPermissions([PermissionConstants.manageJobSchedule])) {
            PermissionService.permissionList.add(
                PermissionConstants.manageJobSchedule);
          }
          jobModel.isMultiJob = false;
          isFeatureEnabled = true;

          await widgetTester.pumpWidget(getJPPlusButtonSheet(jobModel));
          expect(findByLabel('schedule_job'.tr), findsOneWidget);
        });

        group('Schedule option should not be visible', () {

          testWidgets('When user has no permission to manage schedule', (widgetTester) async {
            PermissionService.permissionList.remove(PermissionConstants.manageJobSchedule);

            await widgetTester.pumpWidget(getJPPlusButtonSheet(jobModel));
            expect(findByLabel('schedule_job'.tr), findsNothing);
          });

          testWidgets('When job has multiple job', (widgetTester) async {
            jobModel.isMultiJob = true;

            await widgetTester.pumpWidget(getJPPlusButtonSheet(jobModel));
            expect(findByLabel('schedule_job'.tr), findsNothing);
          });
        });
      });

      group('Project Schedule', () {

        setUpAll(() {
          jobModel.parentId = 23;
        });

        testWidgets('Schedule option should be visible', (widgetTester) async {
          if(!PermissionService.hasUserPermissions([PermissionConstants.manageJobSchedule])) {
            PermissionService.permissionList.add(
                PermissionConstants.manageJobSchedule);
          }
          jobModel.isMultiJob = false;
          isFeatureEnabled = true;

          await widgetTester.pumpWidget(getJPPlusButtonSheet(jobModel));
          expect(findByLabel('schedule_project'.tr), findsOneWidget);
        });

        group('Schedule option should not be visible', () {

          testWidgets('When user has no permission to manage schedule', (widgetTester) async {
            PermissionService.permissionList.remove(PermissionConstants.manageJobSchedule);

            await widgetTester.pumpWidget(getJPPlusButtonSheet(jobModel));
            expect(findByLabel('schedule_project'.tr), findsNothing);
          });

          testWidgets('When job has multiple job', (widgetTester) async {
            jobModel.isMultiJob = true;

            await widgetTester.pumpWidget(getJPPlusButtonSheet(jobModel));
            expect(findByLabel('schedule_project'.tr), findsNothing);
          });
        });
      });
    });

    group('JobSummaryActions@invoice', () {

      group('Invoice should be visible', () {

        setUpAll(() {
          isFeatureEnabled = true;
        });

        setUp(() {
          if(!PermissionService.hasUserPermissions([PermissionConstants.manageFinancial])) {
            PermissionService.permissionList.add(
                PermissionConstants.manageFinancial);
          }
          jobModel.jobInvoices = [];
        });

        testWidgets('When financial details is not available', (widgetTester) async {
          jobModel.financialDetails = null;

          await widgetTester.pumpWidget(getJPPlusButtonSheet(jobModel));

          expect(findByLabel('invoice'.tr), findsOneWidget);
        });

        testWidgets('When financial details is available but financial can be blocked', (widgetTester) async {
          jobModel.financialDetails = FinancialDetailModel(
              canBlockFinancial: false
          );

          await widgetTester.pumpWidget(getJPPlusButtonSheet(jobModel));

          expect(findByLabel('invoice'.tr), findsOneWidget);
        });
      });

      group('Invoice should not be visible', () {

        setUpAll(() {
          isFeatureEnabled = false;
        });

        testWidgets('When user has no permission to manage financial', (widgetTester) async {
          PermissionService.permissionList.remove(PermissionConstants.manageFinancial);

          await widgetTester.pumpWidget(getJPPlusButtonSheet(jobModel));
          expect(findByLabel('invoice'.tr), findsNothing);
        });

        testWidgets('When invoice is not available', (widgetTester) async {
          jobModel.jobInvoices = [];

          await widgetTester.pumpWidget(getJPPlusButtonSheet(jobModel));
          expect(findByLabel('invoice'.tr), findsNothing);
        });

        testWidgets('When financial details is available and can be blocked', (widgetTester) async {
          jobModel.financialDetails = FinancialDetailModel(
              canBlockFinancial: true
          );

          await widgetTester.pumpWidget(getJPPlusButtonSheet(jobModel));
          expect(findByLabel('invoice'.tr), findsNothing);
        });

        testWidgets('When production feature is not allowed', (widgetTester) async {
          isFeatureEnabled = false;
        });

      });
    });

    group('JobSummaryActions@changeOrder', () {
      group('Change Order should be visible', () {

        setUpAll(() {
          isFeatureEnabled = true;
        });

        setUp(() {
          if(!PermissionService.hasUserPermissions([PermissionConstants.manageFinancial])) {
            PermissionService.permissionList.add(
                PermissionConstants.manageFinancial);
          }
          jobModel.jobInvoices = [JobInvoices()];
          jobModel.isMultiJob = false;
          jobModel.parentId = null;
        });

        testWidgets('When financial details is not available', (widgetTester) async {
          jobModel.financialDetails = null;

          await widgetTester.pumpWidget(getJPPlusButtonSheet(jobModel));

          expect(findByLabel('change_order'.tr), findsOneWidget);
        });

        testWidgets('When financial details is available but financial can be blocked', (widgetTester) async {
          jobModel.financialDetails = FinancialDetailModel(
              canBlockFinancial: false
          );

          await widgetTester.pumpWidget(getJPPlusButtonSheet(jobModel));

          expect(findByLabel('change_order'.tr), findsOneWidget);
        });
      });

      group('Change Order should not be visible', () {

        setUpAll(() {
          isFeatureEnabled = false;
        });

        testWidgets('When user has no permission to manage financial', (widgetTester) async {
          PermissionService.permissionList.remove(PermissionConstants.manageFinancial);

          await widgetTester.pumpWidget(getJPPlusButtonSheet(jobModel));
          expect(findByLabel('change_order'.tr), findsNothing);
        });

        testWidgets('When invoice is not available', (widgetTester) async {
          jobModel.jobInvoices = [];

          await widgetTester.pumpWidget(getJPPlusButtonSheet(jobModel));
          expect(findByLabel('change_order'.tr), findsNothing);
        });

        testWidgets('When job has multiple job', (widgetTester) async {
          jobModel.isMultiJob = true;

          await widgetTester.pumpWidget(getJPPlusButtonSheet(jobModel));
          expect(findByLabel('change_order'.tr), findsNothing);
        });

        testWidgets('When job has parent job', (widgetTester) async {
          jobModel.parentId = 12;

          await widgetTester.pumpWidget(getJPPlusButtonSheet(jobModel));
          expect(findByLabel('change_order'.tr), findsNothing);
        });

        testWidgets('When financial details is available and can be blocked', (widgetTester) async {
          jobModel.financialDetails = FinancialDetailModel(
              canBlockFinancial: true
          );

          await widgetTester.pumpWidget(getJPPlusButtonSheet(jobModel));
          expect(findByLabel('change_order'.tr), findsNothing);
        });

        testWidgets('production feature is not allowed', (widgetTester) async {
          isFeatureEnabled = false;

          await widgetTester.pumpWidget(getJPPlusButtonSheet(jobModel));
          expect(findByLabel('change_order'.tr), findsNothing);
        });

      });
    });

    group('JobSummaryActions@bill', () {
      testWidgets('Bill should be visible', (widgetTester) async {

        isFeatureEnabled = true;
        if(!PermissionService.hasUserPermissions([PermissionConstants.manageFinancial])) {
          PermissionService.permissionList.add(
              PermissionConstants.manageFinancial);
        }
        jobModel.isMultiJob = false;

        await widgetTester.pumpWidget(getJPPlusButtonSheet(jobModel));
        expect(findByLabel('bill'.tr), findsOneWidget);

      });

      group('Bill should not be visible', () {

        setUpAll(() {
          isFeatureEnabled = false;
        });

        testWidgets('When user has no permission to manage financial', (widgetTester) async {
          PermissionService.permissionList.remove(PermissionConstants.manageFinancial);

          await widgetTester.pumpWidget(getJPPlusButtonSheet(jobModel));
          expect(findByLabel('bill'.tr), findsNothing);
        });

        testWidgets('When job has multiple job', (widgetTester) async {
          jobModel.isMultiJob = true;

          await widgetTester.pumpWidget(getJPPlusButtonSheet(jobModel));
          expect(findByLabel('bill'.tr), findsNothing);
        });

        testWidgets('When production feature is not allowed', (widgetTester) async {
          isFeatureEnabled = false;

          await widgetTester.pumpWidget(getJPPlusButtonSheet(jobModel));
          expect(findByLabel('bill'.tr), findsNothing);
        });

      });
    });

    group('JobSummaryActions@Refund', () {

      group('Refund option should be visible', () {

        setUpAll(() {
          isFeatureEnabled = true;
        });

        setUp(() {
          if(!PermissionService.hasUserPermissions([PermissionConstants.manageFinancial])) {
            PermissionService.permissionList.add(
                PermissionConstants.manageFinancial);
          }
          jobModel.isMultiJob = false;
        });

        testWidgets('When financial details is not available', (widgetTester) async {
          jobModel.financialDetails = null;

          await widgetTester.pumpWidget(getJPPlusButtonSheet(jobModel));

          await widgetTester.scrollUntilVisible(findByLabel('refund'.tr), 100);

          expect(findByLabel('refund'.tr), findsOneWidget);
        });

        testWidgets('When financial details is available but financial can be blocked', (widgetTester) async {
          jobModel.financialDetails = FinancialDetailModel(
              canBlockFinancial: false
          );

          await widgetTester.pumpWidget(getJPPlusButtonSheet(jobModel));

          await widgetTester.scrollUntilVisible(findByLabel('refund'.tr), 100);

          expect(findByLabel('refund'.tr), findsOneWidget);
        });
      });

      group('Refund should not be visible', () {

        setUpAll(() {
          isFeatureEnabled = false;
        });

        testWidgets('When user has no permission to manage financial', (widgetTester) async {
          PermissionService.permissionList.remove(PermissionConstants.manageFinancial);

          await widgetTester.pumpWidget(getJPPlusButtonSheet(jobModel));
          expect(findByLabel('refund'.tr), findsNothing);
        });

        testWidgets('When job has multiple job', (widgetTester) async {
          jobModel.isMultiJob = true;

          await widgetTester.pumpWidget(getJPPlusButtonSheet(jobModel));
          expect(findByLabel('refund'.tr), findsNothing);
        });

        testWidgets('When financial details is available and can be blocked', (widgetTester) async {
          jobModel.financialDetails = FinancialDetailModel(
              canBlockFinancial: true
          );

          await widgetTester.pumpWidget(getJPPlusButtonSheet(jobModel));
          expect(findByLabel('refund'.tr), findsNothing);
        });

        testWidgets('When production is not featured', (widgetTester) async {
          isFeatureEnabled = false;
        });

      });

    });

    group('JobSummaryActions@clockIn', () {

      testWidgets('ClockIn option should be visible', (widgetTester) async {
        showClockIn = true;
        isFeatureEnabled = true;

        await widgetTester.pumpWidget(getJPPlusButtonSheet(jobModel));
        expect(findByLabel('clock_in'.tr), findsOneWidget);
      });

      group('ClockIn option should not be visible', () {

        testWidgets('When user management feature is available and user is not clockedIn', (widgetTester) async {
          isFeatureEnabled = true;
          showClockIn = false;

          await widgetTester.pumpWidget(getJPPlusButtonSheet(jobModel));
          expect(findByLabel('clock_in'.tr), findsNothing);
        });

        testWidgets('When user is not clocked-in', (widgetTester) async {
          showClockIn = false;

          await widgetTester.pumpWidget(getJPPlusButtonSheet(jobModel));
          expect(findByLabel('clock_in'.tr), findsNothing);
        });
      });
    });

    group('JobSummaryActions@clockOut', () {
      testWidgets('Clock out option should be visible', (widgetTester) async {
        showClockIn = false;
        isFeatureEnabled = true;

        await widgetTester.pumpWidget(getJPPlusButtonSheet(jobModel));
        expect(findByLabel('clock_out'.tr), findsOneWidget);
      });

      group('Clock out option should not be visible', () {

        testWidgets('When user management feature is not available and user is clockedIn', (widgetTester) async {
          isFeatureEnabled = false;
          showClockIn = true;

          await widgetTester.pumpWidget(getJPPlusButtonSheet(jobModel));
          expect(findByLabel('clock_out'.tr), findsNothing);
        });

        testWidgets('When user is clocked-in', (widgetTester) async {
          showClockIn = true;

          await widgetTester.pumpWidget(getJPPlusButtonSheet(jobModel));
          expect(findByLabel('clock_out'.tr), findsNothing);
        });
      });
    });

    group('JobSummaryActions@progressBoard', () {

      testWidgets('Progress board option should be visible', (widgetTester) async {
        isSubUser = false;
        jobModel.productionBoards = [];
        if(!PermissionService.hasUserPermissions([PermissionConstants.manageProgressBoard])) {
          PermissionService.permissionList.add(PermissionConstants.manageProgressBoard);
        }

        await widgetTester.pumpWidget(getJPPlusButtonSheet(jobModel));

        await widgetTester.scrollUntilVisible(findByLabel('progress_board'.tr), 100);

        expect(findByLabel('progress_board'.tr), findsOneWidget);
      });

      group('Progress board option should not be visible', () {

        testWidgets('When user is a sub user', (widgetTester) async {
          isSubUser = true;

          await widgetTester.pumpWidget(getJPPlusButtonSheet(jobModel));
          expect(findByLabel('progress_board'.tr), findsNothing);
        });

        testWidgets('When data is available in progress board', (widgetTester) async {
          jobModel.productionBoards = [
            JobProductionBoardModel()
          ];

          await widgetTester.pumpWidget(getJPPlusButtonSheet(jobModel));
          expect(findByLabel('progress_board'.tr), findsNothing);
        });

        testWidgets('When user has no permission to manage progress board', (widgetTester) async {
          PermissionService.permissionList.remove(PermissionConstants.manageProgressBoard);

          await widgetTester.pumpWidget(getJPPlusButtonSheet(jobModel));
          expect(findByLabel('progress_board'.tr), findsNothing);
        });
      });

      group('JobSummaryActions@estimating option should be hidden as per ${LDFlagKeyConstants.salesProForEstimate} LD Flag', () {
        testWidgets('Estimate option should not be visible when ${LDFlagKeyConstants.salesProForEstimate} is enabled', (widgetTester) async {
          PermissionService.permissionList.add(PermissionConstants.manageEstimates);
          LDFlags.salesProForEstimate.value = true;
          await widgetTester.pumpWidget(getJPPlusButtonSheet(jobModel));
          expect(findByLabel('estimate'.tr), findsNothing);
        });

        testWidgets('Estimate option should be visible when  ${LDFlagKeyConstants.salesProForEstimate} is disabled', (widgetTester) async {
          PermissionService.permissionList.add(PermissionConstants.manageEstimates);
          LDFlags.salesProForEstimate.value = false;
          await widgetTester.pumpWidget(getJPPlusButtonSheet(jobModel));
          expect(findByLabel('estimate'.tr), findsOneWidget);
        });
      });
    });

    testWidgets('File Upload option should be visible', (widgetTester) async {
      isSubUser = false;
      jobModel.productionBoards = [];
      if(!PermissionService.hasUserPermissions([PermissionConstants.manageProgressBoard])) {
        PermissionService.permissionList.add(PermissionConstants.manageProgressBoard);
      }

      await widgetTester.pumpWidget(getJPPlusButtonSheet(jobModel));

      await widgetTester.scrollUntilVisible(findByLabel('file'.tr), 100);

      expect(findByLabel('file'.tr), findsOneWidget);
    });

    testWidgets('Scan & Upload option should be visible', (widgetTester) async {
      isSubUser = false;
      jobModel.productionBoards = [];
      if(!PermissionService.hasUserPermissions([PermissionConstants.manageProgressBoard])) {
        PermissionService.permissionList.add(PermissionConstants.manageProgressBoard);
      }

      await widgetTester.pumpWidget(getJPPlusButtonSheet(jobModel));

      await widgetTester.scrollUntilVisible(findByLabel('scan'.tr), 100);

      expect(findByLabel('scan'.tr), findsOneWidget);
    });

    group("Upload options should be rendered in correct order", () {

      setUp(() {
        AuthService.userDetails = UserModel(
            id: 1,
            firstName: '',
            fullName: '',
            email: ''
        );
      });

      testWidgets("Scan option should be at 7th place in options", (widgetTester) async {
        await widgetTester.pumpWidget(getJPPlusButtonSheet(jobModel));
        final scanLabel = (find.byType(JPText).at(6).evaluate().single.widget as JPText).text.trim();
        expect(scanLabel, 'scan'.tr);
      });

      testWidgets("File option should be at 8th place in options", (widgetTester) async {
        await widgetTester.pumpWidget(getJPPlusButtonSheet(jobModel));
        final uploadLabel = (find.byType(JPText).at(7).evaluate().single.widget as JPText).text.trim();
        expect(uploadLabel, 'file'.tr.capitalize!);
      });

      testWidgets("Photo option should be at 9th place in options", (widgetTester) async {
        await widgetTester.pumpWidget(getJPPlusButtonSheet(jobModel));
        final estimateLabel = (find.byType(JPText).at(8).evaluate().single.widget as JPText).text.trim();
        expect(estimateLabel, 'photo'.tr.capitalize!);
      });
    });
  });

}

final mockedJob = JobModel(
    id: 1,
    customerId: 1,
    customer: CustomerModel()
);

Widget getJPPlusButtonSheet(JobModel? jobModel) => TestHelper.buildWidget(JPPlusButtonSheet(
  job: jobModel,
  options: JobSummaryService.quickActions(jobModel),
  onTapOption: (id) {
  },
  onActionComplete: (String action) {},
), useTranslations: true);

Finder findByLabel(String label) =>
    find.byKey(Key(label));

set isSubUser(bool value) {
  if(value) {
    AuthService.userDetails?.groupId =
        UserGroupIdConstants.subContractor;
  } else {
    AuthService.userDetails?.groupId = -1;
  }
}

set isPrimeSubUser(bool value) {
  if(value) {
    AuthService.userDetails?.groupId =
        UserGroupIdConstants.subContractorPrime;
  } else {
    AuthService.userDetails?.groupId = -1;
  }
}

set isDataMasking(bool value) {
  AuthService.userDetails?.dataMasking = value;
}

set isFeatureEnabled(bool value) {
  if(value) {
    FeatureFlagService.setFeatureData({
      FeatureFlagConstant.production: 1
    });
  } else {
    FeatureFlagService.featureFlagList
        .remove(FeatureFlagConstant.production);
  }
}

set showClockIn(bool value) {
  if(value) {
    ClockInClockOutService.checkInDetails = ClockSummaryTimeLogDetails(
    )..jobModel = JobModel(id: 2, customerId: 1);
  } else {
    ClockInClockOutService.checkInDetails = ClockSummaryTimeLogDetails(
    )..jobModel = mockedJob;
  }
}