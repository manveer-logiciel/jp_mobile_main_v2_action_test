class RecipientModel{
String? email;
String? type;
String? deliveryDateTime;
String? bounceDateTime;

RecipientModel(
this.email,
this.type,
this.deliveryDateTime,
this.bounceDateTime,
);

RecipientModel.fromJson(Map<dynamic, dynamic> json){
  email =json['email'];
  type =json['type'];
  deliveryDateTime=json['delivery_date_time'];
  bounceDateTime=json['bounce_date_time'];
}

Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['title'] = type;
    data['notes'] = deliveryDateTime;
    data['due_date'] = bounceDateTime;
    return data;
  
}
}