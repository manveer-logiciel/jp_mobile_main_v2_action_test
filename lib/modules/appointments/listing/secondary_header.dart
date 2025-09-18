import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/appointment/appointment_param.dart';
import 'package:jobprogress/core/utils/single_select_helper.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/index.dart';
import 'package:jobprogress/modules/appointments/filter_dialog/index.dart';
import 'package:jobprogress/modules/appointments/listing/controller.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class AppointmentSecondaryHeader extends StatelessWidget {
  const AppointmentSecondaryHeader({
    super.key,
    required this.appointmentController
  });

  final AppointmentListingController appointmentController;
  
  void openCustomFilters() {
    showJPGeneralDialog(
      child:(controller) => AppointmentsFilterDialog(
        selectedFilters: appointmentController.paramKeys,
        userList: appointmentController.userList,
        appointmentResultList: appointmentController.appointmentResultList,
        onApply: (AppointmentListingParamModel params) {
          appointmentController.applyFilters(params);  
        },
      )
    );
  }

  void openSortBy() {
    SingleSelectHelper.openSingleSelect(  
      appointmentController.sortByList,
      appointmentController.paramKeys.sortBy,
      'sort_by'.tr, (value) {
        appointmentController.applySortByFilters(value);
      },
      isFilterSheet: true
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 11, top: 10, bottom: 11),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          !appointmentController.isCustomerAppointments ? 
          Material(
            color: JPAppTheme.themeColors.inverse,
            child:  JPTextButton(
              color: JPAppTheme.themeColors.tertiary,
              onPressed: () {
                openSortBy();
              },
              fontWeight: JPFontWeight.medium,
              textSize: JPTextSize.heading5,
              text: '${'sort_by'.tr}: ${SingleSelectHelper.getSelectedSingleSelectValue(appointmentController.sortByList, appointmentController.paramKeys.sortBy)}',
              icon: Icons.keyboard_arrow_down_outlined,
            ),
          ) : Material(
            color: JPAppTheme.themeColors.inverse,
            child: JPTextButton(
              color: JPAppTheme.themeColors.tertiary,
              onPressed: () {
                appointmentController.openFilterBy();
              },
              fontWeight: JPFontWeight.medium,
              textSize: JPTextSize.heading5,
              text: '${'filter_by'.tr.capitalizeFirst}: ${SingleSelectHelper.getSelectedSingleSelectValue(appointmentController.filterByList, appointmentController.selectedFilterId)}',
              icon: Icons.keyboard_arrow_down_outlined,
            ),
          ),
          Visibility(
            visible: !appointmentController.isCustomerAppointments,
            child: Row(
              children: [
                Material(
                  color: JPAppTheme.themeColors.inverse,
                  child: InkWell(
                    onTap: () {
                     appointmentController.sortAppointmentListing();
                    },
                    borderRadius: BorderRadius.circular(50),
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      child: appointmentController.paramKeys.sortOrder == 'desc' ? 
                        SvgPicture.asset('assets/svg/sort_asc.svg') : 
                        SvgPicture.asset('assets/svg/sort_desc.svg')
                    )
                  ),
                ),
                const SizedBox(width: 7),
                Material(
                  color: JPAppTheme.themeColors.inverse,
                  child: JPFilterIcon(
                    onTap: (){
                      openCustomFilters();
                    },
                    isFilterActive: true
                  )
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
