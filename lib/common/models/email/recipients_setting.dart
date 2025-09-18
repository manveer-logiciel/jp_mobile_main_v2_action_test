class RecipientSettingModel{
List<String> to = [];
List<String> bcc = [];
List<String> cc =[];


RecipientSettingModel(
this.to,
this.cc,
this.bcc
);

RecipientSettingModel.fromJson(Map<dynamic, dynamic> json){
  to = json['to'].cast<String>();
  cc = json['cc'].cast<String>();
  bcc = json['bcc'].cast<String>();
}

Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['to'] = to;
    data['cc'] = cc;
    data['bcc'] = bcc;
    return data;
  
}
}