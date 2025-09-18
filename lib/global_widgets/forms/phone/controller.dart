
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/forms/phone/index.dart';
import 'package:jobprogress/common/models/phone.dart';
import 'package:jobprogress/common/services/phone_masking.dart';
import 'package:jobprogress/core/utils/form/validators.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/core/utils/single_select_helper.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/index.dart';
import 'package:jobprogress/global_widgets/phone_book_number_dialog/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'package:permission_handler/permission_handler.dart';

class PhoneFormController extends GetxController {

  PhoneFormController(this.phoneField, this.canBeMultiple);

  List<PhoneFormData> phoneFields = [];

  List<PhoneModel> phoneField;

  bool canShowError = false;

  int maxPhoneFields  = 5; // contains max pholes that can be taken as input

  int get displayingPhoneField => phoneField.length; // holds the number of phones displaying

  final formKey = GlobalKey<FormState>();

  List<JPSingleSelectModel> phoneTypeList = [
    JPSingleSelectModel(label: 'cell'.tr.capitalizeFirst!, id: 'cell'),
    JPSingleSelectModel(label: 'phone'.tr.capitalizeFirst!, id: 'phone'),
    JPSingleSelectModel(label: 'office'.tr.capitalizeFirst!, id: 'office'),
    JPSingleSelectModel(label: 'fax'.tr.capitalizeFirst!, id: 'fax'),
    JPSingleSelectModel(label: 'home'.tr.capitalizeFirst!, id: 'home'),
    JPSingleSelectModel(label: 'other'.tr.capitalizeFirst!, id: 'other'),
  ];

  final bool canBeMultiple;

  @override
  void onInit() {
    init();
    super.onInit();
  }

  void init() {
    if(phoneField.isEmpty){
      phoneFields.add(PhoneFormData(val: '', phoneType: phoneTypeList[0],ext: ''));
      phoneField.add(PhoneModel(number: '',ext: ''));
    } else {
      parsePhoneToPhoneFields();
    }
  }

  void addPhoneField() {

    if(phoneFields.length >= 5) return;

    phoneFields.add(
        PhoneFormData(
          phoneType: phoneTypeList[0],
          val: '',
          ext: ''
        )
    );

    phoneField.add(phoneFields.last.toPhoneModel());

    update();
  }

  void removePhoneField(int index) {
    phoneFields.removeAt(index);
    phoneField.removeAt(index);
    update();
  }

  void selectPhoneType(int index) {
    SingleSelectHelper.openSingleSelect(phoneTypeList, phoneFields[index].phoneType.id, 'select'.tr, (value) {
      final selectedType = phoneTypeList.firstWhere((phoneType) => phoneType.id == value);
      phoneFields[index].setType(selectedType);
      phoneField[index] = phoneFields[index].toPhoneModel();
      Get.back();
      update();
     });
  }

  // validateForm(): helps in performing validation
  bool validateForm({bool scrollOnValidation = true}) {
    final index = phoneFields.indexWhere((fields) => FormValidator.validatePhoneNumber(fields.phoneController.text) != null);

    bool isValid = index < 0;

    if(!isValid) {
      canShowError = true;
      if(scrollOnValidation)  phoneFields[index].phoneController.scrollAndFocus();
      update();
    }

    return isValid;
  }


  void parsePhoneToPhoneFields() {

    for (var phone in phoneField) {
     JPSingleSelectModel phoneType = phoneTypeList.firstWhereOrNull((tempPhone) => phone.label == tempPhone.id.toString()) ?? phoneTypeList[0];
      phoneFields.add(PhoneFormData(
        phoneType: phoneType,
        val: PhoneMasking.maskPhoneNumber(phone.number??''),
        ext: phone.ext ?? '',
      ));
    }
    update();
  
  }

   void onValueChanged(int index) {
      phoneField[index] = phoneFields[index].toPhoneModel();
      update();
    }

  Future<void> updateFields(List<PhoneModel> updatedPhoneFields) async {
    phoneFields.clear();
    phoneField.clear();
    update();
    await Future<void>.delayed(const Duration(milliseconds: 100));
    phoneField.addAll(updatedPhoneFields);
    init();
  }

  // fetchContactFromPhone(): fetch contact from phone directory
  Future<void> fetchContactFromPhone(int selectedIndex) async {
    try {
      PermissionStatus status = await Permission.contacts.request();
      if (status == PermissionStatus.granted) {
        final contactsFromPhoneDirectory = await FlutterContacts.openExternalPick();
        if(contactsFromPhoneDirectory != null) {
          List<PhoneModel> phone = [];
          String label = '';
          for (var contactsPhone in contactsFromPhoneDirectory.phones) {
            String numberToFormat = Helper.isValueNullOrEmpty(contactsPhone.normalizedNumber) ? contactsPhone.number : contactsPhone.normalizedNumber;
            String formattedNumber = Helper.removeCountryCodes(numberToFormat);
            for (var element in phoneTypeList) { 
              if(contactsPhone.label.name == element.id) {
                label = element.id;
                break;
              } else {
                label = 'other';
              }
            }
            phone.add(PhoneModel(number: PhoneMasking.maskPhoneNumber(formattedNumber), label: label));
          }
          if(contactsFromPhoneDirectory.phones.isEmpty){
            Helper.showToastMessage('no_phone_number_found'.tr);
          } else if(contactsFromPhoneDirectory.phones.length == 1) {
            setNumber(phone.first, selectedIndex, inSelectionMode: true);
          } else{
            openPhoneBookDialog(phone, selectedIndex);
          }
          
        }
      } else if(status == PermissionStatus.permanentlyDenied) {
        openAppSettings();
      }
    } catch (e) {
      rethrow;
    } finally {
    }
  }

  void openPhoneBookDialog(List<PhoneModel> numbers, int selectedIndex) {
    showJPGeneralDialog(
      isDismissible: false,
      child: (_) {
        return JPPhoneBookDialog(
          phoneNumbers: numbers,
          callback: (data){
            setNumber(data,selectedIndex);
          },
        );
      }
    );
  }

  void setNumber(PhoneModel data, int index, {bool inSelectionMode = false}) {
    phoneFields[index].phoneController.text = data.number ?? '';
    phoneField[index].number = data.number;
    JPSingleSelectModel phoneType = phoneTypeList.firstWhereOrNull((tempPhone) => data.label == tempPhone.id.toString()) ?? phoneTypeList.last;
    phoneFields[index].setType(phoneType);
    phoneField[index].label = phoneType.id;
    update();
    if(!inSelectionMode) Get.back();
  }
    
}
