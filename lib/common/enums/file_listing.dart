// FL depicts FileListing

// FLModule can be used as differentiator between different modules for same page/screen
enum FLModule {
  companyFiles,
  estimate,
  jobPhotos,
  jobProposal,
  measurements,
  materialLists,
  workOrder,
  stageResources,
  userDocuments,
  customerFiles,
  instantPhotoGallery,
  dropBoxListing,
  financialInvoice,
  companyCamProjects,
  companyCamImagesFromJob,
  companyCamProjectImages,
  cumulativeInvoices,
  templates,
  favouriteListing,
  mergeTemplate,
  attachmentInvoice,
  googleSheetTemplate,
  paymentReceipt,
  templatesListing,
  /// [jobContracts] help to differentiate Job Contracts from other modules
  /// which further helps in having its own unique handling.
  jobContracts,
}

// FLQuickActions contain all the quick actions for FileListing module
// it is not bounded to any specific module
enum FLQuickActions {
  rename,
  print,
  move,
  rotate,
  expireOn,
  delete,
  info,
  clockWise90degree,
  clockWise180degree,
  antiClockWise90degree,
  view,
  edit,
  showOnCustomerWebPage,
  removeFromCustomerWebPage,
  sendViaText,
  sendViaDevice,
  sendViaJobProgress,
  share,
  viewLinkedForm,
  viewLinkedWorkOrder,
  viewLinkedMaterialList,
  viewLinkedMeasurement,
  generateMaterialList,
  generateSRSOrderForm,
  generateBeaconOrderForm,
  generateABCOrderForm,
  placeSRSOrder,
  placeBeaconOrder,
  placeABCOrder,
  generateWorkOrder,
  generateForm,
  syncWithQBD,
  generateWorkSheet,
  markAsFavourite,
  unMarkAsFavourite,
  markAsCompleted,
  markAsPending,
  assignTo,
  insurancePdf,
  updateJobPrice,
  email,
  editPhoto,
  signTemplateFormProposal,
  worksheetSignFormProposal,
  openPublicForm,
  viewLinkedInvoice,
  formProposalNote,
  updateStatus,
  viewLinkedInvoices,
  makeACopy,
  viewLinkedEstimate,
  generateJobInvoice,
  updateJobInvoice,
  viewMeasurementValues,
  hoverImages,
  open3DModel,
  viewReports,
  viewReportsSubOption,
  viewInfo,
  setDeliveryDate,
  editWorkOrder,
  schedule,
  copyToJob,
  moveToJob,
  viewLinkedJobSchedules,
  viewOrderDetails,
  viewBeaconOrderDetails,
  viewDeliveryDate,
  upgradeToHoverRoofOnly,
  upgradeToHoverRoofComplete,
  viewCumulativeInvoice,
  printCumulativeInvoice,
  emailCumulativeInvoice,
  cumulativeInvoiceNote,
  upload,
  quickMeasure,
  eagleView,
  measurementForm,
  editMeasurement,
  editInsurance,
  hover,
  createInsurance,
  dropBox,
  editProposalTemplate,
  editProposalWorksheet,
  jobFormProposalMerge,
  jobFormProposalTemplate,
  unsavedResourceUpdated,
  editWorksheet,
  worksheet,
  insurance,
  uploadInsurance,
  handwrittenTemplate,
  editEstimateTemplate,
  createChangeOrder,
  createInvoice,
  materialList,
  viewLinkedSRSOrderForm,
  viewLinkedBeaconOrderForm,
  viewLinkedABCOrderForm,
  spreadSheetTemplate,
  newSpreadsheet,
  uploadExcel,
  editGoogleSheet,
  editUnsavedResource,
  deleteUnsavedResource,
  viewCompanyCamPhotos,
  unlinkCompanyCam,
  linkJobToCompanyCam,
  smallDropBox,
  chooseSupplierSettings
}

// FLViewMode is also a differentiator between file lisitng view mode
enum FLViewMode {
  ///[FLViewMode.view] can be used to view simple listing
  /// in which user can view files or download files
  view,

  ///[FLViewMode.attach] in this view on tap of files user
  /// will select files to attach
  attach,

  ///[FLViewMode.move] in this view on tap of files user
  /// will select files to move
  move,

  ///[FLViewMode.copy] in this view on tap of files user
  /// will select files to copy
  copy,

  ///[FLViewMode.moveToJob] in this view on tap of files user
  /// will select files to move to a job
  moveToJob,

  ///[FLViewMode.apply] in this view on tap of files user
  /// will select files to apply
  apply
}
