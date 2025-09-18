import 'package:flutter/material.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'package:shimmer/shimmer.dart';

class AppointmentListingShimmer extends StatelessWidget {
  const AppointmentListingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: 10,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        return Container(
          margin: const EdgeInsets.only(top: 5, bottom: 5, left: 16, right: 16),
          padding: const EdgeInsets.only(bottom: 10),
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
  return Row(
    children: [
      Padding(
        padding: const EdgeInsets.only(top: 20.0,),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [           
            Container(
              margin: const EdgeInsets.only(left: 20, bottom: 10),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                color: JPAppTheme.themeColors.dimGray,
              ),
              width: MediaQuery.of(context).size.width-70,
              height: 8,
              child: const JPText(text: ""),
            ),
            Container(
              margin: const EdgeInsets.only(left: 20, bottom: 10),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                color: JPAppTheme.themeColors.dimGray,
              ),
              width: MediaQuery.of(context).size.width-100,
              height: 8,
              child: const JPText(text: ""),
            ),
            Container(
              margin: const EdgeInsets.only(left: 20, bottom: 10),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                color: JPAppTheme.themeColors.dimGray,
              ),
              width: MediaQuery.of(context).size.width-120,
              height: 8,
              child: const JPText(text: ""),
            ),
            Container(
              margin: const EdgeInsets.only(left: 20, bottom: 10),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                color: JPAppTheme.themeColors.dimGray,
              ),
              width: MediaQuery.of(context).size.width-200,
              height: 8,
              child: const JPText(text: ""),
            ),
            Container(
              padding: const EdgeInsets.only(left: 20),
              width: MediaQuery.of(context).size.width - 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.zero,
                        margin: EdgeInsets.zero,
                        width: 30,
                        height: 30,
                        child: ListView.builder(
                            padding: EdgeInsets.zero,
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: 1,
                            itemBuilder: (context, index) {
                              return Align(
                                widthFactor: 0.7,
                                child: Container(
                                  decoration: BoxDecoration(
                                      color:
                                          JPAppTheme.themeColors.dimGray,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color:
                                              JPAppTheme.themeColors.dimGray)),
                                  width: 24,
                                  height: 24,
                                ),
                              );
                            }),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5.0)),
                          color: JPAppTheme.themeColors.dimGray,
                        ),
                        width: 100,
                        height: 8,
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    ],
  );
}
