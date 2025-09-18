import 'package:flutter/material.dart';

class JPSingleChildScrollView extends StatefulWidget {

  final Future<void> Function()? onRefresh;
  final VoidCallback? onLoadMore;
  final Widget  item;
  final bool isLoading;
  final bool? disableOnRefresh;
  final EdgeInsets? padding;


  const JPSingleChildScrollView({
    super.key,
    required this.item,
    this.onRefresh,
    this.onLoadMore,
    this.isLoading = false,
    this.disableOnRefresh,
    this.padding
  });

  @override
  _JPSingleChildScrollViewState createState() => _JPSingleChildScrollViewState();
}

class _JPSingleChildScrollViewState extends State<JPSingleChildScrollView> {
  final ScrollController infiniteScrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    //Listening page scroll to detect is page reached to bottom or not
    //if reached bottom then calling load more function to load next page data in list
    infiniteScrollController.addListener(() {
      if(infiniteScrollController.position.pixels
        >= infiniteScrollController.position.maxScrollExtent
        && widget.onLoadMore != null
        && !widget.isLoading) {
        widget.onLoadMore!();
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
        onRefresh: widget.onRefresh!,
        notificationPredicate: (scroll){
          return !(widget.disableOnRefresh ?? false);
        },
        child: getSingleChildScrollView()
      ) : getSingleChildScrollView()
    );
  }

  Widget getSingleChildScrollView() {
    return SingleChildScrollView(
      controller:infiniteScrollController ,
      child:widget.item,    
    );
  }
}