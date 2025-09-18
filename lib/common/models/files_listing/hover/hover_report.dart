class ReportFile {
  int? id;
  int? hoverJobId;
  String? filePath;
  String? fileName;
  String? fileMimeType;
  String? fileSize;

  ReportFile({
    this.id,
    this.hoverJobId,
    this.filePath,
    this.fileName,
    this.fileMimeType,
    this.fileSize
  });

  ReportFile.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    hoverJobId = json['hover_job_id'];
    filePath = json['file_path'] ?? json['file_url'];
    fileName = json['file_name'] ?? json['name'];
    fileMimeType = json['file_mime_type'];
    if(json['file_size'] != null) {
      fileSize = json['file_size'].toString();
    } else {
      fileSize = json['size'].toString();
    }
  }

}
