class ProductionBoardColumn {

  int? id;
  String? name;
  int? boardId;
  bool? theDefault;
  int? sortOrder;
  String? createdAt;
  String? updatedAt;

  ProductionBoardColumn({
    this.id,
    this.name,
    this.boardId,
    this.theDefault,
    this.sortOrder,
    this.createdAt,
    this.updatedAt,
  });

  ProductionBoardColumn.fromJson(Map<String, dynamic> json) {
    id = int.tryParse(json['id']?.toString() ?? '');
    name = json['name']?.toString();
    boardId = int.tryParse(json['board_id']?.toString() ?? '');
    theDefault = json['default'];
    sortOrder = int.tryParse(json['sort_order']?.toString() ?? '');
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['board_id'] = boardId;
    data['default'] = theDefault;
    data['sort_order'] = sortOrder;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}