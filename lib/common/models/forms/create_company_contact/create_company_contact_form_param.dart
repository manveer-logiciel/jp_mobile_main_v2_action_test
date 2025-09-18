import 'package:jobprogress/common/enums/company_contact_form_type.dart';
import 'package:jobprogress/common/models/company_contacts.dart';
import 'package:jobprogress/common/models/company_contacts_notes.dart';
import 'package:jobprogress/common/models/sql/tag/tag.dart';
import 'package:jobprogress/modules/company_contacts/create_company_contacts/controller.dart';

class CreateCompanyContactFormParam {
  final CreateCompanyContactFormController? controller;
  final CompanyContactFormType? pageType;
  final CompanyContactListingModel? companyContactModel;
  final CompanyContactNoteModel? companyContactsNotes;
  final List<TagModel>? assignGroup;
  final Function(dynamic val)? onUpdate;

  CreateCompanyContactFormParam({
    this.controller,
    this.pageType,
    this.companyContactModel,
    this.companyContactsNotes,
    this.assignGroup,
    this.onUpdate
  });
}