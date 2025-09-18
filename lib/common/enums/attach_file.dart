
enum AttachFileType {
  camera,
  gallery,
  document,
  photosDocument,
  invoices,
  depositReceipts,
  measurements,
  estimates,
  proposals,
  materials,
  workOrders,
  companyFiles,
  stageResources,
  companyCam
}

enum AttachmentOptionType {
  jobDependent, // displays limited option when job id is not there, otherwise display all the options,
  dynamicImage,
  imageTemplate,
  attachPhoto,
  attachWorksheetPhoto,
  srsOrderAttachment
}