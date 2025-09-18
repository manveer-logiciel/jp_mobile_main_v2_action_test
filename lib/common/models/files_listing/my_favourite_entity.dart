class MyFavouriteEntity {
  int? id;
  String? name;
  String? type;
  int? entityId;
  int? markedBy;
  int? forAllTrades;
  int? forAllUsers;

  MyFavouriteEntity(
      {this.id,
        this.name,
        this.type,
        this.entityId,
        this.markedBy,
        this.forAllTrades,
        this.forAllUsers});

  MyFavouriteEntity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    type = json['type'];
    entityId = json['entity_id'];
    markedBy = json['marked_by'];
    forAllTrades = json['for_all_trades'] is bool ? json['for_all_trades'] ? 1: 0 : json['for_all_trades'];
    forAllUsers = json['for_all_users'] is bool ? json['for_all_users'] ? 1 : 0 : json['for_all_users'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['type'] = type;
    data['entity_id'] = entityId;
    data['marked_by'] = markedBy;
    data['for_all_trades'] = forAllTrades;
    data['for_all_users'] = forAllUsers;
    return data;
  }
}
