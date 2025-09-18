import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/modal.dart';
import 'package:jp_mobile_flutter_ui/PopUpMenu/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class JPChipsInputBox<T extends GetxController> extends StatefulWidget {
  const JPChipsInputBox({
    super.key,
    required this.inputBoxController,
    required this.controller,
    required this.selectedItems,
    this.label,
    this.disabled = false,
    this.disableEditing = false,
    this.onDataChanged,
    this.onTap,
    this.onRemove,
    this.validator,
    this.suffixChild,
    this.isRequired = false,
    this.readOnly = true,
  });

  final JPInputBoxController inputBoxController;
  final String? label;
  final List<JPMultiSelectModel> selectedItems;
  final bool disabled;
  final bool disableEditing;
  final T controller;
  final Function(String)? onDataChanged;
  final VoidCallback? onTap;
  final Function(String)? onRemove;
  final FormFieldValidator<dynamic>? validator;
  final Widget? suffixChild;
  final bool? isRequired;
  final bool readOnly;

  @override
  State<JPChipsInputBox<T>> createState() => _JPChipsInputBoxState<T>();
}

class _JPChipsInputBoxState<T extends GetxController> extends State<JPChipsInputBox<T>> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<T>(
        init: widget.controller,
        global: false,
        builder: (context) {
          return JPInputBox(
            inputBoxController: widget.inputBoxController,
            label: widget.label,
            isRequired: widget.isRequired,
            type: JPInputBoxType.withLabel,
            disabled: widget.disabled,
            fillColor: JPAppTheme.themeColors.base,
            readOnly: widget.readOnly,
            chip: (data) {
              final user = data as JPMultiSelectModel;

              return Padding(
                padding: EdgeInsets.only(right: user.label.length < 50 ? 0 : 30),
                child: JPChip(
                  text: user.label,
                  onRemove: widget.disableEditing ? null :  () {
                    removeSelectedUser(user);
                  },
                  child: user.child,
                ),
              );
            },
            moreChipsWidget: widget.selectedItems.length > 5
                ? JPPopUpMenuButton<JPMultiSelectModel>(
                    itemList: widget.selectedItems.sublist(5),
                    popUpMenuButtonChild: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 2, vertical: 2),
                      child: JPText(
                        text: '+${widget.selectedItems.length - 5} ${'more'.tr}',
                        textColor: JPAppTheme.themeColors.primary,
                        fontWeight: JPFontWeight.medium,
                        height: 1.4,
                      ),
                    ),
                    offset: const Offset(0, 30),
                    popUpMenuChild: (user) {
                      return GetBuilder<T>(
                          global: false,
                          init: widget.controller,
                          builder: (popUpController) {
                            return user.isSelect
                                ? Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: IconTheme(
                                      data: IconThemeData(
                                          color: JPAppTheme.themeColors.secondary
                                      ),
                                      child: JPChip(
                                        text: user.label,
                                        onRemove: widget.disableEditing ? null : () {
                                          removeSelectedUser(user,
                                              doPopOnLastItemRemove: true);
                                        },
                                        child: user.child,
                                      ),
                                    ),
                                  )
                                : const SizedBox();
                          });
                    },
                  )
                : null,
            chipsList: widget.selectedItems,
            onChanged: widget.onDataChanged,
            onPressed: widget.disableEditing ? null : widget.onTap,
            validator: widget.validator,
            suffixChild: widget.suffixChild,
          );
        });
  }

  Future<void> removeSelectedUser(JPMultiSelectModel element,
      {bool doPopOnLastItemRemove = false}) async {
    if (doPopOnLastItemRemove) {
      bool isAllPopUpItemsRemoved =
          widget.selectedItems.where((element) => element.isSelect).length <= 6;
      if (isAllPopUpItemsRemoved) {
        Get.back();
        // added duration to avoid pop-up to look empty
        await Future<void>.delayed(const Duration(milliseconds: 200));
      }
      element.isSelect = false;
    } else {
      element.isSelect = false;
    }

    widget.onRemove != null ? widget.onRemove!(element.id.toString()) : (){};

    widget.controller.update();
  }

  @override
  void didUpdateWidget(covariant JPChipsInputBox<T> oldWidget) {
    if (!listEquals(oldWidget.selectedItems, widget.selectedItems)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onDataChanged?.call("");
      });
    }
    super.didUpdateWidget(oldWidget);
  }
}
