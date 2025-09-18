import 'package:flutter/material.dart';
import 'package:jp_mobile_flutter_ui/Label/type.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'package:shimmer/shimmer.dart';

//Using this widget to render task listing shimmer loading
class CustomerListTileShimmer extends StatelessWidget {
  const CustomerListTileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 10,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 5),
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
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        ///   customer name, organisation name, job count
        Row(
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
              ],
            ),
            ///   job count
            JPLabel(
              backgroundColor: JPAppTheme.themeColors.primary,
              text: ' ',
            ),
          ],
        ),
        space(),
        space(),
        ///   phone number
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.zero,
              width: 180,
              height: 7,
              child:  const JPLabel(
                text: " ",
                type: JPLabelType.lightGray,
              ),
            ),
          ],
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.zero,
              width: 250,
              height: 7,
              child:  const JPLabel(
                text: " ",
                type: JPLabelType.lightGray,
              ),
            ),
          ],
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
            JPIcon(Icons.phone,
              size: 22,
              color: JPAppTheme.themeColors.inverse,
            ),
            const SizedBox(width: 25,),
            JPIcon(Icons.email,
              size: 22,
              color: JPAppTheme.themeColors.inverse,
            ),
            const SizedBox(width: 25,),
            JPIcon(Icons.location_on,
              size: 22,
              color: JPAppTheme.themeColors.inverse,
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
