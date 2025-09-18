  import 'package:flutter/material.dart';
import 'package:jobprogress/common/enums/file_listing.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_model.dart';
import 'package:jobprogress/core/constants/templates.dart';
import 'package:jobprogress/core/constants/widget_keys.dart';
import 'package:jp_mobile_flutter_ui/Thumb/icon_type.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../../core/constants/assets_files.dart';
import '../../../global_widgets/quick_book/index.dart';

class FileStatusIcon {

  static List<Widget> getList(FilesListingModel data, FLModule module) {
    bool isPdf = data.jpThumbIconType == JPThumbIconType.pdf;
    bool isTemplateListing = module == FLModule.mergeTemplate || module == FLModule.templates;
    return [
      if (data.pageType != null && isTemplateListing) pageType(data),
      if ((data.googleSheetId != null) && module == FLModule.googleSheetTemplate) googleSheet(),
      if (data.workOrderAssignedUser != null && data.workOrderAssignedUser!.isNotEmpty) userIcon(),
      if ((data.type == "worksheet" &&
           module == FLModule.estimate &&
          (data.linkedMaterialLists?.isNotEmpty ?? false ||
           data.linkedWorkProposal != null ||
           data.linkedWorkOrder != null)))
        lockedIcon(),
      if(data.isRestricted && module == FLModule.jobPhotos)
        restrictedIcon(),
      if (data.isShownOnCustomerWebPage ?? false) checkIcon(),
      if (data.myFavouriteEntity != null) starIcon(),
      if (data.type == "google_sheet") googleSheet(),
      if (data.quickMeasureOrder != null) quickMeasureIcon(),
      if(module == FLModule.financialInvoice) quickBookIcon(data),
      if (data.digitalSignStatus == 'completed') digitalSignature(),
      if ((data.isHover ?? false) && isPdf) hoverSynced(),
      if ((data.isEagleView ?? false) && isPdf) eagleView(),
    ];
  }

  static Widget lockedIcon() => Container(
        decoration: BoxDecoration(
            shape: BoxShape.circle, color: JPAppTheme.themeColors.inverse),
        padding: const EdgeInsets.all(4),
        child: JPIcon(
          Icons.lock,
          size: 12,
          color: JPAppTheme.themeColors.tertiary,
        ),
      );

    static Widget restrictedIcon() => Container(
      decoration: BoxDecoration(
          shape: BoxShape.circle, color: JPAppTheme.themeColors.inverse),
      padding: const EdgeInsets.all(4),
      child: JPIcon(
        Icons.block_outlined,
        size: 12,
        color: JPAppTheme.themeColors.tertiary,
      ),
    );


      
  static Widget userIcon() => Container(
        decoration: BoxDecoration(
            shape: BoxShape.circle, color: JPAppTheme.themeColors.inverse),
        padding: const EdgeInsets.all(4),
        child: JPIcon(
          Icons.group_outlined,
          size: 12,
          color: JPAppTheme.themeColors.tertiary,
        ),
      );

  static Widget checkIcon() => Container(
        key: const Key(WidgetKeys.showCustomerWebPageCheckIcon),
        decoration: BoxDecoration(
            shape: BoxShape.circle, color: JPAppTheme.themeColors.inverse),
        padding: const EdgeInsets.all(2),
        child: JPIcon(
          Icons.check,
          size: 14,
          color: JPAppTheme.themeColors.tertiary,
        ),
      );

  static Widget starIcon() => Container(
        decoration: BoxDecoration(
            shape: BoxShape.circle, color: JPAppTheme.themeColors.inverse),
        padding: const EdgeInsets.all(4),
        child: JPIcon(
          Icons.grade,
          size: 12,
          color: JPAppTheme.themeColors.tertiary,
        ),
      );

  static Widget googleSheet() => Container(
        decoration: BoxDecoration(
            shape: BoxShape.circle, color: JPAppTheme.themeColors.inverse),
        padding: const EdgeInsets.all(4),
        child: Image.asset(
            AssetsFiles.googleSheet
        ),
      );

  static Widget quickMeasureIcon() => Container(
    height: 24,
    width: 24,
    decoration: BoxDecoration(
      shape: BoxShape.circle, color: JPAppTheme.themeColors.inverse),
    padding: const EdgeInsets.all(4),
    child: Image.asset(
        AssetsFiles.quickMeasure
    ),
  );

  static Widget digitalSignature() => Container(
    height: 24,
    width: 24,
    decoration: BoxDecoration(
      shape: BoxShape.circle, color: JPAppTheme.themeColors.inverse),
    padding: const EdgeInsets.all(4),
    child: JPIcon(
      Icons.auto_graph_outlined,
      size: 14,
      color: JPAppTheme.themeColors.tertiary,
    ),
  );

  static Widget hoverSynced() => Container(
    height: 24,
    width: 24,
    decoration: BoxDecoration(
        shape: BoxShape.circle, color: JPAppTheme.themeColors.inverse),
    padding: const EdgeInsets.all(4),
    child: Image.asset(AssetsFiles.hover),
  );

  static Widget eagleView() => Container(
    height: 24,
    width: 24,
    decoration: BoxDecoration(
        shape: BoxShape.circle, color: JPAppTheme.themeColors.inverse),
    padding: const EdgeInsets.all(4),
    child: Image.asset(AssetsFiles.eagleView),
  );

  static Widget pageType(FilesListingModel data) {
    String pageType = data.pageType == TemplateConstants.legalPage ? "L" : "S";
    return Container(
      height: 24,
      width: 24,
      decoration: BoxDecoration(
          shape: BoxShape.circle, color: JPAppTheme.themeColors.inverse),
      child: Center(
        child: JPText(
          text: pageType,
          textColor: JPAppTheme.themeColors.darkGray,
          fontWeight: JPFontWeight.bold,
          textSize: JPTextSize.heading5,
        ),
      ),
    );
  }

  static Widget quickBookIcon(FilesListingModel data) => QuickBookIcon(
    qbDesktopId: data.qbDesktopId,
    quickbookId: data.quickbookId,
    origin: data.origin,
    status: data.quickBookSyncStatus.toString(),
  );
}
