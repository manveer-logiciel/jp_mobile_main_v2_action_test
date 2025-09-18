class CustomFormFieldSubOption {
  int? id;
  String? name;
  int? active;
  int? order;
  int? totalLinkedJobs;
  int? totalLinkedCustomers;
  int? parentId;
  List<CustomFormFieldSubOption>? linkedParentOptions;

  CustomFormFieldSubOption({
    this.id,
    this.name,
    this.active,
    this.order,
    this.totalLinkedJobs,
    this.totalLinkedCustomers,
    this.parentId,
  });

  CustomFormFieldSubOption.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    active = json['active'];
    order = json['order'];
    totalLinkedJobs = json['total_linked_jobs'];
    totalLinkedCustomers = json['total_linked_customers'];
    parentId = json['parent_id'];
    if(json['linked_parent_options']?['data']?.isNotEmpty ?? false) {
      linkedParentOptions = [];
      json['linked_parent_options']?['data']?.forEach((dynamic option) {
        linkedParentOptions?.add(CustomFormFieldSubOption.fromJson(option));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['active'] = active;
    data['order'] = order;
    data['total_linked_jobs'] = totalLinkedJobs;
    data['total_linked_customers'] = totalLinkedCustomers;
    data['parent_id'] = parentId;
    return data;
  }
}
