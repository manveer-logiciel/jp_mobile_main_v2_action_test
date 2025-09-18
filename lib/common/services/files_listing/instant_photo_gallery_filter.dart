    class InstantPhotoGalleryFilterModel {
      String? date;
      String? startDate;
      String? endDate;

    InstantPhotoGalleryFilterModel({
      this.date,
      this.startDate,
      this.endDate
    });

    InstantPhotoGalleryFilterModel.fromJson(Map<String, dynamic> json) {
      date = json['date'];
      startDate = json['start_date'];
      endDate = json['end_date'];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = <String, dynamic>{};
        data['date']= date;
        data['start_date'] = startDate;
        data['end_date'] = endDate;
        return data;
    }
  }