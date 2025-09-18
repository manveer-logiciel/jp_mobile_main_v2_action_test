enum JobQuickActionCallbackType {
  navigateToDetailScreenCallback,
  flagCallback,
  markAsLostJobCallback,
  reinstateJob,
  addToProgressBoard,
  archive,
  unarchive,
  customer,
  appointment,
  createAnAppointment,
  scheduleJob,
  markAsAwarded,
  /// [openProgressBoardCallback] handles the callback whenever the progress board
  /// is opened from progress board tray
  openProgressBoardCallback
}