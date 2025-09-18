import 'package:flutter/material.dart';
import 'package:jp_mobile_flutter_ui/Theme/index.dart';

class ContactViewShimmer extends StatelessWidget {
  const ContactViewShimmer({super.key});

  @override
  Widget build(BuildContext context) {

    Widget getHeader() {
      return Stack(
        children: [
          Positioned.fill(
            top: 75,
            child: Material(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  shimmerBox(height: 130, width: 130, borderRadius: 75),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              shimmerBox(height: 12, width: 250),
              const SizedBox(
                height: 6,
              ),
              shimmerBox(height: 6, width: 230),
              const SizedBox(
                height: 30,
              ),
              Row(            mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  shimmerBox(height: 50, width: 50, borderRadius: 25),
                  const SizedBox(
                    width: 15,
                  ),
                  shimmerBox(height: 50, width: 50, borderRadius: 25),
                  const SizedBox(
                    width: 15,
                  ),
                  shimmerBox(height: 50, width: 50, borderRadius: 25),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ],
      );
    }

    Widget getNoteCard({double? height}) {
      return Material(
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              shimmerBox(height: 12, width: 100),
              const SizedBox(
                height: 15,
              ),
              shimmerBox(height: 10, width: double.maxFinite),
              const SizedBox(
                height: 8,
              ),
              shimmerBox(height: 10, width: double.maxFinite),
              const SizedBox(
                height: 8,
              ),
              shimmerBox(height: 10, width: double.maxFinite),
              const SizedBox(
                height: 8,
              ),
              shimmerBox(height: 10, width: 100),
              const SizedBox(
                height: 15,
              ),
              shimmerBox(height: 10, width: double.maxFinite),
              const SizedBox(
                height: 8,
              ),
              shimmerBox(height: 10, width: double.maxFinite),
              const SizedBox(
                height: 8,
              ),
              shimmerBox(height: 10, width: double.maxFinite),
              const SizedBox(
                height: 8,
              ),
              shimmerBox(height: 10, width: 100),
            ],
          ),
        ),
      );
    }

    Widget getCard({double? height, int count = 1}) {
      return Material(
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: List.generate(count, (index) {
              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            shimmerBox(height: 10, width: 150),
                            const SizedBox(
                              height: 10,
                            ),
                            shimmerBox(height: 10, width: 250),
                            const SizedBox(
                              height: 4,
                            ),
                            shimmerBox(height: 6, width: 200),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Icon(Icons.messenger_outlined, color: JPAppTheme.themeColors.dimGray,),
                      const SizedBox(
                        width: 16,
                      ),
                      Icon(Icons.call, color: JPAppTheme.themeColors.dimGray,),
                    ],
                  ),
                  if(count > 1 && index < count - 1)
                    const Divider(
                      thickness: 1,
                      height: 30,
                    ),
                ],
              );
            }),
          ),
        ),
      );
    }

    return Scaffold(
        backgroundColor: JPAppTheme.themeColors.lightestGray,
        body: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              getHeader(),
              const SizedBox(
                height: 20,
              ),
              getCard(count: 2),
              const SizedBox(
                height: 20,
              ),
              getCard(count: 3),
              const SizedBox(
                height: 20,
              ),
              getNoteCard(height: 180),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
          //),
        ));
  }

  Widget shimmerBox({
    required double height,
    required double width,
    double borderRadius = 3
  }) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        color: JPAppTheme.themeColors.dimGray,
      ),
    );
  }
}
