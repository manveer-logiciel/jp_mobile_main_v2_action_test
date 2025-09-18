import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/core/utils/file_helper.dart';
import 'package:jobprogress/global_widgets/network_image/index.dart';
import 'package:jobprogress/global_widgets/no_data_found/index.dart';
import 'package:jobprogress/global_widgets/replace_job_id_with_company_setting/job_name_with_company_setting.dart';
import 'package:jobprogress/global_widgets/safearea/safearea.dart';
import 'package:jobprogress/global_widgets/scaffold/index.dart';
import 'package:jobprogress/modules/document_expired/shimmer.dart';
import 'package:jp_mobile_flutter_ui/Thumb/icon_thumb.dart';
import 'package:jp_mobile_flutter_ui/Thumb/image_thumb.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'controller.dart';
import 'date_detail_tile.dart';

class DocumentExpiredView extends StatelessWidget {
  const DocumentExpiredView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DocumentExpiredController>(
      init: DocumentExpiredController(),
      global: false,
      builder: (controller) {
        return JPScaffold(
          scaffoldKey: controller.scaffoldKey,
          appBar: JPHeader(
            onBackPressed: () {
              Get.back();
            },
            title: '${'expired'.tr.capitalize!} ${'document'.tr}',
          ),
          body:controller.isLoading ? 
            const DocumentExpiredShimmer() :
            controller.expiredDocument !=null ?
            JPSafeArea(
              top: false,
              child: SingleChildScrollView(
                child: 
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, bottom: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FileHelper.checkIfImage(controller.expiredDocument!.path!) ? 
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: JPAppTheme.themeColors.dimGray,
                              width: 1
                            )
                          ),
                          padding: const EdgeInsets.all(10),
                          child:SizedBox(
                            width: 125,
                            height: 125,
                            child: 
                            JPThumbImage(
                              borderRadius: BorderRadius.zero,
                              thumbImage: 
                              JPNetworkImage(
                                borderRadius: 4,
                                src: controller.expiredDocument!.url,
                                boxFit: BoxFit.cover,
                              ),
                            ) 
                          )
                        ):
                        Container( 
                          height: 125,
                          width: 125,
                          padding: const EdgeInsets.all(35),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: JPAppTheme.themeColors.dimGray,
                              width: 1
                            )
                          ),
                          child: JPThumbIcon(
                            iconType: controller.expiredDocument!.jpThumbIconType!,
                            size: ThumbSize.large,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.only(left: 16, top: 10, right: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                JPText(
                                  textAlign: TextAlign.left,
                                  text: controller.expiredDocument?.name ?? '',
                                  fontWeight: JPFontWeight.medium,
                                ),
                                const SizedBox(height: 5),
                                JPText(
                                  text: controller.type.capitalize ?? '',
                                  textColor: JPAppTheme.themeColors.darkGray,
                                ),
                                const SizedBox(height: 10),
                                JPButton(
                                  onPressed: controller.openFile,
                                  size: JPButtonSize.extraSmall,
                                  text: 'open'.tr.toUpperCase(),
                                ), 
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        JPText(text: '${'other'.tr.toUpperCase()} ${'details'.tr.toUpperCase()}',fontWeight: JPFontWeight.medium),
                        DateDetailTile(
                          title: '${'expiring'.tr.capitalize!} ${'date'.tr.capitalize!}',
                          date: controller.expiredDocument!.expirationDate
                        ),
                        DateDetailTile(
                          title: 'creation_date'.tr,
                          date: controller.expiredDocument?.createdAt
                        ),
                        DateDetailTile(
                          title: "last_modified".tr,
                          date: controller.expiredDocument?.updatedAt
                        ),
                        if(controller.job != null)
                        Container(
                          padding: const EdgeInsets.only(top: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              JPText(
                                textAlign: TextAlign.left,
                                text: 'job_id'.tr,
                                textColor: JPAppTheme.themeColors.tertiary,
                              ),
                              Flexible(
                                child: JobNameWithCompanySetting(
                                  alignment: MainAxisAlignment.end,
                                  job: controller.job!,
                                  textColor: JPAppTheme.themeColors.primary,
                                  textDecoration: TextDecoration.underline,
                                  isClickable: true,
                                ),
                              )
                            ],
                          ),
                        ),
                        
                        if(controller.expiredDocument!.expirationDescription != null)...{
                          const SizedBox(height: 15,),
                          JPText(
                            text: 'description'.tr,
                            textColor: JPAppTheme.themeColors.tertiary,  
                          ),
                          const SizedBox(height: 5),
                          JPReadMoreText(
                            controller.expiredDocument!.expirationDescription!,
                            textAlign: TextAlign.start,
                            dialogTitle: 'description'.tr,
                          ),
                        }
                      ],  
                    ),
                  ),
                ],
              ),
            )
          ):
          NoDataFound(
            icon: Icons.insert_drive_file_outlined,
            title: '${'document'.tr.capitalize!} ${'not'.tr.capitalize!} ${'found'.tr.capitalize!}' ,
          )
        );
      }
    );
  }
}

