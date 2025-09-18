
import 'package:jobprogress/common/enums/network_multiselect.dart';
import 'package:jobprogress/common/models/custom_fields/custom_form_fields/sub_option.dart';
import 'package:jobprogress/common/repositories/company_city.dart';
import 'package:jobprogress/common/repositories/customer.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/modal.dart';

class JPNetworkMultiSelectService {

  static Future<dynamic> typeToApi(JPNetworkMultiSelectType type, Map<String, dynamic> params) async {

    switch (type) {

      case JPNetworkMultiSelectType.cities:
        return await CompanyCityRepo.fetchCompanyCities(params);

      case JPNetworkMultiSelectType.customFieldSubOptions:
        return await CustomerRepository.getCustomFieldsSubOptions(params);
    }
  }

  static List<JPMultiSelectModel> parseToMultiSelect(JPNetworkMultiSelectType type, dynamic dataList) {

    List<JPMultiSelectModel> mainList = [];

    switch (type) {

      case JPNetworkMultiSelectType.cities:
        for (String city in (dataList as List<String>)) {
          mainList.add(
            JPMultiSelectModel(
              label: city,
              id: city,
              isSelect: false,
            ),
          );
        }
        break;

      case JPNetworkMultiSelectType.customFieldSubOptions:
        for (CustomFormFieldSubOption option in (dataList as List<CustomFormFieldSubOption>)) {
          mainList.add(
            JPMultiSelectModel(
              label: option.name ?? "-",
              id: option.id.toString(),
              isSelect: false,
              additionData: (option.linkedParentOptions?.isNotEmpty ?? false)
                  ? option.linkedParentOptions!.map((e) => e.id).toList(): null
            ),
          );
        }
        break;
    }

    return mainList;
  }

}