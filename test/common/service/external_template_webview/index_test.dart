import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/models/customer/customer.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_model.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_quick_action_params.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/sql/user/user_limited.dart';
import 'package:jobprogress/common/models/templates/form_proposal/template.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/common/services/external_temlate_web_view/index.dart';
import 'package:jobprogress/core/config/app_env.dart';
import 'package:jobprogress/core/constants/shared_pref_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../modules/files_listing/file_listing_test.dart';
import 'external_template_url_test_helper.dart';

void main() {

  late ExternalTemplateTestHelper urlParser;

  String tempAccessToken = "abc";
  String baseUrl = "abc";

  List<int> order = [0, 1, 2];
  List<String> groups = ['Group 1', 'Group 2', 'Group 3'];
  List<FilesListingModel> resourceList = [];

  FilesListingModel tempFile = FilesListingModel(
    id: '5',
    isFile: true,
    pageType: 'legal',
    groupId: 'gid',
  );

  FormProposalTemplateModel tempProposal = FormProposalTemplateModel(
    id: 1,
    templateId: 15,
  );

  JobModel tempJob = JobModel(
    id: 0,
    customerId: 12,
    isMultiJob: false,
    altId: "p1",
    leadNumber: "j1",
    name: "job",
    description: "test desc",
    duration: "12:22:11",
    customer: CustomerModel(
      id: 123
    ),
    reps: [
      UserLimitedModel(id: 12, firstName: "temp", fullName: "temp name", email: "email", groupId: 1),
      UserLimitedModel(id: 12, firstName: "temp", fullName: "temp name", email: "email", groupId: 1)
    ],
  );

  final tempActionParams = FilesListingQuickActionParams(
    fileList: [tempFile],
    jobModel: tempJob,
    onActionComplete: (_, __) {},
  );

  setUpAll(() async {
    AppEnv.setEnvironment(Environment.dev);
    baseUrl = AppEnv.config["EXTERNAL_TEMPLATE_URL_PREFIX"];
    SharedPreferences.setMockInitialValues({
      PrefConstants.accessToken: jsonEncode(tempAccessToken),
      PrefConstants.user: jsonEncode(userJson),
    });
    await AuthService.getLoggedInUser();
    urlParser = ExternalTemplateTestHelper(baseUrl);
  });

  group('ExternalTemplateWebViewService@createProposalTemplateUrl should generate correct url for creating external proposal template', () {
    setUp(() async {
      String url = await ExternalTemplateWebViewService.createProposalTemplateUrl(tempJob, '10');
      urlParser.splitIntoPieces(url);
    });

    test("Base URL should be set correctly", () {
      expect(urlParser.baseUrl, baseUrl);
    });

    test("Customer ID should be inserted just after 'customer-jobs'", () {
      final result = urlParser.getJustAfter('customer-jobs');
      expect(result, tempJob.customer?.id.toString());
    });

    test("Job ID should be inserted just after 'job'", () {
      final result = urlParser.getJustAfter('job');
      expect(result, tempJob.id.toString());
    });

    test("File ID should be inserted just after 'proposals'", () {
      final result = urlParser.getJustAfter('proposals');
      expect(result, '10');
    });

    test("Query params should be set properly", () {
      expect(urlParser.queryParams, {
        'access_token': tempAccessToken,
        'user_id': '1',
      });
    });

    test("Complete URL should be generated correctly", () {
      expect(urlParser.completeUrl, equals(
          "https://dev.jobprog.net/qb/#/mobile/customer-jobs/123/job/0/proposals/10/create?access_token=abc&user_id=1"
      ));
    });
  });

  group("ExternalTemplateWebViewService@getEditTemplateUrl should generate correct url for editing external proposal template", () {
    setUp(() async {
      String url = await ExternalTemplateWebViewService.getEditTemplateUrl(tempActionParams);
      urlParser.splitIntoPieces(url);
    });

    group("In case of 'proposal' template", () {
      test("Base URL should be set correctly", () {
        expect(urlParser.baseUrl, baseUrl);
      });

      test("Customer ID should be inserted just after 'customer-jobs'", () {
        final result = urlParser.getJustAfter('customer-jobs');
        expect(result, tempJob.customer?.id.toString());
      });

      test("Job ID should be inserted just after 'job'", () {
        final result = urlParser.getJustAfter('job');
        expect(result, tempJob.id.toString());
      });

      test("File ID should be inserted just after 'proposals'", () {
        final result = urlParser.getJustAfter('proposals');
        expect(result, '5');
      });

      test("Query params should be set properly", () {
        expect(urlParser.queryParams, {
          'access_token': tempAccessToken,
          'user_id': '1',
        });
      });

      test("Complete URL should be generated correctly", () {
        expect(urlParser.completeUrl, equals(
          "https://dev.jobprog.net/qb/#/mobile/customer-jobs/123/job/0/proposals/5/edit?access_token=abc&user_id=1"
        ));
      });
    });

    group("In case of 'insurance' template", () {
      setUp(() async {
        tempActionParams.fileList.first.insuranceEstimate = true;
        String url = await ExternalTemplateWebViewService.getEditTemplateUrl(tempActionParams);
        urlParser.splitIntoPieces(url);
      });

      test("File ID should be inserted just after 'insurance'", () {
        final result = urlParser.getJustAfter('insurance');
        expect(result, '5');
      });

      test("Complete URL should be generated correctly", () {
        expect(urlParser.completeUrl, equals(
          "https://dev.jobprog.net/qb/#/mobile/customer-jobs/123/job/0/insurance/5/edit?access_token=abc&user_id=1"
        ));
      });
    });
  });

  group("ExternalTemplateWebViewService@getUrlData should give URL data from template ids", () {
    group("In case of single template id", () {
      test("URL data for image template should be generated correctly", () {
        final result = ExternalTemplateWebViewService.getUrlData([-1]);
        expect(result, 'templates=images&');
      });

      test("URL data for selling price template should be generated correctly", () {
        final result = ExternalTemplateWebViewService.getUrlData([-2]);
        expect(result, 'templates=pricing&');
      });

      test("URL data for other templates should be generated correctly", () {
        final result = ExternalTemplateWebViewService.getUrlData([5]);
        expect(result, 'templates=5&');
      });
    });

    group("In case of multiple template ids", () {
      test("URL data for local templates should be generated correctly", () {
        final result = ExternalTemplateWebViewService.getUrlData([-1, -2]);
        expect(result, 'templates=images&templates=pricing&');
      });

      test("URL data for other templates should be generated correctly", () {
        final result = ExternalTemplateWebViewService.getUrlData([5, 6]);
        expect(result, 'templates=5&templates=6&');
      });

      test("URL data for all templates should be generated correctly", () {
        final result = ExternalTemplateWebViewService.getUrlData([-1, -2, 5, 6]);
        expect(result, 'templates=images&templates=pricing&templates=5&templates=6&');
      });
    });
  });

  group("ExternalTemplateWebViewService@getUrlParams should give URL params", () {
    group("When group ID does not exists", () {
      group("In case of single template id", () {
        test("URL data for image template should be generated correctly", () {
          final result = ExternalTemplateWebViewService.getUrlParams([], [-1]);
          expect(result, 'templates=images&');
        });

        test("URL data for selling price template should be generated correctly", () {
          final result = ExternalTemplateWebViewService.getUrlParams([], [-2]);
          expect(result, 'templates=pricing&');
        });

        test("URL data for other templates should be generated correctly", () {
          final result = ExternalTemplateWebViewService.getUrlParams([], [5]);
          expect(result, 'templates=5&');
        });
      });

      group("In case of multiple template ids", () {
        test("URL data for local templates should be generated correctly", () {
          final result = ExternalTemplateWebViewService.getUrlParams([], [-1, -2]);
          expect(result, 'templates=images&templates=pricing&');
        });

        test("URL data for other templates should be generated correctly", () {
          final result = ExternalTemplateWebViewService.getUrlParams([], [5, 6]);
          expect(result, 'templates=5&templates=6&');
        });

        test("URL data for all templates should be generated correctly", () {
          final result = ExternalTemplateWebViewService.getUrlParams([], [-1, -2, 5, 6]);
          expect(result, 'templates=images&templates=pricing&templates=5&templates=6&');
        });
      });
    });

    group("when group ID exists", () {
      group("In case of single group id", () {
        test("URL data for image template should be generated correctly", () {
          final result = ExternalTemplateWebViewService.getUrlParams(['1'], [-1]);
          expect(result, 'groups=1&templates=images&');
        });

        test("URL data for selling price template should be generated correctly", () {
          final result = ExternalTemplateWebViewService.getUrlParams(['1'], [-2]);
          expect(result, 'groups=1&templates=pricing&');
        });

        test("URL data for other templates should be generated correctly", () {
          final result = ExternalTemplateWebViewService.getUrlParams(['1'], [5]);
          expect(result, 'groups=1&templates=5&');
        });
      });

      group("In case of multiple group ids", () {
        test("URL data for local templates should be generated correctly", () {
          final result = ExternalTemplateWebViewService.getUrlParams(['2', '3'], [-1, -2]);
          expect(result, 'groups=2&groups=3&templates=images&templates=pricing&');
        });

        test("URL data for other templates should be generated correctly", () {
          final result = ExternalTemplateWebViewService.getUrlParams(['2', '3'], [5, 6]);
          expect(result, 'groups=2&groups=3&templates=5&templates=6&');
        });

        test("URL data for all templates should be generated correctly", () {
          final result = ExternalTemplateWebViewService.getUrlParams(['2', '3'], [-1, -2, 5, 6]);
          expect(result, 'groups=2&groups=3&templates=images&templates=pricing&templates=5&templates=6&');
        });
      });
    });
  });

  group("ExternalTemplateWebViewService@getFirstSelectedFileId should return first selected file id", () {
    test('First selected file ID should be equal to "group"', () {
      resourceList = [tempFile..isSelected = true..isGroup = true];
      String result = ExternalTemplateWebViewService.getFirstSelectedFileId(order, groups, resourceList);
      expect(result, equals('group'));
    });

    test('First selected file ID should not be "group" when there are no groups', () {
      resourceList = [tempFile..isSelected = true..isGroup = true];
      String result = ExternalTemplateWebViewService.getFirstSelectedFileId(order, [], resourceList);
      expect(result, isNot(equals('group')));
    });

    test('First selected file ID should not be "group" when it\'s not a group', () {
      resourceList = [tempFile..isSelected = true..isGroup = false];
      String result = ExternalTemplateWebViewService.getFirstSelectedFileId(order, groups, resourceList);
      expect(result, isNot(equals('group')));
    });

    test('First selected file ID should not be "group" when it\'s a group but not selected', () {
      resourceList = [tempFile..isSelected = false..isGroup = true];
      String result = ExternalTemplateWebViewService.getFirstSelectedFileId(order, groups, resourceList);
      expect(result, isNot(equals('group')));
    });

    test("First selected file ID should be first selected template id", () {
      resourceList = [tempFile
        ..isSelected = true
        ..isGroup = true
        ..proposalTemplatePages = [tempProposal..isSelected = true]
      ];

      String result = ExternalTemplateWebViewService.getFirstSelectedFileId(order, [], resourceList);
      expect(result, equals('15'));
    });

    test("First selected file ID should be other than first selected template id", () {
      resourceList = [tempFile
        ..isSelected = true
        ..isGroup = true
        ..proposalTemplatePages = [tempProposal..isSelected = false]
      ];

      String result = ExternalTemplateWebViewService.getFirstSelectedFileId(order, [], resourceList);
      expect(result, isNot(equals('15')));
    });

    test("First selected file ID should be first selected template id", () {
      resourceList = [tempFile
        ..isSelected = true
        ..isGroup = false
        ..proposalTemplatePages = [tempProposal..isSelected = true]
      ];
      String result = ExternalTemplateWebViewService.getFirstSelectedFileId(order, [], resourceList);
      expect(result, equals('1'));
    });

    test("First selected file ID should be other than first selected template id", () {
      resourceList = [tempFile
        ..isSelected = true
        ..isGroup = true
        ..proposalTemplatePages = [tempProposal..isSelected = false]
      ];
      String result = ExternalTemplateWebViewService.getFirstSelectedFileId(order, [], resourceList);
      expect(result, isNot(equals('1')));
    });

    test("First selected file ID should be 'images' if selected page is local image template", () {
      resourceList = [tempFile
        ..isGroup = false
        ..proposalTemplatePages = [tempProposal..id = -1..isSelected = false]
      ];
      String result = ExternalTemplateWebViewService.getFirstSelectedFileId(order, [], resourceList);
      expect(result, equals('images'));
    });

    test("First selected file ID should be other than 'images'", () {
      resourceList = [tempFile
        ..proposalTemplatePages = [tempProposal..id = -2..isSelected = false]
      ];
      String result = ExternalTemplateWebViewService.getFirstSelectedFileId(order, [], resourceList);
      expect(result, isNot(equals('images')));
    });

    test("First selected file ID should be 'pricing' if selected page is local pricing template", () {
      resourceList = [tempFile
        ..proposalTemplatePages = [tempProposal..id = -2..isSelected = false]
      ];
      String result = ExternalTemplateWebViewService.getFirstSelectedFileId(order, [], resourceList);
      expect(result, equals('pricing'));
    });

    test("First selected file ID should be other than 'pricing'", () {
      resourceList = [tempFile
        ..proposalTemplatePages = [tempProposal..id = -1..isSelected = false]
      ];
      String result = ExternalTemplateWebViewService.getFirstSelectedFileId(order, [], resourceList);
      expect(result, isNot(equals('pricing')));
    });

    test("First selected file ID should be the ID of first template", () {
      resourceList = [tempFile
        ..proposalTemplatePages = [tempProposal..id = 5..isSelected = true]
      ];
      String result = ExternalTemplateWebViewService.getFirstSelectedFileId(order, [], resourceList);
      expect(result, equals('5'));
    });
  });

  group("ExternalTemplateWebViewService@createMergeTemplateUrl should generate correct url for merge template", () {
    group("In case of normal file", () {
      setUp(() async {
        resourceList = [tempFile
          ..proposalTemplatePages = [tempProposal..id = 5..isSelected = true]
        ];
        String url = await ExternalTemplateWebViewService.createMergeTemplateUrl(order, resourceList, tempJob);
        urlParser.splitIntoPieces(url);
      });

      test("Base URL should be correct", () {
        expect(urlParser.baseUrl, baseUrl);
      });

      test("Customer ID should be inserted just after 'customer-jobs'", () {
        final result = urlParser.getJustAfter('customer-jobs');
        expect(result, tempJob.customer?.id.toString());
      });

      test("Job ID should be inserted just after 'job'", () {
        final result = urlParser.getJustAfter('job');
        expect(result, tempJob.id.toString());
      });

      test("Page type should be inserted just after 'insurance'", () {
        final result = urlParser.getJustAfter('insurance');
        expect(result, 'legal');
      });

      test("File ID should be added just after page type", () {
        final result = urlParser.getJustAfter('legal');
        expect(result, '5');
      });

      test("Query params should be set properly", () {
        expect(urlParser.queryParams, {'templates': '5', 'access_token': 'abc', 'user_id': '1'});
      });

      test("Complete URL should be generated correctly", () {
        expect(urlParser.completeUrl, equals(
            "https://dev.jobprog.net/qb/#/mobile/customer-jobs/123/job/0/insurance/legal/5/create?templates=5&access_token=abc&user_id=1"
        ));
      });
    });

    group("In case of image template", () {
      setUp(() async {
        resourceList = [tempFile
          ..proposalTemplatePages = [
            tempProposal..id = -1
              ..isSelected = true
              ..pageType = 'legal'
          ]
        ];
        String url = await ExternalTemplateWebViewService.createMergeTemplateUrl(order, resourceList, tempJob);
        urlParser.splitIntoPieces(url);
      });

      test("File ID should be added just after page type", () {
        final result = urlParser.getJustAfter('legal');
        expect(result, 'images');
      });

      test("Query params should be set properly", () {
        expect(urlParser.queryParams, {'templates': 'images', 'access_token': 'abc', 'user_id': '1'});
      });

      test("Complete URL should be generated correctly", () {
        expect(urlParser.completeUrl,equals(
            "https://dev.jobprog.net/qb/#/mobile/customer-jobs/123/job/0/insurance/legal/images/create?templates=images&access_token=abc&user_id=1"
        ));
      });
    });

    group("In case of pricing template", () {
      setUp(() async {
        resourceList = [tempFile
          ..proposalTemplatePages = [
            tempProposal..id = -2
              ..isSelected = true
          ]
        ];
        String url = await ExternalTemplateWebViewService.createMergeTemplateUrl(order, resourceList, tempJob);
        urlParser.splitIntoPieces(url);
      });

      test("File ID should be added just after page type", () {
        final result = urlParser.getJustAfter('legal');
        expect(result, 'pricing');
      });

      test("Query params should be set properly", () {
        expect(urlParser.queryParams, {'templates': 'pricing', 'access_token': 'abc', 'user_id': '1'});
      });

      test("Complete URL should be generated correctly", () {
        expect(urlParser.completeUrl, equals(
            "https://dev.jobprog.net/qb/#/mobile/customer-jobs/123/job/0/insurance/legal/pricing/create?templates=pricing&access_token=abc&user_id=1"
        ));
      });
    });

    group("In case of grouped template", () {
      setUp(() async {
        resourceList = [tempFile..proposalTemplatePages = [
            tempProposal..id = 5
          ]..isGroup = true..isSelected = true
        ];
        String url = await ExternalTemplateWebViewService.createMergeTemplateUrl(order, resourceList, tempJob);
        urlParser.splitIntoPieces(url);
      });

      test("File ID should be added just after page type", () {
        final result = urlParser.getJustAfter('legal');
        expect(result, 'group');
      });

      test("Complete URL should be generated correctly", () {
        expect(urlParser.completeUrl, equals(
            "https://dev.jobprog.net/qb/#/mobile/customer-jobs/123/job/0/insurance/legal/group/create?groups=gid&access_token=abc&user_id=1"
        ));
      });
    });

    group("In case of grouped template with not whole group is selected", () {
      setUp(() async {
        resourceList = [tempFile..proposalTemplatePages = [
            tempProposal..id = 5,
            tempProposal..id = 6..isSelected = true,
          ]..isGroup = true
        ];
        String url = await ExternalTemplateWebViewService.createMergeTemplateUrl(order, resourceList, tempJob);
        urlParser.splitIntoPieces(url);
      });

      test("File ID should be added just after page type", () {
        final result = urlParser.getJustAfter('legal');
        expect(result, 'group');
      });

      test("Complete URL should be generated correctly", () {
        expect(urlParser.completeUrl, equals(
            "https://dev.jobprog.net/qb/#/mobile/customer-jobs/123/job/0/insurance/legal/group/create?groups=gid&access_token=abc&user_id=1"
        ));
      });
    });

    group("Page type should be correctly added to URL", () {
      test("'legal' page type should be added", () async {
        resourceList = [tempFile..proposalTemplatePages = [tempProposal..id = 5]];
        String url = await ExternalTemplateWebViewService.createMergeTemplateUrl(order, resourceList, tempJob);
        urlParser.splitIntoPieces(url);

        final result = urlParser.getJustAfter('insurance');
        expect(result, 'legal');
      });

      test("'a4' page type should be added", () async {
        resourceList = [tempFile..proposalTemplatePages = [tempProposal..id = 5..pageType = 'a4']..pageType = 'a4-page'..isSelected = true];
        String url = await ExternalTemplateWebViewService.createMergeTemplateUrl(order, resourceList, tempJob);
        urlParser.splitIntoPieces(url);

        final result = urlParser.getJustAfter('insurance');
        expect(result, 'a4');
      });
    });
  });
}