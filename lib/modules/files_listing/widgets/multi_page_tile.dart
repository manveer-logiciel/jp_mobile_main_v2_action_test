
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_model.dart';
import 'package:jobprogress/common/models/templates/form_proposal/template.dart';
import 'package:jobprogress/core/constants/templates.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class FilesMultiPageTile extends StatelessWidget {
  const FilesMultiPageTile({
    super.key,
    required this.data,
    this.onTap,
    this.onLongPress,
    this.onTapExpand,
    this.onTapTemplate
  });

  final FilesListingModel data;

  final VoidCallback? onTap;

  final VoidCallback? onLongPress;

  final VoidCallback? onTapExpand;

  final Function(int)? onTapTemplate;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          child: Padding(
            padding: const EdgeInsets.only(
                left: 16,
                right: 12
            ),
            child: Column(
              children: [
                const SizedBox(
                  height: 16,
                ),
                Row(
                  children: [
                    JPAddRemoveButton(
                      isAddBtn: !data.showSubPages!,
                      iconSize: 18,
                      onTap: onTapExpand,
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          JPText(
                            text: data.groupName ?? "",
                            textSize: JPTextSize.heading4,
                            fontWeight: JPFontWeight.regular,
                            textAlign: TextAlign.start,
                            maxLine: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          getSubtitle(),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    JPCheckbox(
                      selected: data.isSelected,
                      onTap: (val) {
                        onTap?.call();
                      },
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
              ],
            ),
          ),
        ),

        if ((data.proposalTemplatePages?.isNotEmpty ?? false) && data.showSubPages!)
          ListView.separated(
            shrinkWrap: true,
            primary: false,
            itemCount: data.proposalTemplatePages?.length ?? 0,
            itemBuilder: (_, index) {
              final template = data.proposalTemplatePages![index];
              return getSubTile(index, template);
            },
            separatorBuilder: (_, index) {
              return Divider(
                indent: 60,
                height: 1,
                color: JPAppTheme.themeColors.secondaryText,
              );
            },
        ),

        Divider(
          indent: 60,
          height: 1,
          color: JPAppTheme.themeColors.secondaryText,
        ),
      ],
    );
  }

  Widget getSubtitle() {
    String pageSymbol = data.pageType == TemplateConstants.legalPage ? "L" : "S";
    int totalPages = (data.totalPages ?? 0);
    return JPText(
      text: "($pageSymbol) - $totalPages ${totalPages > 1 ? 'pages'.tr : 'page'.tr}",
      textSize: JPTextSize.heading5,
      fontWeight: JPFontWeight.regular,
      textAlign: TextAlign.start,
      maxLine: 1,
      textColor: JPAppTheme.themeColors.darkGray,
      overflow: TextOverflow.ellipsis,
    );
  }
  
  Widget getSubTile(int index, FormProposalTemplateModel template) {
    return InkWell(
      onTap: () => onTapTemplate?.call(index),
      child: Column(
        children: [
          const SizedBox(
            height: 8,
          ),
          Row(
            children: [
              const SizedBox(
                width: 60,
              ),
              JPText(text: "${index + 1}."),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: JPText(
                  text: template.title ?? "",
                  textSize: JPTextSize.heading4,
                  fontWeight: JPFontWeight.regular,
                  textAlign: TextAlign.start,
                  maxLine: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(
                width: 6,
              ),
              JPCheckbox(
                selected: template.isSelected,
                onTap: (val) => onTapTemplate?.call(index),
              ),
              const SizedBox(
                width: 11,
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),

        ],
      ),
    );
  }
  
}
