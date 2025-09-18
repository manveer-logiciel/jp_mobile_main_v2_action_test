
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/file_listing.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_quick_action_params.dart';
import 'package:jobprogress/common/models/files_listing/my_favourite_entity.dart';
import 'package:jobprogress/common/models/sql/trade_type/trade_type_param.dart';
import 'package:jobprogress/common/models/sql/trade_type/trade_type_response.dart';
import 'package:jobprogress/common/repositories/estimations.dart';
import 'package:jobprogress/common/repositories/sql/trade_type.dart';
import 'package:jobprogress/common/services/files_listing/quick_action_helpers.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/index.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/index.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/modal.dart';

class MarkAsFavouriteController extends GetxController{

  MarkAsFavouriteController(this.fileParams);

  final FilesListingQuickActionParams fileParams;

  bool isAllTradesSelected = false;
  bool isMarkingAsFavourite = false;

  TextEditingController nameController = TextEditingController();
  TextEditingController tradeTypeController = TextEditingController();

  List<JPMultiSelectModel> tradesList = [];
  List<int> tradeIds = [];

  final formKey = GlobalKey<FormState>();

  // isMarkedByMe is used to checked/unchecked the mark for radio button
  bool isMarkedByMe = true;

  @override
  void onInit() {
    nameController.text = fileParams.fileList.first.name.toString();
    getTrades();
    super.onInit();
  }

  void getTrades() async {
    TradeTypeParamModel requestParams = TradeTypeParamModel(
        withInactive: true,
        includes: ['work_type'],
        withInActiveWorkType: true,
        limit: 0
    );

    TradeTypeResponseModel trades = await SqlTradeTypeRepository().get(params: requestParams);
    for (var i = 0; i < trades.data.length; i++) {
      tradesList.add(
        JPMultiSelectModel(label: trades.data[i].name, id: trades.data[i].id.toString(), isSelect: false)
      );
    }
  }

  void showTradeType(){
    showJPBottomSheet(
        child: (_) => JPMultiSelect(
          mainList: tradesList,
          inputHintText: 'search_trade'.tr,
          onDone: (List<JPMultiSelectModel>? selectedTrades){
            setTradeType(selectedTrades);
          },
        ),
        isDismissible: false,
        enableDrag: false,
        isScrollControlled: true
    );
  }

  void toggleIsAllTradesSelected(){
    isAllTradesSelected = !isAllTradesSelected;
    update();
  }

  void setTradeType(List<JPMultiSelectModel>? trades){

    String selectedTradeNames = '';
    tradeIds.clear();

    List<JPMultiSelectModel>? selectedTrades = trades?.where((element) => element.isSelect).toList();

    tradesList = trades!;

    if(selectedTrades == null || selectedTrades.isEmpty){
      Get.back();
      tradeTypeController.text = '';
      return;
    }

    for (var trade in selectedTrades) {
      if(trade.isSelect) {
        selectedTradeNames += '${trade.label}; ';
        tradeIds.add(int.parse(trade.id));
      }
    }

    tradeTypeController.text = selectedTradeNames.substring(0, selectedTradeNames.length - 2);

    validateForm();

    update();

    Get.back();
  }

  validateName(String value){
    if (value.isEmpty) {
      return "please_enter_name".tr;
    }

    return '';
  }

  validateTradeType(String value){
    if (value.isEmpty) {
      return "please_select_trade_type".tr;
    }

    return '';
  }

  bool validateForm() {
    return formKey.currentState!.validate();
  }

  Future<void> markAsFavourite() async{
    if (validateForm()) {
    try {
        toggleIsMarkingAsFavourite();
        Map<String, dynamic> params = {
          "entity_id": fileParams.fileList.first.id,
          "for_all_trades": isAllTradesSelected,
          "name": nameController.text,
          if(!isAllTradesSelected) "trade_ids": tradeIds,
          "type": getFileType(),
          "for_all_users": Helper.isTrueReverse(!isMarkedByMe)
        };

        MyFavouriteEntity entity = await EstimatesRepository.markAsFavourite(params);
       
        Get.back();
        
        fileParams.fileList.first.myFavouriteEntity = entity;
        
        fileParams.onActionComplete(fileParams.fileList.first, FLQuickActions.markAsFavourite);

        Helper.showToastMessage(FileListingQuickActionHelpers.getToastMessage(FLQuickActions.markAsFavourite));
        isMarkedByMe = true;
    }catch(e){
      Helper.handleError(e);
    }finally{
      toggleIsMarkingAsFavourite();
    }
    }
  }

  void toggleIsMarkingAsFavourite(){
    isMarkingAsFavourite = !isMarkingAsFavourite;
    update();
  }

  String getFileType() {
    if(fileParams.fileList.first.type == 'xactimate') {
      return 'xactimate_estimate';
    } else {
      switch(fileParams.type) {
        case FLModule.estimate:
          return 'estimate';
        case FLModule.jobProposal:
          return 'proposal';
        case FLModule.materialLists:
          return 'material_list';
        case FLModule.workOrder:
          return 'work_order';
        default:
          return '';
      }
    }
    
  }

  void cancelOnGoingApiRequest() {
    Helper.cancelApiRequest();
  }

  void toggleMarkedByMe(dynamic value) {
    isMarkedByMe = !isMarkedByMe;
    update();
  }

  @override
  void dispose() {
    cancelOnGoingApiRequest();
    super.dispose();
  }

}