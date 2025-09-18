import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/macro.dart';
import 'package:jobprogress/core/constants/navigation_parms_constants.dart';
import 'package:jobprogress/routes/pages.dart';
import '../../../common/models/macros/index.dart';
import '../../../common/models/snippet_listing/snippet_list_param.dart';
import '../../../common/repositories/macros.dart';

class MacroListingController extends GetxController {

  bool isLoading = true;
  bool isLoadingMore = false;
  bool canShowMore = false;
  bool canShowApplyBtn = false;
  
  CancelToken? cancelToken = CancelToken();
  
  List<String> macroIdList = [];
  List<MacroListingModel> macroList = [];
  
  SnippetListingParamModel macroListingParam = SnippetListingParamModel();
  
  bool isEnableSellingPrice = Get.arguments?[NavigationParams.isEnableSellingPrice] ?? false;
  MacrosListType type = Get.arguments?[NavigationParams.macroType] ?? MacrosListType.xactimateEstimate;
  String? srsBranchCode = Get.arguments?[NavigationParams.srsBranchCode];
  String? beaconBranchCode = Get.arguments?[NavigationParams.beaconBranchCode];
  String? worksheetType = Get.arguments?[NavigationParams.worksheetType];
  int? srsSupplierId = Get.arguments?[NavigationParams.srsSupplierId];
  String? abcBranchCode = Get.arguments?[NavigationParams.abcBranchCode];
  String? shipToSequenceId = Get.arguments?[NavigationParams.shipToSequenceId];
  int? jobDivisionId = Get.arguments?[NavigationParams.jobDivisionId];

  @override
  void onInit() {
    fetchData();
    super.onInit();
  }

  Future<void> fetchData() async {
    try {
      await fetchMacros();
    } catch (e) {                                                                                         
      rethrow;
    } finally {
      isLoading = false;
      isLoadingMore = false;
      update();
    }
  }

  void toggleIsChecked(bool val,int index) {
    macroList[index].isChecked = !macroList[index].isChecked;

    List<MacroListingModel> selectedMacros = macroList.where((element) => element.isChecked).toList();

    macroIdList = selectedMacros.map((e) => e.macroId.toString()).toList();

    canShowApplyBtn = macroIdList.isNotEmpty;

    update();
  }

  Future<void> fetchMacros() async {
      final type = getTypeFromMarcosList();
      final params = MacroListingModel.getMacrosParams(type,
        srsBranchCode: srsBranchCode,
        beaconBranchCode: beaconBranchCode,
        srsSupplierId: srsSupplierId,
        abcBranchCode: abcBranchCode,
        jobDivisionId: jobDivisionId
      );
      final response = await MacrosRepository().fetchMacroList(params);
      List<MacroListingModel> list = response['list'];
      macroList.addAll(list);
  }
  
  void cancelOnGoingRequest() {
     cancelToken?.cancel();
  }
  
  Future<void> refreshList({bool? showLoading}) async {
    macroList.clear();
    macroListingParam.page = 1;
    isLoading = showLoading ?? false;
    update();
    await fetchData();
  }

  String getTypeFromMarcosList() {
    switch (type) {

      case MacrosListType.estimateProposal:
        return "estimate_proposal";

      case MacrosListType.xactimateEstimate:
        return "xactimate_estimate";

      case MacrosListType.materialList:
        return 'material_list';

      case MacrosListType.workOrder:
        return 'work_order';

      case MacrosListType.beacon:
        return 'beacon';

      case MacrosListType.srs:
        return 'srs';
    }
  }

  void navigateToMacroDetails({
      String? macroId,
  }) async {
      Get.toNamed(Routes.macroListDetail, arguments: {
          NavigationParams.macroId: macroId,
          NavigationParams.macroType: type,
          NavigationParams.beaconBranchCode: beaconBranchCode,
          NavigationParams.abcBranchCode: abcBranchCode,
          NavigationParams.srsBranchCode: srsBranchCode,
          NavigationParams.isEnableSellingPrice: isEnableSellingPrice,
          NavigationParams.srsSupplierId: srsSupplierId,
          NavigationParams.shipToSequenceId: shipToSequenceId,
          NavigationParams.jobDivisionId: jobDivisionId
      });
  }

}
