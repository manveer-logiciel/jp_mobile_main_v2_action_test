
import 'package:get/get.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_model.dart';
import 'package:jobprogress/common/models/templates/form_proposal/template.dart';
import 'package:jobprogress/core/constants/templates.dart';
import 'package:jobprogress/core/constants/templates/html.dart';
import 'package:jp_mobile_flutter_ui/Thumb/icon_type.dart';
import 'package:jp_mobile_flutter_ui/Thumb/type.dart';

class FilesListingTemplateFiles {

  static FilesListingModel get imageTemplate => FilesListingModel(
    name: 'images'.tr,
    isDir: 0,
    isFile: true,
    isSelected: false,
    jpThumbIconType: JPThumbIconType.template,
    jpThumbType: JPThumbType.icon,
    proposalTemplatePages: [
      FormProposalTemplateModel(
          id: -1,
          title: 'image'.tr,
          isVisitRequired: true,
          pageType: TemplateConstants.legalPage,
          content: TemplateFormHtmlConstants.imageTemplateHeader
      )
    ]
  );

  static FilesListingModel get sellingPriceSheet => FilesListingModel(
    name: 'selling_price_sheet'.tr,
    isDir: 0,
    isFile: true,
    isSelected: false,
    jpThumbIconType: JPThumbIconType.template,
    jpThumbType: JPThumbType.icon,
    proposalTemplatePages: [
      FormProposalTemplateModel(
        id: -2,
        isVisitRequired: true,
        pageType: TemplateConstants.legalPage,
        title: 'selling_price_sheet'.tr,
      )
    ]
  );

}