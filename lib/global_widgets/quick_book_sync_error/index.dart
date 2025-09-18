import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/global_widgets/in_app_web_view/index.dart';
import 'package:jobprogress/global_widgets/quick_book_sync_error/header.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'controller.dart';
import 'shimmer.dart';

class QuickBookSyncError extends StatelessWidget {
  final String entity;
  final String entityId;
  const QuickBookSyncError({super.key, required this.entity, required this.entityId});

  @override
  Widget build(BuildContext context) {

     QuickBookSyncErrorController controller = Get.put(QuickBookSyncErrorController(entity : entity , entityId : entityId));

    return GetBuilder<QuickBookSyncErrorController>(
      builder: (_) {
        return Wrap(
          children: [
              Container(
                padding: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                    color: JPAppTheme.themeColors.base,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [                   
                    QuickBookErrorBottomSheetHeader(title: 'quick_book_sync_error'.tr.toUpperCase()),            
                    AnimatedContainer(
                      width: MediaQuery.of(context).size.width,
                      constraints: BoxConstraints(
                        maxHeight: controller.isLoading? MediaQuery.of(context).size.height * 0.40 : MediaQuery.of(context).size.height * 0.80,
                      ),
                      duration: const Duration(milliseconds: 200),
                      child: controller.isLoading ? const QuickBookSyncErrorShimmer() : controller.quickBookSyncError != null  ? 
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [                              
                              if(controller.quickBookSyncError!.details != null)
                              JPText(
                                text:controller.quickBookSyncError!.details!,
                                textColor: JPAppTheme.themeColors.darkGray
                              ),
                              const SizedBox(height: 5),
                              if(controller.quickBookSyncError!.explanation != null)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                JPText(
                                  text: controller.quickBookSyncError!.message!,
                                  fontWeight: JPFontWeight.medium,
                                  textSize: JPTextSize.heading4
                                ),
                                const SizedBox(height: 7),
                                JPText(
                                  text: controller.quickBookSyncError!.explanation!,
                                  textColor: JPAppTheme.themeColors.darkGray,
                                  textAlign: TextAlign.start,
                                ),
                                const SizedBox(height: 10),
                              ]),
                            
                              if(controller.quickBookSyncError!.remedy != null)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                Material(
                                  color: JPAppTheme.themeColors.base,
                                  child: JPTextButton(
                                    paddingInsets: const EdgeInsets.only(top: 5, bottom: 5),
                                    onPressed: (){
                                      controller.isSolutionExpandedChange();
                                    },
                                    isExpanded: false,
                                    text: 'check_solutions'.tr,
                                    color: JPAppTheme.themeColors.primary,
                                    textSize: JPTextSize.heading4,
                                    icon: controller.isSolutionExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down
                                  ),
                                ),
                                const SizedBox(height: 5),
                                AnimatedContainer(
                                  margin: const EdgeInsets.only(right: 5),
                                  duration:const Duration(milliseconds: 150),
                                  height: controller.isSolutionExpanded ? controller.height : 1.0,
                                  child: JPInAppWebView(
                                    callBackForHeight: (height){
                                      controller.callBackForHeight(height);
                                    },
                                    content: controller.quickBookSyncError!.remedy!,
                                    height: controller.height,  
                                  )
                                ),
                              ])
                            ],
                          ),
                        ): 
                      const SizedBox.shrink(),
                    )
                  ],
                ),
              )
          ],
        );
      }
    );
  }
}