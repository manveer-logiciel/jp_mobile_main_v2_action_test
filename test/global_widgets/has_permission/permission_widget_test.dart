import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/services/permission.dart';
import 'package:jobprogress/global_widgets/has_permission/index.dart';
import 'package:jp_mobile_flutter_ui/Text/index.dart';
void main() {
  List<String> permissionList = [
    "account_unsubscribe",
    "activity_feed",
    "add_activity_feed",
    "add_job_note",
    "approve_job_price_request",
    "change_proposal_status",
    "classified_and_product_focus",
    "connect_social_network",
    "delete_all_materials",
    "delete_customer",
    "delete_followup_note",
    "delete_job",
    "eagleview",
    "email",
    "export_customers"
  ];

  PermissionService.permissionList = permissionList;

  Widget buildTestableWidget(Widget widget) {
    return MediaQuery(
      data: const MediaQueryData(),
      child: MaterialApp(home: Material(child: widget))
    );
  }

  group("When atleast one permission should match in permission list", () {
    //When isAllRequired: false

    testWidgets("HasPermision widget should not remove widget if any permission matched in permission list", (WidgetTester tester) async {
      UniqueKey textKey = UniqueKey();
      final widget = buildTestableWidget(
        HasPermission(
          permissions: const ['activity_feed'],
          child: SizedBox(
            child: JPText(key: textKey, text: "Hello Jobprogress")
          )
        )
      );
      await tester.pumpWidget(widget);

      expect(find.byKey(textKey), findsOneWidget);
    });

    testWidgets("HasPermision widget should not remove widget if any permission matched in permission list", (WidgetTester tester) async {
      UniqueKey textKey = UniqueKey();
      final widget = buildTestableWidget(
        HasPermission(
          permissions: const ['activity_feed', 'manage_company'],
          child: SizedBox(
            child: JPText(key: textKey, text: "Hello Jobprogress")
          )
        )
      );
      await tester.pumpWidget(widget);

      expect(find.byKey(textKey), findsOneWidget);
    });

    testWidgets("HasPermision widget should not remove widget when all permissions matched in permission list", (WidgetTester tester) async {
      UniqueKey textKey = UniqueKey();
      final widget = buildTestableWidget(
        HasPermission(
          permissions: const ['activity_feed', 'add_activity_feed'],
          child: SizedBox(
            child: JPText(key: textKey, text: "Hello Jobprogress")
          )
        )
      );
      await tester.pumpWidget(widget);

      expect(find.byKey(textKey), findsOneWidget);
    });

    testWidgets("HasPermision widget should remove widget when no permission matched in permission list", (WidgetTester tester) async {
      UniqueKey textKey = UniqueKey();
      final widget = buildTestableWidget(
        HasPermission(
          permissions: const ['manage_company'],
          child: SizedBox(
            child: JPText(key: textKey, text: "Hello Jobprogress")
          )
        )
      );
      await tester.pumpWidget(widget);

      expect(find.byKey(textKey), findsNothing);
    });

    testWidgets("HasPermision widget should remove widget when no permission matched in permission list", (WidgetTester tester) async {
      UniqueKey textKey = UniqueKey();
      final widget = buildTestableWidget(
        HasPermission(
          permissions: const ['manage_company', 'manage_company_contacts'],
          child: SizedBox(
            child: JPText(key: textKey, text: "Hello Jobprogress")
          )
        )
      );
      await tester.pumpWidget(widget);

      expect(find.byKey(textKey), findsNothing);
    });
  });

  group("When every permission should match in permission list", () {
    //When isAllRequired: true

    testWidgets("HasPermision widget should not remove widget if permission matched in permission list", (WidgetTester tester) async {
      UniqueKey textKey = UniqueKey();
      final widget = buildTestableWidget(
        HasPermission(
          permissions: const ['activity_feed'],
          isAllPermissionRequired: true,
          child: SizedBox(
            child: JPText(key: textKey, text: "Hello Jobprogress")
          )
        )
      );
      await tester.pumpWidget(widget);

      expect(find.byKey(textKey), findsOneWidget);
    });

    testWidgets("HasPermision widget should remove widget when all permissions not matched in permission list", (WidgetTester tester) async {
      UniqueKey textKey = UniqueKey();
      final widget = buildTestableWidget(
        HasPermission(
          permissions: const ['activity_feed', 'manage_company'],
          isAllPermissionRequired: true,
          child: SizedBox(
            child: JPText(key: textKey, text: "Hello Jobprogress")
          )
        )
      );
      await tester.pumpWidget(widget);

      expect(find.byKey(textKey), findsNothing);
    });

    testWidgets("HasPermision widget should not remove widget when all permissions matched in permission list", (WidgetTester tester) async {
      UniqueKey textKey = UniqueKey();
      final widget = buildTestableWidget(
        HasPermission(
          permissions: const ['activity_feed', 'add_activity_feed'],
          isAllPermissionRequired: true,
          child: SizedBox(
            child: JPText(key: textKey, text: "Hello Jobprogress")
          )
        )
      );
      await tester.pumpWidget(widget);

      expect(find.byKey(textKey), findsOneWidget);
    });

    testWidgets("HasPermision widget should remove widget when no permission matched in permission list", (WidgetTester tester) async {
      UniqueKey textKey = UniqueKey();
      final widget = buildTestableWidget(
        HasPermission(
          permissions: const ['manage_company'],
          isAllPermissionRequired: true,
          child: SizedBox(
            child: JPText(key: textKey, text: "Hello Jobprogress")
          )
        )
      );
      await tester.pumpWidget(widget);

      expect(find.byKey(textKey), findsNothing);
    });

    testWidgets("HasPermision widget should remove widget when all permissions not matched in permission list", (WidgetTester tester) async {
      UniqueKey textKey = UniqueKey();
      final widget = buildTestableWidget(
        HasPermission(
          permissions: const ['manage_company', 'manage_company_contacts'],
          isAllPermissionRequired: true,
          child: SizedBox(
            child: JPText(key: textKey, text: "Hello Jobprogress")
          )
        )
      );
      await tester.pumpWidget(widget);

      expect(find.byKey(textKey), findsNothing);
    });
  });
}