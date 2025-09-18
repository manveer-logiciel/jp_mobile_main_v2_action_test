import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/run_mode.dart';
import 'package:jobprogress/common/models/company_contacts.dart';
import 'package:jobprogress/common/models/group_company_contacts_model.dart';
import 'package:jobprogress/common/models/sql/tag/tag.dart';
import 'package:jobprogress/common/services/run_mode/index.dart';
import 'package:jobprogress/modules/company_contacts/listing/controller.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/modal.dart';

void main() {
  RunModeService.setRunMode(RunMode.unitTesting);

  final controller = CompanyContactListingController();
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    Get.testMode = true;
  });

  test("Company Contacts listing should be constructed with default values", () {
    expect(controller.canShowLoadMore, false);
    expect(controller.isLoading, true);
    expect(controller.isLoadMore, false);
    expect(controller.isMultiSelectionOn, false);
    expect(controller.maxScrollPosition, 0);
    expect(controller.paramkeys.limit, 20);
    expect(controller.paramkeys.name, 'name');
    expect(controller.paramkeys.page, 1);
    expect(controller.paramkeys.sortBy, 'first_name');
    expect(controller.paramkeys.sortOrder, 'asc');
    expect(controller.countSearchLength, false);
    expect(controller.totalContactLength, 0);
    expect(controller.allContactLength, 0);
  });

  group('Company Contacts listing loadMore function should set values', () {
      controller.loadMore();    
    test('Company Contacts listing loadMore function should set page to 1', () {
      expect(controller.paramkeys.page, 1);
    });
    test('Company Contacts listing refreshList function should set isLoading to true', () {
      expect(controller.isLoading, true);
    });
  });
  group('Company Contacts listing refreshList function should set values', () {
      controller.refreshList();    
    test('Company Contacts listing refreshList function should set page to 1', () {
      expect(controller.paramkeys.page, 1);
    });
    test('Company Contacts listing refreshList function should set isLoading to true', () {
      expect(controller.isLoading, true);
    });
  });


   group('Company Contacts listing onSearchTextChanged function should set values', () {
      String text = 'name';
      controller.onSearchTextChanged(text);
      test('Company Contacts listing onSearchTextChanged function should set text', () {
        expect(text, 'name');
      });      
      test('Company Contacts listing onSearchTextChanged function should set page to 1', () {
        expect(controller.paramkeys.page, 1);
      });
      test('Company Contacts listing onSearchTextChanged function should set isLoading to true', () {
        expect(controller.isLoading, true);
      });
    });

    group('Company Contacts listing filterContactBytag function should set values', () {
        TagModel selectedTag = TagModel(id: 1, name: 'shiva', type: 'ddd', updatedAt: '');
        controller.filterContactBytag(selectedTag);
      test('Company Contacts listing filterContactBytag function should set page to 1', () {
        expect(controller.paramkeys.page, 1);
      });
      test('Company Contacts listing filterContactBytag function should set isLoading to true', () {
        expect(controller.isLoading, true);
      });
    });


  group('Company Contacts listing getAllContacts function should set values', () {
      controller.getAllContacts();
    test('Company Contacts listing getAllContacts function should set activeTag to null', () {
      expect(controller.activeTag, null);
    });

    test('Company Contacts listing getAllContacts function should set tagId to null', () {
      expect(controller.paramkeys.tagId, null);
    });

    test('Company Contacts listing getAllContacts function should set isLoading to true', () {
      expect(controller.isLoading, true);
    });
  });

  group('Company Contacts listing deleteContact function should set values', () {
      controller.deleteContact();
    test('Company Contacts listing deleteContact function should set page to 1', () {
      expect(controller.paramkeys.page, 1);
    });

    test('Company Contacts listing deleteContact function should set isMultiSelectionOn to false', () {
      expect(controller.isMultiSelectionOn, false);
    });

    test('Company Contacts listing deleteContact function should set isLoading to true', () {
      expect(controller.isLoading, true);
    });
  });
  group('Company Contacts listing removeFromGroup function should set values', () {
    controller.removeFromGroup();
    test('Company Contacts listing removeFromGroup function should set page to 1', () {
      expect(controller.paramkeys.page, 1);
    });

    test('Company Contacts listing removeFromGroup function should set isMultiSelectionOn to false', () {
      expect(controller.isMultiSelectionOn, false);
    });

    test('Company Contacts listing removeFromGroup function should set isLoading to true', () {
      expect(controller.isLoading, true);
    });
  });

  group('Company Contacts listing addSelectedIntoGroup function should set values', () {
      List<JPMultiSelectModel> selected = [JPMultiSelectModel(id: 'a', label: "Value 1", isSelect: false)];
      controller.addSelectedIntoGroup(selected);
    test('Company Contacts listing addSelectedIntoGroup function should set page to 1', () {
      expect(controller.paramkeys.page, 1);
    });

    test('Company Contacts listing addSelectedIntoGroup function should set isMultiSelectionOn to false', () {
      expect(controller.isMultiSelectionOn, false);
    });

    test('Company Contacts listing addSelectedIntoGroup function should set isLoading to true', () {
      expect(controller.isLoading, true);
    });
  });

  group('CompanyContactListingController@isMultiSelectionOn should set correct value on multi select', () {
    test('When selectedContacts is not empty', () {
      controller.companyContactsGroup = [
        GroupCompanyContactListingModel(
          groupName: 'U',
          groupValues: [
            CompanyContactListingModel(
              id: 1,
              fullName: 'User 1',
            ),
            CompanyContactListingModel(
              id: 2,
              fullName: 'User 2',
            )
          ]
        )
      ];
      controller.companyContacts = [
        CompanyContactListingModel(
          id: 1,
          fullName: 'User 1',
          checked: false,
        ),
        CompanyContactListingModel(
          id: 2,
          fullName: 'User 2',
          checked: false,
        )
      ];
      controller.onContactChecked(0, 0);
      expect(controller.isMultiSelectionOn, true);
      expect(controller.selectedContacts, isNotEmpty);
    });

    test('When selectedContacts is empty', () async {
      controller.selectedContacts = [];
      controller.companyContactsGroup = [
        GroupCompanyContactListingModel(
          groupName: 'U',
          groupValues: [
            CompanyContactListingModel(
              id: 1,
              fullName: 'User 1',
            ),
            CompanyContactListingModel(
              id: 2,
              fullName: 'User 2',
            )
          ]
        )
      ];
      controller.companyContacts = [
        CompanyContactListingModel(
          id: 1,
          fullName: 'User 1',
          checked: false,
        ),
        CompanyContactListingModel(
          id: 2,
          fullName: 'User 2',
          checked: false,
        )
      ];
      
      await controller.onContactChecked(0, 0);
      await controller.onContactChecked(0, 0);
      expect(controller.isMultiSelectionOn, false);
      expect(controller.selectedContacts, isEmpty);
    });
  });

  test('Company contact listing createGroup function should show loading when creating group', () {
    String craeteGroup = 'group name';
    controller.createGroup(craeteGroup);
    expect(controller.isLoading, true);
  });
}
