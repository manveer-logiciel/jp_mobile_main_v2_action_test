import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/network_multiselect.dart';
import 'package:jobprogress/common/enums/network_singleselect.dart';
import 'package:jobprogress/common/enums/templates.dart';
import 'package:jobprogress/common/models/customer/customer.dart';
import 'package:jobprogress/common/models/phone.dart';
import 'package:jobprogress/common/providers/http/interceptor.dart';
import 'package:jobprogress/common/services/launch_darkly/index.dart';
import 'package:jobprogress/common/services/location/background_location_service.dart';
import 'package:jobprogress/common/services/shared_pref.dart';
import 'package:jobprogress/core/constants/launchdarkly/flag_keys.dart';
import 'package:jobprogress/core/constants/navigation_parms_constants.dart';
import 'package:jobprogress/core/constants/shared_pref_constants.dart';
import 'package:jobprogress/core/constants/urls.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/index.dart';
import 'package:jobprogress/global_widgets/network_multiselect/index.dart';
import 'package:jobprogress/global_widgets/network_singleselect/index.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/modal.dart';
import 'package:jp_mobile_flutter_ui/QuickAction/model.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../common/models/address/address.dart';
import '../../common/models/phone_consents.dart';
import '../../core/constants/consent_status_constants.dart';
import '../../core/utils/helpers.dart';
import '../../routes/pages.dart';

SharedPrefService preferences = SharedPrefService();

class DemoController extends GetxController {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  bool isSelected = false;
  bool isSelected1 = false;
  bool isSelected2 = true;
  String groupValue = 'a';
  bool toggle = false;
  bool toggle1 = false;
  bool toggle2 = true;
  bool isDarkTheme = false;
  bool isTrackingLocation = false;

  late Map<String, String> headersMap;
  String imagePath = '';

  final GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  final GlobalKey<FormState> globalKey1 = GlobalKey<FormState>();
  final GlobalKey<FormState> globalKey2 = GlobalKey<FormState>();
  late TextEditingController textEditingController;
  late TextEditingController textEditingController1;
  var controller = '';
  var controller1 = '';

  List<JPMultiSelectModel> multiSelectList = [];
  String singleSelectItemId = "";

  List<JPRadioData> data = [
    JPRadioData(label: 'label', value: 'a'),
    JPRadioData(label: 'label1', value: 'b'),
    JPRadioData(label: 'label2', value: 'c'),
    JPRadioData(label: 'label2', value: 'd', disabled: true),
  ];

  List<JPQuickActionModel> filterByList1 = [
    JPQuickActionModel(
        id: '1',
        child: const JPIcon(
          Icons.edit,
          size: 18,
        ),
        label: 'Edit',
        chipTitle: 'chipTitle'),
    JPQuickActionModel(
        id: '2',
        child: const JPIcon(
          Icons.edit,
          size: 18,
        ),
        label: 'Sign Form/Proposal',
        sublist: [
          JPQuickActionModel(
              id: '31',
              child: const JPIcon(
                Icons.edit,
                size: 18,
              ),
              label: 'Generate Material List'),
          JPQuickActionModel(
              id: '9',
              child: const JPIcon(
                Icons.edit,
                size: 18,
              ),
              label: 'Generate Work Order List'),
          JPQuickActionModel(
              id: '13',
              child: const JPIcon(
                Icons.edit,
                size: 18,
              ),
              label: 'Email',
              chipTitle: 'ChipT'),
          JPQuickActionModel(
              id: '14',
              child: const JPIcon(
                Icons.edit,
                size: 18,
              ),
              label: 'Show on Customer Browser'),
        ]),
    JPQuickActionModel(
        id: '31',
        child: const JPIcon(
          Icons.edit,
          size: 18,
        ),
        label: 'Generate Material List'),
    JPQuickActionModel(
        id: '9',
        child: const JPIcon(
          Icons.edit,
          size: 18,
        ),
        label: 'Generate Work Order List'),
    JPQuickActionModel(
        id: '13',
        child: const JPIcon(
          Icons.edit,
          size: 18,
        ),
        label: 'Email',
        chipTitle: 'ChipT',
        sublist: [
          JPQuickActionModel(
              id: '31',
              child: const JPIcon(
                Icons.edit,
                size: 18,
              ),
              label: 'Generate Material List'),
          JPQuickActionModel(
              id: '9',
              child: const JPIcon(
                Icons.edit,
                size: 18,
              ),
              label: 'Generate Work Order List'),
          JPQuickActionModel(
              id: '13',
              child: const JPIcon(
                Icons.edit,
                size: 18,
              ),
              label: 'Email',
              chipTitle: 'ChipT'),
          JPQuickActionModel(
              id: '14',
              child: const JPIcon(
                Icons.edit,
                size: 18,
              ),
              label: 'Show on Customer Browser'),
        ]),
    JPQuickActionModel(
        id: '14',
        child: const JPIcon(
          Icons.edit,
          size: 18,
        ),
        label: 'Show on Customer Browser'),
    JPQuickActionModel(
        id: '3',
        child: const JPIcon(
          Icons.edit,
          size: 18,
        ),
        label: 'Rename',
        sublist: [
          JPQuickActionModel(
              id: '31',
              child: const JPIcon(
                Icons.edit,
                size: 18,
              ),
              label: 'Generate Material List'),
          JPQuickActionModel(
              id: '9',
              child: const JPIcon(
                Icons.edit,
                size: 18,
              ),
              label: 'Generate Work Order List'),
          JPQuickActionModel(
              id: '13',
              child: const JPIcon(
                Icons.edit,
                size: 18,
              ),
              label: 'Email',
              chipTitle: 'ChipT111'),
          JPQuickActionModel(
              id: '14',
              child: const JPIcon(
                Icons.edit,
                size: 18,
              ),
              label: 'Show on Customer Browser'),
        ]),
    JPQuickActionModel(
        id: '4',
        child: const JPIcon(
          Icons.edit,
          size: 18,
        ),
        label: 'Show on Proposal Form'),
    JPQuickActionModel(
        id: '5',
        child: const JPIcon(
          Icons.edit,
          size: 18,
        ),
        label: 'Update Status'),
    JPQuickActionModel(
        id: '6',
        child: const JPIcon(
          Icons.edit,
          size: 18,
        ),
        label: 'Print Status'),
    JPQuickActionModel(
        id: '11',
        child: const JPIcon(
          Icons.edit,
          size: 18,
        ),
        label: 'Delete'),
    JPQuickActionModel(
        id: '11',
        child: const JPIcon(
          Icons.edit,
          size: 18,
        ),
        label: 'Delete'),
    JPQuickActionModel(
        id: '11',
        child: const JPIcon(
          Icons.edit,
          size: 18,
        ),
        label: 'Delete'),
    JPQuickActionModel(
        id: '11',
        child: const JPIcon(
          Icons.edit,
          size: 18,
        ),
        label: 'Delete'),
    JPQuickActionModel(
        id: '11',
        child: const JPIcon(
          Icons.edit,
          size: 18,
        ),
        label: 'Delete'),
    JPQuickActionModel(
        id: '11',
        child: const JPIcon(
          Icons.edit,
          size: 18,
        ),
        label: 'Delete'),
    JPQuickActionModel(
        id: '11',
        child: const JPIcon(
          Icons.edit,
          size: 18,
        ),
        label: 'Delete'),
    JPQuickActionModel(
        id: '11',
        child: const JPIcon(
          Icons.edit,
          size: 18,
        ),
        label: 'Delete'),
    JPQuickActionModel(
        id: '11',
        child: const JPIcon(
          Icons.edit,
          size: 18,
        ),
        label: 'Delete'),
    JPQuickActionModel(
        id: '11',
        child: const JPIcon(
          Icons.edit,
          size: 18,
        ),
        label: 'Delete'),
    JPQuickActionModel(
        id: '11',
        child: const JPIcon(
          Icons.edit,
          size: 18,
        ),
        label: 'Delete'),
    JPQuickActionModel(
        id: '11',
        child: const JPIcon(
          Icons.edit,
          size: 18,
        ),
        label: 'Delete'),
    JPQuickActionModel(
        id: '11',
        child: const JPIcon(
          Icons.edit,
          size: 18,
        ),
        label: 'Delete'),
  ];

  List<JPMultiSelectModel> filterByMultiList = [
    JPMultiSelectModel(id: 'a', label: "Value 1", isSelect: false),
    JPMultiSelectModel(id: 'b', label: "Value 1", isSelect: false),
    JPMultiSelectModel(id: 'c', label: "Value 2", isSelect: false),
    JPMultiSelectModel(id: 'd', label: "Value 3", isSelect: false),
    JPMultiSelectModel(id: 'e', label: "Value 2", isSelect: false),
    JPMultiSelectModel(id: 'f', label: "Value 4", isSelect: false),
    JPMultiSelectModel(id: 'g', label: "Value 5", isSelect: false),
    JPMultiSelectModel(id: 'h', label: "Value 6", isSelect: false),
    JPMultiSelectModel(id: 'i', label: "Value 7", isSelect: false),
    JPMultiSelectModel(id: 'j', label: "Value 8", isSelect: false),
    JPMultiSelectModel(id: '9', label: "Value 9", isSelect: false),
    JPMultiSelectModel(id: 'x', label: "Value 9", isSelect: false),
    JPMultiSelectModel(id: 'y', label: "Value 9", isSelect: false),
    JPMultiSelectModel(id: 'z', label: "Value 9", isSelect: false),
    JPMultiSelectModel(id: '1', label: "Value 9", isSelect: false),
    JPMultiSelectModel(id: '2', label: "Value 8", isSelect: false),
    JPMultiSelectModel(id: '3', label: "Value 19", isSelect: false),
    JPMultiSelectModel(id: '3', label: "Value 19", isSelect: false),
    JPMultiSelectModel(id: '3', label: "Value 19", isSelect: false),
    JPMultiSelectModel(id: '3', label: "Value 19", isSelect: false),
    JPMultiSelectModel(id: '3', label: "Value 19", isSelect: false),
    JPMultiSelectModel(id: '3', label: "Value 19", isSelect: false),
    JPMultiSelectModel(id: '3', label: "Value 19", isSelect: false),
    JPMultiSelectModel(id: '3', label: "Value 19", isSelect: false),
    JPMultiSelectModel(id: '3', label: "Value 19", isSelect: false),
  ];

  List<JPSingleSelectModel> filterBySingleList = [
    JPSingleSelectModel(id: '1', label: 'abx'),
    JPSingleSelectModel(id: '2', label: 'abx'),
    JPSingleSelectModel(id: '3', label: 'abx'),
    JPSingleSelectModel(id: '4', label: 'abx'),
    JPSingleSelectModel(id: '5', label: 'abx'),
    JPSingleSelectModel(id: '6', label: 'abx'),
  ];
  setCookies() async {
    var data = await preferences.read(PrefConstants.cookies);
    var response = await dio.get('${Urls.user}/1');
    dynamic jsonData = json.decode(response.toString());
    headersMap = {"Cookie": data};

    imagePath = jsonData["data"]["profile_pic"] ?? '';
    update();
  }

  checkMethod(bool value) {
    isSelected = !value;
    update();
  }

  checkMethod1(bool value) {
    isSelected1 = !value;
    update();
  }

  checkMethod2(bool value) {
    isSelected1 = !value;
    update();
  }

  radioMethod(String value) {
    groupValue = value;
    update();
  }

  updateToggle(bool value) {
    toggle = value;
    update();
  }

  updateToggle1(bool value) {
    toggle1 = value;
    update();
  }

  updateToggle2(bool value) {
    toggle2 = value;
    update();
  }

  String? validate(String value) {
    if (value.isEmpty) {
      return 'Email Field is Required';
    }
    return null;
  }

  void onSave() {
    final isValid = globalKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    globalKey.currentState!.save();
  }

  void onSave1() {
    final isValid = globalKey1.currentState!.validate();
    if (!isValid) {
      return;
    }
    globalKey.currentState!.save();
  }

  void conformationStatus() {
    showJPBottomSheet(
        child: (_) => Container(
          height: 100,
          width: 200,
          color: Colors.green,
        ),
        isDismissible: true,
        enableDrag: false,
        isScrollControlled: true);
    // update();
  }

  void a() {
    showJPBottomSheet(
        child: (_) => JPSingleSelect(
          selectedItemId: '1',
          mainList: filterBySingleList,
          //isFilterSheet: true,
        ),
        isScrollControlled: true);
  }

  void showNetworkMultiSelect() {
    showJPBottomSheet(
        child: (_) {
          return JPNetworkMultiSelect(
            selectedItems: multiSelectList,
            type: JPNetworkMultiSelectType.cities,
            onDone: (list) {
              multiSelectList = list;
              update();
            },
          );
        },
        isScrollControlled: true,
        ignoreSafeArea: false);
  }

  void showNetworkSingleSelect() {
    showJPBottomSheet(
        child: (_) {
          return JPNetworkSingleSelect(
            selectedItemId: singleSelectItemId,
            type: JPNetworkSingleSelectType.cities,
            onDone: (item) {
              singleSelectItemId = item.id;
              update();
            },
          );
        },
        isScrollControlled: true,
        ignoreSafeArea: false);
  }

  void navigateToSearchLocation () async {
    dynamic response = await Get.toNamed(Routes.searchLocation);
    if (response != null && response is AddressModel) {
      Helper.showToastMessage(Helper.convertAddress(response).trim());
    }
  }

  void navigateToFormProposalTemplate() {
    Get.toNamed(Routes.formProposalTemplate, arguments: {
      NavigationParams.templateType: ProposalTemplateFormType.add,
      NavigationParams.jobId : 22641,
      NavigationParams.templateId : "582"
    });
  }


  Future<void> startStopBgTrackingService() async {
    await BackgroundLocationService.stopAndInitiateService();
  }

  @override
  void onInit() {
    textEditingController = TextEditingController();
    textEditingController1 = TextEditingController();
    super.onInit();
  }

  @override
  void onClose() {
    textEditingController.dispose();
    textEditingController1.dispose();
    super.onClose();
  }

  Future<void> handleLDLogic() async {
    LDService.handleFeatureLogic(
      flagKey: LDFlagKeyConstants.testStaffCalendar,
      onTrue: () {
        Helper.showToastMessage('Feature is enabled');
      },
      onFalse: () {
        Helper.showToastMessage('Feature is disabled');
      },
    );
  }

  Future<void> transitionMessaging() async {
    var result = await Get.toNamed(Routes.confirmConsent, arguments: {
      NavigationParams.consentStatusConstants: ConsentStatusConstants.promotionalMessage,
      NavigationParams.phone: PhoneModel(number: "8888888888"),
      NavigationParams.customer: CustomerModel(
        id: 97340,
        fullName: 'Danish Wasim',
      )
    });
    if(result is PhoneConsentModel) debugPrint(result.status);
  }
}
