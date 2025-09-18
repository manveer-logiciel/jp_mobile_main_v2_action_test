import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/global_widgets/listview/index.dart';
import 'package:jobprogress/global_widgets/macros/list_tile/shimmer.dart';
import 'package:jobprogress/global_widgets/no_data_found/index.dart';
import 'package:jp_mobile_flutter_ui/AnimatedSpinKit/fading_circle.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../listing/controller.dart';
import 'list_tile.dart';

class MacroList extends StatelessWidget {
  final MacroListingController controller;
  const MacroList({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        controller.isLoading
            ?  const MacroListShimmer()
            : controller.macroList.isNotEmpty
                ? JPListView(
                    listCount: controller.macroList.length,
                    padding: const EdgeInsets.only(
                        top: 10),
                  
                    onRefresh: () => controller.refreshList(showLoading: true),
                    itemBuilder: (_, index) {
                      if (index < controller.macroList.length) {
                        return MacroListTile(
                          data: controller.macroList[index],
                          index: index,
                          controller: controller,
                      
                        );
                      } else if (controller.canShowMore) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: FadingCircle(
                              size: 25,
                              color: JPAppTheme.themeColors.primary,
                            ),
                          ),
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  )
                :  Expanded(
                    child: NoDataFound(
                      icon: Icons.description_outlined,
                      title:'no_macro_found'.tr.capitalize,
                    ),
                  )
      ],
    );
  }
}
