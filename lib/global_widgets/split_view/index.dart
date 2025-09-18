
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/core/constants/common_constants.dart';
import 'package:jobprogress/global_widgets/scaffold/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

/// JPResponsiveSplitView can be used as a wrapper over screens which supports split ui for desktop
class JPResponsiveSplitView extends StatefulWidget {

  const JPResponsiveSplitView({
    super.key,
    required this.list,
    required this.content,
    this.splitter,
    this.contentPlaceholder = const SizedBox(),
    this.contentRouteName,
    this.header = const SizedBox(),
  });

  /// list is used to display list (first view on mobile & left side on desktop)
  final Widget list;

  /// content is used to display selected list item content (second view on mobile & right side on desktop)
  final Widget content;

  /// splitter is used to display separator between split view on desktop
  final Widget? splitter;

  /// contentPlaceholder will be displayed on desktop only when content is empty
  final Widget contentPlaceholder;

  /// contentRouteName helps in nested navigation
  final String? contentRouteName;

  /// header is a common header in desktop mode and in mobile same will be displayed over list
  final Widget header;

  @override
  State<JPResponsiveSplitView> createState() => _JPResponsiveSplitViewState();
}

class _JPResponsiveSplitViewState extends State<JPResponsiveSplitView> {

  String? currentRoute;

  @override
  void initState() {
    currentRoute ??= Get.currentRoute;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        JPResponsiveBuilder(
          desktop: desktop,
          mobile: mobile,
        ),
        floatingClock,
        floatingUploadIndicator,
      ],
    )
    ;
  }

  Widget get desktop => Column(
    children: [
      widget.header,
      Expanded(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 4,
              child: widget.list,
            ),
            widget.splitter ?? IntrinsicHeight(
              child: VerticalDivider(
                thickness: 1,
                width: 1,
                color: JPAppTheme.themeColors.dimGray,
              ),
            ),
            Expanded(
              flex: 7,
              child: navigationContent,
            ),
          ],
        ),
      ),
    ],
  );

  Widget get mobile => navigationContent;

  Widget get listContent => Column(
    children: [
      widget.header,
      Expanded(child: widget.list),
    ],
  );

  Widget get navigationContent => Navigator(
    key: Get.nestedKey(currentRoute),
    initialRoute: currentRoute,
    onDidRemovePage: (_) => false,
    onGenerateRoute: (routeSettings) {
      if(routeSettings.name == widget.contentRouteName) {
        return GetPageRoute(
            fullscreenDialog: JPScreen.isMobile,
            routeName: widget.contentRouteName!,
            page: () => widget.content,
            transition: JPScreen.isDesktop ? Transition.fadeIn : Transition.rightToLeft,
            transitionDuration: const Duration(milliseconds: CommonConstants.transitionDuration),
        );
      }

      return MaterialPageRoute(builder: (_) => JPScreen.isDesktop
          ? widget.contentPlaceholder
          : listContent,
        fullscreenDialog: JPScreen.isMobile
      );
    },
  );
}
