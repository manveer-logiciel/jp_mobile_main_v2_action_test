import 'package:flutter/material.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class JPListView extends StatefulWidget {
  final int listCount;

  final Future<void> Function()? onRefresh;

  final Future<void> Function()? onLoadMore;

  final Widget Function(BuildContext, int) itemBuilder;

  final bool? disableOnRefresh;
  
  final EdgeInsets? padding;

  final Axis scrollDirection;

  final ScrollPhysics? physics;

  final ScrollController? scrollController;

  final bool shrinkWrap;

  final bool doAddFloatingButtonMargin;

  const JPListView({
    super.key,
    required this.listCount,
    required this.itemBuilder,
    this.onRefresh,
    this.onLoadMore,
    this.disableOnRefresh,
    this.padding = EdgeInsets.zero,
    this.scrollDirection = Axis.vertical,
    this.physics,
    this.scrollController,
    this.shrinkWrap = true,
    this.doAddFloatingButtonMargin = false
  });

  @override
  _JPListViewState createState() => _JPListViewState();
}

class _JPListViewState extends State<JPListView> {
  late final ScrollController infiniteScrollController;

  bool isRefreshing = false;
  bool isLoadingMore = false;

  int count = 0;

  @override
  void initState() {
    infiniteScrollController = widget.scrollController ?? ScrollController();
    super.initState();

    //Listening page scroll to detect is page reached to bottom or not
    //if reached bottom then calling load more function to load next page data in list
    infiniteScrollController.addListener(() async {
      if((infiniteScrollController.position.pixels + JPResponsiveDesign.floatingButtonSize + 50)
        >= infiniteScrollController.position.maxScrollExtent
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
    return Flexible(
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
        child: getListView()
      ) : getListView()
    );
  }

  Widget getListView() {
    return MediaQuery.removeViewPadding(
      context: context,
      removeTop: true,
      child: ListView.builder(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: getListPadding(),
        controller: infiniteScrollController,
        scrollDirection: widget.scrollDirection,
        itemCount: widget.listCount + 1,
        itemBuilder: widget.itemBuilder,
        physics: widget.physics,
        shrinkWrap: widget.shrinkWrap,
      ),
    );
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

  void toggleIsRefreshing() {
    isRefreshing = !isRefreshing;
  }

  void toggleIsLoadingMore() {
    isLoadingMore = !isLoadingMore;
  }
}