import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/network_singleselect.dart';
import 'package:jobprogress/common/enums/supplier_form_type.dart';
import 'package:jobprogress/common/models/forms/worksheet/supplier_form_params.dart';
import 'package:jobprogress/common/models/network_singleselect/params.dart';
import 'package:jobprogress/common/models/pagination_model.dart';
import 'package:jobprogress/common/models/suppliers/beacon/job.dart';
import 'package:jobprogress/common/models/suppliers/branch.dart';
import 'package:jobprogress/common/models/suppliers/srs/srs_ship_to_address.dart';
import 'package:jobprogress/common/models/suppliers/beacon/account.dart';
import 'package:jobprogress/common/repositories/material_supplier.dart';
import 'package:jobprogress/common/services/forms/value_selector.dart';
import 'package:jobprogress/common/services/network_singleselect/index.dart';
import 'package:jobprogress/common/services/worksheet/helpers.dart';
import 'package:jobprogress/core/constants/common_constants.dart';
import 'package:jobprogress/core/constants/navigation_parms_constants.dart';
import 'package:jobprogress/core/constants/supplier_constant.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jp_mobile_flutter_ui/InputBox/controller.dart';
import 'package:jp_mobile_flutter_ui/SingleSelect/model.dart';
import 'package:jp_mobile_flutter_ui/Theme/form_ui_helper.dart';
import 'package:jp_mobile_flutter_ui/Theme/index.dart';

/// [shipToAddressList] holds all the ship to addresses for SRS Supplier
List<SrsShipToAddressModel> shipToAddressList = [];
/// [srsBranchList] holds all the branches for SRS Supplier
List<SupplierBranchModel> srsBranchList = [];
/// [beaconAccountsList] holds all the accounts for Beacon Supplier
List<BeaconAccountModel> beaconAccountsList = [];
/// [beaconBranchList] holds all the branches for Beacon Supplier
List<SupplierBranchModel> beaconBranchList = [];
/// [beaconJobs] holds all the jobs of Beacon Supplier
Map<String, (JPSingleSelectParams, List<BeaconJobModel>)> beaconJobs = {};

/// [abcAccountList] holds all the ship to addresses for ABC Supplier
List<SrsShipToAddressModel> abcAccountList = [];
/// [abcBranchList] holds all the branches for ABC Supplier
List<SupplierBranchModel> abcBranchList = [];

class MaterialSupplierFormController extends GetxController {

  MaterialSupplierFormController({required this.params});

  final GlobalKey<FormState> formKey = GlobalKey();

  final FormUiHelper formUiHelper = JPAppTheme.formUiHelper; // provides necessary values for paddings, margins and form section spacing

  Map<String, String> get typeParam => {'type': params.worksheetType ?? ''};

  /// [getTitle] Returns the title based on the [params.type] and [isEdit] flag.
  String get getTitle {
    switch (params.type) {
    /// Returns the title for SRS material supplier type.
      case MaterialSupplierType.srs:
        return (isEdit && !params.isDefaultBranchSaved? 'confirm_srs_account'.tr : 'srs_distribution_account_verification'.tr).toUpperCase();
    /// Returns the title for Beacon material supplier type.
      case MaterialSupplierType.beacon:
        return (isEdit && !params.isDefaultBranchSaved ? 'confirm_beacon_account'.tr : 'beacon_distribution_account_verification'.tr).toUpperCase();
      case MaterialSupplierType.abc:
        return (isEdit && !params.isDefaultBranchSaved? 'confirm_abc_account'.tr : 'abc_distribution_account_verification'.tr).toUpperCase();
        /// Returns an empty string for other material supplier types.
      default:
        return '';
    }
  }

  String? get getSubtitle {
    if(!Helper.isValueNullOrEmpty(params.worksheetType) && !params.isDefaultBranchSaved) {
      switch (params.type) {
      /// Returns the subtitle for SRS material supplier type.
        case MaterialSupplierType.srs:
          return 'activate_an_srs_distribution'.trParams(typeParam);
      /// Returns the subtitle for Beacon material supplier type.
        case MaterialSupplierType.beacon:
          return 'activate_an_beacon_distribution'.trParams(typeParam);
      /// Returns the subtitle for ABC material supplier type.
        case MaterialSupplierType.abc:
          return 'activate_an_abc_distribution'.trParams(typeParam);
      /// Returns an empty string for other material supplier types.
        default:
          return null;
      }
    } else {
      return '';
    }
  }

  /// [showJobAccounts] helps in deciding whether Job Accounts field should be shown or not
  bool get showJobAccounts => params.type == MaterialSupplierType.beacon && !Helper.isTrue(params.excludeJob);
  String get saveTitle => isEdit ? 'confirm'.tr.toUpperCase() : 'done'.tr.toUpperCase();

  JPInputBoxController accountController = JPInputBoxController();
  JPInputBoxController branchController = JPInputBoxController();
  JPInputBoxController jobAccountController = JPInputBoxController();

  final MaterialSupplierFormParams params;

  bool isLoading = false;
  bool isLoadingJobAccount = false;
  bool isBranchLoading = false;
  bool isJobAccountRequired = false;
  bool isEdit = false;
  bool showSelectedBranchJobAccounts = false;

  /// [disableForm] helps in disabling the form while loading
  bool get disableForm => isBranchLoading || isLoading || isLoadingJobAccount;

  @override
  void onInit() {
    init();
    super.onInit();
  }

  void init() async {
    if(params.isDefaultBranchSaved) return;
    isEdit = params.isDataAvailable;
    switch (params.type) {
      case MaterialSupplierType.srs:
        await setUpSRSForm();
      case MaterialSupplierType.beacon:
        await setUpBeaconForm();
      case MaterialSupplierType.abc:
        await setUpABCForm();
      default:
        break;
    }
  }

  Future<void> setUpSRSForm() async {
    if (shipToAddressList.isEmpty || srsBranchList.isEmpty) {
      toggleIsLoading();
      shipToAddressList = await MaterialSupplierRepository().getAllSRSShipAddress(params.srsSupplierId);
      if (shipToAddressList.isNotEmpty) {
        String? shipToAddressId = Helper.isValueNullOrEmpty(params.srsShipToAddress?.shipToSequenceId)
            ? shipToAddressList[0].id?.toString()
            : shipToAddressList.firstWhere((element) => element.shipToSequenceId == params.srsShipToAddress!.shipToSequenceId?.toString(),
            orElse: () => shipToAddressList[0]).id?.toString();
        await getDataFromShipToAddress(shipToAddressId ?? '');
      }
      toggleIsLoading();
    } else {
      params.srsShipToAddress ??= shipToAddressList[0];
      accountController.text = Helper.getAccountName(params.srsShipToAddress!);
      params.srsBranch ??= srsBranchList.firstWhere((element) => element.defaultCompanyBranch == 1, orElse: () => srsBranchList[0]);
      branchController.text = params.srsBranch!.name ?? '';
    }
  }

  Future<void> setUpBeaconForm() async {
    try {
      toggleIsLoading();

        final response = await MaterialSupplierRepository().getBeaconAccounts();
        beaconAccountsList.clear();
        beaconAccountsList.addAll(response);

      if (beaconAccountsList.isNotEmpty) {
        onBeaconAccountSelected(getDefaultBeaconBranchId());
      } else {
        /// loading beacon jobs with first account
        await loadBeaconJobs();
      }
    } catch (e) {
      rethrow;
    } finally {
      toggleIsLoading();
      update();
    }
  }

  /// [loadBeaconJobs] - loads the list of jobs for the selected beacon account
  Future<void> loadBeaconJobs() async {
    if (!showJobAccounts) return;
    try {
      // getting selected account id
      String? accountId = (params.beaconAccount?.accountId).toString();
      // If beacon jobs are already loaded for an account then we'll simply
      // extract the data from there and return
      if (!Helper.isValueNullOrEmpty(beaconJobs[accountId]?.$2)) {
        setBeaconJobAccount();
        // Deciding whether Job Accounts field should be required or not
        isJobAccountRequired = (beaconJobs[accountId]?.$2.isNotEmpty ?? false)
            && Helper.isTrue(beaconJobs[accountId]?.$2[0].isJobAccountRequired ?? false);

        showSelectedBranchJobAccounts = getBeaconBranchJobAccounts(accountId).isNotEmpty;
        return;
      }

      // If jobs for selected beacon account are not loaded then
      // we'll load them and persist them
      toggleIsLoadingJobAccount(true);
      final requestParams = JPSingleSelectParams(
        accountId: accountId,
      );
      // loading beacon jobs
      final response = await MaterialSupplierRepository.getBeaconJobs(requestParams.toJson());
      List<BeaconJobModel>? beaconJobsList = response['list'];
      PaginationModel? pagination = PaginationModel.fromJson(response['pagination']);
      // setting up request params and beacon jobs data if they are not null
      if (!Helper.isValueNullOrEmpty(accountId)) {
        requestParams.total = pagination.total ?? 0;
        beaconJobs[accountId] = (requestParams, beaconJobsList ?? []);
      }
      setBeaconJobAccount();
      // Deciding whether Job Accounts field should be required or not
      isJobAccountRequired = (beaconJobs[accountId]?.$2.isNotEmpty ?? false)
          && Helper.isTrue(beaconJobsList?[0].isJobAccountRequired ?? false);
      showSelectedBranchJobAccounts = getBeaconBranchJobAccounts(accountId).isNotEmpty;
    } catch (e) {
      rethrow;
    } finally {
      toggleIsLoadingJobAccount(false);
    }
  }

  void setBeaconJobAccount() {
    String? accountId = (params.beaconAccount?.accountId).toString();
    bool isJobNameMissing = Helper.isValueNullOrEmpty(params.beaconJob?.jobName);
    bool hasJobNumber = !Helper.isValueNullOrEmpty(params.beaconJob?.jobNumber);
    // In case of edit beacon supplier details
    if (hasJobNumber && isJobNameMissing) {
      final jobDetails = beaconJobs[accountId]!.$2.firstWhereOrNull((job) {
        return job.jobNumber == params.beaconJob?.jobNumber;
      });
      params.beaconJob = jobDetails;
      jobAccountController.text = jobDetails?.jobName ?? '';
    }
  }

  void toggleIsLoading(){
    isLoading = !isLoading;
    update();
  }

  void toggleIsLoadingJobAccount(bool val) {
    isLoadingJobAccount = val;
    update();
  }

  /// selectAccountAddress() open address list bottom sheet
  void selectAccountAddress() {
    FormValueSelectorService.openSingleSelect(
      title: 'select_account'.tr,
      list: getAccountOptions(),
      controller: accountController,
      selectedItemId: params.selectedAccountId,
      onValueSelected: onAccountSelected,
    );
  }

  /// [getAccountOptions] Returns a list of JPSingleSelectModel objects
  /// based on the type of MaterialSupplier.
  List<JPSingleSelectModel> getAccountOptions() {
    switch (params.type) {
    // If the type is MaterialSupplierType.srs, map shipToAddressList to JPSingleSelectModel objects.
      case MaterialSupplierType.srs:
        return shipToAddressList.map((address) => JPSingleSelectModel(
          id: address.id.toString(),
          label: Helper.getAccountName(address),),
        ).toList();
    // If the type is MaterialSupplierType.beacon, map beaconAccountsList to JPSingleSelectModel objects.
      case MaterialSupplierType.beacon:
        return beaconAccountsList.map((account) => JPSingleSelectModel(
            id: account.id.toString(),
            label: account.name ?? ""),
        ).toList();
    // If the type is MaterialSupplierType.beacon, map beaconAccountsList to JPSingleSelectModel objects.
      case MaterialSupplierType.abc:
        return abcAccountList.map((account) => JPSingleSelectModel(
            id: account.id.toString(),
            label: Helper.getAbcAccountName(account))
        ).toList();  
    // If the type is neither srs nor beacon, return an empty list.
      default:
        return [];
    }
  }

  /// [getBranchOptions] Retrieves the branch options based on the material supplier type
  List<JPSingleSelectModel> getBranchOptions() {
    List<SupplierBranchModel> tempOptions = [];
    switch (params.type) {
      case MaterialSupplierType.srs:
        tempOptions = srsBranchList;
        break;
      case MaterialSupplierType.beacon:
        tempOptions = beaconBranchList;
      case MaterialSupplierType.abc:
        tempOptions = abcBranchList;
        break;
      default:
        break;
    }
    return tempOptions.map((branch) => JPSingleSelectModel(
        id: branch.branchCode.toString(),
        label: params.type == MaterialSupplierType.abc
            ? Helper.getAbcBranchName(branch)
            : branch.name ?? '')
    ).toList();
  }

  /// [onAccountSelected] updates the branches associated with Material Supplier Account
  /// on the basis on selected [params.type]
  void onAccountSelected(String id) {
    // Resetting beacon job
    jobAccountController.text = "";
    params.beaconJob = null;

    switch (params.type) {
      case MaterialSupplierType.srs:
        getDataFromShipToAddress(id);
        break;
      case MaterialSupplierType.beacon:
        onBeaconAccountSelected(id);
      case MaterialSupplierType.abc:
        getDataFromAbcAddress(id);
      default:
        break;
    }
  }

  /// [onBeaconAccountSelected] Handles the event when a beacon account is selected.
  ///
  /// Updates the [params.beaconAccount] based on the selected [id],
  /// sets the [accountController.text] to the name of the selected beacon account,
  void onBeaconAccountSelected(String id) {
    params.beaconAccount = beaconAccountsList.firstWhereOrNull((beaconAccount) {
      return beaconAccount.id?.toString() == id || beaconAccount.accountId?.toString() == id;
    });
    accountController.text = params.beaconAccount?.name ?? '';
    jobAccountController.text = params.beaconJob?.jobName ?? "";
    // updating selected branch
    onBeaconBranchSelected();
    // updating the job accounts
    loadBeaconJobs();
  }

  /// getDataFromShipToAddress() get ship to address from list through id and set data in fields & fetch branches
  Future<void> getDataFromShipToAddress(String id) async {
    toggleIsBranchLoading();
    params.srsShipToAddress = shipToAddressList.firstWhereOrNull((element) => element.id?.toString() == id);
    accountController.text = Helper.getAccountName(params.srsShipToAddress);

    srsBranchList = [];
    branchController.text = '';

    if (params.srsShipToAddress?.id != null) {
      srsBranchList = await MaterialSupplierRepository().getAllSRSBranches(params.srsShipToAddress!.id!, params.srsSupplierId);
      if (srsBranchList.isNotEmpty) {
        String? branchCode;
        if (params.srsBranch != null) {
          branchCode = params.srsBranch!.branchCode?.toString();
        } else {
          branchCode = srsBranchList.firstWhere((element) => element.defaultCompanyBranch == 1, orElse: () => srsBranchList[0]).branchCode?.toString();
        }
        getDataFromBranch(branchCode ?? '');
      } else {
        params.srsBranch = null;
      }
    }
    toggleIsBranchLoading();
  }

  /// selectBranch() open branch bottom sheet list filtered with selected address 
  void selectBranch() {
    FormValueSelectorService.openSingleSelect(
      title: 'select_branch'.tr,
      list: getBranchOptions(),
      controller: branchController,
      selectedItemId: params.selectedBranchId,
      onValueSelected: onBranchSelected,
    );
  }

  void onBranchSelected(String id) {
    switch (params.type) {
      case MaterialSupplierType.srs:
        getDataFromBranch(id);
        break;
      case MaterialSupplierType.beacon:
        onBeaconBranchSelected();
      case MaterialSupplierType.abc:
        getDataFromAbcBranch(id);
      default:
        break;
    }
  }

  /// [onBeaconBranchSelected] Updates the beacon branch based on the selected beacon account
  void onBeaconBranchSelected() {
    toggleIsBranchLoading();
    // Set beaconBranch to the supplierBranch of the beaconAccount if it exists
    params.beaconBranch = params.beaconAccount?.supplierBranch;
    // Set the text of branchController to the name of the supplierBranch
    // of the beaconAccount, or an empty string if it doesn't exist
    branchController.text = params.beaconAccount?.supplierBranch?.name ?? '';
    // Set beaconBranchList to contain params.beaconBranch if it's not null
    beaconBranchList = params.beaconBranch != null ? [params.beaconBranch!] : [];
    String? accountId = (params.beaconAccount?.accountId).toString();
    showSelectedBranchJobAccounts = getBeaconBranchJobAccounts(accountId).isNotEmpty;
    toggleIsBranchLoading();
  }

  /// getDataFromBranch() get branch from list through id and set data in fields
  void getDataFromBranch(String id) {
    params.srsBranch = srsBranchList.firstWhereOrNull((element) => element.branchCode?.toString() == id);
    branchController.text = params.srsBranch?.name ?? '';
    update();
  }

  /// onDone() : will back with selected address & branch on validations completed otherwise show error field
  void onDone() {
    bool isValid = formKey.currentState?.validate() ?? false; // validating form
    if (isValid) {
      Get.back(result: {
        NavigationParams.supplierDetails: params,
      });
    }
  }

  Future<void> selectJobAccount() async {
    String? accountId = (params.beaconAccount?.accountId).toString();
    // Preparing options to be displayed for selection
    final List<JPSingleSelectModel> optionsList = getBeaconBranchJobAccounts(accountId);

    // Displaying selector
    await FormValueSelectorService.openNetworkSingleSelect(
      title: 'select_job_account'.tr,
      controller: jobAccountController,
      selectedItemId: params.beaconJob?.jobNumber ?? "",
      networkListType: JPNetworkSingleSelectType.beaconJobs,
      params: beaconJobs[accountId]?.$1,
      optionsList: optionsList,
      onValueSelected: (val) {
        params.beaconJob = (val.additionalData as BeaconJobModel);
        formKey.currentState?.validate();
      },
    );
  }

  List<JPSingleSelectModel> getBeaconBranchJobAccounts(String accountId) {
    return JPNetworkSingleSelectService.parseToMultiSelect(
      JPNetworkSingleSelectType.beaconJobs,
      beaconJobs[accountId]?.$2 ?? <BeaconJobModel>[],
    );
  }

  void onTapMakeDefault(bool isChecked) {
    params.isBranchMakeDefault = !isChecked;
    update();
  }

  String getDefaultBeaconBranchId() {
    String id;
    if(params.beaconAccount?.accountId != null) {
      id = params.beaconAccount!.accountId.toString();
    } else {
      final BeaconAccountModel defaultBeaconAccount = beaconAccountsList.firstWhere(
              (element) => element.supplierBranch?.defaultCompanyBranch == SupplierConstant.defaultCompanyBranch,
          orElse: () => beaconAccountsList[0]);
      id = defaultBeaconAccount.accountId.toString();
    }
    return id;
  }

  Future<void> setUpABCForm() async {
    try {
      toggleIsLoading();
      final Map<String, dynamic> queryParams = {
        'limit': 0,
        'includes': 'branches'
      };
      final response = await MaterialSupplierRepository().getSupplierAccounts(
          Helper.getSupplierId(key: CommonConstants.abcSupplierId)!,
          queryParams
      );
      abcAccountList.clear();
      abcAccountList.addAll(response);

      if (abcAccountList.isNotEmpty) {
        String? accountId = params.abcAccount?.shipToId == null ? abcAccountList[0].id?.toString() : abcAccountList.firstWhereOrNull((element) => element.shipToId == params.abcAccount?.shipToId)?.id?.toString();
        await getDataFromAbcAddress(accountId!);
      } else {
        params.abcBranch = null;
        Get.back();
        WorksheetHelpers.showABCSupplierInfoDialog();
      }
    } catch (e) {
      rethrow;
    } finally {
      toggleIsLoading();
      update();
    }
  }

  /// getDataFromAbcAddress() get ship to address from list through id and set data in fields & fetch branches
  Future<void> getDataFromAbcAddress(String id) async {
    toggleIsBranchLoading();
    params.abcAccount = abcAccountList.firstWhereOrNull((element) => element.id?.toString() == id);
    accountController.text = Helper.getAbcAccountName(params.abcAccount);

    abcBranchList = [];
    branchController.text = '';

    if (params.abcAccount?.id != null) {
      var map = {
        'includes[]': 'supplier_accounts',
        'supplier_account_id': params.abcAccount!.id!
      };
      abcBranchList = await MaterialSupplierRepository().getSupplierBranches(Helper.getSupplierId(key: CommonConstants.abcSupplierId)!, map);
      if (abcBranchList.isNotEmpty) {
        String? branchId;
        if (params.abcBranch != null) {
          branchId = params.abcBranch!.branchCode?.toString();
        } else {
          branchId = abcBranchList.firstWhere((element) => element.defaultCompanyBranch == 1, orElse: () => abcBranchList[0]).branchCode?.toString();
        }
        getDataFromAbcBranch(branchId ?? '');
      } else {
        params.abcBranch = null;
        WorksheetHelpers.showABCSupplierInfoDialog();
      }
    }
    toggleIsBranchLoading();
  }

  /// getDataFromAbcBranch() get branch from list through id and set data in fields
  void getDataFromAbcBranch(String id) {
    params.abcBranch = abcBranchList.firstWhereOrNull((element) => element.branchCode?.toString() == id);
    branchController.text = Helper.getAbcBranchName(params.abcBranch);
    update();
  }

  void toggleIsBranchLoading() {
    isBranchLoading = !isBranchLoading;
    update();
  }
}