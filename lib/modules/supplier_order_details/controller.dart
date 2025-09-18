import 'package:dio/dio.dart';
import 'package:flutter/animation.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/supplier_form_type.dart';
import 'package:jobprogress/common/models/files_listing/srs/delivery_detail.dart';
import 'package:jobprogress/core/constants/navigation_parms_constants.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jp_mobile_flutter_ui/Theme/index.dart';
import '../../common/models/files_listing/srs/srs_order_detail.dart';
import '../../common/repositories/material_lists.dart';

class SupplierOrderDetailController extends GetxController {
  bool isLoading = true;
  
  CancelToken? cancelToken = CancelToken();
  String? supplierOrderId;
  SrsOrderModel? srsOrder;
  SrsDeliveryDetailModel? srsDeliveryDetail;
  String? trackingUrl;
  String? srsInvoiceTotal;
  MaterialSupplierType supplierType = Get.arguments?[NavigationParams.supplierType] ?? MaterialSupplierType.srs;

  int? srsSupplierId = Get.arguments?[NavigationParams.srsSupplierId];
  
  @override
  void onInit() {
    supplierOrderId = Get.arguments?[NavigationParams.supplierOrderId];
    init();
    super.onInit();
  }

  Future<void> init() async {
    switch (supplierType) {
      case MaterialSupplierType.srs:
        await getSrsOrderDetail(supplierOrderId!);
        break;

      case MaterialSupplierType.beacon:
        break;
      case MaterialSupplierType.abc:
        break;
    }
  }

  Color? get labelColor {
    if (srsOrder?.inProgress ?? false) {
      return JPAppTheme.themeColors.tertiary.withValues(alpha: 0.7);
    }
    return JPAppTheme.themeColors.success;
  }

  String get title {
    switch (supplierType) {
      case MaterialSupplierType.srs:
        return 'srs_order_details'.tr;
      case MaterialSupplierType.beacon:
        return 'beacon_order_details'.tr;
      case MaterialSupplierType.abc:
        return 'abc_order_details'.tr;
    }
  }

  Future<void> getSrsOrderDetail(String srsOrderId) async {
    Map<String, dynamic> params = {
      'includes[]': 'srs_order_attachments',
      'supplier_id': srsSupplierId
    };
    try {
      srsOrder = await MaterialListsRepository().fetchSrsOrderDetail(srsOrderId,params);
      trackingUrl = await MaterialListsRepository().fetchTrackingDetails(srsOrder!.orderId.toString(), params);
      srsDeliveryDetail = await MaterialListsRepository().fetchSrsDeliveryDetail(srsOrder!.orderId.toString(), params);
      if(srsOrder?.invoiceNumber != null){
        srsInvoiceTotal = await MaterialListsRepository().fetchSrsInvoiceTotal(srsOrder!.invoiceNumber.toString(), srsSupplierId);
      }
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> downloadPdf() async {
    try {
      showJPLoader(msg: 'downloading'.tr);
      await MaterialListsRepository().downloadPdf(srsOrder?.orderId ??'', srsSupplierId);
    } catch(e) {
      rethrow;
    } finally {
      Get.back();
    }
  }

  Future<void> onTapOfAttachment() async{
    try {
     showJPLoader(msg: 'downloading'.tr);
      await MaterialListsRepository().downloadAttachment(srsOrder?.orderId ??'', srsSupplierId);
    } catch (e) {
      rethrow;
    } finally {
      Get.back();
    }
  }

  void cancelOnGoingRequest() {
    cancelToken?.cancel();
  }
}
