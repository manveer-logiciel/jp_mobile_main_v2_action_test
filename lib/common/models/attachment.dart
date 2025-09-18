import 'package:jobprogress/common/models/files_listing/files_listing_model.dart';
import 'package:jobprogress/core/constants/urls.dart';
import 'package:jobprogress/core/utils/file_helper.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jp_mobile_flutter_ui/Thumb/icon_type.dart';

import '../enums/file_listing.dart';

class AttachmentResourceModel {
  late int id;
  int? jobId;
  int? parentId;
  String? name;
  int? size;
  String? path;
  String? mimeType;
  String? createdAt;
  String? updatedAt;
  String? url;
  String? filePath;
  String? thumbUrl;
  late bool isImage;
  String? type;
  late double downloadProgress;
  String? localUrl;
  String? extensionName;
  JPThumbIconType? iconType;
  String? classType;
  FLModule? moduleType;

  AttachmentResourceModel(
      {required this.id,
      this.parentId,
      this.name,
      this.size,
      this.filePath,
      this.path,
      this.mimeType,
      this.createdAt,
      this.updatedAt,
      this.url,
      this.thumbUrl,
      this.downloadProgress = 0,
      this.isImage = false,
      this.type = 'resource',
      this.localUrl,
      this.extensionName,
      this.iconType,
      this.moduleType,
      this.classType,
      });

  AttachmentResourceModel.fromMaterialListJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['file_name'];
    size = json['file_size'];
    path = json['file_path'];
    mimeType = json['mfile_mime_type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    url = json['file_path'];
    thumbUrl = json['thumb'];
    downloadProgress = 0;

    if(filePath != null) {
      extensionName = FileHelper.getFileExtension(filePath!);
    } else if(path != null) {
      extensionName = FileHelper.getFileExtension(path!);
    } else if(url != null) {
      extensionName = FileHelper.getFileExtension(url!);
    }

    if(extensionName != null) {
      iconType = Helper.getIconTypeAccordingToExtension("", extensionName: extensionName);
    }
  }

  AttachmentResourceModel.fromInvoiceListJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['title'];
    path = json['file_path'];
    type = 'invoice';
    createdAt = json['created_at'];
    size = int.parse(json['file_size']);
    extensionName =FileHelper.getFileExtension(path!);
    iconType = Helper.getIconTypeAccordingToExtension("", extensionName: extensionName);
    url = json['file_path'];
    downloadProgress = 0;
  }

  AttachmentResourceModel.fromPaymentSlipJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    size = json['size'];
    type = 'resource';
    filePath = json['original_file_path'];
    path = json['path'];
    parentId = json['parent_id'];
    mimeType = json['mime_type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    url = json['url'];
    downloadProgress = 0;
    if(filePath != null) {
      extensionName = FileHelper.getFileExtension(filePath!);
    } else if(path != null) {
      extensionName = FileHelper.getFileExtension(path!);
    } else if(url != null) {
      extensionName = FileHelper.getFileExtension(url!);
    }

    if(extensionName != null) {
      iconType = Helper.getIconTypeAccordingToExtension("", extensionName: extensionName);
    }
    isImage = FileHelper.checkIfImage(url ?? "");
  }

  AttachmentResourceModel.fromSrsOrderForm(Map<String, dynamic> json) {
    id =  int.tryParse(json['id']?.toString() ?? "") ?? -1;
    name = json['file_name'];
    filePath = json['file_path'];
    path = json['file_path'];
    parentId = json['resource_id'];
    url = Urls.srsOrderAttachmentUrl(filePath ?? '');
    isImage = FileHelper.checkIfImage(url ?? "");
    downloadProgress = 0;
    extensionName = FileHelper.getFileExtension(url!);
    iconType = Helper.getIconTypeAccordingToExtension("", extensionName: extensionName);
    type = 'resource';
  }

  AttachmentResourceModel.fromEmailJson(Map<String, dynamic> json, FLModule from) {
    id = int.tryParse(json['id']?.toString() ?? "") ?? -1;
    parentId = json['parent_id'];
    name = json['file_name'];
    size = json['file_size'];
    path = json['path'];
    filePath = json['file_path'];
    mimeType = json['mime_type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    url = json['url'];
    thumbUrl = json['thumb_url'];
    downloadProgress = 0;
    type = Helper.resourceType(from);
    localUrl = json['local_url'];
    isImage = FileHelper.checkIfImage(thumbUrl ?? url ?? "");

    if(filePath != null) {
      extensionName = FileHelper.getFileExtension(filePath!);
    } else if(path != null) {
      extensionName = FileHelper.getFileExtension(path!);
    } else if(url != null) {
      extensionName = FileHelper.getFileExtension(url!);
    }

    if(extensionName != null) {
      iconType = Helper.getIconTypeAccordingToExtension("", extensionName: extensionName);
    }
  }

  AttachmentResourceModel.fromJson(Map<String, dynamic> json) {
    id = int.tryParse(json['id']?.toString() ?? "") ?? -1;
    parentId = json['parent_id'];
    name = json['name'];
    size = json['size'];
    url = json['url'] ?? json['image'];
    path = json['path'] ?? json['image'] ?? url;
    filePath = json['file_path'];
    mimeType = json['mime_type'];
    createdAt = json['created_at'];
    classType = json['class_type'] ?? '';
    updatedAt = json['updated_at'];
    thumbUrl = json['thumb_url'];
    downloadProgress = 0;
    type = json['type'] ?? 'resource';
    localUrl = json['local_url'];
    isImage = FileHelper.checkIfImage(thumbUrl ?? url ?? "");

    if(filePath != null) {
      extensionName = FileHelper.getFileExtension(filePath!);
    } else if(path != null) {
      extensionName = FileHelper.getFileExtension(path!);
    } else if(url != null) {
      extensionName = FileHelper.getFileExtension(url!);
    }

    if(extensionName != null) {
      iconType = Helper.getIconTypeAccordingToExtension("", extensionName: extensionName);
    }
  }

  factory AttachmentResourceModel.fromFileModel(FilesListingModel file, FLModule? type) {
    
    return AttachmentResourceModel(
      id: int.parse(file.id.toString()),
      extensionName: FileHelper.getFileExtension(file.path!),
      name: file.name,
      url: file.url,
      filePath: file.path,
      iconType: file.jpThumbIconType,
      size: file.size,
      type: Helper.resourceType(type),
    );
  }

  factory AttachmentResourceModel.fromAttachmentResourceModel(AttachmentResourceModel file) {
    return AttachmentResourceModel(
      id: int.parse(file.id.toString()),
      extensionName: FileHelper.getFileExtension(file.path!),
      name: file.name,
      url: file.url,
      filePath: file.path,
      type: file.type,
      iconType: file.iconType,
      thumbUrl: file.thumbUrl,
      isImage: file.isImage,
      path: file.path,
      size: file.size,
      localUrl: file.localUrl,
      moduleType: file.moduleType,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['parent_id'] = parentId;
    data['name'] = name;
    data['size'] = size;
    data['path'] = path;
    data['file_path'] = filePath;
    data['mime_type'] = mimeType;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['url'] = url;
    data['thumb_url'] = thumbUrl;
    // Include type field for consistency with other attachment handling code
    data['type'] = type ?? 'resource';
    return data;
  }

  Map<String, dynamic> toMaterialListJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['file_name'] = name;
    data['file_size'] = size;
    data['file_path'] = path;
    data['mfile_mime_type'] = mimeType;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['file_path'] = url;
    data['thumb'] = thumbUrl;
    return data;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AttachmentResourceModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          jobId == other.jobId &&
          parentId == other.parentId &&
          name == other.name &&
          size == other.size &&
          path == other.path &&
          mimeType == other.mimeType &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt &&
          url == other.url &&
          filePath == other.filePath &&
          thumbUrl == other.thumbUrl &&
          isImage == other.isImage &&
          type == other.type &&
          downloadProgress == other.downloadProgress &&
          localUrl == other.localUrl &&
          extensionName == other.extensionName &&
          iconType == other.iconType &&
          moduleType == other.moduleType;

  @override
  int get hashCode =>
      id.hashCode ^
      jobId.hashCode ^
      parentId.hashCode ^
      name.hashCode ^
      size.hashCode ^
      path.hashCode ^
      mimeType.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      url.hashCode ^
      filePath.hashCode ^
      thumbUrl.hashCode ^
      isImage.hashCode ^
      type.hashCode ^
      downloadProgress.hashCode ^
      localUrl.hashCode ^
      extensionName.hashCode ^
      iconType.hashCode ^
      moduleType.hashCode;
}
