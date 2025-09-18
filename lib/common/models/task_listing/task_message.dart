class TaskMessageModel {
  String? content;
  String? firebaseMessageId;
  int? id;
  String? subject;
  String? threadId;
  String? createdAt;

  TaskMessageModel({this.content,
        this.createdAt,
        this.firebaseMessageId,
        this.id,
        this.subject,
        this.threadId,
  });

  TaskMessageModel.fromJson(Map<String, dynamic> json) {
    content = json['content'];
    createdAt = json['created_at'];
    firebaseMessageId = json['firebase_message_id'];
    id = json['id'];
    subject = json['subject'];
    threadId = json['thread_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['content'] = content;
    data['created_at'] = createdAt;
    data['firebase_message_id'] = firebaseMessageId;
    data['id'] = id;
    data['subject'] = subject;
    data['thread_id'] = threadId;
    return data;
  }
}
