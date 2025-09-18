
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/company_contact_form_type.dart';
import 'package:jobprogress/common/models/company_contacts.dart';
import 'package:jobprogress/modules/company_contacts/create_company_contacts/controller.dart';
void main() {

  CreateCompanyContactFormController controller = CreateCompanyContactFormController();
  CompanyContactListingModel companyContactListingModel = CompanyContactListingModel(
      id: 1,
  );

  setUpAll(() {
    controller.init();
  });

  group('In case of create company contact', () {

    test('CreateCompanyContactFormController should be initialized with correct values', () {
      controller.pageType = CompanyContactFormType.createForm;
      expect(controller.isSavingForm, false);
      expect(controller.validateFormOnDataChange, false);
      expect(controller.isAdditionalDetailsExpanded, false);
      expect(controller.companyContactModel, null);
      expect(controller.pageType, CompanyContactFormType.createForm);
      expect(controller.pageTitle, 'add_company_contact'.tr.toUpperCase());

      controller.pageType = CompanyContactFormType.jobContactPersonCreateForm;
      expect(controller.pageType, CompanyContactFormType.jobContactPersonCreateForm);
      expect(controller.pageTitle, 'add_contact_person'.tr.toUpperCase());
    });

    group('CreateCompanyContactFormController@onAdditionalOptionsExpansionChanged should toggle additional options expansion', () {

      test('Additional options should be expanded', () {
        controller.onAdditionalOptionsExpansionChanged(true);
        expect(controller.isAdditionalDetailsExpanded, true);
      });

      test('Additional options should be collapsed', () {
        controller.onAdditionalOptionsExpansionChanged(false);
        expect(controller.isAdditionalDetailsExpanded, false);
      });

    });

    group('CreateCompanyContactFormController@toggleIsSavingForm should toggle form\'s saving state', () {

      test('Form editing should be disabled', () {
        controller.toggleIsSavingForm();
        expect(controller.isSavingForm, true);
      });

      test('Form editing should be allowed', () {
        controller.toggleIsSavingForm();
        expect(controller.isSavingForm, false);
      });

    });

  });

  group('In case of edit/update company contact', () {

    test('CreateCompanyContactFormController should be initialized with correct values', () {

      controller.companyContactModel = companyContactListingModel;
      controller.pageType = CompanyContactFormType.editForm;

      expect(controller.isSavingForm, false);
      expect(controller.validateFormOnDataChange, false);
      expect(controller.isAdditionalDetailsExpanded, false);
      expect(controller.companyContactModel, companyContactListingModel);
      expect(controller.pageType, CompanyContactFormType.editForm);
      expect(controller.pageTitle, 'edit_company_contact'.tr.toUpperCase());
      
      controller.pageType = CompanyContactFormType.jobContactPersonEditForm;
      expect(controller.pageType, CompanyContactFormType.jobContactPersonEditForm);
      expect(controller.pageTitle, 'edit_contact_person'.tr.toUpperCase());
    });

  });
  
}