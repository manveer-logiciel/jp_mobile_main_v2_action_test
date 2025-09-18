class PlacesAutoCompleteModel {
  String? description;
  String? placeId;
  String? reference;
  List<PlacesAutoCompleteModel?>? terms;
  int? offset;
  String? value;

  PlacesAutoCompleteModel({
    this.description,
    this.placeId,
    this.reference,
    this.terms,
    this.offset,
    this.value,
  });

  PlacesAutoCompleteModel.fromJson(Map<String, dynamic> json) {
    description = json['description']?.toString();
    placeId = json['place_id']?.toString();
    reference = json['reference']?.toString();
    offset = int.tryParse(json['offset']?.toString() ?? '');
    value = json['value']?.toString();
    if (json['terms'] != null && (json['terms'] is List)) {
      terms = <PlacesAutoCompleteModel>[];
      json['terms'].forEach((dynamic term) {
        terms!.add(PlacesAutoCompleteModel.fromJson(term));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['description'] = description;
    data['place_id'] = placeId;
    data['reference'] = reference;
    if (terms != null) {
      data['terms'] = <dynamic>[];
      for (var term in terms!) {
        data['terms'].add({
          'offset': term?.offset,
          'value': term?.value,
        });
      }
    }
    return data;
  }
}
