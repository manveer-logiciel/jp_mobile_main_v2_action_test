import 'package:flutter/material.dart';
import 'package:jobprogress/core/constants/widget_keys.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../../../common/models/address/address.dart';
import '../../../custom_material_card/index.dart';
import '../../../listview/index.dart';
import '../controller.dart';

class SearchResultListing extends StatelessWidget {
  const SearchResultListing({
    super.key,
    required this.controller,
    required this.callback
  });

  final SearchLocationController controller;
  final Function(AddressModel params)? callback;

  @override
  Widget build(BuildContext context) {
    return JPListView(
      listCount: controller.placesList?.length ?? 0,
      itemBuilder: (context, index) {
        if (index < (controller.placesList?.length ?? 0)) {
          return CustomMaterialCard(
            key: Key('${WidgetKeys.searchLocationResultListKey}[$index]'),
            borderRadius: 0,
            child: Column(
              children: [
                InkWell(
                  onTap: () => controller.onAddressSelect(index, callback),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ///   icon
                        JPIcon(
                          Icons.location_on_outlined,
                          color: JPAppTheme.themeColors.darkGray,
                        ),
                        ///   location
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 7.5),
                            child: JPText(
                              text: controller.placesList![index].description ?? "",
                              textSize: JPTextSize.heading4,
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(height: 1, color: JPAppTheme.themeColors.dimGray)
              ],
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
