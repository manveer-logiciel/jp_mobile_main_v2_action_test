import 'dart:ui';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../../services/connected_third_party.dart';
import '../../address/address.dart';
import '../../job/job.dart';

class QuickMeasureFormData {
  QuickMeasureFormData({
    required this.update,
    this.jobModel,
  });

  final VoidCallback update; // update method from respective controller to refresh ui from service itself
  JobModel? jobModel; // used to store selected job data
  AddressModel? selectedAddress; // used to store selected job data
  String? quickMeasureAccountId;

  // form field controllers
  JPInputBoxController productsController = JPInputBoxController();
  JPInputBoxController accountController = JPInputBoxController();
  JPInputBoxController emailController = JPInputBoxController();
  JPInputBoxController specialInfoController = JPInputBoxController();

  int? countryId;
  int? stateIds;
  JPSingleSelectModel? selectedProduct;

  bool isLoading = true;
  bool isProductSectionExpanded = false;
  bool isOtherInfoSectionExpanded = false;
  bool isDefaultLocation = true;

  Map<String, dynamic> initialJson = {}; // helps in data changes comparison

  // setFormData(): set-up form data to be pre-filled in form
  void setFormData() {

    quickMeasureAccountId = ConnectedThirdPartyService.connectedThirdParty["quickmeasure"]?["quickmeasure_account_id"] ?? "";

    if (jobModel != null) {
      productsController.text = selectedProduct?.label ?? "";

      accountController.text = !Helper.isValueNullOrEmpty(quickMeasureAccountId)
          ? quickMeasureAccountId! :  "";

      selectedAddress = AddressModel.copy(addressModel: jobModel?.address);

    }
    initialJson = quickMeasureFormJson();
    update();
  }

  // checkIfNewDataAdded(): used to compare form data changes
  Map<String, dynamic> quickMeasureFormJson() {
    final data = <String, dynamic>{};

    data["product_code"] = selectedProduct?.id;
    data["product_name"] = selectedProduct?.label;
    data["job_id"] = jobModel?.id;
    data["roofaddress[address_line1]"] = (selectedAddress?.address ?? "") + (selectedAddress?.addressLine1 ?? "");
    data["roofaddress[city]"] = selectedAddress?.city;
    data["roofaddress[state_code]"] = selectedAddress?.state?.code;
    data["roofaddress[country]"] = selectedAddress?.country?.name;
    data["roofaddress[zip_code]"] = selectedAddress?.zip;
    data["roofaddress[latitude]"] = selectedAddress?.lat;
    data["roofaddress[longitude]"] = selectedAddress?.long;
    data["recipient_email_addresses"] = emailController.text;
    data["instructions"] = specialInfoController.text;

    return data;
  }

}