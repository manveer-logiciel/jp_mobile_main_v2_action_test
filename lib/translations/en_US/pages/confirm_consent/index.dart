import '../../../../core/constants/urls.dart';

class EnUsConfirmConsentMessageTranslations {
  static Map<String, String> strings = {
    'confirm_consent_message': "What type of message will you be sending the consumer now or in the future?",
    'no_messaging': "No messaging",
    'no_messaging_consent_message': "I do not intend to communicate through messaging with this customer, or they have specifically requested to not be contacted.",
    'transactional_messaging': "Transactional messaging",
    'transactional_messaging_consent_message': "I wish to send the customer transactional(${Urls.transactionalTextingURL}) messages to communicate about a job being estimated or a job in progress.",
    'promotional_messaging': "Promotional messaging",
    'promotional_messaging_consent_message': "In addition to transactional(${Urls.transactionalTextingURL}) messages, I wish to also send the customer promotional(${Urls.promotionalTextingURL}) messages to market my business, promotions we are running, or anything not directly related to the transaction they originally consented to be contacted for.",
    'confirm_express_consent': "Confirm Express Consent",
    'express_consent_conformation_message': "Please confirm you have obtained “express consent” to contact this customer for transactional messaging since they willingly provided their phone number in one of the following ways:",
    'express_consent_conformation_message_statement_1': "Over the phone or in person to a member of your team",
    'express_consent_conformation_message_statement_2': "Through contact form (printed or on your website)",
    'express_consent_conformation_message_statement_3': "Through an email communication",
    'express_consent_conformation_checkbox_message': "I confirm this consumer provided “express consent” to\nbe contacted",
    'remove_consent': "Remove Consent",
    'remove_consent_message': "Are you sure you want to indicate this customer has not given consent to be contacted? You will not be able to send them any messages unless you obtain consent from them again.",
    'remove_consent_checkbox_message': "I understand I can’t send any messages to this customer \nwithout consent",
    'remove_express_consent': "Remove Express Written Consent",
    'remove_express_consent_message': "Are you sure you want to remove express written consent for this customer? You will not be able to send them promotional messages in the future unless you obtain written consent from them again.",
    'remove_express_consent_checkbox_message': "I understand I can’t send promotional messages to this \ncustomer without express written consent.",
    'no': "No",
    'consent_status': "Consent Status",
  };
}