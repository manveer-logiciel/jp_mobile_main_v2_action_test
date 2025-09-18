import 'package:flutter/material.dart';
import 'package:jp_mobile_flutter_ui/Theme/index.dart';
import 'package:shimmer/shimmer.dart';

class SheetLineItemListingShimmer extends StatelessWidget {
  const SheetLineItemListingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: 20,
        padding: const EdgeInsets.only(left: 16, top: 24),
        itemBuilder: (BuildContext context, int index) {
          return Shimmer.fromColors(
              baseColor: JPAppTheme.themeColors.dimGray,
              highlightColor: JPAppTheme.themeColors.inverse,
              child: Row(
                children: [
                  Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: JPAppTheme.themeColors.inverse,
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(bottom: 15, top: 12, right: 16),
                      decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1, color:JPAppTheme.themeColors.dimGray, style: BorderStyle.solid))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                         Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                             Container(
                                margin: const EdgeInsets.only(top: 3, bottom: 3),
                                height: 10,
                                width: 100,
                                color: JPAppTheme.themeColors.inverse,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(top: 3, bottom: 3),
                                    height: 10,
                                    width: 70,
                                    color: JPAppTheme.themeColors.inverse,
                                  ),
                                  const SizedBox(
                                    width: 25,
                                  ),
                                   Container(
                                    margin: const EdgeInsets.only(top: 3, bottom: 3),
                                    height: 10,
                                    width: 70,
                                    color: JPAppTheme.themeColors.inverse,
                                  ),
                                ],
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 3, bottom: 3),
                                height: 10,
                                width: 70,
                                color: JPAppTheme.themeColors.inverse,
                              ),
                          ],
                         ),
                           Container(
                                margin: const EdgeInsets.only(top: 3, bottom: 3),
                                height: 10,
                                width: 70,
                                color: JPAppTheme.themeColors.inverse,
                              ),
                        ],
                      ),
                    ),
                  ),                 
                ],
              ));
        },
      ),
    );
  }
}
