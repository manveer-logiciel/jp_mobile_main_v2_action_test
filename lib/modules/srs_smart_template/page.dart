import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/global_widgets/safearea/safearea.dart';
import 'package:jobprogress/global_widgets/scaffold/index.dart';
import 'package:jobprogress/modules/srs_smart_template/widgets/list_tile/shimmer.dart';
import 'package:jobprogress/modules/srs_smart_template/widgets/list_tile/srs_smart_template_tile.dart';
import 'package:jp_mobile_flutter_ui/Header/header.dart';
import 'package:jp_mobile_flutter_ui/Theme/index.dart';
import '../../global_widgets/listview/index.dart';
import '../../global_widgets/no_data_found/index.dart';
import 'controller.dart';

class SrsSmartTemplateView extends StatelessWidget {
  const SrsSmartTemplateView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SrsSmartTemplateController>(
      init: SrsSmartTemplateController(),
      global: false,
      builder: (controller) =>
       JPScaffold(
           backgroundColor: JPAppTheme.themeColors.inverse,
           appBar: JPHeader(
               title: 'select_srs_smart_template'.tr,
               onBackPressed: Get.back<void>),
           body: JPSafeArea(
               top: false,
               child: getList(controller),
           )
       )
    );
  }

  Widget getList(SrsSmartTemplateController controller) {
    return controller.isLoading ?
     const SrsSmartTemplateShimmer() :
     controller.srsSmartTemplateModel?.branchOrderHistroyTemplates != null ?
     Column(
       children: [
         JPListView(
             shrinkWrap: true,
             listCount: controller.srsSmartTemplateModel!.branchOrderHistroyTemplates!.length - 1,
             itemBuilder: (_, index) {
               final model = controller.srsSmartTemplateModel!.branchOrderHistroyTemplates![index];
               return Padding(
                 padding: EdgeInsets.only(top: 20, left: 20, right: 20,
                   bottom: (index == controller.srsSmartTemplateModel!
                     .branchOrderHistroyTemplates!.length -1) ? 20 : 0,),
                 child: SRSSmartTemplateTile(
                   model: model,
                   onSelect: () => controller.onSelectItem(model),
                 ),
               );
             }),
       ],
     ) :
     NoDataFound(
       icon: Icons.task,
       title: 'no_template_found'.tr.capitalize,
     );
  }
}
