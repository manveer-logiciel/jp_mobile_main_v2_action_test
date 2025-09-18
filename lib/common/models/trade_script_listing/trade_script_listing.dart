import 'package:jobprogress/common/models/snippet_listing/snippet_listing.dart';

class TradeScriptListModel {
  SnippetListModel? snippetListModel;
  String? type;
  bool? forAllTrades;
  String? createdAt;
  String? updatedAt;

  TradeScriptListModel(
      {this.snippetListModel,
        this.type,
        this.forAllTrades,
        this.createdAt,
        this.updatedAt});

  TradeScriptListModel.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    forAllTrades = json['for_all_trades'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    snippetListModel = SnippetListModel.fromJson(json);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = snippetListModel!.id;
    data['title'] = snippetListModel!.title;
    data['description'] = snippetListModel!.description;
    data['type'] = type;
    data['for_all_trades'] = forAllTrades;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
