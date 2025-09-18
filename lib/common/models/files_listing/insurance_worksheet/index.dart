import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/insurance_form_type.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_model.dart';
import 'package:jobprogress/common/models/forms/measurement/measurement.dart';
import 'package:jobprogress/common/models/worksheet/worksheet_detail_category_model.dart';
import 'package:jobprogress/common/models/worksheet/worksheet_model.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/core/utils/job_financial_helper.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../job/job.dart';
import '../../job_financial/financial_listing.dart';
import '../../sheet_line_item/sheet_line_item_model.dart';

class InsuranceFormData {
  InsuranceFormData({
    required this.update,
    this.jobModel,
    this.pageType,
    this.worksheetId,
    this.insurancePdfJson,
  });

  final VoidCallback update; // update method from respective controller to refresh ui from service itself
  JobModel? jobModel; // used to store selected job data
  InsuranceFormType? pageType;
  
  String? worksheetId; 
  String? measurementPath;
  String? measurementId;
  
  FinancialListingModel? financialListingModel;
  WorksheetDetailCategoryModel? insuranceCategoryDetail;


  JPInputBoxController titleController = JPInputBoxController();
  JPInputBoxController divisionController = JPInputBoxController();

  List<JPSingleSelectModel> divisionsList = []; // used to store divisions for dropdown
  List<SheetLineItemModel> insuranceItems = [];
  List<WorksheetDetailCategoryModel> categoryList = [];
  
  JPSingleSelectModel? selectedDivision;
  JPSingleSelectModel? selectedTaxRate;
  
  MeasurementModel? measurement;

  FilesListingModel? estimate;
  
  bool isLoading = true;
  bool isInsuranceInfoUpdated = false;
  bool disableDivision = false;
  bool isSavingForm = false;
  bool isMeasurementApplied = false;

  String note = '';
  String fileName = '';
  String? xactimateFileName;

  num totalACV = 0;
  num totalRCV = 0;
  num totalTax = 0;
  num totalDeprecation = 0;

  Map<String, dynamic>? insurancePdfJson;
  Map<String, dynamic> initialJson = {}; // helps in data changes comparison

  // setFormData(): set-up form data to be pre-filled in form

  void setFormData() {
    setDivisionFromJob();
    WorksheetModel? worksheet = estimate?.worksheet!;
    if(worksheet != null) {
      titleController.text = worksheet.title ?? "";
      selectedDivision = JPSingleSelectModel(
        id: worksheet.division?.id.toString() ?? "",
        label: worksheet.division?.name.toString() ?? "",
      );
      divisionController.text = selectedDivision?.label ?? "";
      note = worksheet.note ?? '';
      if(!Helper.isValueNullOrEmpty(worksheet.lineItems)) {
          insuranceItems = worksheet.lineItems ??  [];
      }
      if(!Helper.isValueNullOrEmpty(worksheet.measurementId)){
        isMeasurementApplied = true;
        measurementId = worksheet.measurementId;
      } 
    }
    calculateValues();
  }

  void setDivisionFromJob() {
    selectedDivision = divisionsList.firstWhereOrNull((element) =>
      element.id == jobModel!.division?.id?.toString());

    if(selectedDivision  != null) {
      divisionController.text = selectedDivision!.label;
      disableDivision = true;
      update();
    }
  }

  double getRCV(SheetLineItemModel item){
    double price = 0.0;
    double qty = 0.0;
    double tax = 0.0;

    if(!Helper.isValueNullOrEmpty(item.price)) {
      price = double.parse(item.price.toString());
    }
    if(!Helper.isValueNullOrEmpty(item.qty)) {
      qty = double.parse(item.qty.toString());
    }
    if(!Helper.isValueNullOrEmpty(item.tax) ) {
      tax = double.parse(item.tax.toString());
    }

    return(price * qty + tax);   
  }

  ///////////////////////     CALCULATION    ////////////////////////
  void calculateValues() {
    totalACV = 0.0;
    totalRCV = 0.0;
    totalTax = 0.0;
    totalDeprecation = 0.0;

    for (var element in insuranceItems) {

      element.rcv = JobFinancialHelper.getRoundOff(getRCV(element), fractionDigits: 2);

      num rcv = num.parse(element.rcv ?? '0.0');
      
      if(Helper.isValueNullOrEmpty(element.depreciation)) {
        element.totalPrice = rcv.toString();  
      } else {
        element.totalPrice = (rcv - double.parse(element.depreciation ?? '0.0')).toString();
      }

      num acv = num.parse(element.totalPrice ?? "");
      
      totalACV += acv;
      totalRCV += rcv;
      
      if(!Helper.isValueNullOrEmpty(element.tax)){
        num tax = num.parse(element.tax!);
        totalTax += tax;
      }

      if(!Helper.isValueNullOrEmpty(element.depreciation)){
        num depreciateValue = num.parse(element.depreciation!);
        totalDeprecation += depreciateValue;
      }
    }
  }

  /////////////////////////////      API PARAMS     ////////////////////////////

  Map<String, dynamic> insuranceFormJson() {
   
    final data = <String, dynamic>{};
    data["job_id"] = jobModel!.id;
    data['division_name'] =  selectedDivision?.label ?? '';
    data['fromFavourite'] = false;
    data['isMobile'] = 1;
    data['type'] =  'xactimate';
    data['measurement_id'] = measurementId ?? '';
    data['name'] = fileName;
    data['title'] =  titleController.text;
    data["division_id"] = selectedDivision?.id ?? "";
    data['note'] = note;
    data['update_job_insurance'] = isInsuranceInfoUpdated ? 1 : 0;
    if (!Helper.isValueNullOrEmpty(xactimateFileName)) {
      data['xactimate_file'] = xactimateFileName;
    }
    data['details'] = insuranceItems.map((item) {
      int index = -1;
      index++;
      return item.toEstimateJson(index,);
    }).toList();

    data.addIf(pageType == InsuranceFormType.edit, 'id', worksheetId);
    return data;
  }

  void setInsuranceFormDataFromPdfJson(Map<String, dynamic> json) {
    
    insuranceItems = (json['table_data'] as List).map((e) {
      return SheetLineItemModel.fromInsurancePdfJson(e);
    }).toList();

    note = json['meta']['notes'];
    xactimateFileName = json['meta']['xactimate_file'];

    calculateValues();
    initialJson = insuranceFormJson();
  }
}