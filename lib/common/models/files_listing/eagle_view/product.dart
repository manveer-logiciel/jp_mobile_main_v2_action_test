
class EagleViewProductModel {

  int? productID;
  String? name;
  String? description;
  String? productGroup;
  bool? isTemporarilyUnavailable;
  int? priceMin;
  int? priceMax;
  List<EagleViewProductModel?>? deliveryProducts;
  List<EagleViewProductModel?>? addOnProducts;
  List<int?>? measurementInstructionTypes;
  int? typeOfStructure;
  bool? isRoofProduct;
  int? sortOrder;
  bool? allowsUserSubmittedPhotos;
  String? detailedDescription;
  List<int?>? deliveryProductIds;

  EagleViewProductModel({
    this.productID,
    this.name,
    this.description,
    this.productGroup,
    this.isTemporarilyUnavailable,
    this.priceMin,
    this.priceMax,
    this.deliveryProducts,
    this.addOnProducts,
    this.measurementInstructionTypes,
    this.typeOfStructure,
    this.isRoofProduct,
    this.sortOrder,
    this.allowsUserSubmittedPhotos,
    this.detailedDescription,
  });

  EagleViewProductModel.fromJson(Map<String, dynamic> json) {
    productID = int.tryParse(json['productID']?.toString() ?? '');
    name = json['name']?.toString();
    description = json['description']?.toString();
    productGroup = json['productGroup']?.toString();
    isTemporarilyUnavailable = json['isTemporarilyUnavailable'];
    priceMin = int.tryParse(json['priceMin']?.toString() ?? '');
    priceMax = int.tryParse(json['priceMax']?.toString() ?? '');
    if (json['deliveryProducts'] != null && (json['deliveryProducts'] is List)) {
      deliveryProducts = <EagleViewProductModel>[];
      json['deliveryProducts'].forEach((dynamic value) {
        deliveryProducts!.add(EagleViewProductModel.fromJson(value));
      });
    }
    if (json['deliveryProductIds'] != null && (json['deliveryProductIds'] is List)) {
      deliveryProductIds = <int>[];
      json['deliveryProductIds'].forEach((dynamic value) {
        deliveryProductIds!.add(int.tryParse(value.toString()));
      });
    }

    detailedDescription = json['DetailedDescription']?.toString();

    if (json['addOnProducts'] != null && (json['addOnProducts'] is List)) {
      addOnProducts = <EagleViewProductModel>[];
      json['addOnProducts'].forEach((dynamic value) {
        addOnProducts!.add(EagleViewProductModel.fromJson(value));
      });
    }
    if (json['measurementInstructionTypes'] != null && (json['measurementInstructionTypes'] is List)) {
      measurementInstructionTypes = <int>[];
      json['measurementInstructionTypes'].forEach((dynamic value) {
        measurementInstructionTypes!.add(int.tryParse(value.toString()));
      });
    }
    typeOfStructure = int.tryParse(json['TypeOfStructure']?.toString() ?? '');
    isRoofProduct = json['IsRoofProduct'];
    sortOrder = int.tryParse(json['SortOrder']?.toString() ?? '');
    allowsUserSubmittedPhotos = json['AllowsUserSubmittedPhotos'];
    detailedDescription = json['DetailedDescription']?.toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['productID'] = productID;
    data['name'] = name;
    data['description'] = description;
    data['productGroup'] = productGroup;
    data['isTemporarilyUnavailable'] = isTemporarilyUnavailable;
    data['priceMin'] = priceMin;
    data['priceMax'] = priceMax;
    if (deliveryProducts != null) {
      data['deliveryProducts'] = <dynamic>[];
      for (var value in deliveryProducts!) {
        data['deliveryProducts'].add(value!.toJson());
      }
    }
    if (deliveryProductIds != null) {
      data['deliveryProductIds'] = <dynamic>[];
      for (var value in deliveryProductIds!) {
        data['deliveryProductIds'].add(value);
      }
    }
    if (addOnProducts != null) {
      data['addOnProducts'] = <dynamic>[];
      for (var value in addOnProducts!) {
        data['addOnProducts'].add(value!.toJson());
      }
    }
    if (measurementInstructionTypes != null) {
      data['measurementInstructionTypes'] = <dynamic>[];
      for (var value in measurementInstructionTypes!) {
        data['measurementInstructionTypes'].add(value);
      }
    }
    data['TypeOfStructure'] = typeOfStructure;
    data['IsRoofProduct'] = isRoofProduct;
    data['SortOrder'] = sortOrder;
    data['AllowsUserSubmittedPhotos'] = allowsUserSubmittedPhotos;
    data['DetailedDescription'] = detailedDescription;
    return data;
  }
}