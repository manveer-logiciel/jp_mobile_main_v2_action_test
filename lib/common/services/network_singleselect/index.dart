import 'package:jobprogress/common/enums/network_singleselect.dart';
import 'package:jobprogress/common/models/files_listing/hover/user.dart';
import 'package:jobprogress/common/models/network_singleselect/params.dart';
import 'package:jobprogress/common/models/suppliers/beacon/job.dart';
import 'package:jobprogress/common/repositories/company_city.dart';
import 'package:jobprogress/common/repositories/hover.dart';
import 'package:jobprogress/common/repositories/material_supplier.dart';
import 'package:jobprogress/common/models/vendor/active_vendor_model.dart';
import 'package:jobprogress/common/repositories/job.dart';
import 'package:jobprogress/core/constants/pagination_constants.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class JPNetworkSingleSelectService {

  static Map<String, dynamic> typeToParams(JPNetworkSingleSelectType type, JPSingleSelectParams requestParams) {
    switch (type) {
      case JPNetworkSingleSelectType.vendors:
        return {
        'limit': PaginationConstants.pageLimit50,
        'page': requestParams.page,
        'includes[]': 'address',
        'active': 1,
        'display_name': requestParams.keyword,
        'sort_by': 'display_name',
        'sort_order': 'asc'
      };
      case JPNetworkSingleSelectType.hoverUsers:
        return {
          'limit': requestParams.limit,
          'page': requestParams.page,
          'search': requestParams.keyword
        };
      default:
        return requestParams.toJson();
    }
  }

  static Future<dynamic> typeToApi(JPNetworkSingleSelectType type, JPSingleSelectParams requestParams) async {

    Map<String, dynamic> params = typeToParams(type, requestParams);
    
    switch (type) {

      case JPNetworkSingleSelectType.hoverUsers:
        return await HoverRepository.getHoverUsers(params);

      case JPNetworkSingleSelectType.cities:
        return await CompanyCityRepo.fetchCompanyCities(params);
      
      case JPNetworkSingleSelectType.vendors:
        return await JobRepository.fetchActiveVendors(params);

      case JPNetworkSingleSelectType.beaconJobs:
        return await MaterialSupplierRepository.getBeaconJobs(params);
    }
  }

  static List<JPSingleSelectModel> parseToMultiSelect(JPNetworkSingleSelectType type, dynamic dataList) {

    List<JPSingleSelectModel> mainList = [];

    switch (type) {

      case JPNetworkSingleSelectType.hoverUsers:
        for (HoverUserModel user in (dataList as List<HoverUserModel>)) {
          mainList.add(
            JPSingleSelectModel(
              label: user.fullName ?? user.firstName ?? "",
              id: user.id.toString(),
              additionalData: user
            ),
          );
        }
        break;

      case JPNetworkSingleSelectType.cities:
        for (String city in (dataList as List<String>)) {
          mainList.add(
            JPSingleSelectModel(
              label: city,
              id: city,
            ),
          );
        }
        break;

      case JPNetworkSingleSelectType.beaconJobs:
        for (BeaconJobModel job in (dataList as List<BeaconJobModel>)) {
          mainList.add(
            JPSingleSelectModel(
              label: job.jobName ?? "",
              id: job.jobNumber.toString(),
              additionalData: job
            ),
          );
        }
        break;

      case JPNetworkSingleSelectType.vendors:
        for(ActiveVendorModel vendor in dataList as List<ActiveVendorModel>) {
          mainList.add(
          JPSingleSelectModel(
              label: vendor.displayName.toString(),
              id: vendor.id.toString(),
              subLabel: vendor.address ?? '',
          ));
        }
        break;
    }

    return mainList;
  }

}