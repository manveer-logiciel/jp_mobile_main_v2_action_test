import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/enums/chats.dart';
import 'package:jobprogress/common/enums/file_listing.dart';
import 'package:jobprogress/common/models/address/address.dart';
import 'package:jobprogress/common/models/customer/customer.dart';
import 'package:jobprogress/common/models/customer/referred_by/referred_by.dart';
import 'package:jobprogress/common/models/email.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/label.dart';
import 'package:jobprogress/common/models/launchdarkly/flags.dart';
import 'package:jobprogress/common/models/sql/user/user_limited.dart';
import 'package:jobprogress/common/models/suppliers/branch.dart';
import 'package:jobprogress/common/models/suppliers/srs/srs_ship_to_address.dart';
import 'package:jobprogress/common/models/suppliers/suppliers.dart';
import 'package:jobprogress/common/models/workflow_stage.dart';
import 'package:jobprogress/common/services/company_settings.dart';
import 'package:jobprogress/core/config/app_env.dart';
import 'package:jobprogress/core/constants/auth_constant.dart';
import 'package:jobprogress/core/constants/common_constants.dart';
import 'package:jobprogress/core/constants/company_seetings.dart';
import 'package:jobprogress/core/constants/launchdarkly/flag_keys.dart';
import 'package:jobprogress/core/constants/message_type_constant.dart';
import 'package:jobprogress/core/constants/user_roles.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

void main() {
   WorkFlowStageModel work = WorkFlowStageModel(name: '', color: '', code: '');

   SrsShipToAddressModel? account = SrsShipToAddressModel();
   SupplierBranchModel? branch = SupplierBranchModel();

  group("Check getJobName function returns when different value pass in 'value' keyword of setCompanySettings function ",() {
    JobModel job = JobModel(id: 123, customerId: 123, currentStage:work, altId: 'Alt143', name: 'Kabira', number: '123', divisionCode: '786');
    test("getJobName Should return job number value when 'none' is pass in value keyword",() {
      CompanySettingsService.setCompanySettings([{
        "id": 10795,
        "key": "JOB_ID_REPLACE_WITH",
        "name": "Job Id Replace with",
        "value": "none"
      }]); 

      expect(Helper.getJobName(job), '123');
    });
    test("getJobName Should return job name value when 'name' is pass in value keyword ", () {
      CompanySettingsService.setCompanySettings([{
        "id": 10795,
        "key": "JOB_ID_REPLACE_WITH",
        "name": "Job Id Replace with",
        "value": "name"
      }]);

      expect( Helper.getJobName(job), 'Kabira');
    });
    test("getJobName Should return 'divison code-alt id' value when 'alt-id' is pass in value keyword ", () {
      CompanySettingsService.setCompanySettings([{
        "id": 10795,
        "key": "JOB_ID_REPLACE_WITH",
        "name": "Job Id Replace with",
        "value": "alt_id"
      }]);

      expect(Helper.getJobName(job), '786-Alt143');
    });
  });

  group('Check returns of getJobFunction  when  name ,divison code ,alt_id  having null value in job list',() {
    test("Should return job number when job name is null and  'name' is pass in value keyword of setCompanySettings function  ", () {
      JobModel job = JobModel(id: 123, customerId: 123, currentStage:work, altId: 'Alt143', number: '123',name: '', divisionCode: '786');
      CompanySettingsService.setCompanySettings([{
        "id": 10795,
        "key": "JOB_ID_REPLACE_WITH",
        "name": "Job Id Replace with",
        "value": "name"
      }]);

      expect(Helper.getJobName(job), '123');
   });
    test("Should return only alt-id when  division code is null and  'alt_id' is pass in value keyword of setCompanySettings function ", () {
        JobModel job = JobModel(id: 123, customerId: 123, currentStage:work, altId: 'Alt143', number: '123', name: '',divisionCode: '');
        CompanySettingsService.setCompanySettings([{
          "id": 10795,
          "key": "JOB_ID_REPLACE_WITH",
          "name": "Job Id Replace with",
          "value": "alt_id"
        }]); 

      expect(Helper.getJobName(job), 'Alt143');
    });

    test("Should return only job number when  division code is null ,altId is also null  and  'alt_id' is pass in value keyword of setCompanySettings function ", () {
      JobModel job = JobModel(id: 123, customerId: 123, currentStage:work, altId: '', number: '123', name: '',divisionCode: '786');
      CompanySettingsService.setCompanySettings([{
        "id": 10795,
        "key": "JOB_ID_REPLACE_WITH",
        "name": "Job Id Replace with",
        "value": "alt_id"
      }]);

      expect(Helper.getJobName(job), '123');
    });
  });
  
  test(
      "Should given empty value address, addressLine1, city converted in address",
      () {
    AddressModel address =
        AddressModel(id: 1, address: '', addressLine1: '', city: '');
    final fullAddress = Helper.convertAddress(address);
    expect(fullAddress, '');
  });

  test("Should given value addressLine1, city converted in address", () {
    AddressModel address = AddressModel(
        id: 1, address: '', addressLine1: 'jain', city: 'Prayagraj');
    final fullAddress = Helper.convertAddress(address);
    expect(fullAddress, 'jain, Prayagraj');
  });

  test("Should given value address, city converted in address", () {
    AddressModel address = AddressModel(
        id: 1,
        address: 'A1/161 Badri Awaas Yojna',
        addressLine1: '',
        city: 'Prayagraj');
    final fullAddress = Helper.convertAddress(address);
    expect(fullAddress, 'A1/161 Badri Awaas Yojna, Prayagraj');
  });

  test("Should given value address, addressLine1 converted in address", () {
    AddressModel address = AddressModel(
        id: 1,
        address: 'A1/161 Badri Awaas Yojna',
        addressLine1: 'jain',
        city: '');
    final fullAddress = Helper.convertAddress(address);
    expect(fullAddress, 'A1/161 Badri Awaas Yojna, jain');
  });

  test("Should given value address, addressLine1, city converted in address",
      () {
    AddressModel address = AddressModel(
        id: 1,
        address: 'A1/161 Badri Awaas Yojna',
        addressLine1: 'jain',
        city: 'Prayagraj');
    final fullAddress = Helper.convertAddress(address);
    expect(fullAddress, 'A1/161 Badri Awaas Yojna, jain, Prayagraj');
  });

  group('Converting html text to free text', () {
    test('When data is already html free', () {
      String data = 'My name is Leap';
      String result = Helper.parseHtmlToText(data);
      expect(result, data);
    });

    test('When data contains basic html tags', () {
      String data =
          '<p>My name is Leap.<br/>Am a very big application</p>';
      String result = Helper.parseHtmlToText(data);
      expect(result, 'My name is Leap.Am a very big application');
    });

    test('When data contains html tag with properties', () {
      String data = '<h2 style="color: #2e6c80;">My name is Leap.</h2>';
      String result = Helper.parseHtmlToText(data);
      expect(result, 'My name is Leap.');
    });

    test('When data contains multiple html tag with properties', () {
      String data = """<h2 style="color: #2e6c80;">My name is Leap.</h2>
          <p>My name is Leap.<br>Am a very big application</p>""";
      String result = Helper.parseHtmlToText(data);

      expect(result,
          'My name is Leap.\nMy name is Leap.Am a very big application');
    });

    test('When data contains single incomplete html tag with properties', () {
      String data = '<h2 style="color: #2e6c80;">My name is Leap';
      String result = Helper.parseHtmlToText(data);
      expect(result, 'My name is Leap');
    });

    test('When data contains multiple incomplete html tag with properties', () {
      String data =
          '<h2 style="color: #2e6c80;">My name is Leap<p> My name is Leap.';
      String result = Helper.parseHtmlToText(data);
      expect(result, 'My name is Leap My name is Leap.');
    });

    test('When data contains multiple paragraphs', () {
      String data = """<p>This is first paragraph</p>
      <p>This is second paragraph. This is second paragraph. This is second paragraph. This is second paragraph. This is second paragraph. This is second paragraph. </p>
      <p>This is third paragraph. This is third paragraph. </p>
      """;
      String result = Helper.parseHtmlToText(data);
      String value =
          """This is first paragraph\nThis is second paragraph. This is second paragraph. This is second paragraph. This is second paragraph. This is second paragraph. This is second paragraph. \nThis is third paragraph. This is third paragraph.""";
      expect(result, value);
    });

    test('When data contains sub tags', () {
      String data = """<p><strong>Lorem Ipsum</strong> is simply </p>
      <p><strong>Lorem Ipsum</strong> is simply </p>
      """;
      String result = Helper.parseHtmlToText(data);
      String value = """Lorem Ipsum is simply \nLorem Ipsum is simply""";

      expect(result, value);
    });

    test('When data contains &nbsp;', () {
      String data = """<p><strong>Lorem Ipsum</strong>&nbsp;is simply </p>
      <p><strong>Lorem Ipsum</strong>&nbsp;is simply </p>
      """;
      String result = Helper.parseHtmlToText(data);
      String value = """Lorem Ipsum is simply \nLorem Ipsum is simply""";
      expect(result, value);
    });

    test('Parsing complete HTML file', () {
      String data =
          """<h1 style="color: #5e9ca0;">You can edit <span style="color: #2b2301;">this demo</span> text!</h1>
<h2 style="color: #2e6c80;">How to use the editor:</h2>
<p>Paste your documents in the visual editor on the left or your HTML code in the source editor in the right. <br />Edit any of the two areas and see the other changing in real time.&nbsp;</p>
<p>Click the <span style="background-color: #2b2301; color: #fff; display: inline-block; padding: 3px 10px; font-weight: bold; border-radius: 5px;">Clean</span> button to clean your source code.</p>
<h2 style="color: #2e6c80;">Some useful features:</h2>
<ol style="list-style: none; font-size: 14px; line-height: 32px; font-weight: bold;">
<li style="clear: both;"><img style="float: left;" src="https://html-online.com/img/01-interactive-connection.png" alt="interactive connection" width="45" /> Interactive source editor</li>
<li style="clear: both;"><img style="float: left;" src="https://html-online.com/img/02-html-clean.png" alt="html cleaner" width="45" /> HTML Cleaning</li>
<li style="clear: both;"><img style="float: left;" src="https://html-online.com/img/03-docs-to-html.png" alt="Word to html" width="45" /> Word to HTML conversion</li>
<li style="clear: both;"><img style="float: left;" src="https://html-online.com/img/04-replace.png" alt="replace text" width="45" /> Find and Replace</li>
<li style="clear: both;"><img style="float: left;" src="https://html-online.com/img/05-gibberish.png" alt="gibberish" width="45" /> Lorem-Ipsum generator</li>
<li style="clear: both;"><img style="float: left;" src="https://html-online.com/img/6-table-div-html.png" alt="html table div" width="45" /> Table to DIV conversion</li>
</ol>""";
      String result = Helper.parseHtmlToText(data);
      String value =
          """You can edit this demo text!\nHow to use the editor:\nPaste your documents in the visual editor on the left or your HTML code in the source editor in the right. Edit any of the two areas and see the other changing in real time. \nClick the Clean button to clean your source code.\nSome useful features:\nInteractive source editor\nHTML Cleaning\nWord to HTML conversion\nFind and Replace\nLorem-Ipsum generator\nTable to DIV conversion""";

      expect(result, value);
    });
    
  });

  test('Helper@formatNote should return blank tag in childrens', () {
      String value = '';   
      List<UserLimitedModel>? mentions = [ UserLimitedModel(id: 85, firstName: 'Standard', fullName: 'Standard User00', email: 'standard@logiciel.io', groupId: 1)];

      TextSpan result = Helper.formatNote(value, mentions, 'id', 'full_name', JPAppTheme.themeColors.text, JPTextSize.heading4);  
      var children = <InlineSpan>[
        JPTextSpan.getSpan('')
      ];
      expect(result.children, children);
    });

  group('Helper@formatBase64String should format base64 string', () {

    test('If signature image type is jpeg', () {
      String signature = "data:image/jpeg;base64,demobase64String";
      String result = Helper.formatBase64String(signature);

      expect(result, 'demobase64String');
    });

    test('If signature image type is png', () {
      String signature = "data:image/png;base64,demobase64String";
      String result = Helper.formatBase64String(signature);

      expect(result, 'demobase64String');
    });

  });
  
  test('Helper@formatNote should return one tag in childrens', () {
      String value = 'rthryrt @[u:85]';  
      List<UserLimitedModel>? mentions = [ UserLimitedModel(id: 85, firstName: 'Standard', fullName: 'Standard User00', email: 'standard@logiciel.io', groupId: 1)];

      TextSpan result = Helper.formatNote(value, mentions, 'id', 'full_name', JPAppTheme.themeColors.text, JPTextSize.heading4); 

      var children = <InlineSpan>[
        JPTextSpan.getSpan('rthryrt '),
        JPTextSpan.getSpan('@Standard User00', textColor: JPAppTheme.themeColors.primary),
        JPTextSpan.getSpan('')
      ];

      expect(result.children, children);
    });

  test('Helper@formatNote should not return any tag in childrens', () {
      String value = 'rthryrt rthryrt rthryrt rthryrt';   
      List<UserLimitedModel>? mentions = [ UserLimitedModel(id: 85, firstName: 'Standard', fullName: 'Standard User00', email: 'standard@logiciel.io', groupId: 1)];

      TextSpan result = Helper.formatNote(value, mentions, 'id', 'full_name', JPAppTheme.themeColors.text, JPTextSize.heading4); 
      var children = <InlineSpan>[ JPTextSpan.getSpan('rthryrt rthryrt rthryrt rthryrt') ];

      expect(result.children, children);
    });

  test('Helper@formatNote should not return tag in childrens if matched userId is not in mention list', () {      
      String value = '@[u:35] rthryrt @[u:85]';
      List<UserLimitedModel>? mentions = [ UserLimitedModel(id: 35, firstName: 'Owner', fullName: 'Owner User00', email: 'standard@logiciel.io', groupId: 1)];

      TextSpan result = Helper.formatNote(value, mentions, 'id', 'full_name', JPAppTheme.themeColors.text, JPTextSize.heading4); 
      var children = <InlineSpan>[
        JPTextSpan.getSpan(''),
        JPTextSpan.getSpan('@Owner User00', textColor: JPAppTheme.themeColors.primary),
        JPTextSpan.getSpan(' rthryrt '),
        JPTextSpan.getSpan('@[u:85]'),
        JPTextSpan.getSpan('')
      ];

      expect(result.children, children);
    });

  test('Helper@formatNote should return two tag in childrens', () {
      String value = '@[u:85] rthryrt @[u:85]';  
      List<UserLimitedModel>? mentions = [ UserLimitedModel(id: 85, firstName: 'Standard', fullName: 'Standard User00', email: 'standard@logiciel.io', groupId: 1)];

      TextSpan result = Helper.formatNote(value, mentions, 'id', 'full_name', JPAppTheme.themeColors.text, JPTextSize.heading4); 

      var children = <InlineSpan>[
        JPTextSpan.getSpan(''),
        JPTextSpan.getSpan('@Standard User00', textColor: JPAppTheme.themeColors.primary),
        JPTextSpan.getSpan(' rthryrt '),
        JPTextSpan.getSpan('@Standard User00', textColor: JPAppTheme.themeColors.primary),
        JPTextSpan.getSpan('')
      ];

      expect(result.children, children);
    });

  group("Helper@formatNote should conditionally add read more button", () {
    test("In case text is less than limit, complete note should be shown without read more button", () {
      String value = '@[u:35] this is test small note @[u:85]';
      List<UserLimitedModel>? mentions = [ UserLimitedModel(id: 35, firstName: 'Owner', fullName: 'Owner User00', email: 'standard@logiciel.io', groupId: 1)];

      TextSpan result = Helper.formatNote(value, mentions, 'id', 'full_name', JPAppTheme.themeColors.text, JPTextSize.heading4, limit: 100);
      var children = <InlineSpan>[
        JPTextSpan.getSpan(''),
        JPTextSpan.getSpan('@Owner User00', textColor: JPAppTheme.themeColors.primary),
        JPTextSpan.getSpan(' this is test small note '),
        JPTextSpan.getSpan('@[u:85]'),
        JPTextSpan.getSpan('')
      ];

      expect(result.children, children);
    });

    group("In case text is greater than limit", () {
      test("Read more button should be shown", () {
        String value = '@[u:35] this is test small note this is test small note this is test small note this is test at 100 char @[u:85]';
        List<UserLimitedModel>? mentions = [ UserLimitedModel(id: 35, firstName: 'Owner', fullName: 'Owner User00', email: 'standard@logiciel.io', groupId: 1)];

        TextSpan result = Helper.formatNote(value, mentions, 'id', 'full_name', JPAppTheme.themeColors.text, JPTextSize.heading4, limit: 100);
        var children = <InlineSpan>[
          JPTextSpan.getSpan(''),
          JPTextSpan.getSpan('@Owner User00', textColor: JPAppTheme.themeColors.primary),
          JPTextSpan.getSpan(' this is test small note this is test small note this is test small note this is test'),
          JPTextSpan.getSpan('... read_more', textColor: JPAppTheme.themeColors.primary, fontStyle: FontStyle.italic,),
        ];

        expect(result.children, children);
      });

      test("Non parsable mentions should be excluded", () {
        String value = '@[u:35] this is test small note this is test small note this is test small note this is one @[u:85] the test';
        List<UserLimitedModel>? mentions = [ UserLimitedModel(id: 35, firstName: 'Owner', fullName: 'Owner User00', email: 'standard@logiciel.io', groupId: 1)];

        TextSpan result = Helper.formatNote(value, mentions, 'id', 'full_name', JPAppTheme.themeColors.text, JPTextSize.heading4, limit: 100);
        var children = <InlineSpan>[
          JPTextSpan.getSpan(''),
          JPTextSpan.getSpan('@Owner User00', textColor: JPAppTheme.themeColors.primary),
          JPTextSpan.getSpan(' this is test small note this is test small note this is test small note this is one'),
          JPTextSpan.getSpan('... read_more', textColor: JPAppTheme.themeColors.primary, fontStyle: FontStyle.italic,),
        ];

        expect(result.children, children);
      });
    });
  });

    group('Helper@isValueNullOrEmpty  should check whether value is null or empty', () {
      test('when value is null', () {
        String? value;
        bool isValueNullOrEmpty = Helper.isValueNullOrEmpty(value);
        expect(isValueNullOrEmpty, true);
      });
      test('when value is empty', (){
        String value = '';
        bool isValueNullOrEmpty = Helper.isValueNullOrEmpty(value);
        expect(isValueNullOrEmpty, true);
      });
      test('When value is not null or empty', (){
        String value = '1';
        bool isValueNullOrEmpty = Helper.isValueNullOrEmpty(value);
        expect(isValueNullOrEmpty, false);
      });
    });

 group('Helper@getWorkCrewName should return company name or full name', () {
    // Test case 1: byRoleName is true, user is a sub contractor prime, and company name is not null or empty
    test('Should return full name with company name, when byRoleName is true, user is sub contractor prime, and company name is not null or empty', () {
      // Setup
      UserLimitedModel user = UserLimitedModel(
        roleName: AuthConstant.subContractorPrime, 
        companyName: 'Company A', 
        email: '', 
        firstName: '', 
        fullName: 'John Doe', 
        groupId: -1, 
        id:-1
      );

      // Test
      var result = Helper.getWorkCrewName(user, byRoleName: true);

      expect(result, '${user.fullName} (${user.companyName})');
    });

    // Test case 2: byRoleName is true, user is a sub contractor prime, but company name is null or empty
    test('Should return full name, when byRoleName is true, user is a sub contractor prime, but company name is null or empty', () {
      // Setup
      UserLimitedModel user = UserLimitedModel(
        roleName: AuthConstant.subContractorPrime, 
        companyName: '', 
        email: '', 
        firstName: '', 
        fullName: 'John', 
        groupId: -1, 
        id:-1
      );

      // Test
      var result = Helper.getWorkCrewName(user, byRoleName: true);

      expect(result, user.fullName);
    });

    // Test case 3: byRoleName is true, user is not a sub contractor prime
    test('Should return full name, when byRoleName is true and user is not a sub contractor prime', () {
      // Setup
      UserLimitedModel user = UserLimitedModel(
        roleName: 'SomeOtherRole', 
        companyName: 'Company A', 
        email: '', 
        firstName: '', 
        fullName: 'John', 
        groupId: -1, 
        id:-1
      );

      // Test
      var result = Helper.getWorkCrewName(user, byRoleName: true);

      expect(result, user.fullName);
    });

    // Test case 4: byRoleName is false, user is a sub contractor or labor, and company name is not null or empty
    test('Should return full name with company name, when byRoleName is false, user is a sub contractor or labor, and company name is not null or empty', () {
      // Setup
      UserLimitedModel user = UserLimitedModel(
        roleName: 'SomeOtherRole', 
        companyName: 'Company B', 
        email: '', 
        firstName: '', 
        fullName: 'John', 
        groupId: UserGroupIdConstants.subContractor, 
        id:-1
      );
      // Test
      var result = Helper.getWorkCrewName(user);

      expect(result, '${user.fullName} (${user.companyName})');
    });

    // Test case 5: byRoleName is false, user is a sub contractor or labor, but company name is null or empty
    test('Should return full name, when byRoleName is false, user is a sub contractor or labor, but company name is null or empty', () {
      // Setup
      UserLimitedModel user = UserLimitedModel(
        roleName: 'SomeOtherRole', 
        companyName: '', 
        email: '', 
        firstName: '', 
        fullName: 'John', 
        groupId: UserGroupIdConstants.subContractor, 
        id:-1
      );
      // Test
      var result = Helper.getWorkCrewName(user);

      expect(result, user.fullName);
    });

    // Test case 6: byRoleName is false, user is not a sub contractor or labor
    test('Should return full name, when byRoleName is false and user is not a sub contractor or labor should return full name', () {
      // Setup
      UserLimitedModel user = UserLimitedModel(
        roleName: 'SomeOtherRole', 
        companyName: '', 
        email: 'Company B', 
        firstName: '', 
        fullName: 'John', 
        groupId: -1, 
        id:-1
      );

      // Test
      var result = Helper.getWorkCrewName(user);

      expect(result, user.fullName);
    });
  
  }); 

  group('Helper@convertEmailListToStringList should parse email data to a list of email ', () {
    test('empty list should be return when email data is not available', () {
      final result = Helper.convertEmailListToStringList(null);
      
      expect(result, isEmpty);
    });
    
    test('empty list should be return when email data is available but empty', () {
      final result = Helper.convertEmailListToStringList([]);
      
      expect(result, isEmpty);
    });
    
    test('should parse email models data to a list of email strings', () {
      List<EmailModel>? emailList = [
        EmailModel(email: 'email1@example.com'), 
        EmailModel(email: 'email2@example.com'), 
        EmailModel(email: 'email3@example.com')];
      final result = Helper.convertEmailListToStringList(emailList);
      
      expect(result, equals(['email1@example.com', 'email2@example.com', 'email3@example.com']));
    });
    
    test('should not parse models data to a list of string representations when model data is already a string', () {
      final models = ['email1@example.com', 'email2@example.com', 'email3@example.com'];
      final result = Helper.convertEmailListToStringList(models, isAlreadyString: true);
      
      expect(result, equals(['email1@example.com', 'email2@example.com', 'email3@example.com']));
    });
  });

  group("Helper@extractIncludesFormParams should extract all includes from api params", () {
    test('All includes should be extracted to a list', () {
      Map<String, dynamic> params = {
        'param1': 'value1',
        'param2': 'value2',
        'includes[0]': 'include1',
        'includes[1]': 'include2',
      };

      List<dynamic> result = Helper.extractIncludesFormParams(params);
      expect(result, ['include1', 'include2']);
    });

    test('All includes should be removed from original params', () {
      Map<String, dynamic> params = {
        'param1': 'value1',
        'param2': 'value2',
        'includes[0]': 'include1',
        'includes[1]': 'include2',
      };

      Helper.extractIncludesFormParams(params);
      expect(params.keys, ['param1', 'param2']);
    });
  });

  group("Helpers@getSupplierId should give supplier id as per key", () {
    test('SRS id should be returned for SRS key', () {
      final result = Helper.getSupplierId(key: CommonConstants.srsId);
      expect(result, 3);
    });

    test('Beacon id should be returned for Beacon key', () {
      final result = Helper.getSupplierId(key: CommonConstants.beaconId);
      expect(result, 173);
    });

    test('SRS id should be returned by default, If key is not given', () {
      final result = Helper.getSupplierId();
      expect(result, 3);
    });

    group('When SRS v2 is enabled', () {
      setUpAll(() {
        final flagDetails = LDFlags.allFlags[LDFlagKeyConstants.srsV2MaterialIntegration];
        flagDetails?.value = true;
      });
      tearDownAll(() {
        final flagDetails = LDFlags.allFlags[LDFlagKeyConstants.srsV2MaterialIntegration];
        flagDetails?.value = null;
      });
      test('SRS id should be returned for SRS key', () {
        final result = Helper.getSupplierId();
        expect(result, 181);
      });

      test('SRS id should be returned by default, If key is not given', () {
        final result = Helper.getSupplierId();
        expect(result, 181);
      });
    });
  });

  group("Helpers@isSupplierHaveBeaconItem should check if suppliers list has beacon supplier", () {
    test("When suppliers list does not exist, it should return false", () {
      final result = Helper.isSupplierHaveBeaconItem(null);
      expect(result, false);
    });

    test("When suppliers list is empty, it should return false", () {
      final result = Helper.isSupplierHaveBeaconItem([]);
      expect(result, false);
    });

    test("When suppliers list does not contain beacon supplier, it should return false", () {
      final result = Helper.isSupplierHaveBeaconItem([
        SuppliersModel()
      ]);
      expect(result, false);
    });

    test("When suppliers list contains beacon supplier, it should return true", () {
      final result = Helper.isSupplierHaveBeaconItem([
        SuppliersModel(
          id: 173
        )
      ]);
      expect(result, true);
    });
  });

   group('Helpers@isSRSv2Id should check', () {
     group('In case of SRS type', () {
       test('When supplierId matched', () {
         // Arrange
         int supplierId = 181; // Example valid supplierId
         // Act
         bool result = Helper.isSRSv2Id(supplierId);
         // Assert
         expect(result, true);
       });

       test('When supplierId does not match', () {
         // Arrange
         int supplierId = 789; // Example invalid supplierId
         // Act
         bool result =  Helper.isSRSv2Id(supplierId);
         // Assert
         expect(result, false);
       });
     });
   });
  group('Helper@filterDuplicatesByKey should filter duplicate items', () {
    test('when given a list of integers', () {
      final items = [1, 2, 2, 3, 4, 4, 4, 5];
      final result = Helper.filterDuplicatesByKey(items, (int item) => item);
      expect(result, [1, 2, 3, 4, 5]);
    });

    test('when given a list of strings', () {
      final items = ['apple', 'banana', 'apple', 'cherry', 'banana', 'date'];
      final result = Helper.filterDuplicatesByKey(items, (String item) => item);
      expect(result, ['apple', 'banana', 'cherry', 'date']);
    });

    test('when given a list of maps', () {
      final items = [
        {'id': 1, 'name': 'Alice'},
        {'id': 2, 'name': 'Bob'},
        {'id': 1, 'name': 'Alice'},
        {'id': 3, 'name': 'Charlie'},
        {'id': 2, 'name': 'Bob'}
      ];
      final result = Helper.filterDuplicatesByKey(items, (item) => item['id']);
      expect(result, [
        {'id': 1, 'name': 'Alice'},
        {'id': 2, 'name': 'Bob'},
        {'id': 3, 'name': 'Charlie'}
      ]);
    });

    test('when given a list of models', () {
      final items = [
        EmailLabelModel(id: 1, createdAt: ''),
        EmailLabelModel(id: 2, createdAt: ''),
        EmailLabelModel(id: 3, createdAt: ''),
        EmailLabelModel(id: 2, createdAt: ''),
        EmailLabelModel(id: 1, createdAt: ''),
      ];
      final result = Helper.filterDuplicatesByKey(items, (EmailLabelModel emailLabelModel) => emailLabelModel.id);
      expect(result.length, 3);
      expect(result[0].id, 1);
      expect(result[1].id, 2);
      expect(result[2].id, 3);
    });

    test('when given an empty list', () {
      final items = <int>[];
      final result = Helper.filterDuplicatesByKey(items, (int item) => item);
      expect(result, <int>[]);
    });

    test('when there are no duplicates', () {
      final items = [1, 2, 3, 4, 5];
      final result = Helper.filterDuplicatesByKey(items, (int item) => item);
      expect(result, [1, 2, 3, 4, 5]);
    });
  });
   
   group("Helpers@resourceType should return correct type as per module", () {
     test("In case of ${FLModule.jobContracts} resource type should be [contract]", () {
       final result = Helper.resourceType(FLModule.jobContracts);
       expect(result, 'contract');
     });

     test("For any unknown module resource type should be [resource]", () {
       final result = Helper.resourceType(null);
       expect(result, 'resource');
     });
   });

   group('Helper@getCustomerReferredBy should return referredBy on the basis of referredByType', () {
    test('Should returns referredByNote for referredByType "other"', () {
      final customer = CustomerModel(referredByType: 'other', referredByNote: 'Note about referral');
      expect(Helper.getCustomerReferredBy(customer), 'Note about referral');
    });

    test('if showExistingCustomerLabel is true should returns customer fullNameMobile with label of "existing_customer" for referredByType "customer"', () {
      final referredBy = CustomerReferredBy(fullNameMobile: 'John Doe');
      final customer = CustomerModel(referredByType: 'customer', referredBy: referredBy);
      expect(Helper.getCustomerReferredBy(customer, showExistingCustomerLabel: true), 'John Doe (existing_customer)'); // Make sure you mock 'existing_customer'.tr if needed
    });

    test('if showExistingCustomerLabel is false should returns fullNameMobile without label for referredByType "customer"', () {
      final referredBy = CustomerReferredBy(fullNameMobile: 'John Doe');
      final customer = CustomerModel(referredByType: 'customer', referredBy: referredBy);
      expect(Helper.getCustomerReferredBy(customer), 'John Doe');
    });

    test('should returns fullName for referredByType "referral"', () {
      final referredBy = CustomerReferredBy(fullName: 'Jane Smith');
      final customer = CustomerModel(referredByType: 'referral', referredBy: referredBy);
      expect(Helper.getCustomerReferredBy(customer), 'Jane Smith');
    });

    test('should returns empty string for unknown referredByType', () {
      final customer = CustomerModel(referredByType: 'unknown');
      expect(Helper.getCustomerReferredBy(customer), '');
    });

    test('should returns empty string for null customer', () {
      expect(Helper.getCustomerReferredBy(null), '');
    });
  });

   group('Helpers@getSRSV1Supplier should get', () {
       test('get SRS v1 Supplier Id', () {
         // Act
         int? result = Helper.getSRSV1Supplier();
         // Assert
         expect(result, isNotNull);
       });

       test('not get SRS v1 Supplier Id', () {
         Map<String, dynamic> suppliers = AppEnv.envConfig[CommonConstants.suppliersIds];
         suppliers.remove(CommonConstants.srsId);
         // Act
         int? result =  Helper.getSRSV1Supplier();
         // Assert
         expect(result, isNull);
       });
   });

   group('Helpers@getSRSV2Supplier should get', () {
     test('get SRS v2 Supplier Id', () {
       // Act
       int? result = Helper.getSRSV2Supplier();
       // Assert
       expect(result, isNotNull);
     });

     test('not get SRS v2 Supplier Id', () {
       Map<String, dynamic> suppliers = AppEnv.envConfig[CommonConstants.suppliersIds];
       suppliers.remove(CommonConstants.srsV2Id);
       // Act
       int? result =  Helper.getSRSV2Supplier();
       // Assert
       expect(result, isNull);
     });
   });

  group('Helper@isBeaconSupplierId should check', () {
    test('When supplier id is beacon id', () {
      const beaconId = 173; // Valid Beacon id
      expect(Helper.isBeaconSupplierId(beaconId), isTrue);
    });

    test('When supplier id is not beacon id', () {
      const beaconId = 13; // Invalid Beacon id
      expect(Helper.isBeaconSupplierId(beaconId), isFalse);
    });
  });

  group('Helper@formattedUnderscoreString should convert string with underscores to Title Case', () {
    test('Should convert string with underscores to Title Case', () {
      String eventName = 'salespro_contract_created';
      String formattedString = Helper.formattedUnderscoreString(eventName);
      expect(formattedString, 'Salespro Contract Created');
    });

    test('Should format string with multiple words separated by underscores', () {
      String eventName = 'appointment_resulted';
      String formattedString = Helper.formattedUnderscoreString(eventName);
      expect(formattedString, 'Appointment Resulted');
    });

    test('Should handle single word input by capitalizing the first letter', () {
      String eventName = 'user';
      String formattedString = Helper.formattedUnderscoreString(eventName);
      expect(formattedString, 'User');
    });

    test('Should return an empty string for null input', () {
      const eventName = null;
      String formattedString = Helper.formattedUnderscoreString(eventName);
      expect(formattedString, '');
    });

    test('Should return an empty string for empty input', () {
      String eventName = '';
      String formattedString = Helper.formattedUnderscoreString(eventName);
      expect(formattedString, '');
    });

    test('Should handle consecutive underscores between words', () {
      String eventName = 'shipping__order__received';
      String formattedString = Helper.formattedUnderscoreString(eventName);
      expect(formattedString, 'Shipping Order Received');
    });

    test('Should format string with leading and trailing underscores correctly', () {
      String eventName = '_leading_and_trailing_';
      String formattedString = Helper.formattedUnderscoreString(eventName);
      expect(formattedString, 'Leading And Trailing');
    });

    test('Should handle strings with uppercase letters and underscores', () {
      String eventName = 'ORDER_SHIPPED';
      String formattedString = Helper.formattedUnderscoreString(eventName);
      expect(formattedString, 'Order Shipped');
    });

    test('Should handle mixed case strings with underscores', () {
      String eventName = 'Payment_received';
      String formattedString = Helper.formattedUnderscoreString(eventName);
      expect(formattedString, 'Payment Received');
    });

    test('Should return properly formatted string when no underscores are present', () {
      String eventName = 'singleword';
      String formattedString = Helper.formattedUnderscoreString(eventName);
      expect(formattedString, 'Singleword');
    });
  });

  group('Helper@getMessageType should get type', () {
    test('When Firestore messaging is enabled', () {
      CompanySettingsService.companySettings = {
        CompanySettingConstants.realTimeMessaging: {
          'value': true
        }
      };
      expect(Helper.getMessageType(''), GroupsListingType.fireStoreMessages);
    });

    group('When Firestore messaging is not enabled', () {
      setUpAll(() {
        CompanySettingsService.companySettings = {
          CompanySettingConstants.realTimeMessaging: {
            'value': false
          }
        };
      });

      test('When message type is SMS', () {
        expect(Helper.getMessageType(MessageTypeConstant.sms), GroupsListingType.apiTexts);
      });

      test('When message type is not SMS type', () {
        expect(Helper.getMessageType('SYSTEM_MESSAGE'), GroupsListingType.apiMessages);
      });
    });
  });

  group('Helper@getAbcAccountName should get ABC account name', () {
    test('When account is not available', () {
      account = null;
      expect(Helper.getAbcAccountName(account), isEmpty);
    });

    group('When account is available', () {
      setUpAll(() {
        account = SrsShipToAddressModel();
      });

      test('When address line 1 is available', () {
        account?.addressLine1 = 'ABC';
        account?.shipToId = '1';
        expect(Helper.getAbcAccountName(account), "${account?.shipToId}: ${account?.addressLine1}");
      });

      test('When address line 1 is not available', () {
        account?.addressLine1 = '';
        account?.shipToId = '2';
        expect(Helper.getAbcAccountName(account), account?.shipToId);
      });
    });
  });

   group('Helper@getAbcBranchName should get ABC branch name', () {
     test('When branch is not available', () {
       branch = null;
       expect(Helper.getAbcBranchName(branch), isEmpty);
     });

     group('When branch is available', () {
       setUpAll(() {
         branch = SupplierBranchModel();
       });

       test('When branch id is available', () {
         branch?.branchId = '1';
         branch?.name = 'ABC';
         expect(Helper.getAbcBranchName(branch), "${branch?.branchId}: ${branch?.name}");
       });

       test('When branch id is not available', () {
         branch?.branchId = '';
         branch?.name = '2';
         expect(Helper.getAbcBranchName(branch), branch?.name);
       });
     });
   });
}

