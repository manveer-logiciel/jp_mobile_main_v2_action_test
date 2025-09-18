import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/company_contacts.dart';
import 'package:jobprogress/common/models/customer/customer.dart';
import 'package:jobprogress/common/models/job/customer_info.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/job_summary/customize/section_item.dart';
import 'package:jobprogress/common/models/phone.dart';
import 'package:jobprogress/common/models/sql/user/user_limited.dart';
import 'package:jobprogress/core/constants/job_overview.dart';
import 'package:jobprogress/core/constants/locale.dart';
import 'package:jobprogress/modules/job/job_summary/widgets/details/index.dart';
import 'package:jobprogress/translations/index.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('JobOverViewDetails should render job details properly', () {
    // Mock data for testing
    late JobModel jobModel;
    late List<CustomerInfo> customerInfo;
    late List<CompanyContactListingModel> contactPersons;
    late TabController tabController;
    late TickerProvider vsync;
    late List<JobOverviewSectionItem> sectionItems;

    setUp(() {
      // Initialize GetX in setUp
      Get.reset();
      Get.testMode = true;
      Get.addTranslations(JPTranslations().keys);
      Get.locale = LocaleConst.usa;

      // Initialize a simple TestVSync for TabController
      vsync = const TestVSync();

      // Create mock data with properly initialized UserLimitedModel
      jobModel = JobModel(
        id: 1,
        customerId: 1,
        isProject: false,
        customer: CustomerModel(
          id: 1,
          rep: UserLimitedModel(
            id: 1,
            firstName: "Test",
            lastName: "Rep",
            fullName: "Test Rep",
            email: "test@example.com",
            groupId: 1,
            phones: [
              PhoneModel(
                id: 1,
                number: "555-123-4567",
                label: "Mobile",
              ),
            ],
          ),
        ),
      );

      customerInfo = [];
      contactPersons = [];

      // Default section items (job, customer, contact person)
      sectionItems = JobOverviewSectionItem.defaultSections;

      // Initialize TabController with 3 tabs
      tabController = TabController(length: 3, vsync: vsync);
    });

    testWidgets('should display tabs in the standard default order (Job, Customer, Contact Person) when using default sections', (WidgetTester tester) async {
      // Build our widget with default section order
      await tester.pumpWidget(
        GetMaterialApp(
          locale: const Locale('en', 'US'),
          home: Scaffold(
            body: JobOverViewDetails(
              tabController: tabController,
              job: jobModel,
              customerInfo: customerInfo,
              contactPerson: contactPersons,
              isJobDetailExpanded: true,
              sectionItems: sectionItems,
            ),
          ),
        ),
      );

      // Default order should be: Job, Customer, Contact Person
      expect(find.text('Job Info'), findsOneWidget);
      expect(find.text('Customer Info'), findsOneWidget);
      expect(find.text('Contact Persons'), findsOneWidget);

      // Check tab order - the first tab should be active by default
      expect(tabController.index, 0);
    });

    testWidgets('should display tabs in customized order when section items are explicitly reordered', (WidgetTester tester) async {
      // Create custom order: Customer, Job, Contact Person
      sectionItems = [
        JobOverviewSectionItem(
          key: JobOverviewConstants.customer,
          name: 'customer_info'.tr,
          selected: true,
          index: 0,
        ),
        JobOverviewSectionItem(
          key: JobOverviewConstants.job,
          name: 'job_info'.tr,
          selected: false,
          index: 1,
        ),
        JobOverviewSectionItem(
          key: JobOverviewConstants.contactPersons,
          name: 'contact_persons'.tr,
          selected: false,
          index: 2,
        ),
      ];

      // Build our widget with custom section order
      await tester.pumpWidget(
        GetMaterialApp(
          locale: const Locale('en', 'US'),
          home: Scaffold(
            body: JobOverViewDetails(
              tabController: tabController,
              job: jobModel,
              customerInfo: customerInfo,
              contactPerson: contactPersons,
              isJobDetailExpanded: true,
              sectionItems: sectionItems,
            ),
          ),
        ),
      );

      // Verify tabs are displayed in the custom order
      final tabs = tester.widgetList<Tab>(find.byType(Tab)).toList();
      expect(tabs[0].text, 'Customer Info');
      expect(tabs[1].text, 'Job Info');
      expect(tabs[2].text, 'Contact Persons');
    });

    testWidgets('should display the correct content panel when each tab is selected', (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          locale: const Locale('en', 'US'),
          home: Scaffold(
            body: JobOverViewDetails(
              tabController: tabController,
              job: jobModel,
              customerInfo: customerInfo,
              contactPerson: contactPersons,
              isJobDetailExpanded: true,
              sectionItems: sectionItems,
            ),
          ),
        ),
      );

      // Initially job tab should be shown (index 0)
      expect(find.text('Job Info'), findsOneWidget);

      // Simulate selecting the customer tab
      tabController.animateTo(1); // Customer tab at index 1
      await tester.pumpAndSettle();

      // The doShowTab method should evaluate to true for the customer tab now
      expect(find.text('Customer Info'), findsOneWidget);

      // Simulate selecting the contact persons tab
      tabController.animateTo(2); // Contact person tab at index 2
      await tester.pumpAndSettle();

      // The doShowTab method should evaluate to true for the contact person tab now
      expect(find.text('Contact Persons'), findsOneWidget);
    });

    testWidgets('should ensure doShowTab method returns true only for the currently selected tab', (WidgetTester tester) async {
      // Create a JobOverViewDetails widget instance
      final widget = JobOverViewDetails(
        tabController: tabController,
        job: jobModel,
        customerInfo: customerInfo,
        contactPerson: contactPersons,
        isJobDetailExpanded: true,
        sectionItems: sectionItems,
      );

      // Build the widget
      await tester.pumpWidget(
        GetMaterialApp(
          locale: const Locale('en', 'US'),
          home: Scaffold(
            body: widget,
          ),
        ),
      );

      // Initially tab index is 0 (job)
      expect(widget.doShowTab(JobOverviewConstants.job), isTrue, reason: 'Job tab should be active when index is 0');
      expect(widget.doShowTab(JobOverviewConstants.customer), isFalse, reason: 'Customer tab should not be active when index is 0');
      expect(widget.doShowTab(JobOverviewConstants.contactPersons), isFalse, reason: 'Contact Persons tab should not be active when index is 0');

      // Change to customer tab (index 1)
      tabController.animateTo(1);
      await tester.pumpAndSettle();

      expect(widget.doShowTab(JobOverviewConstants.job), isFalse, reason: 'Job tab should not be active when index is 1');
      expect(widget.doShowTab(JobOverviewConstants.customer), isTrue, reason: 'Customer tab should be active when index is 1');
      expect(widget.doShowTab(JobOverviewConstants.contactPersons), isFalse, reason: 'Contact Persons tab should not be active when index is 1');

      // Change to contact person tab (index 2)
      tabController.animateTo(2);
      await tester.pumpAndSettle();

      expect(widget.doShowTab(JobOverviewConstants.job), isFalse, reason: 'Job tab should not be active when index is 2');
      expect(widget.doShowTab(JobOverviewConstants.customer), isFalse, reason: 'Customer tab should not be active when index is 2');
      expect(widget.doShowTab(JobOverviewConstants.contactPersons), isTrue, reason: 'Contact Persons tab should be active when index is 2');
    });
  });
}

// Test implementation of TickerProvider for TabController
class TestVSync extends TickerProvider {
  const TestVSync();

  @override
  Ticker createTicker(TickerCallback onTick) {
    return Ticker(onTick, debugLabel: 'created by TestVSync');
  }
}
