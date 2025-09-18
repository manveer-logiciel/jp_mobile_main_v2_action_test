import 'package:flutter/material.dart';
import 'package:jobprogress/common/enums/cj_list_type.dart';
import 'package:jp_mobile_flutter_ui/Label/type.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'package:shimmer/shimmer.dart';

//Using this widget to render task listing shimmer loading
class JobListTileShimmer extends StatelessWidget {
  const JobListTileShimmer({super.key, this.listType});

  final CJListType? listType;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 10,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          margin: listType == CJListType.projectJobs && index == 0
              ? const EdgeInsets.fromLTRB(0, 20, 0, 5)
              : const EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: JPAppTheme.themeColors.base,
          ),
          child: Shimmer.fromColors(
              baseColor: JPAppTheme.themeColors.dimGray,
              highlightColor: JPAppTheme.themeColors.inverse,
              child: renderShimmerTile(context)),
        );
      },
    );
  }
}

Widget renderShimmerTile(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(15),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ///   customer name
            Container(
              padding: EdgeInsets.zero,
              width: 100,
              height: 7,
              child:  const JPLabel(
                text: " ",
                type: JPLabelType.lightGray,
              ),
            ),
            space(),
            ///   organisation name
            Container(
              padding: EdgeInsets.zero,
              width: 150,
              height: 7,
              child:  const JPLabel(
                text: " ",
                type: JPLabelType.lightGray,
              ),
            ),
            space(),
            space(),
            ///   phone number
            Container(
              padding: EdgeInsets.zero,
              width: 180,
              height: 7,
              child:  const JPLabel(
                text: " ",
                type: JPLabelType.lightGray,
              ),
            ),
            space(),
            ///   email
            Container(
              padding: EdgeInsets.zero,
              width: 200,
              height: 7,
              child:  const JPLabel(
                text: " ",
                type: JPLabelType.lightGray,
              ),
            ),
            space(),
            ///   address
            Container(
              padding: EdgeInsets.zero,
              width: 250,
              height: 7,
              child:  const JPLabel(
                text: " ",
                type: JPLabelType.lightGray,
              ),
            ),
            space(),
            ///   sm/ cust. Rep
            Container(
              padding: EdgeInsets.zero,
              width: 180,
              height: 7,
              child:  const JPLabel(
                text: " ",
                type: JPLabelType.lightGray,
              ),
            ),
            space(),
            space(),
            ///   tags
            Row(
              children: [
                Container(
                  padding: EdgeInsets.zero,
                  width: 80,
                  height: 20,
                  child:  const JPLabel(
                    text: " ",
                    type: JPLabelType.lightGray,
                  ),
                ),
                space(),
                Container(
                  padding: EdgeInsets.zero,
                  width: 80,
                  height: 20,
                  child:  const JPLabel(
                    text: " ",
                    type: JPLabelType.lightGray,
                  ),
                ),
                space(),
                Container(
                  padding: EdgeInsets.zero,
                  width: 80,
                  height: 20,
                  child:  const JPLabel(
                    text: " ",
                    type: JPLabelType.lightGray,
                  ),
                ),
              ],
            ),
            space(),
            ///   Buttons
            Row(
              children: [
                JPLabel(
                  backgroundColor: JPAppTheme.themeColors.primary,
                  text: ' ',
                ),
                space(),
                JPLabel(
                  backgroundColor: JPAppTheme.themeColors.primary,
                  text: ' ',
                ),
                space(),
                JPLabel(
                  backgroundColor: JPAppTheme.themeColors.primary,
                  text: ' ',
                ),
              ],
            ),
          ],
        ),

        ///   customer name, organisation name, job count
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ///   job count
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: JPLabel(
                backgroundColor: JPAppTheme.themeColors.primary,
                text: ' ',
              ),
            ),
            Container(
              height: 24,
              width: 24,
              padding: const EdgeInsets.only(bottom: 5),
              child: const JPLabel(
                text: '',
              ),
            ),
            Container(
              height: 24,
              width: 24,
              padding: const EdgeInsets.only(bottom: 5),
              child: const JPLabel(
                text: '',
              ),
            ),
          ],
        ),

      ],
    ),
  );
}

Widget space() => const SizedBox(
  height: 10,
  width: 10,
);
