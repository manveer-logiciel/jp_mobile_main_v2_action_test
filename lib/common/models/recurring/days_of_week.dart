class DaysOfWeekModel {
  String value;
  String id;
  String label;
  bool isActive = false;
  
  DaysOfWeekModel({
   required this.value,
   required this.id,
   required this.label,
   this.isActive = false
  });
}