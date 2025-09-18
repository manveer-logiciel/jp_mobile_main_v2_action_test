class ReminderModel {
  int? id;
  String? type;
  String? minutes;
  String? duration;

  ReminderModel({
    this.id,
    this.type,
    this.minutes,
    this.duration
  });

  ReminderModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    minutes = json['minutes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;
    data['minutes'] = minutes;
    return data;
  }
}
