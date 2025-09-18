import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/snippet_listing/snippet_listing.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class SnippetTradeListTile extends StatelessWidget {

  final SnippetListModel data;
  final VoidCallback? onTap;
  final VoidCallback? onCopyPressed;
  final int index;

  const SnippetTradeListTile({super.key, required this.data, this.onTap, this.onCopyPressed, required this.index});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: Row(
          children: [
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
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(top: 5 ,bottom: 7),
                decoration: BoxDecoration(border:Border(bottom: BorderSide(width: 1, color:JPAppTheme.themeColors.dimGray, style: BorderStyle.solid))),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          JPText(
                            text: data.title!.capitalize!,
                            fontWeight: JPFontWeight.medium,
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 5),
                          JPText(
                            text: data.parseHtmlDescription!,
                            textAlign: TextAlign.left,
                            textSize: JPTextSize.heading5,
                            textColor: JPAppTheme.themeColors.tertiary,
                            overflow: TextOverflow.ellipsis,
                            maxLine: 1,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      splashRadius: 20,
                      onPressed: onCopyPressed,
                      icon: JPIcon(
                        Icons.file_copy_outlined,
                          size: 24,
                          color: JPAppTheme.themeColors.tertiary,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
