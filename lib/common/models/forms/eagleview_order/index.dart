import 'dart:ui';

import 'package:jp_mobile_flutter_ui/MultiSelect/modal.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../../enums/eagle_view_form_type.dart';
import '../../../services/forms/parsers.dart';
import '../../address/address.dart';
import '../../files_listing/eagle_view/product.dart';
import '../../job/job.dart';

class EagleViewFormData {

  EagleViewFormData({
    required this.update,
    this.jobModel,
    this.pageType
  });

  final EagleViewFormType? pageType;
  final VoidCallback update; // update method from respective controller to refresh ui from service itself
  JobModel? jobModel; // used to store selected job data

  // form field controllers
  JPInputBoxController productsController = JPInputBoxController();
  JPInputBoxController deliveryController = JPInputBoxController();
  JPInputBoxController addOnProductsController = JPInputBoxController();
  JPInputBoxController measurementController = JPInputBoxController();
  JPInputBoxController promoCodeController = JPInputBoxController();
  JPInputBoxController insuredNameController = JPInputBoxController();
  JPInputBoxController referenceIdController = JPInputBoxController();
  JPInputBoxController batchIdController = JPInputBoxController();
  JPInputBoxController policyNoController = JPInputBoxController();
  JPInputBoxController claimNumberController = JPInputBoxController();
  JPInputBoxController claimInfoController = JPInputBoxController();
  JPInputBoxController poNumberController = JPInputBoxController();
  JPInputBoxController catIdController = JPInputBoxController();
  JPInputBoxController dateOfLossController = JPInputBoxController();
  JPInputBoxController sendCopyToController = JPInputBoxController();
  JPInputBoxController commentController = JPInputBoxController();

  List<JPSingleSelectModel> allMeasurementsList = []; // used to store measurements
  List<EagleViewProductModel> allProductsList = []; // used to store products
  List<JPSingleSelectModel> productList = []; // used to store products for dropdown
  List<JPSingleSelectModel> deliveryList = []; // used to store delivery's for dropdown
  List<JPMultiSelectModel> addOnProductList = []; // used to store add-on products for dropdown
  List<JPSingleSelectModel> measurementsList = []; // used to store measurement's for dropdown
  List<JPMultiSelectModel> selectedAddOnProductsList = []; // used to store selected other products from dropdown

  AddressModel? selectedAddress;
  JPSingleSelectModel? selectedProduct;
  JPSingleSelectModel? selectedDelivery;
  JPSingleSelectModel? selectedMeasurements;
  String? selectedDateOfLoss;

  bool isLoading = true;
  bool isProductSectionExpanded = false;
  bool isInstructionSectionExpanded = false;
  bool isClaimSectionExpanded = false;
  bool isOtherInfoSectionExpanded = false;
  bool havePromoCode = false;
  bool havePreviousChanges = false;
  bool isDefaultLocation = true;

  Map<String, dynamic> initialJson = {}; // helps in data changes comparison

  /////////////////////////////      API PARAMS     ////////////////////////////

  Map<String, dynamic> eagleViewFormJson() {
    final data = <String, dynamic>{};

    data["job_id"] = jobModel?.id;
    data["customer_id"] = jobModel?.customerId;
    ///   Address Information Section
    data["Address"]= (selectedAddress?.address ?? "") + (selectedAddress?.addressLine1 ?? "");
    data["City"]= selectedAddress?.city;
    data["State"]= selectedAddress?.state?.code;
    data["Zip"]= selectedAddress?.zip;
    data["Latitude"]= selectedAddress?.lat;
    data["Longitude"]= selectedAddress?.long;
    ///   Product Information Section
    data["PrimaryProductId"] = selectedProduct?.id;
    data["DeliveryProductId"] = selectedDelivery?.id;
    data["MeasurementInstructionType"] = selectedMeasurements?.id;
    data["MeasurementInstructionName"] = selectedMeasurements?.label;
    data["ProductTypeName"] = selectedProduct?.label;
    data["ProductDeliveryOptionName"] = selectedDelivery?.label;
    data['AddOnProductIds[]'] = FormValueParser.multiSelectToSelectedIds(addOnProductList);
    data['AddOnProductNames[]'] = FormValueParser.multiSelectToSelectedLabels(addOnProductList);
    data["PromoCode"] = promoCodeController.text;
    ///   Insurance Information Section
    data["InsuredName"] = insuredNameController.text;
    data["ReferenceId"] = referenceIdController.text;
    data["BatchId"] = batchIdController.text;
    data["PolicyNumber"] = policyNoController.text;
    ///   Claim Information Section
    data["ClaimNumber"] = claimNumberController.text;
    data["ClaimInfo"] = claimInfoController.text;
    data["PONumber"] = poNumberController.text;
    data["CatId"] = catIdController.text;
    data["DateOfLoss"] = selectedDateOfLoss;
    ///   Other Information Section
    data["AdditionalEmails[]"] = sendCopyToController.text;
    data["ChangesInLast4Years"] = havePreviousChanges ? 1 : 0;

    return data;
  }
}