import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/safearea/safearea.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../../common/models/address/address.dart';
import '../../../global_widgets/main_drawer/index.dart';
import '../../../global_widgets/scaffold/index.dart';
import '../../../global_widgets/search_location/index.dart';
import 'controller.dart';

class MapSections extends StatelessWidget {
  const MapSections({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MapSectionController>(
        global: false,
        init: MapSectionController(),
        builder: (MapSectionController controller) {
          return GestureDetector(
            onTap: () => Helper.hideKeyboard(),
            child: JPScaffold(
                backgroundColor: JPAppTheme.themeColors.inverse,
                appBar: JPHeader(
                  backgroundColor: JPAppTheme.themeColors.inverse,
                  backIconColor: JPAppTheme.themeColors.text,
                  onBackPressed: () {
                    Get.back();
                  },
                  actions: [
                    Padding(
                      padding: const EdgeInsets.only(right: 18),
                      child: Center(
                        child: JPTextButton(
                            color: JPAppTheme.themeColors.text,
                            iconSize: 24,
                            onPressed: () => controller
                                .scaffoldKey.currentState!
                                .openEndDrawer(),
                            icon: Icons.menu),
                      ),
                    ),
                  ],
                ),
                endDrawer: JPMainDrawer(
                  selectedRoute: 'demo',
                ),
                scaffoldKey: controller.scaffoldKey,
                body: JPSafeArea(
                  child: CustomScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    slivers: <Widget>[
                      ///   map view
                      JPCollapsibleMapView(
                        onAddressUpdate: (AddressModel params, {bool? canUpdateMarker, bool? isPinUpdated}) {},
                        mapDragDetector: (bool isMapDragged) {},
                      ),

                      ///   dummy widgets
                      SliverToBoxAdapter(
                        child: SingleChildScrollView(
                            physics: const NeverScrollableScrollPhysics(),
                            child: Column(
                              children: [
                                for (int i = 0; i < 40; i++)
                                  Container(
                                    height: 40,
                                    width: MediaQuery.of(context).size.width,
                                    margin: const EdgeInsets.only(top: 20),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(18),
                                      color: JPAppTheme.themeColors.base,
                                    ),
                                    alignment: Alignment.center,
                                    child: JPText(
                                      text: "Dummy Text $i",
                                    ),
                                  )
                              ],
                            )),
                      ),
                    ],
                  ),
                )),
          );
        });
  }
}
