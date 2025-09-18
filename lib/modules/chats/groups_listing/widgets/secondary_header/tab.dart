import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/firebase.dart';
import 'package:jobprogress/common/models/popover_action.dart';
import 'package:jobprogress/global_widgets/from_firebase/index.dart';
import 'package:jp_mobile_flutter_ui/PopUpMenu/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class ChatsListingSecondaryHeaderTab extends StatelessWidget {
  const ChatsListingSecondaryHeaderTab({
      super.key,
      required this.title,
      this.isSelected = false,
      this.onTap,
      this.keyType,
      this.doShowCount = false,
      this.onTapFilter,
      this.filterList,
      this.realTimeKeyType,
      this.canShowFilterIcon = false,
      this.flex = 1,
      this.isDesktop = false,
      });

  /// title used to display tab title
  final String title;

  /// isSelected helps to differentiate between selected ui and un-selected ui
  final bool isSelected;

  /// onTap handles click on tab item
  final VoidCallback? onTap;

  /// keyType helps in loading fire store stream
  final FireStoreKeyType? keyType;

  /// doShowCount helps to hide/show count, default value is false
  final bool doShowCount;

  /// onTapFilter handled click on filter button
  final Function(String)? onTapFilter;

  /// filterList is the list of filters to be displayed
  final List<PopoverActionModel>? filterList;

  /// realTimeKeyType can be used to read counts from realtime db
  final RealTimeKeyType? realTimeKeyType;

  /// canShowFilterIcon used to show/hide filter icon
  final bool canShowFilterIcon;

  final int flex;

  final bool isDesktop;

  @override
  Widget build(BuildContext context) {

    if(flex == 0) return tab();

    return Expanded(
      flex: flex,
      child: tab(),
    );
  }

  Widget tab() {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (doShowCount) ...{
              Center(
                child: FromFirebase(
                  fireStoreKeyType: keyType,
                  realTimeKeys: realTimeKeyType != null ? [
                    realTimeKeyType!
                  ] : null,
                  placeholder: placeholder,
                  child: (val) {
                    return JPText(
                      text: title + (val == null || val == '0' ? "" : " (${val.toString()})"),
                      textColor: isSelected
                          ? selectedColor
                          : unSelectedColor,
                      fontWeight: JPFontWeight.medium,
                    );
                  },
                ),
              )
            } else ...{
              Center(child: placeholder)
            },
            if (canShowFilterIcon) ...{

              if(onTapFilter == null) ...{
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: JPIcon(Icons.keyboard_arrow_down,
                    color: JPAppTheme.themeColors.dimGray,
                    size: 22,
                  ),
                ),
              } else ...{
                JPPopUpMenuButton<PopoverActionModel>(
                  itemList: filterList!,
                  onTap: onTapFilter != null ? (PopoverActionModel val) {
                    onTapFilter!(val.value);
                  } : null,
                  popUpMenuButtonChild: JPTextButton(
                    icon: Icons.keyboard_arrow_down,
                    color: isSelected ? selectedColor : unSelectedColor,
                    iconSize: 22,
                  ),
                  childPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  offset: const Offset(-50, 30),
                  popUpMenuChild: (PopoverActionModel val) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: JPText(
                            text: val.label.capitalizeFirst!,
                            textAlign: TextAlign.start,
                            textColor: val.isSelected
                                ? JPAppTheme.themeColors.primary
                                : JPAppTheme.themeColors.text,
                          ),
                        ),
                        if(val.isSelected)...{
                          JPIcon(
                            Icons.check,
                            size: 18,
                            color: JPAppTheme.themeColors.primary,
                          ),
                        }
                      ],
                    );
                  },
                ),
              }
            }
          ],
        ),
      ),
    );
  }

  Widget get placeholder => JPText(
        text: title,
        textColor: isSelected
            ? selectedColor
            : unSelectedColor,
      );

  Color get selectedColor => isDesktop
      ? JPAppTheme.themeColors.primary
      : JPAppTheme.themeColors.base;

  Color get unSelectedColor => isDesktop
      ? JPAppTheme.themeColors.text
      : JPAppTheme.themeColors.dimGray;

}
