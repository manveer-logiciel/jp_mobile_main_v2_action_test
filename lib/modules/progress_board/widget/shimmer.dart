import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:jp_mobile_flutter_ui/Label/type.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../../global_widgets/progress_board_list_view/index.dart';
import '../controller.dart';

class ProgressBoardShimmer extends StatelessWidget {
  const ProgressBoardShimmer({
    super.key,
    required this.controller
  });

  final ProgressBoardController controller;

  @override
  Widget build(BuildContext context) {
    return JPProgressBoardList(
      disableScrolling: true,
      controller: controller,
      headerHeight: 20,
      noOfRows: 10,
      noOfColumns: 5,
      headerWidget: (int columnIndex) => headerWidget(),
      separatorWidget: (int rowIndex) => separatorWidget(),
      contentWidget: (int rowIndex, int columnIndex) => contentWidget(),
    );
  }

  Widget headerWidget() => Shimmer.fromColors(
    baseColor: JPAppTheme.themeColors.dimGray,
    highlightColor: JPAppTheme.themeColors.inverse,
    child: Padding(
      padding: const EdgeInsets.all(4),
      child: Container(
        padding: EdgeInsets.zero,
        width: 20,
        height: 10,
        alignment: Alignment.centerLeft,
        child: const JPLabel(
          text: " ",
          type: JPLabelType.lightGray,
        ),
      ),
    ),
  );

  Widget separatorWidget() => Shimmer.fromColors(
    baseColor: JPAppTheme.themeColors.dimGray,
    highlightColor: JPAppTheme.themeColors.inverse,
    child: Padding(
      padding: const EdgeInsets.only(top: 10,bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 10),
            child: contentDataWidget(
              height: 10,
              width: 10,
              pendingBottom: 5
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 15),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                contentDataWidget(
                                  height: 10,
                                  width: 150,
                                  pendingBottom: 5
                                ),
                                contentDataWidget(
                                  height: 7,
                                  width: 250,
                                  pendingBottom: 0
                                ),
                              ]
                            )
                          )
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(4),
                              child: JPIcon(
                                Icons.expand_more,
                                color: JPAppTheme.themeColors.inverse,
                                size: 18,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4),
                              child: JPIcon(
                                Icons.archive_outlined,
                                color: JPAppTheme.themeColors.inverse,
                                size: 18,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4),
                              child: JPIcon(
                                Icons.delete_outline,
                                color: JPAppTheme.themeColors.inverse,
                                size: 18,
                              ),
                            ),
                          ],
                        ),
                      ]
                    )
                  ]
                )
            )
          ),
        ],
      ),
    ),
  );

  Widget contentWidget() => Shimmer.fromColors(
    baseColor: JPAppTheme.themeColors.dimGray,
    highlightColor: JPAppTheme.themeColors.inverse,
    child: Container(
      width: double.maxFinite,
      height: double.maxFinite,
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          for(int i = 0; i < 1; i++)
          contentDataWidget(height: 7, pendingBottom: i == 0 ? 0 : 6)
        ],
      ),
    ),
  );

  Widget contentDataWidget({
    required double height,
    required double pendingBottom,
    double width = double.maxFinite,}) => Container(
      padding: EdgeInsets.zero,
      width: width,
      height: height,
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(bottom: pendingBottom),
      decoration: BoxDecoration(
        color: JPAppTheme.themeColors.dimGray,
        border: Border.all(color: JPColor.red, width: 1),
        borderRadius: BorderRadius.circular(20)
      ),
    );
}
