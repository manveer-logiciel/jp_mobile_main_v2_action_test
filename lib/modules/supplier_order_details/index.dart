import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/safearea/safearea.dart';
import 'package:jobprogress/global_widgets/scaffold/index.dart';
import 'package:jobprogress/global_widgets/will_pop_scope/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'controller.dart';
import 'detail_tile/index.dart';

class SupplierOrderDetail extends GetView<SupplierOrderDetailController> {
  const SupplierOrderDetail( {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SupplierOrderDetailController>(
      init: SupplierOrderDetailController(),
      builder: (_) => JPWillPopScope(
        onWillPop: () async {
          controller.cancelOnGoingRequest();
          return true;
        },
        child: JPScaffold(
          backgroundColor: JPAppTheme.themeColors.inverse,
          appBar: JPHeader(
            title: controller.title,
            onBackPressed: () {
              controller.cancelOnGoingRequest();
              Get.back();
            },
            actions: [
              const SizedBox(
                width: 16,
              ),
              Visibility(
                visible: !Helper.isValueNullOrEmpty(controller.srsOrder?.orderStatusLabel),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    margin: const EdgeInsets.only(top: 3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: controller.labelColor
                    ),
                    child: JPText(
                      text: controller.srsOrder?.orderStatusLabel?.toUpperCase() ?? '',
                      textColor: JPAppTheme.themeColors.base,
                      textSize: JPTextSize.heading5 
                    ),
                  )
                ),
              ),
              const SizedBox(
                width: 16,
              )
            ],
          ),         
          body: body()
        ),
      ),
    );
  }

  Widget body() => JPSafeArea(
        child: SrsOrderDetailView(
          controller: controller
        ),
      );
}
