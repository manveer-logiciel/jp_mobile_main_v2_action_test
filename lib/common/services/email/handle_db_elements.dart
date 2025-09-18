import 'package:get/get.dart';
import 'package:jobprogress/common/enums/templates.dart';
import 'package:jobprogress/common/models/address/address.dart';
import 'package:jobprogress/common/models/appointment/appointment.dart';
import 'package:jobprogress/common/models/company_contacts.dart';
import 'package:jobprogress/common/models/customer/customer.dart';
import 'package:jobprogress/common/models/files_listing/delivery_date.dart';
import 'package:jobprogress/common/models/insurance/insurance_model.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/job_financial/financial_details.dart';
import 'package:jobprogress/common/models/phone.dart';
import 'package:jobprogress/common/models/sql/company/company.dart';
import 'package:jobprogress/common/models/sql/user/user_limited.dart';
import 'package:jobprogress/common/models/subscriber/license_detail.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/common/services/company_settings.dart';
import 'package:jobprogress/common/services/phone_masking.dart';
import 'package:jobprogress/common/services/subscriber_details.dart';
import 'package:jobprogress/core/constants/company_seetings.dart';
import 'package:jobprogress/core/constants/date_formats.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/core/utils/job_financial_helper.dart';

class EmailDbElementService {
  static CompanyModel? companyDetails;
  static String sourceString = '';

  static String getArrayValueByKey(List<dynamic> array, String key) {
    if(array.isEmpty) return '';
    return array.map((e) {
      var json = e.toJson();
      return json[key];
    }).join(', ');
  }

  static String getPhoneNumber(List<PhoneModel>? array, {String type = 'other'}) {
    if(array == null || array.isEmpty) return '';
    List<PhoneModel> filteredArray = [];
    if(type != 'phones'){
      filteredArray = array.where((ele) => type.toLowerCase() == ele.label!.toLowerCase()).toList();
    } else {
      filteredArray = array;
    }
    
    String numbers =  filteredArray.map((ele) {
        return PhoneMasking.maskPhoneNumber(ele.number!);
    }).join(', ');

    return numbers == 'null' || numbers.isEmpty ? '' : numbers;
  }

  static String maskPhoneList(List<String> phones){
    List<String> maskedPhone = [];
    for(String phone in phones){
      maskedPhone.add(PhoneMasking.maskPhoneNumber(phone)); 
    } 

    return maskedPhone.join(', ');
  }

  static String getDeliveryDate(List<DeliveryDateModel> deliveryDates){
    
    deliveryDates.sort((a, b) {
      int aDate = DateTime.parse(DateTimeHelper.convertSlashIntoHyphen(a.deliveryDate!)).microsecondsSinceEpoch;
      int bDate = DateTime.parse(DateTimeHelper.convertSlashIntoHyphen(b.deliveryDate!)).microsecondsSinceEpoch;
      return aDate.compareTo(bDate);
    });
    List<DeliveryDateModel> filterList = deliveryDates.where((element){
      final date =  DateTime.parse(DateTimeHelper.convertSlashIntoHyphen(element.deliveryDate!));
      return DateTime.now().isBefore(date);
    }).toList();

      return filterList.isEmpty ? '' : filterList[0].deliveryDate!;
  }

  static String setSoucreString({CustomerModel? customer, JobModel? job, String? content, DbElementType type = DbElementType.email, String? proposalUrl}) {
    int currentYear = DateTime.now().year;
    companyDetails = AuthService.userDetails!.companyDetails!;
    String websiteLink = CompanySettingsService.getCompanySettingByKey(CompanySettingConstants.websiteLink);

    sourceString = getInitials(type, content);

    sourceString += '''
        function setValue(key, element) {
          switch (key) {
            case 'CURRENT_YEAR':
              setElementValue(element, $currentYear);
            break;
            case 'COMPANY_NAME':
              setElementValue(element, `${companyDetails!.companyName}`);
            break;
            case "COMPANY_LICENSE_NUMBER":
              setElementValue(element, `${companyDetails!.licenseNumber}`);
            break;
         ''';

        if(companyDetails!.email != null) {
        sourceString += '''
            case "COMPANY_EMAIL":
              setElementValue(element, `${companyDetails!.email}`);
            break; 
          ''';
        }

        if(!Helper.isValueNullOrEmpty(proposalUrl)){
          sourceString += '''
            case "PUBLIC_PROPOSAL_LINK":
              setElementValue(element, `$proposalUrl`, true);
            break; 
          ''';
        }
        
        if(companyDetails != null && !Helper.isValueNullOrEmpty(companyDetails?.logo)) {
          sourceString += '''
            case "COMPANY_LOGO":
              setElementValue(element, `${companyDetails!.logo}`);
            break; 
          ''';
        }

        if(companyDetails!.additionalEmail  != null && companyDetails!.additionalEmail!.isNotEmpty) {
        String additionalEmails =  companyDetails!.additionalEmail!.join(',');
        sourceString += '''
            case "COMPANY_ADDITIONAL_EMAIL":
              setElementValue(element, `$additionalEmails`);
            break;
          ''';
        }
        if(companyDetails!.phone != null) {
            String phone = PhoneMasking.maskPhoneNumber(companyDetails!.phone!); 
            sourceString += '''
              case "COMPANY_PHONE":
                setElementValue(element, `$phone`);
              break; 
            ''';
        }
        if(companyDetails!.additionalPhone!.isNotEmpty) {
          String additionalPhone = maskPhoneList(companyDetails!.additionalPhone!) ; 
          sourceString += '''
            case "COMPANY_ADDITIONAL_PHONE":
              setElementValue(element, `$additionalPhone`);
            break; 
          ''';
        }
        if(companyDetails!.convertedAddress != null) {
          sourceString += '''
            case "COMPANY_FULL_ADDRESS":
              setElementValue(element, `${companyDetails!.convertedAddress}`);
            break; 
          ''';  
        }
        
        sourceString += '''
          case "COMPANY_WEBSITE_URL":
            setElementValue(element, `$websiteLink`);
          break; 
        ''';

        sourceString += '''
          case "DATE":
            setElementValue(element, `${DateTimeHelper.formatDate(DateTime.now().toString(), DateFormatConstants.dateOnlyFormat)}`);
            break;
              ''';
        if(customer != null) {
          String customerContact = getArrayValueByKey(customer.contacts!, 'full_name_mobile');
          String customerContactWithFullName = '${customer.fullName}${customerContact.isNotEmpty ? ', $customerContact' : ''}';
          String customerReferredBy = Helper.getCustomerReferredBy(customer); 

          if(customer.companyName != null && customer.companyName!.isNotEmpty) {
             sourceString += '''
              case "CUSTOMER_RESIDENTIAL_COMPANY_NAME":
                setElementValue(element, `${customer.companyName!}`);
              break; 
            ''';
          }
          if(customer.fullName != null && customer.fullName!.isNotEmpty) {
            sourceString += '''
              case "CUSTOMER_FULL_NAME":
              case "CUSTOMER_NAME":
              case "CUSTOMER_NAME_COMMERCIAL":
                setElementValue(element, `${customer.fullName}`);
              break;
               case "CUSTOMER_SECONDARY_AND_FULL_NAME":
               case "CUSTOMER_SEC_AND_FULL_NAME":
                setElementValue(element, `$customerContactWithFullName`);
              break;
            ''';
          }
          if(customer.firstName != null && customer.firstName!.isNotEmpty) {
            sourceString += '''
              case "CUSTOMER_FIRST_NAME":
              case "CUSTOMER_FNAME":
                setElementValue(element, `${customer.firstName}`);
              break;
            ''';
          }
          if(customer.lastName != null && customer.lastName!.isNotEmpty) {
            sourceString += '''
              case "CUSTOMER_LAST_NAME":
              case "CUSTOMER_LNAME":
                setElementValue(element, `${customer.lastName}`);
              break;
            ''';
          }
          if(customer.contacts != null) {
            sourceString += '''
              case "CUSTOMER_SECONDARY_NAME":
              case "CUSTOMER_SEC_NAME_COMMERCIAL":
              case "CUSTOMER_SEC_NAME":
                setElementValue(element, `$customerContact`);
              break;
            ''';
          }
          if(customer.addressString != null && customer.addressString!.isNotEmpty) {
            sourceString += '''
              case "CUSTOMER_FULL_ADDRESS":
              case "CUSTOMER_FADDRESS":
                setElementValue(element, `${customer.addressString}`);
            break;
            ''';
          }
          if(!Helper.isValueNullOrEmpty(customer.billingName)) {
             sourceString += '''
              case "CUSTOMER_BILLING_NAME":
                setElementValue(element, `${customer.billingName}`);
            break;
            ''';
          }
          if(customer.billingAddressString != null && customer.billingAddressString!.isNotEmpty) {
            sourceString += '''
              case "CUSTOMER_BILLING_FULL_ADDRESS":
              case "BILLING_FADDRESS":
                setElementValue(element, `${customer.billingAddressString}`);
            break;
            ''';
          }
          if(customer.phones!.isNotEmpty) {
            sourceString += '''
              case "CUSTOMER_HOME_NUMBER":
                setElementValue(element, `${getPhoneNumber(customer.phones, type: 'home')}`);
            break;
              case "CUSTOMER_CELL_NUMBER":
                setElementValue(element, `${getPhoneNumber(customer.phones, type: 'cell')}`);
            break;
              case "CUSTOMER_PHONE_NUMBER":
                setElementValue(element, `${getPhoneNumber(customer.phones, type: 'phone')}`);
              break;
              case "CUSTOMER_PHONE":
                setElementValue(element, `${getPhoneNumber([customer.phones!.first], type: 'phones')}`);
              break;
              case "CUSTOMER_OFFICE_NUMBER":
                setElementValue(element, `${getPhoneNumber(customer.phones, type: 'office')}`);
              break;
              case "CUSTOMER_FAX_NUMBER":
                setElementValue(element, `${getPhoneNumber(customer.phones, type: 'fax')}`);
              break;
              case "CUSTOMER_OTHER_NUMBER":
                setElementValue(element, `${getPhoneNumber(customer.phones, type: 'other')}`);
              break;
            ''';
          }
          if(customer.email != null && customer.email!.isNotEmpty) {
            sourceString += '''
              case "CUSTOMER_EMAIL":
                setElementValue(element, `${customer.email}`);
              break;
            ''';
          }
          if(customer.address != null) {
            AddressModel customerAddress = customer.address!;
            if(customerAddress.address != null &&  customerAddress.address!.isNotEmpty){
              sourceString += '''
                case "CUSTOMER_ADDRESS":
                  setElementValue(element, `${customerAddress.address}`);
                break;
              ''';
            }
            if(customerAddress.addressLine1 != null &&  customerAddress.addressLine1!.isNotEmpty) {
              sourceString += '''
                case "CUSTOMER_ADDRESS_LINE_2":
                  setElementValue(element, `${customerAddress.addressLine1}`);
                break;
              ''';
            }
            if(customerAddress.zip != null &&  customerAddress.zip!.isNotEmpty) {
              sourceString += '''
                case "CUSTOMER_ZIP":
                  setElementValue(element, `${customerAddress.zip}`);
                break;
              ''';
            }
            if(customerAddress.city != null &&  customerAddress.city!.isNotEmpty) {
              sourceString += '''
                 case "CUSTOMER_CITY":
                  setElementValue(element, `${customerAddress.city}`);
                break;
              ''';
            }
            if(customerAddress.state != null &&  customerAddress.state!.name.isNotEmpty) {
              sourceString += '''
                case "CUSTOMER_STATE":
                  setElementValue(element, `${customerAddress.state!.name}`);
                break;
              ''';
            }
            if(customerAddress.country != null &&  customerAddress.country!.name.isNotEmpty) {
              sourceString += '''
                case "CUSTOMER_COUNTRY":
                  setElementValue(element, `${customerAddress.country!.name}`);
                break; 
              ''';
            }
          }
          if(customer.billingAddress != null) {
            AddressModel customerBillingAddress = customer.billingAddress!;
            if(customerBillingAddress.address != null &&  customerBillingAddress.address!.isNotEmpty) {
              sourceString += '''
                case "CUSTOMER_BILLING_ADDRESS":
                case "BILLING_ADDRESS":
                  setElementValue(element, `${customerBillingAddress.address}`);
                break;
              ''';
            }
            if(customerBillingAddress.addressLine1 != null &&  customerBillingAddress.addressLine1!.isNotEmpty) {
              sourceString += '''
                case "CUSTOMER_BILLING_ADDRESS_LINE_2":
                case "BILLING_ADDRESS_LINE_2":
                  setElementValue(element, `${customerBillingAddress.addressLine1}`);
                break;
              ''';
            }
            if(customerBillingAddress.zip != null &&  customerBillingAddress.zip!.isNotEmpty) {
              sourceString += '''
                case "CUSTOMER_BILLING_ZIP":
                case "BILLING_ZIP":
                  setElementValue(element, `${customerBillingAddress.zip}`);
                break;
              ''';
            }
            if(customerBillingAddress.city != null &&  customerBillingAddress.city!.isNotEmpty) {
              sourceString += '''
                 case "CUSTOMER_BILLING_CITY":
                 case "BILLING_CITY":
                  setElementValue(element, `${customerBillingAddress.city}`);
                break;
              ''';
            }
            if(customerBillingAddress.state != null &&  customerBillingAddress.state!.name.isNotEmpty) {
              sourceString += '''
                case "CUSTOMER_BILLING_STATE":
                case "BILLING_STATE":
                  setElementValue(element, `${customerBillingAddress.state!.name}`);
                break;
              ''';
            }
            if(customerBillingAddress.country != null &&  customerBillingAddress.country!.name.isNotEmpty) {
              sourceString += '''
                case "CUSTOMER_BILLING_COUNTRY":
                case "BILLING_COUNTRY":
                  setElementValue(element, `${customerBillingAddress.country!.name}`);
                break; 
              ''';
            }
          }
          if(customer.rep != null) {
            UserLimitedModel customerRep = customer.rep!;
            if(customerRep.fullName.isNotEmpty) {
              sourceString += '''
                case "CUSTOMER_REP":
                  setElementValue(element, `${customerRep.fullName}`);
                break; 
              ''';
            }
            if(customerRep.phones != null) {
              sourceString += '''
                case "CUSTOMER_REP_PHONE":
                  setElementValue(element, `${getPhoneNumber(customerRep.phones, type: 'phones')}`);
                break;
              ''';
            }
            if(customerRep.email.isNotEmpty) {
              sourceString += '''
                case "CUSTOMER_REP_EMAIL":
                  setElementValue(element, `${customerRep.email}`);
                break;
              ''';
            }
          }
          if(customer.note != null && customer.note!.isNotEmpty) {
            sourceString += '''
                case "CUSTOMER_NOTE":
                  setElementValue(element, `${customer.note}`);
                break;
              ''';
          }
          if(customerReferredBy.isNotEmpty) {
            sourceString += '''
                case "CUSTOMER_REFERRED_BY":
                  setElementValue(element, `$customerReferredBy`);
                break; 
              ''';
          }
          if(type == DbElementType.email && customer.intial!= null  && customer.intial!.isNotEmpty) {
            sourceString += '''
                case "CUSTOMER_INITIAL":
                  setElementValue(element, `${customer.intial}`);
                break; 
            ''';
          }
        }
        if(job != null) {
          String currentTime = DateTime.now().toString();
          String currentDate =  DateTimeHelper.formatDate(currentTime, DateFormatConstants.dateOnlyFormat); 
          sourceString += '''
            case "CURRENT_DATE":
              setElementValue(element, `$currentDate`);
            break; 
          ''';

          if(job.number != null && job.number!.isNotEmpty) {
            sourceString += '''
              case "JOB_ID":
              ${type == DbElementType.formProposal ? 'case "JOB_NUMBER":' : ""}
                setElementValue(element, `${job.number}`);
              break; 
            ''';
          }
          if(job.altId != null && job.altId!.isNotEmpty) {
            sourceString += '''
              case "JOB_ALT_ID": 
              ${type == DbElementType.email ? 'case "JOB_NUMBER":' : ""}          
                setElementValue(element, `${job.altId}`);
              break; 
            ''';
          }
          if(job.leadNumber != null && job.leadNumber!.isNotEmpty) {
             sourceString += '''
              case "LEAD_NUMBER":
              case "JOB_LEAD_NUMBER":
                setElementValue(element, `${job.leadNumber}`);
              break; 
            ''';
          }

          if(job.financialDetails != null) {
            FinancialDetailModel financialDetail = job.financialDetails!;
          
            if(financialDetail.totalJobAmount != null && financialDetail.totalJobAmount! > 0) {
              String totalJobAmount = JobFinancialHelper.getCurrencyFormattedValue(value: job.financialDetails!.totalJobAmount);
              
              sourceString += '''
                case "JOB_AMOUNT":
                  setElementValue(element, `$totalJobAmount`);
                break; 
                case "JOB_AMOUNT_TABLE":
                  setElementValue(element, `${financialDetail.totalJobAmount}`);
                break; 
              ''';
            }
            if(financialDetail.totalChangeOrderAmount != null && financialDetail.totalChangeOrderAmount! > 0) {
              String totalChangeOrderAmount = JobFinancialHelper.getCurrencyFormattedValue(value: job.financialDetails!.totalChangeOrderAmount);
              
              sourceString += '''
                case "JOB_CHANGE_ORDER":
                  setElementValue(element, `$totalChangeOrderAmount`);
                break; 
                case "JOB_CHANGE_ORDER_TABLE":
                  setElementValue(element, `${financialDetail.totalChangeOrderAmount}`);
                break;                 
              ''';
            }
            if(financialDetail.totalAmount != null && financialDetail.totalAmount! > 0 ) {
              String totalAmount = JobFinancialHelper.getCurrencyFormattedValue(value: job.financialDetails!.totalAmount);
             
             sourceString += '''
              case "JOB_PRICE":
                setElementValue(element, `$totalAmount`);
              break; 
              case "JOB_PRICE_TABLE":
                setElementValue(element, `${financialDetail.totalAmount}`);
              break;              
              ''';
            }
          }
          if(job.taxRate != null && job.taxRate!.isNotEmpty) {
             sourceString += '''
              case "JOB_TAX":
                setElementValue(element, `${job.taxRate}%`);
              break; 
            ''';
          }
          if(job.description != null && job.description!.isNotEmpty) {
             sourceString += '''
              case "JOB_DESCRIPTION":
                setElementValue(element, `${job.description}`);
              break; 
            ''';
          }
          if (job.reps?.isNotEmpty ?? false) {
            List<PhoneModel> phones = [];
            job.reps?.forEach((user) {
              phones.addAll(user.phones ?? []);
            });
            sourceString += '''
              case "JOB_REP_NUMBER":
                setElementValue(element, `${getPhoneNumber(phones, type: 'phones')}`);
              break; 
            ''';
          }
          if(job.amount != null && job.taxRate != null && job.taxable == 1) {
            String jobTaxAmount = JobFinancialHelper.getEstimatedTax(job).toString();
            
            sourceString += '''
              case "JOB_TAX_AMOUNT":
                setElementValue(element, `$jobTaxAmount`);
              break; 
            ''';
          }

          if(job.estimators != null  && job.estimators!.isNotEmpty) {
            String estimatorFullName = getArrayValueByKey(job.estimators!, "full_name");
            String estimatorFirstName = getArrayValueByKey(job.estimators!, "first_name");
            String estimatorLastName = getArrayValueByKey(job.estimators!, "last_name");
            String estimatorEmail = getArrayValueByKey(job.estimators!, 'email');
            List<String> phones =[];
            for(UserLimitedModel estimator in job.estimators!) {
              if(
                estimator.profile != null && 
                estimator.profile!.additionalPhone != null &&
                estimator.profile!.additionalPhone!.isNotEmpty
                ){
                phones.add(estimator.profile!.additionalPhone![0].number!);
              }
            }
            sourceString += '''
              case "JOB_ESTIMATOR_FULL_NAME":
              case "JOB_ESTIMATOR":
                setElementValue(element, `$estimatorFullName`);
              break;
              case "JOB_ESTIMATOR_FIRST_NAME":
                setElementValue(element, `$estimatorFirstName`);
              break;
              case "JOB_ESTIMATOR_LAST_NAME":
                setElementValue(element, `$estimatorLastName`);
              break;
              case "JOB_ESTIMATOR_EMAIL":
                setElementValue(element, `$estimatorEmail`);
              break;
            ''';
        
            if(phones.isNotEmpty) {
              String phoneNumber = maskPhoneList(phones);
              sourceString += '''
                case "JOB_ESTIMATOR_PHONE_NUMBER":
                  setElementValue(element, `$phoneNumber`);
                break; 
              ''';
            } 
            
          }
          if(job.addressString != null  && job.addressString!.isNotEmpty) {
            sourceString += '''
              case "JOB_Full_ADDRESS":
              case "JOB_FADDRESS":
                setElementValue(element, `${job.addressString}`);
              break; 
            '''; 
          }
          if(job.address != null) {
            AddressModel jobAddress = job.address!;
            
            if(jobAddress.address != null && jobAddress.address!.isNotEmpty) {
              sourceString += '''
                case "JOB_ADDRESS":
                  setElementValue(element, `${jobAddress.address}`);
                break; 
              ''';
            }
            if(jobAddress.addressLine1 != null && jobAddress.addressLine1!.isNotEmpty) {
              sourceString += '''
                case "JOB_ADDRESS_LINE_2":
                  setElementValue(element, `${jobAddress.addressLine1}`);
                break; 
              '''; 
            }
            if(jobAddress.state != null && jobAddress.state!.name.isNotEmpty) {
              sourceString += '''
                case "JOB_STATE":
                  setElementValue(element, `${jobAddress.state!.name}`);
                break; 
              '''; 
            }
            if(jobAddress.zip != null && jobAddress.zip!.isNotEmpty) {
              sourceString += '''
                case "JOB_ZIP":
                  setElementValue(element, `${jobAddress.zip}`);
                break; 
              '''; 
            }
            if(jobAddress.city != null && jobAddress.city!.isNotEmpty) {
              sourceString += '''
                case "JOB_CITY":
                  setElementValue(element, `${jobAddress.city}`);
                break; 
              '''; 
            }
            if(jobAddress.country != null && jobAddress.country!.name.isNotEmpty) {
              sourceString += '''
                case "JOB_COUNTRY":
                  setElementValue(element, `${jobAddress.country!.name}`);
                break; 
              '''; 
            }
          }
          if(job.trades != null && job.trades!.isNotEmpty) {
            String tradeName =getArrayValueByKey(job.trades!,"name");
           
            sourceString += '''
              case "JOB_TRADE":
                setElementValue(element, `$tradeName`);
              break; 
            '''; 
          }
          if(job.workTypes != null && job.workTypes!.isNotEmpty) {
            String workTypeName =getArrayValueByKey(job.workTypes!,"name");
           
            sourceString += '''
              case "JOB_WORK_TYPE":
                setElementValue(element, `$workTypeName`);
              break; 
            '''; 
          }
          if(job.reps != null && job.reps!.isNotEmpty) {
            String repsName = getArrayValueByKey(job.reps!,"full_name");
            String firstName = getArrayValueByKey(job.reps!, 'first_name');
            String lastName = getArrayValueByKey(job.reps!,'last_name');
            List<String> phones = [];
            for(UserLimitedModel rep in job.reps!) {
              if(
                rep.profile != null && 
                rep.profile!.additionalPhone != null &&
                rep.profile!.additionalPhone!.isNotEmpty
                ){
                phones.add(rep.profile!.additionalPhone![0].number!);
              }
            }
            sourceString += '''
              case "JOB_REP":
              case "JOB_REP_FULL_NAME":
                setElementValue(element, `$repsName`);
              break; 
              case "JOB_REP_FIRST_NAME":
                setElementValue(element, `$firstName`);
              break; 
              case "JOB_REP_LAST_NAME":
                setElementValue(element, `$lastName`);
              break; 
            ''';
            if(phones.isNotEmpty) {
              String phoneNumber = PhoneMasking.maskPhoneNumber(phones.join(', ')); 
              sourceString += '''
                case "JOB_REP_PHONE_NUMBER":
                  setElementValue(element, `$phoneNumber`);
                break; 
              ''';
            }  
          }
          if(job.labours != null && job.labours!.isNotEmpty) {
            String labourName = getArrayValueByKey(job.labours!,"full_name");
           
            sourceString += '''
              case "JOB_LABORS":
                setElementValue(element, `$labourName`);
              break; 
            '''; 
          }
          if(job.subContractors != null && job.subContractors!.isNotEmpty) {
            String subContractorsName = getArrayValueByKey(job.subContractors!,"full_name");
           
            sourceString += '''
              case "JOB_SUBS":
              case "JOB_LABORS":
                setElementValue(element, `$subContractorsName`);
              break; 
            '''; 
          }
          if(job.contactPerson != null && job.contactPerson!.isNotEmpty) {

           CompanyContactListingModel jobContactPerson = job.contactPerson![0];
           

            if(jobContactPerson.firstName != null && jobContactPerson.firstName!.isNotEmpty) {
              sourceString += '''
                case "JOB_CONTACT_PERSON_FIRST_NAME":
                case "JOB_CON_PER_FN":
                  setElementValue(element, `${jobContactPerson.firstName}`);
                break; 
              '''; 
            }
            if(jobContactPerson.lastName != null && jobContactPerson.lastName!.isNotEmpty) {
              sourceString += '''
                case "JOB_CONTACT_PERSON_LAST_NAME":
                case "JOB_CON_PER_LN":
                  setElementValue(element, `${jobContactPerson.lastName}`);
                break; 
              '''; 
            }
            if(jobContactPerson.fullNameMobile != null && jobContactPerson.fullNameMobile!.isNotEmpty) {
              sourceString += '''
                case "JOB_CONTACT_PERSON_FULL_NAME":
                case "JOB_CON_PER_FULL_NAME":
                  setElementValue(element, `${jobContactPerson.fullNameMobile}`);
                break; 
              '''; 
            }
            if(jobContactPerson.emails != null && jobContactPerson.emails!.isNotEmpty) {
              String emails = getArrayValueByKey(jobContactPerson.emails!,'email');
              sourceString += '''
                case "JOB_CONTACT_PERSON_EMAIL":
                case "JOB_CON_PER_EMAIL":
                  setElementValue(element, `$emails`);
                break; 
              '''; 
            }            
            if(jobContactPerson.phones != null && jobContactPerson.phones!.isNotEmpty) {
              sourceString += '''
                case "JOB_CONTACT_PERSON_ALL_PHONE":
                case "JOB_CON_PER_PHONE":
                  setElementValue(element, `${getPhoneNumber(jobContactPerson.phones, type: 'phones')}`);
                break;
                case "JOB_CONTACT_PERSON_HOME_NUMBER":
                case "JOB_CON_PER_PHONE_H":
                  setElementValue(element, `${getPhoneNumber(jobContactPerson.phones, type: 'home')}`);
                break;
                case "JOB_CONTACT_PERSON_CELL_NUMBER":
                case "JOB_CON_PER_PHONE_C":
                  setElementValue(element, `${getPhoneNumber(jobContactPerson.phones, type: 'cell')}`);
                break;
                case "JOB_CONTACT_PERSON_PHONE_NUMBER":
                case "JOB_CON_PER_PHONE_P":
                  setElementValue(element, `${getPhoneNumber(jobContactPerson.phones, type: 'phone')}`);
                break;
                case "JOB_CONTACT_PERSON_OFFICE_NUMBER":
                case "JOB_CON_PER_PHONE_O":
                  setElementValue(element, `${getPhoneNumber(jobContactPerson.phones, type: 'office')}`);
                break;
                case "JOB_CONTACT_PERSON_FAX_NUMBER":
                case "JOB_CON_PER_PHONE_F":
                  setElementValue(element, `${getPhoneNumber(jobContactPerson.phones, type: 'fax')}`);
                break;
                case "JOB_CONTACT_PERSON_OTHERS_NUMBER":
                case "JOB_CON_PER_PHONE_OT":
                  setElementValue(element, `${getPhoneNumber(jobContactPerson.phones, type: 'other')}`);
                break; 
              ''';
            }

            if(jobContactPerson.address != null) {
              AddressModel contactPersonAddress = jobContactPerson.address!;
              if(jobContactPerson.addressString != null && jobContactPerson.addressString!.isNotEmpty) {
                sourceString += '''
                  case "JOB_CONTACT_PERSON_FULL_ADDRESS":
                  case "JOB_CON_PER_FULL_ADDRESS":
                    setElementValue(element, `${jobContactPerson.addressString}`);
                  break; 
                '''; 
              }
              
              if(contactPersonAddress.address != null && contactPersonAddress.address!.isNotEmpty) {
                sourceString += '''
                  case "JOB_CONTACT_PERSON_ADDRESS":
                  case "JOB_CON_PER_ADDRESS":
                    setElementValue(element, `${contactPersonAddress.address}`);
                  break; 
                '''; 
              }
              if(contactPersonAddress.addressLine1 != null && contactPersonAddress.addressLine1!.isNotEmpty) {
                sourceString += '''
                  case "JOB_CONTACT_PERSON_ADDRESS_LINE_2":
                  case "JOB_CON_PER_ADDRESS_LINE_2":
                    setElementValue(element, `${contactPersonAddress.addressLine1}`);
                  break; 
                '''; 
              }
              if(contactPersonAddress.state != null) {
                sourceString += '''
                  case "JOB_CONTACT_PERSON_STATE":
                  case "JOB_CON_PER_STATE":
                    setElementValue(element, `${contactPersonAddress.state!.name}`);
                  break; 
                ''';  
              }
              if(contactPersonAddress.zip != null && contactPersonAddress.zip!.isNotEmpty) {
                sourceString += '''
                  case "JOB_CONTACT_PERSON_ZIP":
                  case "JOB_CON_PER_ZIP":
                    setElementValue(element, `${contactPersonAddress.zip}`);
                  break; 
                ''';  
              }
              if(contactPersonAddress.city != null && contactPersonAddress.city!.isNotEmpty) {
                sourceString += '''
                  case "JOB_CONTACT_PERSON_CITY":
                  case "JOB_CON_PER_CITY":
                    setElementValue(element, `${contactPersonAddress.city}`);
                  break; 
                ''';  
              }
              if(contactPersonAddress.country != null) {               
                sourceString += '''
                  case "JOB_CONTACT_PERSON_COUNTRY":
                  case "JOB_CON_PER_COUNTRY":
                    setElementValue(element, `${contactPersonAddress.country!.name}`);
                  break; 
                ''';  
              } 
            }
          }
          if(job.contractSignedDate != null && job.contractSignedDate!.isNotEmpty) {
            String contractSignedDate = DateTimeHelper.convertHyphenIntoSlash(job.contractSignedDate!);
            sourceString += '''
              case "JOB_CONTRACT_SIGNED_DATE":
                setElementValue(element, `$contractSignedDate`);
              break;
            ''';  
          }
          if(job.insuranceDetails != null ) {
            InsuranceModel insuranceDetail = job.insuranceDetails!;
            if(insuranceDetail.insuranceCompany != null){
              sourceString += '''
                case "JOB_INSURANCE_COMPANY_NAME":
                case "JOB_INS_COMPANY_NAME":
                  setElementValue(element, `${insuranceDetail.insuranceCompany}`);
                break;
              ''';  
            }
            if(insuranceDetail.insuranceCompany != null && insuranceDetail.insuranceCompany!.isNotEmpty) {
              sourceString += '''
                case "JOB_INSURANCE_CLAIM_NO":
                case "JOB_INS_CLAIM_NO":
                  setElementValue(element, `${insuranceDetail.insuranceNumber}`);
                break;
              ''';  
            }
            if(insuranceDetail.phone != null && insuranceDetail.phone!.isNotEmpty) {
              sourceString += '''
                case "JOB_INSURANCE_COMPANY_PHONE":
                case "JOB_INS_COMPANY_PHONE":
                  setElementValue(element, `${insuranceDetail.phone}`);
                break;
              ''';  
            }
            if(insuranceDetail.fax != null && insuranceDetail.fax!.isNotEmpty) {
              sourceString += '''
                case "JOB_INSURANCE_COMPANY_FAX":
                case "JOB_INS_COMPANY_FAX":
                  setElementValue(element, `${insuranceDetail.fax}`);
                break;
              ''';  
            }
            if(insuranceDetail.email != null && insuranceDetail.email!.isNotEmpty) {
              sourceString += '''
                case "JOB_INSURANCE_COMPANY_EMAIL":
                case "JOB_INS_COMPANY_EMAIL":
                  setElementValue(element, `${insuranceDetail.email}`);
                break;
              ''';  
            }
            if(insuranceDetail.adjusterName != null && insuranceDetail.adjusterName!.isNotEmpty) {
              sourceString += '''
                case "JOB_INSURANCE_ADJUSTER_NAME":
                case "JOB_INS_ADJUSTER_NAME":
                  setElementValue(element, `${insuranceDetail.adjusterName}`);
                break;
              ''';  
            }
            if(insuranceDetail.adjusterPhone != null && insuranceDetail.adjusterPhone!.isNotEmpty) {
              String phone = PhoneMasking.maskPhoneNumber(insuranceDetail.adjusterPhone!);
              sourceString += '''
                case "JOB_INSURANCE_ADJUSTER_PHONE":
                case "JOB_INS_ADJUSTER_PHONE":
                  setElementValue(element, `$phone`);
                break;
              ''';  
            }
            if(insuranceDetail.adjusterEmail != null && insuranceDetail.adjusterEmail!.isNotEmpty) {
              sourceString += '''
                case "JOB_INSURANCE_ADJUSTER_EMAIL":
                case "JOB_INS_ADJUSTER_EMAIL":
                  setElementValue(element, `${insuranceDetail.adjusterEmail}`);
                break;
              ''';  
            }
            if(insuranceDetail.rcv != null && insuranceDetail.rcv!.isNotEmpty) {
               String rcv = JobFinancialHelper.getCurrencyFormattedValue(value: insuranceDetail.rcv);
               sourceString += '''
                case "JOB_INSURANCE_RCV":
                case "JOB_INS_RCV":
                  setElementValue(element, `$rcv`);
                break;
              ''';  
            }
            if(insuranceDetail.acv != null && insuranceDetail.acv!.isNotEmpty) {
               String acv = JobFinancialHelper.getCurrencyFormattedValue(value: insuranceDetail.acv);
               sourceString += '''
                case "JOB_INSURANCE_ACV":
                case "JOB_INS_ACV":
                  setElementValue(element, `$acv`);
                break;
              ''';  
            }
            if(insuranceDetail.deductibleAmount != null && insuranceDetail.deductibleAmount!.isNotEmpty) {
               String deductableAmount = JobFinancialHelper.getCurrencyFormattedValue(value: insuranceDetail.deductibleAmount);

               sourceString += '''
                case "JOB_INSURANCE_DEDUCTABLE_AMOUNT":
                case "JOB_INS_DEDUCTABLE_AMOUNT":
                  setElementValue(element, `$deductableAmount`);
                break;
              ''';  
            }

            if(insuranceDetail.policyNumber != null && insuranceDetail.policyNumber!.isNotEmpty) {
               sourceString += '''
                case "JOB_INSURANCE_POLICY_NUMBER":
                case "JOB_INS_POLICY_NUMBER":
                  setElementValue(element, `${insuranceDetail.policyNumber}`);
                break;
              ''';  
            }
            if(insuranceDetail.total != null && insuranceDetail.total!.isNotEmpty) {
              String total = JobFinancialHelper.getCurrencyFormattedValue(value: insuranceDetail.total);
              sourceString += '''
                case "JOB_INSURANCE_TOTAL_AMOUNT":
                case "JOB_INS_TOTAL":
                  setElementValue(element, `$total`);
                break;
              ''';  
            }
            if(insuranceDetail.netClaim != null && insuranceDetail.netClaim!.isNotEmpty) {
              String netClaim = JobFinancialHelper.getCurrencyFormattedValue(value: insuranceDetail.netClaim);
              sourceString += '''
                case "JOB_INS_NET_CLAIM":
                  setElementValue(element, `$netClaim`);
                break;
              ''';   
            }
            if(insuranceDetail.supplement != null && insuranceDetail.depreciation!.isNotEmpty) {
              String supplement = JobFinancialHelper.getCurrencyFormattedValue(value: insuranceDetail.supplement);
              sourceString += '''
                case "JOB_INS_SUPPLEMENT":
                  setElementValue(element, `$supplement`);
                break;
              ''';   
            }
            if(insuranceDetail.depreciation != null && insuranceDetail.depreciation!.isNotEmpty) {
              String depreciation = JobFinancialHelper.getCurrencyFormattedValue(value: insuranceDetail.depreciation);
              sourceString += '''
                case "JOB_INS_DEPRECIATION":
                  setElementValue(element, `$depreciation`);
                break;
              ''';   
            }
            if(insuranceDetail.contingencyContractSignedDate != null) {
              sourceString += '''
                case "JOB_INS_CONTINGENCY_CONTRACT_SIGNED_DATE":
                  setElementValue(element, `${insuranceDetail.contingencyContractSignedDate}`);
                break;
              ''';   
            }
            if(insuranceDetail.dateOfLoss != null) {
              sourceString += '''
                case "JOB_INS_DATE_OF_LOSS":
                  setElementValue(element, `${insuranceDetail.dateOfLoss}`);
                break;
              ''';   
            }
            if(insuranceDetail.claimFiledDate != null) {
              sourceString += '''
                case "JOB_INS_CLAIM_FILED_DATE":
                  setElementValue(element, `${insuranceDetail.claimFiledDate}`);
                break;
              ''';   
            }
            if(insuranceDetail.upgrade != null) {
              String upgrade = JobFinancialHelper.getCurrencyFormattedValue(value: insuranceDetail.upgrade);
              sourceString += '''
                case "JOB_INS_UPGRADES":
                  setElementValue(element, `$upgrade`);
                break;
              ''';   
            }
          }
          if(job.completionDate != null) {
            sourceString += '''
              case "JOB_COMPLETION_DATE":
                setElementValue(element, `${job.completionDate}`);
              break;
              ''';    
          }
          if(job.shareUrl != null && job.shareUrl!.isNotEmpty) {
            sourceString += '''
              case "JOB_CUSTOMER_WEB_PAGE":
                setElementValue(element, `${job.shareUrl}`);
              break;
            ''';    
          }
          if(job.name != null && job.name!.isNotEmpty) {
            sourceString += '''
              case "JOB_NAME":
                setElementValue(element, `${job.name}`);
              break;
            ''';    
          }
          if(job.deliveryDates != null && job.deliveryDates!.isNotEmpty) {
            String deliverydate = getDeliveryDate(job.deliveryDates!);
            sourceString += '''
              case "JOB_MATERIAL_DELIVERY_DATE":
                setElementValue(element, `$deliverydate`);
              break;
            ''';   
          }
          if(job.purchaseOrderNumber != null && job.purchaseOrderNumber!.isNotEmpty) {
            sourceString += '''
              case "JOB_PURCHASE_ORDER_NUMBER":
                setElementValue(element, `${job.purchaseOrderNumber}`);
              break;
            ''';    
          }
          if(job.division != null && job.division!.name != null && job.division!.name!.isNotEmpty) {
            sourceString += '''
              case "JOB_DIVISION":
                setElementValue(element, `${job.division!.name}`);
              break;
            ''';
          }
          if(job.upcomingSchedules != null) {
            if(job.upcomingSchedules!.startDateTime != null) {
              sourceString += '''
                case "JOB_SCHEDULE_START_DATE":
                  setElementValue(element, `${job.upcomingSchedules!.formattedStartDateTime ?? ''}`);
                break;
              ''';  
            }
            if(job.upcomingSchedules!.endDateTime != null) {
              sourceString += '''
                case "JOB_SCHEDULE_END_DATE":
                  setElementValue(element, `${job.upcomingSchedules!.formattedEndDateTime ?? ''}`);
                break;
              ''';  
            }
          }
          if(job.upcomingAppointment != null) {
            AppointmentModel upcomingAppointment = job.upcomingAppointment!;
            if(upcomingAppointment.startDate != null) {
              sourceString += '''
                case "JOB_APPOINTMENT_START_DATE":
                  setElementValue(element, `${upcomingAppointment.formattedStartDateTime ?? ''}`);
                break;
              ''';  
            }
            if(upcomingAppointment.endDate != null) {
              sourceString += '''
                case "JOB_APPOINTMENT_END_DATE":
                  setElementValue(element, `${upcomingAppointment.formattedEndDateTime ?? ''}`);
                break;
              ''';  
            }
            if(upcomingAppointment.user != null && job.upcomingAppointment!.user!.fullName.isNotEmpty) {
              sourceString += '''
                case "JOB_APPOINTMENT_FOR":
                  setElementValue(element, `${job.upcomingAppointment!.user!.fullName}`);
                break;
              '''; 
            }
            if(upcomingAppointment.attendees!= null && upcomingAppointment.attendees!.isNotEmpty) {
              String attendeesName = getArrayValueByKey(upcomingAppointment.attendees!, 'full_name');
              sourceString += '''
                case "JOB_APPOINTMENT_ATTENDEES":
                  setElementValue(element, `$attendeesName`);
                break;
              '''; 
            }
            if(upcomingAppointment.location != null && upcomingAppointment.location!.isNotEmpty) {
              sourceString += '''
                case "JOB_APPOINTMENT_LOCATION":
                  setElementValue(element, `${upcomingAppointment.location}`);
                break;
              '''; 
            }
            if(upcomingAppointment.description != null && upcomingAppointment.description!.isNotEmpty) {
              sourceString += '''
                case "JOB_APPOINTMENT_NOTE":
                  setElementValue(element, `${upcomingAppointment.description}`);
                break;
              ''';
            }
          }
        }

        if(SubscriberDetailsService.subscriberDetails != null) {
          List<LicenseDetail> licenseList = SubscriberDetailsService.subscriberDetails!.licenseList!;
          if(!Helper.isValueNullOrEmpty(licenseList)) {
            String allLicenseNumber = getArrayValueByKey(licenseList, 'number');

            LicenseDetail? pos1 = licenseList.firstWhereOrNull((element) => element.position == 1);
            LicenseDetail? pos2 = licenseList.firstWhereOrNull((element) => element.position == 2);
            LicenseDetail? pos3 = licenseList.firstWhereOrNull((element) => element.position == 3);
            
            if(pos1 != null && pos1.number != null && pos1.number!.isNotEmpty) {
              sourceString += '''
                case "CONTRACTOR_LICENSE_NUMBER":
                  setElementValue(element, `${pos1.number}`);
                break;
              ''';   
            }

            if(pos2 != null && pos2.number != null && pos2.number!.isNotEmpty) {
              sourceString += '''
                case "CONTRACTOR_LICENSE_NUMBER_2":
                  setElementValue(element, `${pos2.number}`);
                break;
              ''';   
            }

            if(pos3 != null && pos3.number != null && pos3.number!.isNotEmpty) {
              sourceString += '''
                case "CONTRACTOR_LICENSE_NUMBER_3":
                  setElementValue(element, `${pos3.number}`);
                break;
              ''';
            }

            if(allLicenseNumber.isNotEmpty) {
              sourceString += '''
                case "CONTRACTOR_LICENSE_NUMBERS":
                  setElementValue(element, `$allLicenseNumber`);
                break;
              ''';
            }
          }
        }
    dynamic sign = CompanySettingsService.getCompanySettingByKey(CompanySettingConstants.userEmailSign);

        if(sign != null && sign is Map) {
          String signHtml = '<div id="user-email-signatures"> ${sign['signature'].toString().trim()} </div>';
          sourceString += '''
            case "USER_EMAIL_SIGNATURE":
              console.log("SIGNATURE: ", element);
              setElementValue(element, `$signHtml`);
             break;
          ''';
        }

  ////CLOSING
      sourceString += '''
          }
        } 
        
        ${setElementValue(type)}
        
        setTimeout(function() {
          getElements()
        }, 200);
      ''';

        return sourceString;
  }

  static String getInitials(DbElementType type, String? content) {

    switch (type) {
      case DbElementType.email:
        return emailTemplateInitial(content);

      case DbElementType.formProposal:
        return formProposalTemplateInitial();
    }

  }

  static String emailTemplateInitial(String? content) {

    String tempSourceString = "";

    if(content != null) {
      tempSourceString = '''
        var div = window.document.createElement("div")
        div.innerHTML = `$content`;

        function getElements() {
          var items = div.getElementsByTagName('span')
          for (let index = 0; index < items.length; index++) {
            var span = items[index]
            setValue(span.getAttribute('db-element'), span)
          }

          window.flutter_inappwebview.callHandler("updateContent", div.innerHTML);
        }
      ''';
    } else {
      tempSourceString = '''
        function getElements() {
          var items = document.getElementsByTagName('span')
          var image = document.getElementsByTagName('img')
          var anchorTags = document.getElementsByTagName('a')
          for (let index = 0; index < items.length; index++) {
            var span = items[index]
            setValue(span.getAttribute('db-element'), span)
          }

          for (let index = 0; index < image.length; index++) {
            var img = image[index]
            setValue(img.getAttribute('db-element'), img)
          }

          if(anchorTags.length > 0) {
            for (let index = 0; index < anchorTags.length; index++) {
              var anchor = anchorTags[index]
              setValue(anchor.getAttribute('filled-val'), anchor)
            }  
          }
        }
      ''';
    }

    return tempSourceString;
  }

  static String formProposalTemplateInitial() {

    String tempSourceString = """    
    function getElements() {

            \$(document).ready(function() {
              \$("input.input-filled").each(function(\$i, \$ele) {
                setValue(\$(\$ele).attr("filled-val"), \$ele);
              });
              
              \$("textarea.input-filled").each(function(\$i, \$ele) {
                setValue(\$(\$ele).attr("filled-val"), \$ele);
              });
              
              \$("img").each(function(\$i, \$ele) {
                setValue(\$(\$ele).attr('db-element'), \$ele);
              });
            
              \$("td").each(function(\$i, \$ele) {
                setValue(\$(\$ele).attr('ref-db') + '_TABLE', \$ele);
              });

              \$("img.input-filled").each(function(\$i, \$ele) {
                setValue(\$(\$ele).attr("filled-val"), \$ele);
              });

              \$("div.leap-profile-logo-round-responsive").each(function(\$i, \$ele) {
                \$(ele).css({
                  'display': 'flex',
                  'justify-content': 'center',
                  'align-items': 'center',
                  'overflow': 'hidden'
                });
              });
            });
       }
    """;

    return tempSourceString;
  }

  static String setElementValue(DbElementType type) {

    switch (type) {
      case DbElementType.email:
        return setEmailElementValue();

      case DbElementType.formProposal:
        return setTemplateElementValue();
    }

  }

  static setEmailElementValue() {
    return """
    function setElementValue(element, value, isLink = false) {
      if(value && value != null) {
      if(isLink) {
        element.setAttribute("href", value)
        return;
      }

       if(element.hasAttribute("src")) {
         element.setAttribute("src", value)
       } else {
         element.innerHTML = value;
       }
      }
    }
    """;
  }

  static setTemplateElementValue() {
    return """
    
    function setElementValue(element, value) {
            if (\$(element).is("input")) {
              \$(element).attr("value", value || "");
            }

            if (\$(element).is("textarea")) {
              \$(element).text(value || "");
            }

            if (\$(element).is("td")) {
              if (\$(element).hasClass("cell-with-dropdown")) {
                \$(element).find(".cell-text").text(value || "");
              } else {
                \$(element).text(value || "");
              }
            }

            if (\$(element).is("img") && \$(element).hasClass("input-filled")) {
              \$(element).attr("src", value || "");
              \$(element).css({
                  'max-width': '100%',
                  'max-height': '100%',
                  'object-fit': 'cover'
                });
            }
         
          };
    """;
  }
}