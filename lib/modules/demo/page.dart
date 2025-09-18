import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/services/download.dart';
import 'package:jobprogress/common/services/file_attachment/quick_actions.dart';
import 'package:jobprogress/common/services/firebase_crashlytics.dart';
import 'package:jobprogress/core/constants/common_constants.dart';
import 'package:jobprogress/core/constants/launchdarkly/flag_keys.dart';
import 'package:jobprogress/global_widgets/background_location/index.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/index.dart';
import 'package:jobprogress/global_widgets/from_launch_darkly/index.dart';
import 'package:jobprogress/global_widgets/main_drawer/index.dart';
import 'package:jobprogress/global_widgets/scaffold/index.dart';
import 'package:jobprogress/modules/demo/controller.dart';
import 'package:jobprogress/modules/task/create_task/form/index.dart';
import 'package:jp_mobile_flutter_ui/AnimatedSpinKit/fading_circle.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/index.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/modal.dart';
import 'package:jp_mobile_flutter_ui/QuickAction/index.dart';
import 'package:jp_mobile_flutter_ui/QuickEditDialog/position.dart';
import 'package:jp_mobile_flutter_ui/animations/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../routes/pages.dart';

class DemoView extends GetView<DemoController> {
  const DemoView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return JPScaffold(
      appBar: JPHeader(
        title: 'Demo',
        onBackPressed: () {
          Get.back();
        },
        actions: [
          IconButton(
              splashRadius: 20,
              onPressed: () {
                controller.scaffoldKey.currentState!.openEndDrawer();
              },
              icon: const JPIcon(Icons.menu))
        ],
      ),
      scaffoldKey: controller.scaffoldKey,
      endDrawer: JPMainDrawer(
        selectedRoute: 'demo',
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GetBuilder<DemoController>(
              builder: (_) => Column(
                children: [
                  space(),
                  text("Theme"),
                  Row(
                    children: [
                      const JPText(text: 'Change theme'),
                      space(),
                      JPToggle(
                          value: controller.isDarkTheme,
                          onToggle: (value) {
                            controller.isDarkTheme = value;
                            JPAppTheme.setTheme(value);
                            controller.update();
                          }),
                    ],
                  ),
                  space(),
                  text("Button"),
                  space(),
                  JPButton(
                    text: 'Share file',
                    onPressed: () {
                      String url =
                          "https://scdn.jobprog.net/resources%2Fas_1536310277%2Fjobs%2F2202-30016-01%2Fdocuments%2Fjkl%27s1%2F16455367106214e5c6019df_tmp_Screenshot_20220112-021702625987528029927510.png";
                      DownloadService.downloadFile(url, 'test12.png',
                          action: 'share');
                    },
                  ),
                  space(),
                  space(),
                  text('FLAT BUTTONS'),
                  space(),
                  JPButton(
                    text: ("PRIMARY BUTTON"),
                    colorType: JPButtonColorType.primary,
                    onPressed: () {
                      showJPBottomSheet(
                          child: (_) => JPQuickAction(
                                mainList: controller.filterByList1,
                                onItemSelect: (value) {},
                              ),
                          isScrollControlled: true);
                    },
                  ),
                  space(),
                  const JPButton(
                    text: ("PRIMARY BUTTON"),
                    colorType: JPButtonColorType.primary,
                    disabled: true,
                  ),
                  space(),
                  JPButton(
                    colorType: JPButtonColorType.primary,
                    onPressed: () {
                      Get.generalDialog(
                          barrierDismissible: true,
                          barrierLabel: '',
                          transitionDuration: const Duration(milliseconds: 200),
                          transitionBuilder: (context, animation,
                              secondaryAnimation, child) {
                            return Animations.fromBottom(
                                animation, secondaryAnimation, child);
                          },
                          pageBuilder:
                              (animation, secondaryAnimation, child) {
                            return JPQuickEditDialog(
                                label: 'abc',
                                title: 'Heading',
                                position: JPQuickEditDialogPosition.bottom,
                                // suffixTitle: 'Update',
                                prefixTitle: 'CANCEL',
                                fillValue: 'jsahkd',
                                maxLength: 5,
                                onSuffixTap: (value) {});
                          });
                    },
                  ),
                  space(),
                  JPButton(
                    text: ("TERTIARY BUTTON"),
                    colorType: JPButtonColorType.tertiary,
                    onPressed: () {
                      showJPBottomSheet(
                          child: (_) => JPMultiSelect(
                                mainList: controller.filterByMultiList,
                                onDone: (List<JPMultiSelectModel> list) {
                                  controller.filterByMultiList = list;
                                  controller.update();
                                },
                              ),
                          isScrollControlled: true);
                    },
                  ),
                  space(),
                  const JPButton(
                    text: ("TERTIARY BUTTON"),
                    colorType: JPButtonColorType.tertiary,
                    disabled: true,
                  ),
                  space(),
                  JPButton(
                    colorType: JPButtonColorType.tertiary,
                    onPressed: () {
                      controller.a();
                    },
                  ),
                  GestureDetector(
                    onTapDown: (TapDownDetails details) {
                      showPopover(context, details.globalPosition,
                          width: MediaQuery.of(context).size.width - 20,
                          height: 150,
                          child: Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.lightBlue),
                          ));
                    },
                    child: JPButton(
                      text: "BUTTON",
                      size: JPButtonSize.medium,
                      colorType: JPButtonColorType.lightGray,
                      onPressed: () {},
                    ),
                  ),
                  space(),
                  JPButton(
                    text: ("GRAY BUTTON"),
                    colorType: JPButtonColorType.lightGray,
                    onPressed: () {
                      showModalBottomSheet<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                              color: Colors.amber,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    const Text('Modal BottomSheet'),
                                    ElevatedButton(
                                      child: const Text('Close BottomSheet'),
                                      onPressed: () => Navigator.pop(context),
                                    )
                                  ],
                                ),
                              ),
                            );
                          });
                    },
                  ),
                  space(),
                  const JPButton(
                    text: ("GRAY BUTTON"),
                    colorType: JPButtonColorType.lightGray,
                    disabled: true,
                  ),
                  space(),
                  JPButton(
                    colorType: JPButtonColorType.lightGray,
                    onPressed: () {
                      controller.conformationStatus();
                    },
                  ),
                  space(),
                  space(),
                  text('LARGE BUTTONS'),
                  space(),
                  JPButton(
                    text: "BUTTON",
                    size: JPButtonSize.large,
                    onPressed: () {
                      Get.generalDialog(
                          barrierDismissible: true,
                          barrierLabel: '',
                          transitionDuration: const Duration(milliseconds: 200),
                          transitionBuilder: (context, animation,
                              secondaryAnimation, child) {
                            return Animations.fromBottom(
                                animation, secondaryAnimation, child);
                          },
                          pageBuilder:
                              (animation, secondaryAnimation, child) {
                            return JPQuickEditDialog(
                                label: 'abc',
                                title: 'Heading',
                                position: JPQuickEditDialogPosition.bottom,
                                // suffixTitle: 'Update',
                                prefixTitle: 'CANCEL',
                                fillValue: 'jsahkd',
                                maxLength: 5,
                                onSuffixTap: (value) {});
                          });
                    },
                  ),
                  space(),
                  const JPButton(
                    text: "BUTTON",
                    size: JPButtonSize.large,
                    disabled: true,
                  ),
                  space(),
                  const JPButton(
                      text: "BUTTON",
                      size: JPButtonSize.large,
                      colorType: JPButtonColorType.tertiary,
                      disabled: true),
                  space(),
                  JPButton(
                    text: "BUTTON",
                    size: JPButtonSize.large,
                    colorType: JPButtonColorType.tertiary,
                    onPressed: () {},
                  ),
                  space(),
                  JPButton(
                    text: "BUTTON",
                    size: JPButtonSize.large,
                    colorType: JPButtonColorType.lightGray,
                    onPressed: () {},
                  ),
                  space(),
                  const JPButton(
                    text: "BUTTON",
                    size: JPButtonSize.large,
                    colorType: JPButtonColorType.lightGray,
                    disabled: true,
                  ),
                  space(),
                  space(),
                  text('MEDIUM BUTTONS'),
                  space(),
                  JPButton(
                    text: "BUTTON",
                    size: JPButtonSize.medium,
                    onPressed: () {},
                  ),
                  space(),
                  const JPButton(
                    text: "BUTTON",
                    size: JPButtonSize.medium,
                    disabled: true,
                  ),
                  space(),
                  const JPButton(
                      text: "BUTTON",
                      size: JPButtonSize.medium,
                      colorType: JPButtonColorType.tertiary,
                      disabled: true),
                  space(),
                  JPButton(
                    text: "BUTTON",
                    size: JPButtonSize.medium,
                    colorType: JPButtonColorType.tertiary,
                    onPressed: () {},
                  ),
                  space(),
                  JPButton(
                    text: "BUTTON",
                    size: JPButtonSize.medium,
                    colorType: JPButtonColorType.lightGray,
                    onPressed: () {},
                  ),
                  space(),
                  const JPButton(
                    text: "BUTTON",
                    size: JPButtonSize.medium,
                    colorType: JPButtonColorType.lightGray,
                    disabled: true,
                  ),
                  space(),
                  space(),
                  text(' SMALL BUTTONS'),
                  space(),
                  Wrap(
                    spacing: 20,
                    runSpacing: 20,
                    children: [
                      Column(
                        children: [
                          JPButton(
                            text: 'ADD',
                            size: JPButtonSize.small,
                            onPressed: () {},
                          ),
                          space(),
                          const JPButton(
                            text: 'ADD',
                            size: JPButtonSize.small,
                            disabled: true,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          JPButton(
                            text: 'BUTTON ',
                            size: JPButtonSize.small,
                            colorType: JPButtonColorType.tertiary,
                            onPressed: () {},
                          ),
                          space(),
                          const JPButton(
                            text: 'ADD',
                            size: JPButtonSize.small,
                            colorType: JPButtonColorType.tertiary,
                            disabled: true,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          JPButton(
                            text: 'ADD',
                            size: JPButtonSize.small,
                            colorType: JPButtonColorType.lightGray,
                            onPressed: () {},
                          ),
                          space(),
                          const JPButton(
                            text: 'ADD',
                            size: JPButtonSize.small,
                            colorType: JPButtonColorType.lightGray,
                            disabled: true,
                          ),
                        ],
                      ),
                    ],
                  ),
                  space(),
                  space(),
                  text(' OUTLINE BUTTONS'),
                  space(),
                  JPButton(
                    text: 'ADD',
                    type: JPButtonType.outline,
                    size: JPButtonSize.small,
                    onPressed: () {},
                  ),
                  space(),
                  const JPButton(
                    text: 'ADD',
                    type: JPButtonType.outline,
                    size: JPButtonSize.small,
                    disabled: true,
                  ),
                  space(),
                  text(' LOAD MORE BUTTONS'),
                  space(),
                  JPButton(
                    text: "LOAD MORE",
                    size: JPButtonSize.mediumWithIcon,
                    iconWidget:
                        const FadingCircle(color: JPColor.white, size: 20),
                    onPressed: () {},
                  ),
                  space(),
                  space(),
                  text('ICON BUTTON'),
                  space(),
                  JPButton(
                    onPressed: () {},
                  ),
                  space(),
                  JPButton(
                    size: JPButtonSize.mediumWithIcon,
                    onPressed: () {},
                  ),
                  space(),
                  text('SMALL ICON BUTTON'),
                  space(),
                  text('Pending because svg is not implemented'),
                  space(),
                  space(),
                  text('TEXT'),
                  space(),
                  text('DEFAULT TEXT'),
                  space(),
                  const JPText(text: " ROBOTO/ REGULAR/ 14px"),
                  space(),
                  space(),
                  text("MONTSERRAT / REGULAR /SIZE "),
                  space(),
                  const JPText(
                    text: "MONTSERRAT/ REGULAR/ 16px ",
                    fontFamily: JPFontFamily.montserrat,
                    fontWeight: JPFontWeight.regular,
                    textSize: JPTextSize.heading3,
                  ),
                  const JPText(
                    text: "MONTSERRAT/ REGULAR/ 14px ",
                    fontFamily: JPFontFamily.montserrat,
                    fontWeight: JPFontWeight.regular,
                    textSize: JPTextSize.heading4,
                  ),
                  const JPText(
                    text: "MONTSERRAT/ REGULAR/ 12x ",
                    fontFamily: JPFontFamily.montserrat,
                    fontWeight: JPFontWeight.regular,
                    textSize: JPTextSize.heading5,
                  ),
                  const JPText(
                    text: "MONTSERRAT/ REGULAR/ 11x ",
                    fontFamily: JPFontFamily.montserrat,
                    fontWeight: JPFontWeight.regular,
                    textSize: JPTextSize.heading6,
                  ),
                  space(),
                  space(),
                  text("MONTSERRAT / MEDIUM /SIZE "),
                  space(),
                  const JPText(
                    text: "MONTSERRAT/ MEDIUM/ 16px ",
                    fontFamily: JPFontFamily.montserrat,
                    fontWeight: JPFontWeight.medium,
                    textSize: JPTextSize.heading3,
                  ),
                  const JPText(
                    text: "MONTSERRAT/ MEDIUM/ 14px ",
                    fontFamily: JPFontFamily.montserrat,
                    fontWeight: JPFontWeight.medium,
                    textSize: JPTextSize.heading4,
                  ),
                  const JPText(
                    text: "MONTSERRAT/ MEDIUM/ 12x ",
                    fontFamily: JPFontFamily.montserrat,
                    fontWeight: JPFontWeight.medium,
                    textSize: JPTextSize.heading5,
                  ),
                  const JPText(
                    text: "MONTSERRAT/ MEDIUM/ 11x ",
                    fontFamily: JPFontFamily.montserrat,
                    fontWeight: JPFontWeight.medium,
                    textSize: JPTextSize.heading6,
                  ),
                  space(),
                  space(),
                  text("ROBOTO / REGULAR /SIZE "),
                  space(),
                  const JPText(
                    text: "ROBOTO / REGULAR/ 20px ",
                    fontFamily: JPFontFamily.roboto,
                    fontWeight: JPFontWeight.regular,
                    textSize: JPTextSize.heading1,
                  ),
                  const JPText(
                    text: "ROBOTO / REGULAR/ 18px ",
                    fontFamily: JPFontFamily.roboto,
                    fontWeight: JPFontWeight.regular,
                    textSize: JPTextSize.heading2,
                  ),
                  const JPText(
                    text: "ROBOTO / REGULAR/ 16px ",
                    fontFamily: JPFontFamily.roboto,
                    fontWeight: JPFontWeight.regular,
                    textSize: JPTextSize.heading3,
                  ),
                  const JPText(
                    text: "ROBOTO / REGULAR/ 14px ",
                    fontFamily: JPFontFamily.roboto,
                    fontWeight: JPFontWeight.regular,
                    textSize: JPTextSize.heading4,
                  ),
                  const JPText(
                    text: "ROBOTO / REGULAR/ 12x ",
                    fontFamily: JPFontFamily.roboto,
                    fontWeight: JPFontWeight.regular,
                    textSize: JPTextSize.heading5,
                  ),
                  const JPText(
                    text: "ROBOTO / REGULAR/ 11x ",
                    fontFamily: JPFontFamily.roboto,
                    fontWeight: JPFontWeight.regular,
                    textSize: JPTextSize.heading6,
                  ),
                  space(),
                  space(),
                  text("ROBOTO / MEDIUM /SIZE "),
                  space(),
                  const JPText(
                    text: "ROBOTO / MEDIUM/ 20px ",
                    fontFamily: JPFontFamily.roboto,
                    fontWeight: JPFontWeight.medium,
                    textSize: JPTextSize.heading1,
                  ),
                  const JPText(
                    text: "ROBOTO / MEDIUM/ 18px ",
                    fontFamily: JPFontFamily.roboto,
                    fontWeight: JPFontWeight.medium,
                    textSize: JPTextSize.heading2,
                  ),
                  const JPText(
                    text: "ROBOTO / MEDIUM/ 16px ",
                    fontFamily: JPFontFamily.roboto,
                    fontWeight: JPFontWeight.medium,
                    textSize: JPTextSize.heading3,
                  ),
                  const JPText(
                    text: "ROBOTO / MEDIUM/ 14px ",
                    fontFamily: JPFontFamily.roboto,
                    fontWeight: JPFontWeight.medium,
                    textSize: JPTextSize.heading4,
                  ),
                  const JPText(
                    text: "ROBOTO / MEDIUM/ 12x ",
                    fontFamily: JPFontFamily.roboto,
                    fontWeight: JPFontWeight.medium,
                    textSize: JPTextSize.heading5,
                  ),
                  const JPText(
                    text: "ROBOTO / MEDIUM/ 11x ",
                    fontFamily: JPFontFamily.roboto,
                    fontWeight: JPFontWeight.medium,
                    textSize: JPTextSize.heading6,
                  ),
                  space(),
                  space(),
                  text("ROBOTO / BOLD /SIZE "),
                  space(),
                  const JPText(
                    text: "ROBOTO / BOLD/ 20px ",
                    fontFamily: JPFontFamily.roboto,
                    fontWeight: JPFontWeight.bold,
                    textSize: JPTextSize.heading1,
                  ),
                  const JPText(
                    text: "ROBOTO /BOLD/ 18px ",
                    fontFamily: JPFontFamily.roboto,
                    fontWeight: JPFontWeight.bold,
                    textSize: JPTextSize.heading2,
                  ),
                  const JPText(
                    text: "ROBOTO / BOLD/ 16px ",
                    fontFamily: JPFontFamily.roboto,
                    fontWeight: JPFontWeight.bold,
                    textSize: JPTextSize.heading3,
                  ),
                  const JPText(
                    text: "ROBOTO / BOLD/ 14px ",
                    fontFamily: JPFontFamily.roboto,
                    fontWeight: JPFontWeight.bold,
                    textSize: JPTextSize.heading4,
                  ),
                  const JPText(
                    text: "ROBOTO / BOLD/ 12x ",
                    fontFamily: JPFontFamily.roboto,
                    fontWeight: JPFontWeight.bold,
                    textSize: JPTextSize.heading5,
                  ),
                  const JPText(
                    text: "ROBOTO / BOLD/ 11x ",
                    fontFamily: JPFontFamily.roboto,
                    fontWeight: JPFontWeight.bold,
                    textSize: JPTextSize.heading6,
                  ),
                  space(),
                  space(),
                  text('BADGE'),
                  space(),
                  Row(
                    children: [
                      const JPBadge(
                        text: "2",
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      JPBadge(
                        backgroundColor: JPAppTheme.themeColors.tertiary,
                        text: "2",
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      JPBadge(
                        backgroundColor: JPAppTheme.themeColors.secondary,
                        text: "2",
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      JPBadge(
                        backgroundColor: JPAppTheme.themeColors.dimGray,
                        text: "2",
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const JPBadge(
                        text: "12",
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const JPBadge(
                        text: "123",
                      ),
                    ],
                  ),
                  space(),
                  text('CHIP'),
                  space(),
                  const JPChip(),
                  const SizedBox(
                    height: 20,
                  ),
                  JPChip(
                    onRemove: () {},
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  JPChip(
                    onRemove: () {},
                    child: JPIcon(
                      Icons.person,
                      size: 20,
                      color: JPAppTheme.themeColors.dimGray,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  JPChip(
                    child: JPIcon(
                      Icons.person,
                      size: 20,
                      color: JPAppTheme.themeColors.dimGray,
                    ),
                  ),
                  space(),
                  JPChip(
                    onRemove: () {},
                    text: 'Chip Name',
                    child: Image.network('https://picsum.photos/250?image=9'),
                  ),
                  space(),
                  JPChip(
                    onRemove: () {},
                    text: 'Chip Name',
                    child: Image.network('https://picsum.photos/250?image=9'),
                  ),
                  space(),
                  JPChip(
                    onRemove: () {},
                    text: 'Chip Name Chip Name',
                    child: Image.network('https://picsum.photos/250?image=9'),
                  ),
                  space(),
                  const JPChip(
                    text: 'Chip Name Chip Name',
                  ),
                  space(),
                  text('LABEL'),
                  space(),
                  const Row(
                    children: [
                      JPLabel(),
                      SizedBox(
                        width: 10,
                      ),
                      JPLabel(
                        text: 'Label',
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      JPLabel(
                        text: 'Label',
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      JPLabel(
                        text: 'Label',
                      ),
                      SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                  space(),
                  text('CHECKBOX'),
                  space(),
                  Row(
                    children: [
                      JPCheckbox(
                        text: 'Clicked',
                        selected: controller.isSelected,
                        onTap: (value) {
                          controller.checkMethod(value);
                        },
                      ),
                      space(),
                      JPCheckbox(
                        text: 'Clicked',
                        selected: controller.isSelected1,
                        onTap: (value) {
                          controller.checkMethod1(value);
                        },
                      ),
                      space(),
                      JPCheckbox(
                        disabled: true,
                        text: 'Clicked',
                        selected: controller.isSelected2,
                        onTap: (value) {
                          controller.checkMethod2(value);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  text('TOGGLE'),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      JPToggle(
                          onToggle: (value) => {controller.updateToggle(value)},
                          value: controller.toggle),
                      const SizedBox(
                        width: 10,
                      ),
                      JPToggle(
                          disabled: true,
                          onToggle: (value) =>
                              {controller.updateToggle1(value)},
                          value: controller.toggle1),
                      const SizedBox(
                        width: 10,
                      ),
                      JPToggle(
                          disabled: true,
                          onToggle: (value) =>
                              {controller.updateToggle2(value)},
                          value: controller.toggle2),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  text('RADIO BOX'),
                  const SizedBox(
                    height: 20,
                  ),
                  JPRadioBox(
                    orientation: JPOrientation.vertical,
                    groupValue: controller.groupValue,
                    radioData: controller.data,
                    onChanged: (value) {
                      controller.radioMethod(value);
                    },
                  ),
                  space(),
                  text('AVATAR'),
                  Wrap(
                    children: [
                      const JPAvatar(),
                      const SizedBox(
                        width: 10,
                      ),
                      JPAvatar(
                        size: JPAvatarSize.large,
                        backgroundColor: JPAppTheme.themeColors.warning,
                        child: JPText(
                            text: "AM", textColor: JPAppTheme.themeColors.base),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      JPAvatar(
                        size: JPAvatarSize.large,
                        borderColor: JPAppTheme.themeColors.dimGray,
                        borderWidth: 1,
                        child:
                            Image.network('https://picsum.photos/250?image=9'),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      JPAvatar(
                        size: JPAvatarSize.medium,
                        child:
                            Image.network('https://picsum.photos/250?image=9'),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      JPAvatar(
                        size: JPAvatarSize.medium,
                        borderColor: JPAppTheme.themeColors.dimGray,
                        borderWidth: 1,
                        child:
                            Image.network('https://picsum.photos/250?image=9'),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      JPAvatar(
                        size: JPAvatarSize.small,
                        child:
                            Image.network('https://picsum.photos/250?image=9'),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      JPAvatar(
                        size: JPAvatarSize.small,
                        borderColor: JPAppTheme.themeColors.dimGray,
                        borderWidth: 1,
                        child:
                            Image.network('https://picsum.photos/250?image=9'),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  text('INPUT BOX'),
                  space(),
                  space(),
                  Column(
                    children: [
                      /* Form(
                        key: controller.globalKey,
                        child: JPInputBox(
                          label: "Email",
                          controller: controller.textEditingController,
                          hintText: 'Enter email',
                          obscureText: true,
                          maxLength: 10,
                          onSaved: (value) {
                            controller.controller = value;
                          },
                          validator: (value) {
                            return controller.validate(value);
                          },
                        ),
                      ),*/
                      space(),
                      JPButton(
                        text: 'Click',
                        size: JPButtonSize.small,
                        onPressed: () {
                          controller.onSave();
                        },
                      ),
                      space(),
                      text('SINGLE SELECT BOX'),
                      space(),
                      Form(
                        key: controller.globalKey1,
                        child: JPInputBox(
                          controller: controller.textEditingController1,
                          label: 'abc',
                          type: JPInputBoxType.searchbar,
                          hintText: 'abc',
                          onSaved: (value) {
                            controller.controller1 = value!;
                          },
                          validator: (value) {
                            return controller.validate(value!);
                          },
                          suffixChild: IconButton(
                            splashRadius: 15,
                            onPressed: () {},
                            icon: JPIcon(
                              Icons.keyboard_arrow_down,
                              color: JPAppTheme.themeColors.dimGray,
                            ),
                          ),
                        ),
                      ),
                      Form(
                        key: controller.globalKey2,
                        child: JPInputBox(
                          controller: controller.textEditingController1,
                          //  canShowLabel: false,
                          //  isSearchBar: true,
                          disabled: true,
                          label: 'abc',
                          hintText: 'abc',
                          onSaved: (value) {
                            controller.controller1 = value!;
                          },
                          validator: (value) {
                            return controller.validate(value!);
                          },
                          suffixChild: IconButton(
                            splashRadius: 15,
                            onPressed: () {},
                            icon: JPIcon(
                              Icons.keyboard_arrow_down,
                              color: JPAppTheme.themeColors.dimGray,
                            ),
                          ),
                        ),
                      ),
                      space(),
                      JPButton(
                        text: 'Click',
                        size: JPButtonSize.small,
                        onPressed: () {
                          controller.onSave1();
                        },
                      ),
                      space(),
                      text(' SELECT BOX With ICON AND TEXT'),
                      space(),
                      JPInputBox(
                        label: 'abc',
                        suffixChild: IconButton(
                          splashRadius: 15,
                          onPressed: () {},
                          icon: JPIcon(
                            Icons.person_add_alt_rounded,
                            color: JPAppTheme.themeColors.primary,
                          ),
                        ),
                      ),
                      space(),
                      text('FIREBASE CRASHLYTICS'),
                      space(),
                      JPButton(
                        text: 'Crash App',
                        size: JPButtonSize.small,
                        onPressed: () {
                          Crashlytics.crashApp();
                        },
                      ),
                      space(),
                      JPButton(
                        text: 'Non fatal Error',
                        size: JPButtonSize.small,
                        onPressed: () {
                          Crashlytics.throwNonFatalError();
                        },
                      ),
                      space(),
                      JPButton(
                        text: 'Fatal Error',
                        size: JPButtonSize.small,
                        onPressed: () {
                          Crashlytics.throwFatalError();
                        },
                      ),
                      space(),
                      JPButton(
                        text: 'Attach Sheet',
                        size: JPButtonSize.small,
                        onPressed: () {
                          FileAttachService.openQuickActions(
                              maxSize: CommonConstants.maxAllowedFileSize,
                              jobId: 16272,
                              onFilesSelected: (files, {int? jobId}) {
                                debugPrint('ATTACHED FILES : $files');
                              });
                        },
                      ),
                      space(),
                      JPButton(
                        text: 'Switch Confirmation Dialog',
                        size: JPButtonSize.small,
                        onPressed: () {
                          showJPBottomSheet(child: (controller) {
                            return JPConfirmationDialogWithSwitch(
                              title: 'confirmation'.tr,
                              subTitle:
                                  'You are about to move this job to Estimate stage. Click Yes to confirm',
                              toggleTitle: 'Sales Automation',
                              toggleValue: controller.switchValue,
                            );
                          });
                        },
                      ),
                    ],
                  ),
                  space(),
                  space(),
                  JPButton(
                    text: "Network Multi-Select".toUpperCase(),
                    colorType: JPButtonColorType.secondary,
                    size: JPButtonSize.small,
                    onPressed: () {
                      controller.showNetworkMultiSelect();
                    },
                  ),
                  space(),
                  space(),
                  JPButton(
                    text: "Create Task bottom sheet".toUpperCase(),
                    colorType: JPButtonColorType.secondary,
                    size: JPButtonSize.small,
                    onPressed: () {
                      showJPBottomSheet(
                        child: (_) => const CreateTaskForm(),
                        isScrollControlled: true,
                        ignoreSafeArea: false,
                      );
                    },
                  ),
                  space(),
                  space(),
                  JPButton(
                    text: "map section".toUpperCase(),
                    colorType: JPButtonColorType.primary,
                    size: JPButtonSize.small,
                    onPressed: () {
                      Get.toNamed(Routes.mapSection);
                    },
                  ),
                  space(),
                  space(),
                  JPButton(
                    text: "search location".toUpperCase(),
                    colorType: JPButtonColorType.primary,
                    size: JPButtonSize.small,
                    onPressed: controller.navigateToSearchLocation,
                  ),
                  space(),
                  JPButton(
                    text: "Network Single-Select".toUpperCase(),
                    colorType: JPButtonColorType.secondary,
                    size: JPButtonSize.small,
                    onPressed: () {
                      controller.showNetworkSingleSelect();
                    },
                  ),
                  space(),
                  JPButton(
                    text: "Form Proposal Template".toUpperCase(),
                    colorType: JPButtonColorType.secondary,
                    size: JPButtonSize.small,
                    onPressed: controller.navigateToFormProposalTemplate,
                  ),
                  space(),
                  JPBackgroundLocationListener(
                      child: (locationController) {
                        return Column(
                          children: [
                            JPText(text: 'isActive: ${locationController.isServiceRunning}', fontWeight: JPFontWeight.medium),
                            JPText(text: 'Time: ${locationController.formattedLastTrackedTime}'),
                            JPText(text: 'Address: ${locationController.lastTrackedAddress}'),
                            JPText(text: 'doShowLiveTracking: ${locationController.doShowUserLiveTacking}'),
                            JPText(text: 'doShowLastTracking: ${locationController.doShowLastTracking}'),
                            space(),
                            JPButton(
                              text: "${locationController.isServiceRunning ? 'Stop' : 'Start'} - Bg location".toUpperCase(),
                              colorType: locationController.isServiceRunning ? JPButtonColorType.primary : JPButtonColorType.secondary,
                              size: JPButtonSize.small,
                              onPressed: controller.startStopBgTrackingService,
                            ),
                          ],
                        );
                      },
                  ),
                  space(),
                  text('LAUNCHDARKLY'),
                  space(),
                  FromLaunchDarkly(
                    flagKey: LDFlagKeyConstants.testStaffCalendar,
                    child: (_) => JPButton(
                      text: 'LD Show/Hide Button'.toUpperCase(),
                      size: JPButtonSize.small,
                    ),
                  ),
                  space(),
                  FromLaunchDarkly(
                    flagKey: LDFlagKeyConstants.testStaffCalendarButtonText,
                    showHideOnly: false,
                    child: (data) => JPText(
                      text: 'Dynamic Text from LD: ${data.value}',
                    ),
                  ),
                  space(),
                  FromLaunchDarkly(
                    flagKey: LDFlagKeyConstants.transactionalMessaging,
                    showHideOnly: false,
                    child: (_) => JPButton(
                      text: 'LD Show/Hide transactional-messaging Button'.toUpperCase(),
                      size: JPButtonSize.small,
                    ),
                  ),
                  space(),
                  JPButton(
                    text: 'LD Logic Enable/Disable'.toUpperCase(),
                    onPressed: controller.handleLDLogic,
                    size: JPButtonSize.small,
                  ),
                  space(),
                  JPButton(
                    text: 'Transition Message Consents'.toUpperCase(),
                    onPressed: controller.transitionMessaging,
                    size: JPButtonSize.small,
                  ),
                  space(),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget space() => const SizedBox(
        height: 20,
        width: 20,
      );

  Widget text(String text1) => Align(
        alignment: Alignment.topLeft,
        child: Container(
          padding: const EdgeInsets.only(
            bottom: 5, // Space between underline and text
          ),
          decoration: const BoxDecoration(
              border: Border(
                  bottom: BorderSide(
            color: Colors.black,
            width: 1.0, // Underline thickness
          ))),
          child: JPText(
            text: text1,
            textSize: JPTextSize.heading2,
            fontWeight: JPFontWeight.bold,
            maxLine: 2,
          ),
        ),
      );
}
