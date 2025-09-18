import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/services/permission.dart';

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

  group("When atleast one permission should match in permission list", () {
    //When isAllRequired: false

    test("PermissionService@hasUserPermissions should return true if any permission matched in permission list", () {
      bool hasPermission = PermissionService.hasUserPermissions(["activity_feed"]);
      expect(hasPermission, true);
    });

    test("PermissionService@hasUserPermissions should return false if no permission matched in permission list", () {
      bool hasPermission = PermissionService.hasUserPermissions(["manage_company"]);
      expect(hasPermission, false);
    });

    test("PermissionService@hasUserPermissions should return true if only one permission matched in permission list", () {
      bool hasPermission = PermissionService.hasUserPermissions(["manage_company", "activity_feed"]);
      expect(hasPermission, true);
    });

    test("PermissionService@hasUserPermissions should return false when no permission matched in permission list", () {
      bool hasPermission = PermissionService.hasUserPermissions(["manage_company", "manage_company_contacts"]);
      expect(hasPermission, false);
    });

    test("PermissionService@hasUserPermissions should return true when all permissions matched in permission list", () {
      bool hasPermission = PermissionService.hasUserPermissions(["activity_feed", "add_activity_feed"]);
      expect(hasPermission, true);
    });
  });

  group("When every permission should match in permission list", () {
    //When isAllRequired: true

    test("PermissionService@hasUserPermissions should return true when permission matched in permission list", () {
      bool hasPermission = PermissionService.hasUserPermissions(["activity_feed"], isAllRequired: true);
      expect(hasPermission, true);
    });

    test("PermissionService@hasUserPermissions should return false when no permission matched in permission list", () {
      bool hasPermission = PermissionService.hasUserPermissions(["manage_company"], isAllRequired: true);
      expect(hasPermission, false);
    });

    test("PermissionService@hasUserPermissions should return false when all permissions not matched in permission list", () {
      bool hasPermission = PermissionService.hasUserPermissions(["manage_company", "activity_feed"], isAllRequired: true);
      expect(hasPermission, false);
    });

    test("PermissionService@hasUserPermissions should return false when no permission matched in permission list", () {
      bool hasPermission = PermissionService.hasUserPermissions(["manage_company", "manage_company_contacts"], isAllRequired: true);
      expect(hasPermission, false);
    });

    test("PermissionService@hasUserPermissions should return true when all permissions matched in permission list", () {
      bool hasPermission = PermissionService.hasUserPermissions(["activity_feed", "add_activity_feed"], isAllRequired: true);
      expect(hasPermission, true);
    });
  });
}