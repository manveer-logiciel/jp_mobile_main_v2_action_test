
enum RealTimeKeyType {
  taskPending,
  messageUnread,
  messageUnreadLocal,
  notificationUnread,
  emailUnread,
  isRestricted,
  taskTodayUpdated,
  taskUpcomingUpdated,
  appointmentTodayUpdated,
  appointmentUpcomingUpdated,
  eventTodayUpdated,
  scheduleTodayUpdated,
  permissionUpdated,
  workflowUpdated,
  job,
  textMessageUnread,
  textMessageUnreadLocal,
  checkInCheckOutWithOutJob,
  checkInJob,
  userSettingUpdated,
  companySettingUpdated,
  companyStateLastUpdatedTime,
  userLastUpdatedTime,
  divisionLastUpdatedTime,
  tagsLastUpdatedTime,
  companyTradesLastUpdatedTime,
  customerFlagsUpdatedTime,
  jobFlagsLastUpdatedTime,
  companyWorkflowLastUpdatedTime,
  referralsLastUpdatedTime,
  beaconConnectionStatusUpdatedAt,
  automationFeedUpdated
}

enum RealTimeResult {
  add,
  firstValue,
}

enum FireStoreKeyType {
  unreadMessageCount,
}