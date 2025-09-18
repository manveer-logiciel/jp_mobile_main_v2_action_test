import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jp_mobile_flutter_ui/Label/type.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'package:shimmer/shimmer.dart';

import '../../../common/models/progress_board/progress_board_filter_model.dart';
import '../../../core/utils/single_select_helper.dart';
import '../../../global_widgets/bottom_sheet/index.dart';
import '../controller.dart';
import 'filter_dialog/index.dart';

class ProgressBoardSecondaryHeader extends StatelessWidget {
  const ProgressBoardSecondaryHeader({
    super.key,
    required this.pbController});

  final ProgressBoardController pbController;

  void openFilters() {
    showJPGeneralDialog(
        child:(controller) => PBFilterDialog(
          selectedFilters: pbController.filterKeys,
          defaultFilters: pbController.defaultFilters,
          onApply: (ProgressBoardFilterModel params) {
            pbController.applyFilters(params);
          },
        )
    );
  }

  void openSortBy() {
    SingleSelectHelper.openSingleSelect(
        pbController.pbList,
        pbController.filterKeys.boardId.toString(),
        'progress_boards'.tr,
        (value) {
          pbController.updateProgressBoard(value, pbController.pbList);
        } ,
        isFilterSheet: true
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 11, top: 5, bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ///   Filters
          (pbController.filterKeys.selectedPB?.isEmpty ?? true)
            ?  const SizedBox.shrink()
            : JPFilterIcon(
            onTap: () => openFilters(),
          ),
          ///   Sort By
          (pbController.isLoading)
            ? Shimmer.fromColors(
            baseColor: JPAppTheme.themeColors.dimGray,
            highlightColor: JPAppTheme.themeColors.inverse,
            child: Container(
              padding: EdgeInsets.zero,
              width: 30,
              height: 12,
              child: const JPLabel(
                text: " ",
                type: JPLabelType.lightGray,
                textSize: JPTextSize.heading5,
              ),
            ),
          )
            : (pbController.filterKeys.selectedPB?.isEmpty ?? true)
              ?  const SizedBox.shrink()
              : Material(
                color: JPAppTheme.themeColors.base,
                child: JPTextButton(
                  color: JPAppTheme.themeColors.tertiary,
                  onPressed: () => openSortBy(),
                  fontWeight: JPFontWeight.medium,
                  textSize: JPTextSize.heading5,
                  text: pbController.filterKeys.selectedPB,
                  icon: Icons.keyboard_arrow_down_outlined
                ),
              ),
        ],
      ),
    );
  }
}