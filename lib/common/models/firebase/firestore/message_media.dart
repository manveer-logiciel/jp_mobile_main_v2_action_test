
import 'package:jobprogress/core/utils/file_helper.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jp_mobile_flutter_ui/Thumb/icon_type.dart';

class MessageMediaModel {
  late int id;
  String? messageSid;
  String? mediaUrl;
  String? shortUrl;
  String? fileName;
  String? fileExtension;
  JPThumbIconType? thumbIconType;

  MessageMediaModel({
    required this.id,
    this.messageSid,
    this.mediaUrl,
    this.shortUrl,
    this.fileName,
  });

  /// [filePath] gives the path of the file from where it can be downloaded
  String? get filePath => (mediaUrl ?? shortUrl);

  MessageMediaModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    messageSid = json['message_sid'];
    mediaUrl = json['media_url'];
    shortUrl = json['short_url'];
    if(mediaUrl != null) {
      fileName = FileHelper.getFileName(mediaUrl!);
      fileExtension = FileHelper.getFileExtension(mediaUrl!);
      fileName?.replaceAll(fileExtension!, '');
      thumbIconType = Helper.getIconTypeAccordingToExtension(mediaUrl!);
    } else {
      fileName = shortUrl;
      thumbIconType = JPThumbIconType.url;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['message_sid'] = messageSid;
    data['media_url'] = mediaUrl;
    data['short_url'] = shortUrl;
    return data;
  }
}
