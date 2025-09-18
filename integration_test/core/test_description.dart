import 'dart:core';

class TestDescription {
  static const String  connectivityPlusGroupDesc = 'Connectivity Plus Plugin: ';

  static const String  connectivityPlusTestDesc = 'Device should be connected on active network';

  static const String  deviceInfoTestDesc = 'Device info should be visible';

  static const String  deviceInfoGroupDesc = 'Device Info Plugin: ';

  static const String  easyMaskGroupDesc = 'Easy Mask Plugin: ';

  static const String  easyMaskTestDesc = 'Mobile number should be masked';

  static const String  filePickerGroupDesc = 'File Picker Plugin: ';

  static const String  pickImageFileTestDesc = 'File manager should be open for images';

  static const String  pickDocumentFileTestDesc = 'File manager should be open for document';

  static const String  pickScannedDocumentFileTestDesc = 'Scanner should be open for scaning';

  static const String  inAppWebViewGroupDesc = 'InAppWebView Plugin: ';

  static const String  inAppWebViewTestDesc = 'WebView should be loaded';

  static const String  flutterToastTestDesc = 'Toast should be visible';

  static const String  flutterWidgetFromHtmlCoreGroupDesc = 'Flutter Widget From Html Core Plugin: ';

  static const String  flutterWidgetFromHtmlCoreTestDesc = 'Html widget should be loaded';

  static const String  geoLocationGroupDesc = 'GeoLocation Plugin: ';

  static const String  geoLocationTestDesc = 'Address should be fetched & shown';

  static const String  imagePickerGroupDesc = 'Image Picker Plugin: ';

  static const String  imagePickerTestDesc = 'Image should be taken from camera';

  static const String  loginGroupDesc = 'Login page should validate: ';

  static const String  withoutEmailLoginTestDesc = 'When email is empty or not entered';

  static const String  withoutPasswordLoginTestDesc = 'When password is empty or not entered';

  static const String  withoutCredentialLoginTestDesc = 'When credential are not filled or not entered';

  static const String  incorrectCredentialLoginTestDesc = 'When credential are incorrect';

  static const String  correctCredentialLoginTestDesc = 'When credential are correct';

  static const String  openFileGroupDesc = 'Open File Plugin: ';

  static const String  openFileTestDesc = 'File should be open';

  static const String  printingFileGroupDesc = 'Printing File Plugin: ';

  static const String  printingFileTestDesc = 'Print view should be open';

  static const String  scrollToIndexGroupDesc = 'Scroll To Index Plugin: ';

  static const String  scrollToIndexTestDesc = 'Job WorkFlow should scroll to specific index';

  static const String  sharedPrefGroupDesc = 'Shared Preference Plugin: ';

  static const String  sharedPrefTestDesc = 'User data should be saved & read from shared preference';

  static const String  sqfLiteGroupDesc = 'SqfLite Plugin: ';

  static const String  sqfLiteTestDesc = 'Divisions should be fetched from local database & displayed';

  static const String  urlLauncherGroupDesc = 'Url Launcher Plugin: ';

  static const String  launchNativeDialPadTestDesc = 'Native dial pad should be open ';

  static const String  openGoogleMapTestDesc = 'Google map should be open ';

  static const String  openTermAndConditionTestDesc = 'Should open Terms & Conditions link';

  static const String  insuranceDetailsGroupDesc = 'Insurance Details: ';

  static const String  jobNoteFormGroupDesc = 'Job Note Form: '; 
  
  static const String  measurementFormGroupDesc = 'Measurement Form: ';

  static const String  taskListingGroupDesc = 'Task Listing: ';

  static const String  insuranceDetailsTestDesc = 'Create Insurance Details Form';

  static const String  addEditJobNoteFormTestDesc = 'Add/Edit Job Note Form';

  static const String  openEndDrawerTestDesc = 'Should open end drawer to select section';

  static const String openSecondaryDrawerTestDesc = 'Should open secondary drawer to select section';

  static const String clickOnAddButton = 'Should show add bottom sheet by clicked on add button';

  static const String clickOnMeasurement = 'Should show more add action of measurement by clicked on measurement section';

  static const String clickOnJobNotes = 'Should show job note add form by clicked on job notes section';

  static const String clickOnMeasurementForm = 'Show add measurement form by clicked on measurement form option';

  static const String addButtonActionDesc = 'Should go back to previous screen & update data in measurement form when clicked on add button' ;

  static const String deleteActionDesc = "Should delete table's element when click on delete option" ;

  static const String addNewMeasurementDesc = 'Should add new measurement in the measurement table' ;

  static const String navToAddMultipleTable = 'Should show multiple measurement table screen when clicked on add multiple button';

   static const String editButtonActionDesc = 'Should show multiple measurement table screen when clicked on edit button';

  static const String checkPleaseEnterMeasurementValueCase = 'Should show toast message when no data entered in input field';

  static const String  fillingZeroInField = 'Filling zero in  form field';

  static const String  validationDesc = "Should show validation when invalid data enter in form's field ";

  static const String fillingValidInField = 'Filling valid data in form';

  static const String checkPleaseEnterMeasurementValueCaseByZero = 'Should show toast message when only zero are entered in input field';

  static const String shouldClickOnSaveButton = 'Should click on save Button for opening measurement name dialog box';

  static const String shouldShowValidateErrorInMeasurement = 'Should show "validate error" when measurement name is empty ';

  static const String saveButtonDesc = 'Should show save dialog box when clicked on save button';

  static const String updateButtonDesc = 'Should save updated data when clicked on update button';

  static const String  shouldSaveMeasurementWhenNameEnter = 'Should save measurement when measurement name is not empty';

  static const String shouldEnterValidMeasurementName = 'Should enter measurement name in inputBox';

  static const String  clickToRecentJobsDrawerItemTestDesc = 'Should show recent jobs list by tapping on "recent jobs" section';

  static const String  clickToCompanyContactDrawerItemTestDesc = 'Should show company contact page by tapping on "company contact" section';

  static const String  selectFirstJobFromListTestDesc = 'Should show job summary page by tapping on "first recent job" from list';

  static const String clickOnConfirmationButtonTestDesc = 'Should added attachment in add job Note Form when clicked on confirmation button';

  static const String  clickToAddJobDrawerItemTestDesc = 'Should show add job form by tapping on "add job" section';

  static const String jobNoteSaveButtonClickDesc = 'Should save job note when clicked on save button';

  static const String jobNoteUpdateButtonClickDesc = 'Should update job note when clicked on update button';

  static const String enterNewTextInFieldTestDesc = 'Enter new text in job note input field';

  static const String removeAttachmentTestDesc = 'Should remove attachment from attachment list when click on cross icon';

  static const String  enterAtTheRateSignTestDesc = 'Should show suggestionList of user when enter at the rate sign';

  static const String clickUserTestDesc = 'Should insert user name in input field with highlight color when click on user name from suggestion List'; 
  
  static const String addButtonDesc = 'Should show attachment option when clicked on add button'; 
  
  static selectOptionDesc(String optionName) => 'Should show $optionName list by tapping on $optionName';

  static const String  selectFirstTwoElementsTestDesc = 'Should Select first two elements from list';

  static const String  clickOnJobNoteTestDesc = 'Should show job note listing by clicked on job notes section';

  static const String longPressOnJobNoteItemTestDesc = 'Should open job Note edit form when long pressed on job note item';
  
  static const String  clickToMeasurementItemTestDesc = 'Should show measurement listing by tapping on "measurement" section';

  static const String  longPressOfFileListingItem = "Should show action sheet that can perform on element when long pressed on listing element";

  static const String  editOptionClickDesc = "Should open edit measurement form when clicked on edit";

  static const String  tableLongPressActionDesc = "Should open action sheet that can perform on table item when long press on any table's element";
  
  static const String  navToUpdateMeasurement = 'Should show update measurement bottom sheet when clicked on any element of table';

  static const String  clickToJobCategoryTestDesc = 'Should show category list by tapping on "category" field in job form';

  static const String  selectInsuranceClaimItemTestDesc = 'Should tap on "insurance claim" from category list';

  static const String  goToInsuranceClaimFormPageTestDesc = 'Should open insurance form page by tapping on insurance claim "form icon" button';

  static const String  goToContactPersonFormPageTestDesc = 'Should open contact person form page by tapping on "+ icon" button';

  static const String  checkAllFiledDataShowingTestDesc = 'Should show all filled data on form fields';

  static const String  checkNoChangesMadeTestDesc =  'Should show toast when click on save button without any change';

  static const String  checkFormValidationTestDesc =  'Should show "validation error" in form';

  static const String  checkValidationOnSaveButtonTestDesc =  'Should show "validate error" on click on save button';

  static const String  checkUnsavedDialogTestDesc =  'Should show "unsaved changes" dialog on back button if some changes done in form fields';

  static const String  checkDataFillingInFormTestDesc =  'Should filling valid data in form'; 

  static const String  changeSomeFieldsOnEditTestDesc =  'Should do changes in fields on edit form';

  static const String  checkSavedDataInFormTestDesc = 'Should show saved data on form fields';

  static const String  companyContactGroupDesc = 'Company Contact: ';

  static const String  companyContactTestDesc = 'Create Company Contact Form';

  static const String  jobContactPersonGroupDesc = 'Job Contact Person: ';

  static const String  jobContactPersonTestDesc = 'Create Job Contact Person Form';

  static const String  selectContactPersonFromCompanyContactTestDesc = 'Should fill contact form by choosing contact person from company contact page';

  static const String  clickSaveTestDesc = 'Should tap on "save" button to store form data';

  static const String  showOnlyOnePrimaryContactTestDesc = 'Should show only one primary contact person';

  static const String  customerListingGroupDesc = 'Customer Listing: ';

  static const String  goToCustomerListingTestDesc = 'Go to customer listing';

  static const String  applyFilterTestDesc = 'Applying filter';

  static const String  resetFilterTestDesc = 'Resetting filter';

  static const String measurementFormTestDesc = 'Measurement Form';

  static const String taskListingTestDesc = 'Go to Task Listing';

  static const String taskListingDetailTestDesc = 'Should tap on task to open task detail bottomsheet';

  static const String closeTaskListingDetailTestDesc = 'Should tap on "close" icon to close task detail bottomsheet';

  static const String refreshTaskListingTestDesc = 'Should tap on "refresh" to refresh task listing';

  static const String loadMoreTestDesc = 'Should scroll to bottom to load more data';

  static const String taskFilterTestDesc = 'Should filter data on task listing page';

  static const String taskSortOrderTestDesc = 'Should filter data according to sort order i.e. ASC/DESC';

  static const String taskSortByTestDesc = 'Should filter data according to sort by i.e. completed/created';

  static const String fillCustomFilterTestDesc = 'Should fill custom filter data';

  static const String resetCustomFilterTestDesc = 'Should reset filled custom filter data';

  static const String applyCustomFilterTestDesc = 'Should apply filled custom filter data';

  static const String pullToRefreshTestDesc = 'Should refresh listing on pull to refresh';

  static const String loadMoreTestCaseDesc = 'Should be indicate load more';

  static const String noLoadMoreTestCaseDesc = 'Should not be indicate load more';

  static const String customerListingSortOrderTestDesc = 'Should filter data according to sort order i.e. last modified';

  static const String noDataTestDesc = 'No data found';

  static const String customerListingSortByTestDesc = 'Should filter data according to sort by i.e. completed/created';

  static const String jobListingTestDesc = 'Job Listing: ';

  static const String  clickOnWorkFlowStagesTestDesc = 'Should show jobs list by tapping on workflow stages count';

  static const String openJobListingQuickActionsTestDesc = 'Should open job listing quick actions';

  static const String openJobEditFormTestDesc = 'Should open job edit form';

  static const String openJobDetailTestDesc = 'Should open job detail';

  static const String openEmailComposeViewTestDesc = 'Should open email compose view';

  static const String openFollowupNotesListTestDesc = 'Should open followup notes list';

  static const String openJobFlagTestDesc = 'Should open job flags list';

  static const String openAddToProgressBoardTestDesc = 'Should open add to progress board dialogue';

  static const String openJobScheduleFormTestDesc = 'Should open job schedule form';

  static const String openJobNoteListTestDesc = 'Should open job note list';

  static const String openAppointmentFormTestDesc = 'Should open appointment form';

  static const String openUpdateJobPriceTestDesc = 'Should open job price update section';

  static const String openJobArchiveDialogueTestDesc = 'Should open job archive section';

  static const String openMarkAsLostJobTestDesc = 'Should open mark as lost job section';

  static const String openDeleteJobTestDesc = 'Should open delete job section';

  static const String backToJobListingTestDesc = 'Should return back to job listing';

  /// Customer Form Descriptions
  static const String customerFormGroupDesc = 'Customer Form: ';

  static const String closeFormWithoutConfirmation = 'Should close form without showing confirmation dialog, when no changes were made';

  static const String updateFormDataForConfirmation = 'Should update form data to have different data than initial';

  static const String unsavedChangesCancelTap = 'Should display unsaved changes confirmation dialog and tap on cancel to close it';

  static const String unsavedChangesDoNotSaveTap = 'Should display unsaved changes confirmation dialog and tap on don\'t save to close both form and dialog';

  static const String openSideMenuForOption = 'Should open side menu to select menu option';

  static const String addLeadProspectCustomerTap = 'Should click on Add Lead/Prospect/Customer';

  static const String displayFormWithFirstSectionExpanded = 'Should display form with first section as expanded';

  static const String openCustomerDetailsFromForm = 'Should open customer details after creating new customer';

  static const String goBackToHomePage = 'Should go back to home page';

  static const String expandCollapseAllSections = 'Should expand collapse all sections';

  static const String selectFlagsAndDisplay = 'Should select flags and show selections in form';

  static const String removeFlagsAndNotDisplay = 'Should remove flag and not display in form';

  static const String updateFlagsAndDisplay = 'Should update flags and show selections in form';

  static const String switchFormToCommercial = 'Should switch form type to "Commercial"';

  static const String switchFormToResidential = 'Should switch form type to "Residential"';

  static const String validateRequiredFieldsAndFocus = 'Should validate required fields and focus on first required field';

  static const String showValidationBasedOnFormType = 'Should show validation on the basis of form type';

  static const String fillFirstAndLastName = 'Should fill in first name and last name';

  static const String displaySecondaryName = 'Should toggle and display secondary name and secondary last name';

  static const String fillSecondaryNameAndLastName = 'Should fill in secondary name and secondary last name';

  static const String hideSecondaryNameAndLastName = 'Should hide secondary name and secondary last name';

  static const String preserveSecondaryNameAndLastName = 'Should preserve secondary name and secondary last name';

  static const String fillSalesManCustomerRep = 'Should select and fill in "Salesman/Customer Rep"';

  static const String fillReferredBy = 'Should select and fill in "Referred By"';

  static const String showReferredByAllFields = "Should shown 'Existing Customer' and 'Referred by note' when Existing Customer is selected as 'Referred By'";

  static const String showReferredByLimitedFields = "Should shown and focus 'Referred by note' when 'Other' is selected as 'Referred by'";

  static const String fillReferredByNote = 'Should fill in "Referred by note"';

  static const String fillCanvasser = 'Should select and fill in "Canvasser"';

  static const String showCanvasserAllFields = "Should show and focus 'Canvasser note' when 'Other' is selected as canvasser";

  static const String fillCanvasserNote = 'Should fill in "Canvasser note"';

  static const String fillCallCenterRep = 'Should select and fill in "Call Center Rep"';

  static const String showCallCenterRepAllFields = "Should shown and focus 'Call Center Rep Note' when 'Other' is selected as call center rep";

  static const String fillCallCenterRepNote = 'Should fill in "Call center rep note"';

  static const String fillLimitedFormFields = 'Should fill data in form with limited fields and sections';

  static const String displayDefaultFieldsAndSection = "Should display default fields and section, when company settings do not exists";

  static const String preserveFilledData = 'Should preserve filled in data';

  static const String collapseExpandedSection = 'Should collapse expanded section';

  static const String fillCustomFields = "Should fill in custom fields";

  static const String fillCustomDropDown = 'Should fill data in custom dropdown';

  static const String selectDropDown1Options = 'Should select options for dropdown level 1';

  static const String selectDropDown2Options = 'Should select options for dropdown level 2';

  static const String selectDropDown3Options = 'Should select options for dropdown level 3';

  static const String removeOneDropDown3Options = 'Should remove one option from dropdown level 3 by tapping on cross button';

  static const String removeChildDropdown2 = 'Should remove dropdown level 3 on removing options from level 2';

  static const String notPreserveDropdownValue = 'Should not preserve dropdown values';

  static const String fillInCustomFields = 'Should fill data in custom text fields';

  static const String displayBillingAddress = 'Should display billing address section';

  static const String hideBillingAddress = 'Should hide billing address section';

  static const String preserveBillingAddress = 'Should preserve billing address data';

  static const String collapseBillingAddress = 'Should collapse billing address section';

  static const String fillAddressDetails = "Should select and fill customer address";

  static const String openAddressSearchPage = "Should open search page to select address";

  static const String performAddressSearch = "Should perform address search";

  static const String selectAndFillAddress = "Should select address and fill in form";

  static const String fillAddressLine2 = 'Should fill address line 2';

  static const String updateAutoFilledState = 'Should update auto filled state';

  static const String updateFilledZipCode = 'Should update auto filled zipcode';

  static const String updateAutoFilledCountry = 'Should update auto filled country';

  static const String validateEmailForWrongEmail = 'Should validate email when wrong email is entered';

  static const String validateEmailForCorrectEmail = 'Should validate email when correct email is entered';

  static const String fillAdditionalEmail = 'Should fill and validate additional email addresses';

  static const String removeLastEmail = 'Should remove last email address';

  static const String removeInBetweenEmail = 'Should remove in between email address';

  static const String notPreserveEmailAddress = 'Should not preserve email address on adding additional email at any place';

  static const String removeFailedValidationEmail = 'Should remove unfilled email email';

  static const String validatePhoneForWrongInput = 'Should validate phone when wrong number is entered';

  static const String validatePhoneForCorrectInput = 'Should validate phone when correct number is entered';

  static const String fillPhoneNumber = 'Should fill in phone number';

  static const String updatePhoneNumberType = 'Should update phone number type';

  static const String validateAdditionalPhoneNumber = 'Should fill and validate additional phone number';

  static const String removeLastPhoneNumber = 'Should remove last phone number';

  static const String removeInBetweenPhoneNumber = 'Should remove in between phone number';

  static const String notPreservePhoneNumber = 'Should not preserve phone number on adding additional number at any place';

  static const String removeFailedValidationPhone = 'Should remove phone number with failed validation';

  static const String fillCustomerNote = 'Should fill in customer note';

  static const String fillCompanyName = 'Should fill in company name';

  static const String fillManagementCompany = 'Should fill in management company';

  static const String fillPropertyName = 'Should fill in property name';

  static const String displayFieldsRandomly = 'Should update fields and display in random order';

  static const String displayLimitedFields = 'Should update fields and display only limited fields';

  static const String displayOneSection = "Should update fields and display only one section";

  static const String displayTwoSection = "Should update fields and display only two sections";

  static const String hideOtherInfoSection = "Should update fields and hide 'Other Information' section";

  static const String displayRequiredFields = "Should update fields and display required fields only";

  static const String notUpdateFields = "Should not update fields and maintain the order of fields";

}