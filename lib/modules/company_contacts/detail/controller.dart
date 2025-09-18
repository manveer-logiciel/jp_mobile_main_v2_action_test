import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/company_contact_form_type.dart';
import 'package:jobprogress/common/models/company_contacts.dart';
import 'package:jobprogress/common/models/phone.dart';
import 'package:jobprogress/common/repositories/company_contacts.dart';
import 'package:jobprogress/core/constants/navigation_parms_constants.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/index.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jobprogress/routes/pages.dart';
import 'package:jp_mobile_flutter_ui/ConfirmationDialog/index.dart';
import 'package:jp_mobile_flutter_ui/QuickEditDialog/position.dart';
import 'package:jp_mobile_flutter_ui/QuickEditDialog/type.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../../common/models/company_contacts_notes.dart';

class CompanyContactViewController extends GetxController {
  bool isLoading = true;
  bool isNoteLoading = true;
  bool isDeletingNote = false;
  bool isEditingNote = false;
  bool isAddingNote = false;
  bool isLoadMore = false;
  bool canShowLoadMore = false;

  FocusNode noteDialogFocusNode = FocusNode();

  final scaffoldKey = GlobalKey<ScaffoldState>();
  CompanyContactListingModel companyContactView = CompanyContactListingModel();
  CompanyContactNoteModel companyContactsNotes = CompanyContactNoteModel();

  ///used for email list data.
  List<dynamic> emailList = [];

  /// used for email data.
  String email = '';

  /// used for fullName data.
  String fullName = '';
  String firstLetterOfName = '';

  /// used for primeNumber data.
  String primeNumber = '';

  /// [primePhone] stores the details about the prime number, that is being
  /// required to obtain or edit the consent
  PhoneModel? primePhone;

  String address = '';
  List<CompanyContactNoteModel> notes = [];

  int noteListPage = 1;
  String editNote = '';

  String contactId = '';
  Color avatarColor = JPAppTheme.themeColors.warning;
  int notesLength = 0;

  ///Getting companyContactsParams and tagsParams to send in Company contact view api
  Future<void> getCompanyContactView() async {
    contactId = Get.arguments[0].toString();
    try {
      final companyContactParams = <String, dynamic>{
        'id': contactId,
        'includes[1]': ['emails'],
        "includes[2]": ['phones'],
        "includes[3]": ["address"],
        'includes[0]': ['tags'],
      };
      

      companyContactView = await CompanyContactsListingRepository()
          .fetchCompanyContactView(companyContactParams);

      avatarColor = Get.arguments[1];
      firstLetterOfName =
          companyContactView.firstName![0].capitalize.toString() +
              companyContactView.lastName![0].capitalize.toString();
      fullName = (companyContactView.fullName.toString() == 'null')
          ? ''
          : companyContactView.fullName.toString();

      emailList = companyContactView.emails ?? [];
      email = emailList.isNotEmpty ? companyContactView.emails![0].email : '';
      if (companyContactView.address != null) {
        address = Helper.convertAddress(companyContactView.address);
      }

      int phonesLength = 0;
      phonesLength = companyContactView.phones?.length ?? 0;

      for (int i = 0; i < phonesLength; i++) {
        if (companyContactView.phones![i].isPrimary == 1) {
          primeNumber = companyContactView.phones![i].number!;
          primePhone = companyContactView.phones![i];
        } else {
          primeNumber = companyContactView.phones![0].number!;
          primePhone = companyContactView.phones![0];
        }
      }
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      isLoadMore = false;
      isNoteLoading = false;
      update();
    }
  }

  getCompanyContactViewNotes() async {
    try {
      final companyContactViewNoteParams = <String, dynamic>{
        'id': contactId,
        'limit': 5,
        "page": noteListPage,
      };

      final response = await CompanyContactsListingRepository()
          .fetchCompanyContactViewNote(companyContactViewNoteParams);
      List<CompanyContactNoteModel> list = response["list"];

      if (!isLoadMore) {
        notes = [];
      }

      notes.addAll(list);

      canShowLoadMore = notes.length < response["pagination"]["total"];
      notesLength = response['pagination']["total"];
      update();
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      isLoadMore = false;
      isNoteLoading = false;
      update();
    }
  }

  void getLoadMore() {
    noteListPage += 1;
    isLoadMore = true;
    update();
    getCompanyContactViewNotes();
  }

  void addCompanyContactNotes() async {
    try {
      final addCompanyContactNoteParams = <String, dynamic>{
        'id': contactId,
        'notes[]': editNote,
      };
      await CompanyContactsListingRepository().addCompanyContactViewNote(addCompanyContactNoteParams);
      await getCompanyContactViewNotes();
    } catch (e) {
      rethrow;
    } finally {
      isAddingNote = false;
      update();
      Get.back();
      Helper.showToastMessage('contact_note_added'.tr);
    }
  }

  void editCompanyContactNotes(int noteId) async {
    try {
      final editCompanyContactsNoteParams = <String, dynamic>{
        'id': contactId,
        'noteId': noteId,
        'note': editNote,
      };
      await CompanyContactsListingRepository()
          .editCompanyContactViewNote(editCompanyContactsNoteParams);
      int selectedNoteIndex =
          notes.indexWhere((element) => element.id == noteId);
      notes[selectedNoteIndex].note = editNote;
    } catch (e) {
      rethrow;
    } finally {
      isEditingNote = false;
      update();
      Get.back();
      Helper.showToastMessage('contact_note_updated'.tr);
    }
  }

  void deleteCompanyContactNotes(int noteId) async {
    showJPBottomSheet(
        child: (_) => GetBuilder<CompanyContactViewController>(builder: (context) {
      return JPConfirmationDialog(
        title: "confirmation".tr,
        subTitle:
            "you_are_about_to_delete_selected_note_press_yes_to_confirm".tr,
        suffixBtnText: 'yes'.tr,
        disableButtons: isDeletingNote,
        suffixBtnIcon: showJPConfirmationLoader(show: isDeletingNote),
        onTapPrefix: () {
          Get.back();
        },
        onTapSuffix: () async {
          isDeletingNote = true;
          update();
          try {
            final deleteCompanyContactsNoteParams = <String, dynamic>{
              'id': contactId,
              'noteId': noteId,
            };
            await CompanyContactsListingRepository()
                .deleteCompanyContactViewNote(deleteCompanyContactsNoteParams);

            int selectedNoteIndex =
                notes.indexWhere((element) => element.id == noteId);
            notes.removeAt(selectedNoteIndex);
          } catch (e) {
            rethrow;
          } finally {
            isDeletingNote = false;
            update();
            getCompanyContactViewNotes();
            Get.back(); //hiding loader
            Helper.showToastMessage('contact_note_deleted'.tr);
          }
        },
      );
    }), isDismissible: false, enableDrag: false, isScrollControlled: true);
  }

  void handleNotesQuickActions(String action, int index) {
    switch (action) {
      case 'edit':
        getEditNoteDialog(notes[index].note.toString(), index);
        break;

      case 'delete':
        deleteCompanyContactNotes(notes[index].id!.toInt());
        break;
    }
  }

  void getEditNoteDialog(String note, int index) async {
      showJPGeneralDialog(child: (_) => GetBuilder<CompanyContactViewController>(builder: (context) {
        return JPQuickEditDialog(
            title: 'edit_note'.tr,
            label: 'note'.tr,
            disableButton: isEditingNote,
            maxLength: 500,
            focusNode: noteDialogFocusNode,
            suffixIcon: showJPConfirmationLoader(show: isEditingNote),
            type: JPQuickEditDialogType.textArea,
            fillValue: note,
            suffixTitle: isEditingNote ? '' : 'save'.tr,
            prefixTitle: 'cancel'.tr,
            errorText: 'please_enter_note'.tr,
            onPrefixTap: (value) {
              Get.back();
            },
            onSuffixTap: (value) async {
              isEditingNote = true;
              update();
              try {
                editNote = value;
                editCompanyContactNotes(notes[index].id!.toInt());
                update();
              } catch (e) {
                rethrow;
              } finally {
                update();
              }
            });
      }));
        
      await Future<void>.delayed(const Duration(milliseconds: 400));

      noteDialogFocusNode.requestFocus();
  }

  void getAddNoteDialog() async {

    showJPGeneralDialog(child: (controller) => JPQuickEditDialog(
        title: 'add_note'.tr.toUpperCase(),
        label: 'note'.tr,
        disableButton: isAddingNote,
        maxLength: 500,
        focusNode: noteDialogFocusNode,
        suffixIcon: showJPConfirmationLoader(show: isAddingNote),
        position: JPQuickEditDialogPosition.center,
        type: JPQuickEditDialogType.textArea,
        suffixTitle: isAddingNote ? '' : 'save'.tr,
        prefixTitle: 'CANCEL'.tr,
        errorText: 'please_enter_note'.tr,
        onPrefixTap: (value) {
          Get.back();
        },
        onSuffixTap: (value) async {
          isAddingNote = true;
          update();
          try {
            controller.toggleIsLoading();
            editNote = value;
            addCompanyContactNotes();
            update();
          } catch (e) {
            rethrow;
          } finally {
            controller.toggleIsLoading();
            update();
          }
        }),
    );
      
      await Future<void>.delayed(const Duration(milliseconds: 400));

      noteDialogFocusNode.requestFocus();
  }

  void refreshPage() {
    isLoading = true;
    isLoadMore = false;
    noteListPage = 1;
    getCompanyContactView();
    getCompanyContactViewNotes();
  }

  @override
  void onInit() {
    super.onInit();
    getCompanyContactView();
    getCompanyContactViewNotes();
  }

  Future<void> navigateToUpdateCompanyContact() async{
     final result = await Get.toNamed(Routes.createCompanyContact, arguments: {
      NavigationParams.pageType: CompanyContactFormType.editForm,
      NavigationParams.dataModel:companyContactView
    });
    if(result != null && result["status"]) {
      Get.back(result: result);
    }
  }
}