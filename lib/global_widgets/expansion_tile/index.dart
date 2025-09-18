import 'package:flutter/material.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class JPExpansionTile extends StatefulWidget {

  final Widget header;
  final Widget Function(bool isExpanded)? trailing;
  final List<Widget>? children;
  final bool initialCollapsed;
  final double spaceBetweenHeaderAndTrailing;
  final EdgeInsets? headerPadding;
  final EdgeInsets? contentPadding;
  final bool isExpanded;
  final Function(bool val)? onExpansionChanged;
  final double borderRadius;
  final bool disableRotation;
  final bool enableHeaderClick;
  final Color? headerBgColor;
  final bool preserveWidgetOnCollapsed;
  final Color? trailingIconColor;
  final Widget? footer;

  const JPExpansionTile({
    super.key,
    required this.header,
    this.trailing,
    this.children,
    this.initialCollapsed = false,
    this.spaceBetweenHeaderAndTrailing = 2,
    this.headerPadding,
    this.isExpanded = true,
    this.onExpansionChanged,
    this.borderRadius = 0,
    this.contentPadding,
    this.disableRotation = false,
    this.enableHeaderClick = false,
    this.headerBgColor,
    this.preserveWidgetOnCollapsed = false,
    this.trailingIconColor,
    this.footer,
  });

  @override
  State<JPExpansionTile> createState() => _JPExpansionTileState();
}

class _JPExpansionTileState extends State<JPExpansionTile> with TickerProviderStateMixin {

  late AnimationController expandController;
  late AnimationController iconController;

  late bool isExpanded;

  @override
  void initState() {
    isExpanded = !widget.isExpanded;
    prepareAnimations();
    animate();
    super.initState();
  }


  @override
  void didUpdateWidget(JPExpansionTile oldWidget) {

    isExpanded = !widget.isExpanded;
    animate();

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: widget.headerBgColor ?? JPAppTheme.themeColors.base,
      borderRadius: BorderRadius.circular(widget.borderRadius),
      child: Column(
        children: [
          InkWell(
            onTap: widget.enableHeaderClick ? animate : null,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            child: Padding(
              padding: widget.headerPadding ?? const EdgeInsets.only(
                  top: 16,
                  left: 16,
                  bottom: 16,
                  right: 12
              ),
              child: Row(
                children: [
                  Expanded(
                      child: widget.header,
                  ),
                  SizedBox(
                    width: widget.spaceBetweenHeaderAndTrailing,
                  ),

                  if(widget.disableRotation) ...{
                    trailingWidget,
                  } else ...{
                    RotationTransition(
                      turns: iconController.view,
                      child: trailingWidget
                    ),
                  }

                ],
              ),
            ),
          ),
          SizeTransition(
              axisAlignment: 1.0,
              sizeFactor: expandController.view,
              child: Padding(
                padding: widget.contentPadding ?? EdgeInsets.zero,
                child: !isExpanded && !widget.preserveWidgetOnCollapsed ? const SizedBox() : Column(
                  children: widget.children ?? [],
                ),
              )
          ),
          widget.footer ?? const SizedBox(),
        ],
      ),
    );
  }

  void prepareAnimations() {
    expandController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 200),
    );
    iconController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      lowerBound: 0,
      upperBound: 0.5
    );
  }

  void animate() async{
    if(!isExpanded) {
      expandController.forward();
      iconController.forward();
      isExpanded = true;
    } else {
      await expandController.reverse();
      iconController.reverse();
      isExpanded = false;
    }
    if(widget.onExpansionChanged != null) {
      widget.onExpansionChanged!(isExpanded);
    }
    setState(() {});
  }

  Widget get trailingWidget => InkWell(
    borderRadius: BorderRadius.circular(8),
    onTap: animate,
    child: widget.trailing == null ? JPIcon(
      Icons.keyboard_arrow_down_outlined,
      color: widget.trailingIconColor,
    ) : widget.trailing!(iconController.value <= 0.4),
  );

  @override
  void dispose() {
    expandController.dispose();
    iconController.dispose();
    super.dispose();
  }

}
