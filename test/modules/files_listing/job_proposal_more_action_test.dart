

import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/enums/file_listing.dart';
import 'package:jobprogress/common/models/files_listing/create_file_actions.dart';
import 'package:jobprogress/common/models/sql/user/user.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/common/services/company_settings.dart';
import 'package:jobprogress/common/services/files_listing/add_more_actions/more_actions_list.dart';
import 'package:jobprogress/common/services/files_listing/quick_action_options.dart';
import 'package:jobprogress/core/constants/user_roles.dart';
import 'package:jp_mobile_flutter_ui/QuickAction/model.dart';

void main(){

  setUpAll((){
    CompanySettingsService.companyGoogleAccount = {
      "company_google_account": true, 
      "status": 200
    };
  });


  group('More actions list when User is Sub contractor prime', (){

    test('Not contains Google spreadsheet template option', (){
      AuthService.userDetails = UserModel(
        id: -1, 
        firstName: "Jay", 
        fullName: "Jaideep", 
        email: "Jay@test.com",
        groupId: UserGroupIdConstants.subContractorPrime
      );
      Map<String, List<JPQuickActionModel>> results = FileListingMoreActionsList.getActions(
        CreateFileActions(
          fileList: [],
          type: FLModule.jobProposal, 
          onActionComplete: (_, __) { },
        )
      );

      final tempResult = results[FileListingMoreActionsList.fileActions]!;
      expect(tempResult.contains(FileListingQuickActionOptions.spreadSheetTemplate), false);
    });

  });

  group('More actions list when User is not Sub contractor prime', (){

    test('Contains Google spreadsheet template option', (){
      AuthService.userDetails = UserModel(
        id: -1, 
        firstName: "Jay", 
        fullName: "Jaideep", 
        email: "Jay@test.com",
        groupId: UserGroupIdConstants.admin
      );
      Map<String, List<JPQuickActionModel>> results = FileListingMoreActionsList.getActions(
        CreateFileActions(
          fileList: [],
          type: FLModule.jobProposal, 
          onActionComplete: (_, __) { },
        )
      );

      final tempResult = results[FileListingMoreActionsList.fileActions]!;
      expect(tempResult.contains(FileListingQuickActionOptions.spreadSheetTemplate), true);
    });

  });

}