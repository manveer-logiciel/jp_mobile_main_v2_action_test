import 'package:flutter/material.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class JPGridView extends StatefulWidget {
  final int listCount;

  final Future<void> Function()? onRefresh;

  final Future<void> Function()? onLoadMore;

  final Widget Function(BuildContext, int) itemBuilder;

  final bool isLoading;

  final SliverGridDelegate gridDelegate;

  final EdgeInsets? padding;

  final bool? disableOnRefresh;

  final bool doAddFloatingButtonMargin;

  final ScrollPhysics? physics;

  const JPGridView({
    super.key,
    required this.listCount,
    required this.itemBuilder,
    required this.gridDelegate,
    this.onRefresh,
    this.onLoadMore,
    this.isLoading = false,
    this.padding,
    this.disableOnRefresh = false,
    this.doAddFloatingButtonMargin = false,
    this.physics
  });

  @override
  _JPGridViewState createState() => _JPGridViewState();
}

class _JPGridViewState extends State<JPGridView> {

  final ScrollController infiniteScrollController = ScrollController();

  bool isRefreshing = false;
  bool isLoadingMore = false;

  @override
  void initState() {
    super.initState();

    //Listening page scroll to detect is page reached to bottom or not
    //if reached bottom then calling load more function to load next page data in list
    infiniteScrollController.addListener(() async {
      final gridDelegateWithMaxCrossAxisExtent = widget.gridDelegate as SliverGridDelegateWithMaxCrossAxisExtent;
      final double maxCrossAxisExtent = gridDelegateWithMaxCrossAxisExtent.maxCrossAxisExtent;
      final double crossAxisSpacing = gridDelegateWithMaxCrossAxisExtent.crossAxisSpacing;

      if(infiniteScrollController.position.pixels
          >= infiniteScrollController.position.maxScrollExtent
              - (maxCrossAxisExtent + crossAxisSpacing)
          && widget.onLoadMore != null
          && !isLoadingMore
          && !isRefreshing) {

        toggleIsLoadingMore();
        await widget.onLoadMore!();
        toggleIsLoadingMore();
      }
    });
  }

  @override
  void dispose() {
    infiniteScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: widget.onRefresh != null ?  RefreshIndicator(
            onRefresh: () async {
              if(isLoadingMore) return;
              toggleIsRefreshing();
              await widget.onRefresh!();
              toggleIsRefreshing();
            },
            notificationPredicate: (scroll){
              return isLoadingMore
                  ? false
                  : !(widget.disableOnRefresh ?? false);
            },
            child: getGridView()
        ) : getGridView()
    );
  }

  Widget getGridView() {
    return (
        GridView.builder(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          shrinkWrap: true,
          physics: widget.physics,
          padding: getListPadding(),
          gridDelegate: widget.gridDelegate,
            controller: infiniteScrollController,
            itemCount: widget.listCount + (widget.onLoadMore != null ? 2 : 0),
            itemBuilder: widget.itemBuilder
        )
    );
  }

  void toggleIsRefreshing() {
    isRefreshing = !isRefreshing;
  }

  void toggleIsLoadingMore() {
    isLoadingMore = !isLoadingMore;
  }

  EdgeInsets? getListPadding() {
    if(!widget.doAddFloatingButtonMargin) {
      return widget.padding;
    } else if(widget.padding != null) {
      return widget.padding?.copyWith(
          bottom: JPResponsiveDesign.floatingButtonSize
      );
    } else {
      return JPResponsiveDesign.floatingButtonPadding;
    }
  }

}