import 'package:flutter/material.dart';
import 'package:jp_mobile_flutter_ui/AnimatedSpinKit/fading_circle.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';

import '../../../global_widgets/listview/index.dart';
import '../../modules/progress_board/controller.dart';

class JPProgressBoardList extends StatefulWidget {
  const JPProgressBoardList({
    super.key,
    required this.controller,
    required this.contentWidget,
    required this.headerWidget,
    required this.separatorWidget,
    this.noOfColumns = 0,
    this.disableScrolling = false,
    this.noOfRows = 0,
    this.contentHeight = 120,
    this.contentWidth = 140,
    this.headerHeight = 50,
    this.padding,
  });

  final int noOfColumns;
  final int noOfRows;
  final double contentWidth;
  final double contentHeight;
  final double headerHeight;
  final bool disableScrolling;
  final EdgeInsets? padding;
  final ProgressBoardController controller;
  final Widget Function(int rowIndex, int columnIndex) contentWidget;
  final Widget Function(int columnIndex) headerWidget;
  final Widget Function(int rowIndex) separatorWidget;

  @override
  State<JPProgressBoardList> createState() => _JPProgressBoardListState();
}

class _JPProgressBoardListState extends State<JPProgressBoardList> {

  late LinkedScrollControllerGroup linkedController;
  late ScrollController headerScrollController;

  List<ScrollController> rowControllers = [];

  @override
  void initState() {
    linkedController = LinkedScrollControllerGroup();
    headerScrollController = linkedController.addAndGet();
    setUpRowControllers(widget.noOfRows);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Container(
            constraints: BoxConstraints(
              minHeight: widget.headerHeight,
            ),
            padding: const EdgeInsets.only(bottom: 5),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color:JPAppTheme.themeColors.dimGray,
                  width: 1,
                ),
              )
            ),
            child: SingleChildScrollView(
              physics: widget.disableScrolling ? const NeverScrollableScrollPhysics(): null,
              controller: headerScrollController,
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: List.generate(widget.noOfColumns,
                  (int columnIndex) =>  SizedBox(
                    width: widget.contentWidth,
                    child: widget.headerWidget(columnIndex),
                  )
                ),
              ),
            ),
          ),

          JPListView(
            physics: widget.disableScrolling ? const NeverScrollableScrollPhysics() : null,
              shrinkWrap: false,
              listCount: widget.noOfRows,
              onLoadMore: widget.controller.canShowLoadMore ? widget.controller.loadMore : null,
              onRefresh: () => widget.controller.refreshList(),
              itemBuilder: (context, rowsIndex) {
                if (rowsIndex < widget.noOfRows) {
                  return Column(
                    children: [
                      widget.separatorWidget(rowsIndex),
                      Container(
                        constraints: BoxConstraints(
                          maxHeight: widget.contentHeight,
                        ),
                        decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                color:JPAppTheme.themeColors.dimGray,
                                width: 1,
                              ),
                              bottom: BorderSide(
                                color:JPAppTheme.themeColors.dimGray,
                                width: 1,
                              ),
                            )
                        ),
                        child: SingleChildScrollView(
                          physics: widget.disableScrolling ? const NeverScrollableScrollPhysics() : null,
                          controller: rowControllers[rowsIndex],
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: List.generate(widget.noOfColumns,
                              (int columnIndex) => Container(
                                constraints: BoxConstraints(
                                  minHeight: widget.contentHeight,
                                  maxWidth: widget.contentWidth,
                                ),
                                decoration: BoxDecoration(
                                  border: Border(
                                    left: columnIndex == 0
                                      ? BorderSide(
                                          color:JPAppTheme.themeColors.dimGray,
                                          width: 1,
                                        )
                                     : BorderSide.none,
                                    right: BorderSide(
                                      color:JPAppTheme.themeColors.dimGray,
                                      width: 1,
                                    ),
                                  )
                                ),
                                child: widget.contentWidget(rowsIndex, columnIndex),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                } else if (widget.controller.canShowLoadMore) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                        child: FadingCircle(
                            color: JPAppTheme.themeColors.primary,
                            size: 25)
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              }
          ),
        ],
      ),
    );
  }

  void setUpRowControllers(int noOfRowsToAdd) {
    for (int i = 0; i < noOfRowsToAdd; i++) {
      rowControllers.add(linkedController.addAndGet());
    }
  }

  @override
  void didUpdateWidget(covariant JPProgressBoardList oldWidget) {
    if(oldWidget.noOfRows < widget.noOfRows) {
      setUpRowControllers(widget.noOfRows - oldWidget.noOfRows);
    }
    super.didUpdateWidget(oldWidget);
  }
}

