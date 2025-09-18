import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class MergeTemplateManagePagesTile extends StatelessWidget {
  const MergeTemplateManagePagesTile({
    super.key,
    required this.index,
    required this.title,
    this.canShowRemoveIcon = true,
    this.onTapRemove,
    this.hideDelete = false,
  });

  /// [index] - is used to display item number
  final int index;

  /// [title] - holds the item title
  final String title;

  /// [canShowRemoveIcon] - decides whether removed will be disabled or not
  final bool canShowRemoveIcon;

  /// [onTapRemove] - handles click on remove button
  final VoidCallback? onTapRemove;

  /// [hideDelete] helps in hiding delete button
  final bool hideDelete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10,),
      child: Row(
        children: [
          ///   Draggable icon
          JPIcon(
            Icons.drag_indicator_outlined,
            color: JPAppTheme.themeColors.dimGray,
          ),
          ///   Item index
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: JPAppTheme.themeColors.lightBlue.withValues(alpha: 0.8)),
            child: Center(
              child: JPText(
                textColor: JPAppTheme.themeColors.primary,
                text: (index + 1).toString(),
              ),
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          ///   Title & Remove Icon
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(top: 5 ,bottom: 7),
              decoration: BoxDecoration(border:Border(bottom: BorderSide(width: 1, color:JPAppTheme.themeColors.dimGray, style: BorderStyle.solid))),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8
                      ),
                      child: JPText(
                        text: title.capitalize!,
                        fontWeight: JPFontWeight.medium,
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),

                  if (!hideDelete)
                    JPTextButton(
                      icon: Icons.remove_circle_outline_outlined,
                      color: JPAppTheme.themeColors.secondary,
                      iconSize: 22,
                      isDisabled: !canShowRemoveIcon,
                      onPressed: canShowRemoveIcon ? onTapRemove : null,
                    ),

                  const SizedBox(
                    width: 15,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
