
class JobRequestParams {

  static Map<String, dynamic> forJobSummary(int jobId, {
    List<dynamic> additionalIncludes = const [],
  }) {
    return <String, dynamic>{
      'id': jobId,
      'includes[0]': 'count:with_ev_reports(true)',
      'includes[1]': 'job_message_count',
      'includes[2]': 'upcoming_appointment_count',
      'includes[3]': 'Job_note_count',
      'includes[4]': 'job_task_count',
      'includes[5]': 'upcoming_appointment',
      'includes[6]': 'job_workflow_history',
      'includes[7]': 'workflow',
      "includes[8]":"contact",
      "includes[9]":"contacts.emails",
      "includes[10]":"contacts.phones",
      "includes[11]":"contacts.address",
      "includes[12]":"customer.referred_by",
      "includes[13]":"upcoming_appointment_count",
      "includes[14]":"job_message_count",
      "includes[15]": "flags",
      "includes[16]": "production_boards",
      "includes[17]": "division",
      "includes[18]": "hover_job",
      "includes[19]": "hover_job.hover_user",
      "include[20]": "ev_order",
      "includes[21]": "custom_fields",
      "includes[22]":"custom_fields.options.sub_options",
      "includes[23]": "insurance_details",
      "includes[24]": "job_invoices",
      "includes[25]": "financial_details",
      "includes[26]": "flags.color",
      'incomplete_task_lock_count': 1,
      'track_job': 1,
      for (int i = 0; i < additionalIncludes.length; i++)
        'includes[${27 + i}]': additionalIncludes[i],
    };
  }

}