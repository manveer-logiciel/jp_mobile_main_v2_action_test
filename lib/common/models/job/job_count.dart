class JobCountModel {
  int? estimates;
  int? measurements;
  int? proposals;
  int? workOrders;
  int? materialLists;
  int? workCrewNotes;
  int? jobResources;
  int? stageResources;
  int? tasks;
  int? contracts;

  JobCountModel(
      {this.estimates,
      this.measurements,
      this.proposals,
      this.workOrders,
      this.materialLists,
      this.workCrewNotes,
      this.jobResources,
      this.stageResources,
      this.tasks,
      this.contracts,
      });

  JobCountModel.fromJson(Map<String, dynamic> json) {
    estimates = json['estimates'];
    measurements = json['measurements'];
    proposals = json['proposals'];
    workOrders = json['work_orders'];
    materialLists = json['material_lists'];
    workCrewNotes = json['work_crew_notes'];
    jobResources = json['job_resources'];
    stageResources = json['stage_resources'];
    tasks = json['tasks'];
    contracts = int.tryParse(json['contracts'].toString()) ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['estimates'] = estimates;
    data['measurements'] = measurements;
    data['proposals'] = proposals;
    data['work_orders'] = workOrders;
    data['material_lists'] = materialLists;
    data['work_crew_notes'] = workCrewNotes;
    data['job_resources'] = jobResources;
    data['stage_resources'] = stageResources;
    data['tasks'] = tasks;
    return data;
  }
}