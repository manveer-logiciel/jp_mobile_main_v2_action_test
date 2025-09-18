import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/models/customer/customer.dart';
import 'package:jobprogress/common/models/email/email.dart';
import 'package:jobprogress/common/models/email/profile_detail.dart';
import 'package:jobprogress/common/models/email/recipients_setting.dart';
import 'package:jobprogress/common/models/email/template_list.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/sql/user/user.dart';
import 'package:jobprogress/common/models/sql/user/user_limited.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/core/constants/recurring_constant.dart';
import 'package:jobprogress/modules/email/compose/controller.dart';

void main() {
  late EmailComposeController controller;
  final emailTemplate = EmailListingModel();
  final emailTemplateModel = EmailTemplateListingModel();

  final tempUser = UserLimitedModel(
    id: 1,
    firstName: 'John',
    fullName: 'Doe',
    email: 'john@gmail.com',
    groupId: 1,
  );

  List<String> customerType = [];
  List<String> emailType = [];

  setUpAll(() {
    WidgetsFlutterBinding.ensureInitialized();

    AuthService.userDetails = UserModel(
      id: 1,
      firstName: 'John',
      fullName: 'Doe',
      email: 'john@gmail.com',
    );

    controller = EmailComposeController();
  });
  
  group("EmailComposeController@setDataOnReplyToEmail should set reply data properly", () {
    test("In case data to set from is not available", () {
      controller.setDataOnReplyToEmail(null);
      expect(controller.to, isEmpty);
      expect(controller.cc, isEmpty);
      expect(controller.bcc, isEmpty);
      expect(controller.initialToValues, isEmpty);
      expect(controller.initialCcValues, isEmpty);
      expect(controller.initialBccValues, isEmpty);
      expect(controller.subject, '');
      expect(controller.attachments, isEmpty);
      expect(controller.ccVisibilty, false);
      expect(controller.bccVisibilty, false);
    });

    group("In case data is available", () {
      group("In case of 'Reply' on email", () {
        group("Email is 'To' section should be filled from email data", () {
          setUp(() {
            controller.to.clear();
            controller.initialToValues.clear();
          });

          test("In case there is only one email was sent to a single person, Only one email should be filled", () {
            emailTemplate.to = ['1@gmail.com'];
            controller.setDataOnReplyToEmail(emailTemplate);
            expect(controller.to, ['1@gmail.com']);
            expect(controller.initialToValues.length, equals(1));
          });

          test("In case email was sent to multiple people, All emails should be filled", () {
            emailTemplate.to = ['1@gmail.com', '2@gmail.com'];
            controller.setDataOnReplyToEmail(emailTemplate);
            expect(controller.to, ['1@gmail.com', '2@gmail.com']);
            expect(controller.initialToValues.length, equals(2));
          });

          test('Logged In users email should be excluded on replying', () {
            emailTemplate.to = ['1@gmail.com', '2@gmail.com', AuthService.userDetails!.email!];
            controller.setDataOnReplyToEmail(emailTemplate);
            expect(controller.to, ['1@gmail.com', '2@gmail.com']);
            expect(controller.initialToValues.length, equals(2));
          });

          test("'From' email should be filled in 'To' if it's not logged In user's email", () {
            emailTemplate.from = '1@gmail.com';
            emailTemplate.to?.clear();
            controller.setDataOnReplyToEmail(emailTemplate);
            expect(controller.to, ['1@gmail.com']);
          });

          test("'From' email should not be filled in 'To' if it's logged In user's email", () {
            emailTemplate.from = AuthService.userDetails!.email!;
            emailTemplate.to?.clear();
            controller.setDataOnReplyToEmail(emailTemplate);
            expect(controller.to, isEmpty);
          });

          test('Both "From" and "To" emails should be filled', () {
            emailTemplate.to?.clear();
            emailTemplate.from = '1@gmail.com';
            emailTemplate.to = ['2@gmail.com'];
            controller.setDataOnReplyToEmail(emailTemplate);
            expect(controller.to, ['2@gmail.com', '1@gmail.com']);
          });
        });

        group("'CC' section should not be filled", () {
          test("When email has no 'CC' data, It should not be filled", () {
            emailTemplate.cc = [];
            controller.setDataOnReplyToEmail(emailTemplate);
            expect(controller.cc, isEmpty);
            expect(controller.initialCcValues, isEmpty);
          });

          test("When email has 'CC' data, It should not be filled", () {
            emailTemplate.cc = ['1@gmail.com'];
            controller.setDataOnReplyToEmail(emailTemplate);
            expect(controller.cc, isEmpty);
            expect(controller.initialCcValues, isEmpty);
          });
        });
      });

      group("In case of 'Reply All' on email", () {
        setUp(() {
          controller.emailAction = 'replyAll';
          controller.to.clear();
          controller.initialToValues.clear();
          controller.cc.clear();
          controller.initialCcValues.clear();
        });

        test("In case there is only one email was sent to a single person, Only one email should be filled", () {
          emailTemplate.from  = '';
          emailTemplate.to = ['1@gmail.com'];
          controller.setDataOnReplyToEmail(emailTemplate);
          expect(controller.to, ['1@gmail.com']);
          expect(controller.initialToValues.length, equals(1));
        });

        test("In case email was sent to multiple people, All emails should be filled", () {
          emailTemplate.to = ['1@gmail.com', '2@gmail.com'];
          controller.setDataOnReplyToEmail(emailTemplate);
          expect(controller.to, ['1@gmail.com', '2@gmail.com']);
          expect(controller.initialToValues.length, equals(2));
        });

        test('Logged In users email should be excluded on replying', () {
          emailTemplate.to = ['1@gmail.com', '2@gmail.com', AuthService.userDetails!.email!];
          controller.setDataOnReplyToEmail(emailTemplate);
          expect(controller.to, ['1@gmail.com', '2@gmail.com']);
          expect(controller.initialToValues.length, equals(2));
        });

        test("'From' email should be filled in 'To' if it's not logged In user's email", () {
          emailTemplate.from = '1@gmail.com';
          emailTemplate.to?.clear();
          controller.setDataOnReplyToEmail(emailTemplate);
          expect(controller.to, ['1@gmail.com']);
        });

        test("'From' email should not be filled in 'To' if it's logged In user's email", () {
          emailTemplate.from = AuthService.userDetails!.email!;
          emailTemplate.to?.clear();
          controller.setDataOnReplyToEmail(emailTemplate);
          expect(controller.to, isEmpty);
        });

        test('Both "From" and "To" emails should be filled', () {
          emailTemplate.to?.clear();
          emailTemplate.from = '1@gmail.com';
          emailTemplate.to = ['2@gmail.com'];
          controller.setDataOnReplyToEmail(emailTemplate);
          expect(controller.to, ['2@gmail.com', '1@gmail.com']);
        });

        test("'CC' section should be filled", () {
          emailTemplate.cc = ['1@gmail.com'];
          controller.setDataOnReplyToEmail(emailTemplate);
          expect(controller.cc, ['1@gmail.com']);
          expect(controller.initialCcValues.length, equals(1));
        });

        test("'BCC' section should not be filled", () {
          emailTemplate.bcc = ['1@gmail.com'];
          controller.setDataOnReplyToEmail(emailTemplate);
          expect(controller.bcc, isEmpty);
          expect(controller.initialBccValues, isEmpty);
        });
      });
    });
  });
  
  group("EmailComposeController@clearPreFilledData should decide and clear prefilled data", () {
    group("In case of 'To' emails", () {
      test("Prefilled 'To' emails should be removed when there are 'To' emails in Email Template", () {
        emailTemplateModel.to = ['1@gmail.com', '2@gmail.com'];
        controller.clearPreFilledData(emailTemplateModel);
        expect(controller.to, isEmpty);
        expect(controller.initialToValues, isEmpty);
      });

      test("Prefilled 'To' emails should not be removed when there are no 'To' emails in Email Template", () {
        controller.to = ['1@gmail.com'];
        controller.initialToValues = [
          EmailProfileDetail(
            email: '1@gmail.com',
            name: '1@gmail.com',
          )
        ];

        emailTemplateModel.to = [];
        controller.clearPreFilledData(emailTemplateModel);
        expect(controller.to, ['1@gmail.com']);
        expect(controller.initialToValues.length, equals(1));
      });
    });

    group("In case of 'CC' emails", () {
      test("Prefilled 'CC' emails should be removed when there are 'CC' emails in Email Template", () {
        emailTemplateModel.cc = ['1@gmail.com', '2@gmail.com'];
        controller.clearPreFilledData(emailTemplateModel);
        expect(controller.cc, isEmpty);
        expect(controller.initialCcValues, isEmpty);
      });

      test("Prefilled 'CC' emails should not be removed when there are no 'CC' emails in Email Template", () {
        controller.cc = ['1@gmail.com'];
        controller.initialCcValues = [
          EmailProfileDetail(
            email: '1@gmail.com',
            name: '1@gmail.com',
          )
        ];

        emailTemplateModel.cc = [];
        controller.clearPreFilledData(emailTemplateModel);
        expect(controller.cc, ['1@gmail.com']);
        expect(controller.initialCcValues.length, equals(1));
      });
    });

    group("In case of 'BCC' emails", () {
      test("Prefilled 'BCC' emails should be removed when there are 'BCC' emails in Email Template", () {
        emailTemplateModel.bcc = ['1@gmail.com', '2@gmail.com'];
        controller.clearPreFilledData(emailTemplateModel);
        expect(controller.bcc, isEmpty);
        expect(controller.initialBccValues, isEmpty);
      });

      test("Prefilled 'BCC' emails should not be removed when there are no 'BCC' emails in Email Template", () {
        controller.bcc = ['1@gmail.com'];
        controller.initialBccValues = [
          EmailProfileDetail(
            email: '1@gmail.com',
            name: '1@gmail.com',
          )
        ];

        emailTemplateModel.bcc = [];
        controller.clearPreFilledData(emailTemplateModel);
        expect(controller.bcc, ['1@gmail.com']);
        expect(controller.initialBccValues.length, equals(1));
      });
    });
  });

  group("EmailComposeController@addEmailsAccordingToSetting should set emails from template Recipient Settings", () {
    group("In case of 'To' emails", () {
      test("When template has No Recipients in Settings, No email should be added", () {
        emailTemplateModel.recipientSetting = RecipientSettingModel([], [], []);
        controller.addEmailsAccordingToSetting(emailTemplateModel);
        expect(emailTemplateModel.to, isEmpty);
      });

      test("When template has Recipients in Settings, emails should be added", () {
        controller.job = JobModel(id: 1, customerId: 1, customer: CustomerModel(email: '1@gmail.com'));
        emailTemplateModel.recipientSetting = RecipientSettingModel([RecurringConstants.customer], [], []);
        controller.addEmailsAccordingToSetting(emailTemplateModel);
        expect(emailTemplateModel.to, ['1@gmail.com']);
      });
    });

    group("In case of 'CC' emails", () {
      test("When template has No Recipients in Settings, No email should be added", () {
        emailTemplateModel.recipientSetting = RecipientSettingModel([], [], []);
        controller.addEmailsAccordingToSetting(emailTemplateModel);
        expect(emailTemplateModel.cc, isEmpty);
      });

      test("When template has Recipients in Settings, emails should be added", () {
        controller.job = JobModel(id: 1, customerId: 1, customer: CustomerModel(email: '1@gmail.com'));
        emailTemplateModel.recipientSetting = RecipientSettingModel([], [RecurringConstants.customer], []);
        controller.addEmailsAccordingToSetting(emailTemplateModel);
      });
    });

    group("In case of 'BCC' emails", () {
      test("When template has No Recipients in Settings, No email should be added", () {
        emailTemplateModel.recipientSetting = RecipientSettingModel([], [], []);
        controller.addEmailsAccordingToSetting(emailTemplateModel);
        expect(emailTemplateModel.bcc, isEmpty);
      });

      test("When template has Recipients in Settings, emails should be added", () {
        controller.job = JobModel(id: 1, customerId: 1, customer: CustomerModel(email: '1@gmail.com'));
        emailTemplateModel.recipientSetting = RecipientSettingModel([], [], [RecurringConstants.customer]);
        controller.addEmailsAccordingToSetting(emailTemplateModel);
      });
    });
  });

  group("EmailComposeController@setEmailData should set Emails in Email Templates from Recipient Settings", () {
    test("When template has No Recipients in Settings, No email should be added", () {
      customerType = [];
      controller.setEmailData(customerType, emailType);
      expect(emailType, isEmpty);
    });

    group("When template has Recipients in Settings, emails should be added", () {
      group("In case of 'customer' recipient", () {
        setUp(() {
          emailType = [];
        });

        test("When customer email does not exists, It should not be added", () {
          controller.job = JobModel(id: 1, customerId: 1, customer: CustomerModel());
          customerType = [RecurringConstants.customer];
          controller.setEmailData(customerType, emailType);
          expect(emailType, isEmpty);
        });

        test("When customer email exists but empty, It should not be added", () {
          controller.job = JobModel(id: 1, customerId: 1, customer: CustomerModel(email: ''));
          customerType = [RecurringConstants.customer];
          controller.setEmailData(customerType, emailType);
          expect(emailType, isEmpty);
        });

        test("When customer email exists and not empty, It should be added", () {
          controller.job = JobModel(id: 1, customerId: 1, customer: CustomerModel(email: '1@gmail.com'));
          customerType = [RecurringConstants.customer];
          controller.setEmailData(customerType, emailType);
          expect(emailType, ['1@gmail.com']);
        });

        tearDown(() {
          emailType = [];
        });
      });

      group("In case of 'customer-rep' recipient", () {
        setUp(() {
          emailType = [];
        });

        test("When customer rep email does not exists, It should not be added", () {
          controller.job = JobModel(id: 1, customerId: 1, customer: CustomerModel());
          customerType = [RecurringConstants.customerRep];
          controller.setEmailData(customerType, emailType);
          expect(emailType, isEmpty);
        });

        test("When customer rep email exists but empty, It should not be added", () {
          controller.job = JobModel(id: 1, customerId: 1, customer: CustomerModel(rep: tempUser..email = ''));
          customerType = [RecurringConstants.customerRep];
          controller.setEmailData(customerType, emailType);
          expect(emailType, isEmpty);
        });

        test("When customer rep email exists and not empty, It should be added", () {
          controller.job = JobModel(id: 1, customerId: 1, customer: CustomerModel(rep: tempUser..email = '1@gmail.com'));
          customerType = [RecurringConstants.customerRep];
          controller.setEmailData(customerType, emailType);
          expect(emailType, ['1@gmail.com']);
        });
      });

      group("In case of 'company-crew' recipient", () {
        setUp(() {
          emailType = [];
        });

        test("When company crew email does not exists, It should not be added", () {
          controller.job = JobModel(id: 1, customerId: 1);
          customerType = [RecurringConstants.companyCrew];
          controller.setEmailData(customerType, emailType);
          expect(emailType, isEmpty);
        });

        test("When company crew email exists but empty, It should not be added", () {
          controller.job = JobModel(id: 1, customerId: 1, reps: []);
          customerType = [RecurringConstants.companyCrew];
          controller.setEmailData(customerType, emailType);
          expect(emailType, isEmpty);
        });

        test("When company crew email exists and not empty, It should be added", () {
          controller.job = JobModel(id: 1, customerId: 1, reps: [tempUser]);
          customerType = [RecurringConstants.companyCrew];
          controller.setEmailData(customerType, emailType);
          expect(emailType, [tempUser.email]);
        });
      });

      group("In case of 'sub-contractor' recipient", () {
        setUp(() {
          emailType = [];
        });

        test("When sub-contractor email does not exists, It should not be added", () {
          controller.job = JobModel(id: 1, customerId: 1);
          customerType = [RecurringConstants.sub];
          controller.setEmailData(customerType, emailType);
          expect(emailType, isEmpty);
        });

        test("When sub-contractor email exists but empty, It should not be added", () {
          controller.job = JobModel(id: 1, customerId: 1, subContractors: []);
          customerType = [RecurringConstants.sub];
          controller.setEmailData(customerType, emailType);
          expect(emailType, isEmpty);
        });

        test("When sub-contractor email exists and not empty, It should be added", () {
          controller.job = JobModel(id: 1, customerId: 1, subContractors: [tempUser]);
          customerType = [RecurringConstants.sub];
          controller.setEmailData(customerType, emailType);
          expect(emailType, [tempUser.email]);
        });
      });

      group("In case of 'estimate' recipient", () {
        setUp(() {
          emailType = [];
        });

        test("When estimate email does not exists, It should not be added", () {
          controller.job = JobModel(id: 1, customerId: 1);
          customerType = [RecurringConstants.estimate];
          controller.setEmailData(customerType, emailType);
          expect(emailType, isEmpty);
        });

        test("When estimate email exists but empty, It should not be added", () {
          controller.job = JobModel(id: 1, customerId: 1, estimators: []);
          customerType = [RecurringConstants.estimate];
          controller.setEmailData(customerType, emailType);
          expect(emailType, isEmpty);
        });

        test("When estimate email exists and not empty, It should be added", () {
          controller.job = JobModel(id: 1, customerId: 1, estimators: [tempUser]);
          customerType = [RecurringConstants.estimate];
          controller.setEmailData(customerType, emailType);
          expect(emailType, [tempUser.email]);
        });
      });
    });
  });
}