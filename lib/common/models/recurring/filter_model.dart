class RecurringFilterModel {
  String repeatDuration;
  int interval;
  List<String>? byDays;
  String? monthData;
  int? occurance;
  String? jobEndStageCode;
  String? jobCurrentStageCode;

  RecurringFilterModel({
   this.monthData,
   this.byDays,
   required this.interval,
   this.jobCurrentStageCode,
   this.jobEndStageCode,
   this.occurance,
   required this.repeatDuration
  });
}
