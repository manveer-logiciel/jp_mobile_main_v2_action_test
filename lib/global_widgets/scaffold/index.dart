import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/global_widgets/floating_clock/index.dart';
import 'package:jobprogress/global_widgets/upload_indicator/index.dart';
import 'package:jobprogress/routes/pages.dart';
import 'package:jobprogress/common/services/launch_darkly/index.dart';
import 'package:jobprogress/core/constants/launchdarkly/flag_keys.dart';

class JPScaffold extends StatelessWidget {
  const JPScaffold({
    Key? widgetKey,
    this.scaffoldKey,
    required this.body,
    this.appBar,
    this.floatingActionButton,
    this.backgroundColor,
    this.resizeToAvoidBottomInset,
    this.endDrawer,
    this.backgroundWidget,
    this.drawer,
  }) : super(key: widgetKey);

  final Widget body;

  final PreferredSizeWidget? appBar;

  final Widget? floatingActionButton;

  final Color? backgroundColor;

  final bool? resizeToAvoidBottomInset;

  final Widget? endDrawer;

  final Widget? drawer;

  final GlobalKey<ScaffoldState>? scaffoldKey;

  final Widget? backgroundWidget;

  bool get shouldEnableSelection => LDService.hasFeatureEnabled(LDFlagKeyConstants.allowTextSelection);

  @override
  Widget build(BuildContext context) {
    final Widget scaffoldContent = Scaffold(
      key: scaffoldKey,
      endDrawer: endDrawer,
      drawer: drawer,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      body: Stack(
        children: [
          Scaffold(
            appBar: appBar,
            backgroundColor: backgroundColor,
            body: body,
            floatingActionButton: floatingActionButton,
            resizeToAvoidBottomInset: resizeToAvoidBottomInset,
          ),
          if (Get.currentRoute != Routes.email && Get.currentRoute != '/EmailListingView' && Get.currentRoute != Routes.chatsListing) ...{
            floatingClock,
            floatingUploadIndicator,
          }
        ],
      ),
    );

    if (shouldEnableSelection) {
      return SelectionArea(child: scaffoldContent);
    } else {
      return scaffoldContent;
    }
  }
}


const Widget floatingClock = FloatingClock();
const Widget floatingUploadIndicator = UploadIndicator();

