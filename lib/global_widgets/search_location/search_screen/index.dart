import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/google_maps/place_details.dart';
import 'package:jobprogress/core/constants/widget_keys.dart';
import 'package:jobprogress/global_widgets/safearea/safearea.dart';
import 'package:jobprogress/global_widgets/search_location/search_screen/widgets/shimmer.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../../../../core/utils/helpers.dart';
import '../../../../../global_widgets/scaffold/index.dart';
import '../../../common/models/address/address.dart';
import '../../no_data_found/index.dart';
import 'controller.dart';
import 'widgets/listing.dart';

class SearchLocationView extends StatelessWidget {
  const SearchLocationView({super.key, this.placeDetailsModel, this.callback});

  final PlaceDetailsModel? placeDetailsModel;
  final Function(AddressModel params)? callback;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SearchLocationController>(
        global: false,
        init: SearchLocationController(placeDetailsModel: placeDetailsModel),
        builder: (SearchLocationController controller) => GestureDetector(
            onTap: () => Helper.hideKeyboard(),
            child: JPScaffold(
              backgroundColor: JPAppTheme.themeColors.base,
              scaffoldKey: controller.scaffoldKey,
              appBar: JPHeader(
                onBackPressed: Get.back<void>,
                titleWidget: JPInputBox(
                  key: const Key(WidgetKeys.searchLocationKey),
                  controller: controller.searchTextController,
                  type: JPInputBoxType.searchbarWithoutBorder,
                  hintText: "search_location".tr,
                  onChanged: controller.search,
                  textSize: JPTextSize.heading4,
                  scrollPadding: EdgeInsets.zero,
                  fillColor: JPAppTheme.themeColors.base,
                  cancelButtonSize: 24,
                  cancelButtonColor:
                      JPAppTheme.themeColors.secondaryText.withValues(alpha: 0.6),
                  autofocus: true,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                  debounceTime: 300,
                ),
                backIconColor: JPAppTheme.themeColors.text,
                backgroundColor: JPAppTheme.themeColors.base,
                actions: const [
                  SizedBox(
                    width: 16,
                  )
                ],
              ),
              body: JPSafeArea(
                  top: false,
                  containerDecoration: BoxDecoration(
                    color: controller.placesList?.isEmpty ?? true
                        ? JPAppTheme.themeColors.inverse
                        : JPAppTheme.themeColors.base,
                  ),
                  child: Column(
                    children: [
                      Divider(height: 1, color: JPAppTheme.themeColors.dimGray),
                      getSearchResultList(controller),
                    ],
                  )),
            )));
  }

  Widget getSearchResultList(SearchLocationController controller) {
    if (controller.isLoading) {
      return const Expanded(child: SearchLocationShimmer());
    } else if (controller.placesList == null) {
      return Container();
    } else if (controller.placesList?.isEmpty ?? true) {
      return Expanded(
        child: NoDataFound(
          icon: Icons.location_on_outlined,
          title: 'no_location_found'.tr.capitalize,
        ),
      );
    } else {
      return SearchResultListing(
        controller: controller,
        callback: callback,
      );
    }
  }
}
