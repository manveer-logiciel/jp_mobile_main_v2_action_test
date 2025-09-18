import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/models/email/template_list.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/job/recurring_email.dart';
import 'package:jobprogress/common/models/workflow_stage.dart';
import 'package:jobprogress/common/models/attachment.dart';
import 'package:jobprogress/core/constants/common_constants.dart';
import 'package:jobprogress/core/constants/work_flow_stage_color.dart';
import 'package:jobprogress/modules/job/job_sale_automation_email_listing/controller.dart';

void main() {
  final controller = JobSaleAutomationEmailLisitingController();
  
  List<WorkFlowStageModel> stages = [
    WorkFlowStageModel(name: 'JP Stage 1', color: 'cl-blue', code: '0001'),
    WorkFlowStageModel(name: 'JP Stage 2', color: 'cl-yellow', code: '0002'),
    WorkFlowStageModel(name: 'JP Stage 3', color: 'cl-red', code: '0002'),
  ];
  
  JobModel job = JobModel(
    id: 1, 
    customerId: 1,
    stages: stages
  ); 
  
  List<EmailTemplateListingModel> templateList = [
    EmailTemplateListingModel(
      isChecked: true,
      recurringEmailData: RecurringEmailModel(endStageCode:'0001')
    ),
  ];

  List<EmailTemplateListingModel> emailTemplateList = [
    EmailTemplateListingModel(
      to: ['recipient1@example.com'],
      cc: ['cc1@example.com', 'cc2@example.com'],
      bcc: ['bcc1@example.com'],
    ),
    EmailTemplateListingModel(
      to: ['recipient2@example.com', 'recipient3@example.com'],
      cc: [],
      bcc: [],
    ),
    EmailTemplateListingModel(
      to: ['recipient4@example.com'],
      cc: null,
      bcc: null,
    ),
  ];

  test('JobSaleAutomationEmailLisitingController@getEndStageName should return endStageName when index, job, templateList pass', () {
    String endStageName = controller.getEndStageName(index: 0, job: job, templateList: templateList);
    expect(endStageName, 'JP Stage 1');
  });
  
  test('JobSaleAutomationEmailLisitingController@getEndStageColor should return endStageColor when index, job, templateList pass',() {
    Color endStageColor = controller.getEndStageColor(index: 0, job: job, templateList: templateList);
    expect(endStageColor, WorkFlowStageConstants.colors['cl-blue']);
  });
  
  group('JobSaleAutomationEmailLisitingController@toggleIsChecked test cases', () {
    controller.toggleIsChecked(0,templateList);
    
    test('Should return false in templateList[index]@isChecked if isChecked on that index is true', () {
      expect(templateList[0].isChecked, false);
    });
    
    test('Should return false in templateList[index]@isChecked if isChecked on that index is true', () {
      controller.toggleIsChecked(0, templateList);
      expect(templateList[0].isChecked, true);
    });
  });
  
  group("JobSaleAutomationEmailLisitingController@getRecipients should give correct list of recipients", () {
    setUp(() {
      controller.templateList = emailTemplateList;
    });

    test("Email recipients should be extracted from given index", () {
      final recipients = controller.getRecipients(0);
      expect(recipients, {
        'to[]': ['recipient1@example.com'],
        'cc[]': ['cc1@example.com', 'cc2@example.com'],
        'bcc[]': ['bcc1@example.com'],
      });
    });

    test("In case of any empty recipient, it should be set as empty", () {
      final recipients = controller.getRecipients(1);
      expect(recipients, {
        'to[]': ['recipient2@example.com', 'recipient3@example.com'],
        'cc[]': <dynamic>[],
        'bcc[]': <dynamic>[],
      });
    });

    test("In case recipient does not exists, it should be set as null", () {
      final recipients = controller.getRecipients(2);
      expect(recipients, {
        'to[]': ['recipient4@example.com'],
        'cc[]': null,
        'bcc[]': null,
      });
    });

    test("Single recipient should be set correctly", () {
      final recipients = controller.getRecipients(0);
      expect(recipients['to[]'], ['recipient1@example.com']);
    });

    test("Multiple recipients should be set correctly", () {
      final recipients = controller.getRecipients(1);
      expect(recipients['to[]'], ['recipient2@example.com', 'recipient3@example.com']);
    });
  });
  
  group("JobSaleAutomationEmailLisitingController@getRecipientsForReccuringEmail should give correct list of recipients", () {
    setUp(() {
      controller.templateList = emailTemplateList;
    });

    test("Email recipients should be extracted from given index", () {
      final recipients = controller.getRecipientsForReccuringEmail(0);
      expect(recipients, {
        'to': {
          '0': 'recipient1@example.com',
        },
        'cc': {
          '0': 'cc1@example.com',
          '1': 'cc2@example.com',
        },
        'bcc': {
          '0': 'bcc1@example.com',
        },
      });
    });

    test("In case of any empty recipient, it should be set as empty", () {
      final recipients = controller.getRecipientsForReccuringEmail(1);
      expect(recipients, {
        'to': {'0': 'recipient2@example.com', '1': 'recipient3@example.com'},
        'cc': <String, dynamic>{},
        'bcc': <String, dynamic>{}
      });
    });

    test("In case recipient does not exists, it should be set as null", () {
      final recipients = controller.getRecipientsForReccuringEmail(2);
      expect(recipients, {
        'to': {
          '0': 'recipient4@example.com',
        },
        'cc': <String, dynamic>{},
        'bcc': <String, dynamic>{},
      });
    });

    test("Single recipient should be set correctly", () {
      final recipients = controller.getRecipientsForReccuringEmail(0);
      expect(recipients['to'], {
        '0': 'recipient1@example.com',
      });
    });

    test("Multiple recipients should be set correctly", () {
      final recipients = controller.getRecipientsForReccuringEmail(1);
      expect(recipients['to'], {
        '0': 'recipient2@example.com',
        '1': 'recipient3@example.com',
      });
    });
  });

  group('JobSaleAutomationEmailLisitingController@processAttachmentsForEmail test cases', () {
    test('Should return empty attachments when no attachments present', () async {
      // Setup template with no attachments
      controller.templateList = [
        EmailTemplateListingModel(
          template: '<p>Test content</p>',
          attachments: null,
        ),
      ];
      // Set actualTemplate manually since it's not in constructor
      controller.templateList[0].actualTemplate = '<p>Test content</p>';

      final result = await controller.processAttachmentsForEmail(0);

      expect(result['attachments'], isEmpty);
      expect(result['content'], equals('<p>Test content</p>'));
    });

    test('Should return normal attachments when total size is within limit', () async {
      // Setup template with small attachments (under 7MB limit)
      controller.templateList = [
        EmailTemplateListingModel(
          template: '<p>Test content</p>',
          attachments: [
            AttachmentResourceModel(
              id: 1,
              type: 'photo',
              name: 'small_file.jpg',
              size: 1000000, // 1MB
            ),
            AttachmentResourceModel(
              id: 2,
              type: 'document',
              name: 'small_doc.pdf',
              size: 2000000, // 2MB
            ),
          ],
        ),
      ];
      // Set actualTemplate manually since it's not in constructor
      controller.templateList[0].actualTemplate = '<p>Test content</p>';

      final result = await controller.processAttachmentsForEmail(0);

      expect(result['attachments'], hasLength(2));
      expect(result['attachments'][0]['type'], equals('photo'));
      expect(result['attachments'][0]['value'], equals(1));
      expect(result['attachments'][1]['type'], equals('document'));
      expect(result['attachments'][1]['value'], equals(2));
      expect(result['content'], equals('<p>Test content</p>'));
    });

    test('Should return recurring format attachments when isRecurring is true and size is within limit', () async {
      // Setup template with small attachments
      controller.templateList = [
        EmailTemplateListingModel(
          template: '<p>Test content</p>',
          attachments: [
            AttachmentResourceModel(
              id: 1,
              type: 'photo',
              name: 'small_file.jpg',
              size: 1000000, // 1MB
            ),
          ],
        ),
      ];
      // Set actualTemplate manually since it's not in constructor
      controller.templateList[0].actualTemplate = '<p>Test content</p>';

      final result = await controller.processAttachmentsForEmail(0, isRecurring: true);

      expect(result['attachments'], hasLength(1));
      expect(result['attachments'][0]['ref_type'], equals('photo'));
      expect(result['attachments'][0]['ref_id'], equals(1));
      expect(result['content'], equals('<p>Test content</p>'));
    });

    test('Should have correct attachment size limit constant', () {
      // Test that the size limit is correctly set to 7MB
      expect(CommonConstants.maxAllowedEmailFileSize, equals(7340032));
    });
  });
}
