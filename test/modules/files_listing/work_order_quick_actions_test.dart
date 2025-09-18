import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_model.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_quick_action_params.dart';
import 'package:jobprogress/common/models/files_listing/linked_material.dart';
import 'package:jobprogress/common/models/files_listing/linked_measurement.dart';
import 'package:jobprogress/common/models/files_listing/linked_work_order.dart';
import 'package:jobprogress/common/models/files_listing/my_favourite_entity.dart';
import 'package:jobprogress/common/models/sql/user/user.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/common/services/files_listing/quick_action_helpers.dart';
import 'package:jobprogress/common/services/files_listing/quick_action_options.dart';
import 'package:jobprogress/common/services/files_listing/quick_actions_list.dart';
import 'package:jobprogress/common/services/permission.dart';
import 'package:jobprogress/core/constants/common_constants.dart';
import 'package:jobprogress/core/constants/locale.dart';
import 'package:jobprogress/core/constants/permission.dart';
import 'package:jobprogress/modules/files_listing/controller.dart';
import 'package:jobprogress/translations/index.dart';
import 'package:jp_mobile_flutter_ui/QuickAction/model.dart';
import 'package:jp_mobile_flutter_ui/Thumb/type.dart';

import 'file_listing_test.dart';


void main() {

  FilesListingModel? tempFile;

  setUpAll(() {
    Get.addTranslations(JPTranslations().keys);
    Get.locale = LocaleConst.usa;

    AuthService.userDetails = UserModel(
        id: '1',
        firstName: 'Demo',
        fullName: 'Demo User',
        email: 'abc@test.com'
    );
  });

    group('For work order', (){

      final controller = FilesListingController();
      controller.resourceList = tempResourceList;

      group('In case of directory', () {

        test('When folder is not locked only rename and delete options should be displayed', () {

          Map<String, List<JPQuickActionModel>> result = FileListingQuickActionsList.getWorkOrderActions(
              FilesListingQuickActionParams(
                fileList: [controller.resourceList[4]],
                onActionComplete: (_, __) { },
              )
          );

          final tempResult = result[FileListingQuickActionsList.folderActions]!;

          expect(tempResult.contains(FileListingQuickActionOptions.delete), true);
          expect(tempResult.contains(FileListingQuickActionOptions.rename), true);

        });

        test('When folder is locked no options should be displayed', () {

          Map<String, List<JPQuickActionModel>> result = FileListingQuickActionsList.getWorkOrderActions(
              FilesListingQuickActionParams(
                fileList: [controller.resourceList[5]],
                onActionComplete: (_, __) { },
              )
          );

          final tempResult = result[FileListingQuickActionsList.folderActions]!;

          expect(tempResult.contains(FileListingQuickActionOptions.delete), false);
          expect(tempResult.contains(FileListingQuickActionOptions.rename), false);

        });

      });

      group('In case of file', () {

        test('When file is an image file rotate option should be displayed', () {

          Map<String, List<JPQuickActionModel>> result = FileListingQuickActionsList.getWorkOrderActions(
              FilesListingQuickActionParams(
                fileList: [controller.resourceList[6]],
                onActionComplete: (_, __) { },
              )
          );

          final tempResult = result[FileListingQuickActionsList.fileActions]!;

          expect(tempResult.contains(FileListingQuickActionOptions.delete), true);
          expect(tempResult.contains(FileListingQuickActionOptions.rename), true);
          expect(tempResult.contains(FileListingQuickActionOptions.rotate), true);
          expect(tempResult.contains(FileListingQuickActionOptions.info), true);
          expect(tempResult.contains(FileListingQuickActionOptions.move), !CommonConstants.restrictFolderStructure);
          expect(tempResult.contains(FileListingQuickActionOptions.print), true);
          expect(tempResult.contains(FileListingQuickActionOptions.showOnCustomerWebPage), false);
          expect(tempResult.contains(FileListingQuickActionOptions.removeFromCustomerWebPage), false);
          expect(tempResult.contains(FileListingQuickActionOptions.sendViaJobProgress), false);
          expect(tempResult.contains(FileListingQuickActionOptions.markAsFavourite), false);
          expect(tempResult.contains(FileListingQuickActionOptions.unMarkAsFavourite), false);
          expect(tempResult.contains(FileListingQuickActionOptions.viewLinkedForm), false);
          expect(tempResult.contains(FileListingQuickActionOptions.viewLinkedWorkOrder), false);
          expect(tempResult.contains(FileListingQuickActionOptions.viewLinkedMeasurement), false);
          expect(tempResult.contains(FileListingQuickActionOptions.viewLinkedMaterialList()), false);

        });

        test('When file is an not image file rotate option should be hidden', () {

          FilesListingQuickActionParams filesListingQuickActionParams = FilesListingQuickActionParams(
            fileList: [controller.resourceList[7]],
            onActionComplete: (_, __) { },
          );
          Map<String, List<JPQuickActionModel>> result = FileListingQuickActionsList.getWorkOrderActions(filesListingQuickActionParams);

          final tempResult = result[FileListingQuickActionsList.fileActions]!;

          expect(tempResult.contains(FileListingQuickActionOptions.delete), true);
          expect(tempResult.contains(FileListingQuickActionOptions.rename), true);
          expect(tempResult.contains(FileListingQuickActionOptions.rotate), false);
          expect(tempResult.contains(FileListingQuickActionOptions.info), true);
          expect(tempResult.contains(FileListingQuickActionOptions.move), !CommonConstants.restrictFolderStructure);
          expect(tempResult.contains(FileListingQuickActionOptions.print), true);
          expect(tempResult.contains(FileListingQuickActionOptions.showOnCustomerWebPage), false);
          expect(tempResult.contains(FileListingQuickActionOptions.removeFromCustomerWebPage), false);
          if(!FileListingQuickActionHelpers.checkIfAllSelectedFilesAreImages(filesListingQuickActionParams)) {
            expect(tempResult.contains(FileListingQuickActionOptions.sendViaJobProgress), false);
          } else {
            expect(tempResult.contains(FileListingQuickActionOptions.sendViaText), false);
          }
          expect(tempResult.contains(FileListingQuickActionOptions.markAsFavourite), false);
          expect(tempResult.contains(FileListingQuickActionOptions.unMarkAsFavourite), false);
          expect(tempResult.contains(FileListingQuickActionOptions.viewLinkedForm), false);
          expect(tempResult.contains(FileListingQuickActionOptions.viewLinkedWorkOrder), false);
          expect(tempResult.contains(FileListingQuickActionOptions.viewLinkedMeasurement), false);
          expect(tempResult.contains(FileListingQuickActionOptions.viewLinkedMaterialList()), false);

        });

        test('When file is workorder corresponding options should be displayed', () {

          FilesListingQuickActionParams filesListingQuickActionParams = FilesListingQuickActionParams(
            fileList: [
              controller.resourceList[8]
                ..isWorkOrder = true
            ],
            onActionComplete: (_, __) { },
          );

          Map<String, List<JPQuickActionModel>> result = FileListingQuickActionsList.getWorkOrderActions(filesListingQuickActionParams);

          final tempResult = result[FileListingQuickActionsList.fileActions]!;

          expect(tempResult.contains(FileListingQuickActionOptions.delete), true);
          expect(tempResult.contains(FileListingQuickActionOptions.rename), true);
          expect(tempResult.contains(FileListingQuickActionOptions.rotate), false);
          expect(tempResult.contains(FileListingQuickActionOptions.info), true);
          expect(tempResult.contains(FileListingQuickActionOptions.move), !CommonConstants.restrictFolderStructure);
          expect(tempResult.contains(FileListingQuickActionOptions.print), true);
          expect(tempResult.contains(FileListingQuickActionOptions.showOnCustomerWebPage), false);
          expect(tempResult.contains(FileListingQuickActionOptions.showOnCustomerWebPage), false);
          expect(tempResult.contains(FileListingQuickActionOptions.removeFromCustomerWebPage), false);
          if(!FileListingQuickActionHelpers.checkIfAllSelectedFilesAreImages(filesListingQuickActionParams)) {
            expect(tempResult.contains(FileListingQuickActionOptions.sendViaJobProgress), false);
          } else {
            expect(tempResult.contains(FileListingQuickActionOptions.sendViaText), false);
          }
          expect(tempResult.contains(FileListingQuickActionOptions.markAsFavourite), false);
          expect(tempResult.contains(FileListingQuickActionOptions.unMarkAsFavourite), false);


          expect(tempResult.contains(FileListingQuickActionOptions.viewLinkedWorkOrder), false);
          expect(tempResult.contains(FileListingQuickActionOptions.viewLinkedMeasurement), false);
          expect(tempResult.contains(FileListingQuickActionOptions.viewLinkedMaterialList()), false);
        });

        test('viewLinkedForm should be displayed', (){
          Map<String, List<JPQuickActionModel>> result = FileListingQuickActionsList.getWorkOrderActions(
              FilesListingQuickActionParams(
                fileList: [
                  FilesListingModel(
                      isWorkSheet: false,
                      isWorkOrder : true,
                      isShownOnCustomerWebPage: false,
                      isFile: true,
                      isDir: 0,
                      isGoogleSheet: false,
                      jpThumbType: JPThumbType.image,
                      linkedWorkProposal: LinkedWorkOrder(id: 0)
                  )
                ],
                onActionComplete: (_, __) { },
              )
          );
          final tempResult = result[FileListingQuickActionsList.fileActions]!;
          expect(tempResult.contains(FileListingQuickActionOptions.viewLinkedForm), true);
        });

        test('viewLinkedWorkOrder should be displayed', (){
          Map<String, List<JPQuickActionModel>> result = FileListingQuickActionsList.getWorkOrderActions(
              FilesListingQuickActionParams(
                fileList: [
                  FilesListingModel(
                      isWorkSheet: false,
                      isWorkOrder : true,
                      isShownOnCustomerWebPage: false,
                      isFile: true,
                      isDir: 0,
                      isGoogleSheet: false,
                      jpThumbType: JPThumbType.image,
                      linkedWorkOrder: LinkedWorkOrder(id: 0)
                  )
                ],
                onActionComplete: (_, __) { },
              )
          );
          final tempResult = result[FileListingQuickActionsList.fileActions]!;
          expect(tempResult.contains(FileListingQuickActionOptions.viewLinkedWorkOrder), true);
        });

        test('viewLinkedMeasurement should be displayed', (){
          Map<String, List<JPQuickActionModel>> result = FileListingQuickActionsList.getWorkOrderActions(
              FilesListingQuickActionParams(
                fileList: [
                  FilesListingModel(
                    isWorkSheet : true,
                    isWorkOrder: true,
                    isShownOnCustomerWebPage: false,
                    isFile: true,
                    isDir: 0,
                    isGoogleSheet: false,
                    jpThumbType: JPThumbType.image,
                    linkedMeasurement: LinkedMeasurement(id: 0),
                  )
                ],
                onActionComplete: (_, __) { },
              )
          );
          final tempResult = result[FileListingQuickActionsList.fileActions]!;
          expect(tempResult.contains(FileListingQuickActionOptions.viewLinkedMeasurement), true);
        });

        test('viewLinkedMaterialList should be displayed', (){
          final file =  FilesListingModel(
              isWorkSheet : true,
              isWorkOrder: true,
              isShownOnCustomerWebPage: false,
              isFile: true,
              isDir: 0,
              isGoogleSheet: false,
              jpThumbType: JPThumbType.image,
              linkedMaterialLists: [LinkedMaterialModel(id: 0)]
          );

          Map<String, List<JPQuickActionModel>> result = FileListingQuickActionsList.getWorkOrderActions(
              FilesListingQuickActionParams(
                fileList: [file],
                onActionComplete: (_, __) { },
              )
          );
          final action = FileListingQuickActionOptions.viewLinkedMaterialList(materials: file.linkedMaterialLists);
          final tempResult = result[FileListingQuickActionsList.fileActions]!;
          expect(tempResult.any((option) => option.id == action.id), true);
        });

        test('unMarkAsFavourite should be displayed', (){
          Map<String, List<JPQuickActionModel>> result = FileListingQuickActionsList.getWorkOrderActions(
              FilesListingQuickActionParams(
                fileList: [
                  FilesListingModel(
                      isWorkSheet : true,
                      isShownOnCustomerWebPage: false,
                      isFile: true,
                      isDir: 0,
                      isWorkOrder: true,
                      isGoogleSheet: true,
                      jpThumbType: JPThumbType.image,
                      myFavouriteEntity: MyFavouriteEntity(id: 10, markedBy: 1)
                  )
                ],
                onActionComplete: (_, __) { },
              )
          );
          final tempResult = result[FileListingQuickActionsList.fileActions]!;
          expect(tempResult.contains(FileListingQuickActionOptions.unMarkAsFavourite), true);
          expect(tempResult.contains(FileListingQuickActionOptions.markAsFavourite), false);
        });

        test('markAsFavourite should be displayed', (){
          Map<String, List<JPQuickActionModel>> result = FileListingQuickActionsList.getWorkOrderActions(
              FilesListingQuickActionParams(
                fileList: [
                  FilesListingModel(
                    isWorkSheet : true,
                    isShownOnCustomerWebPage: false,
                    isFile: true,
                    isDir: 0,
                    isWorkOrder: true,
                    isGoogleSheet: true,
                    jpThumbType: JPThumbType.image,
                  )
                ],
                onActionComplete: (_, __) { },
              )
          );
          final tempResult = result[FileListingQuickActionsList.fileActions]!;
          expect(tempResult.contains(FileListingQuickActionOptions.unMarkAsFavourite), false);
          expect(tempResult.contains(FileListingQuickActionOptions.markAsFavourite), true);
        });

        group("'View Linked Estimate' should be displayed conditionally as per 'Manage Estimate' permission", () {
          setUp(() {
            tempFile = FilesListingModel(
                isWorkSheet : true,
                isShownOnCustomerWebPage: false,
                isFile: true,
                isDir: 0,
                isWorkOrder: true,
                isGoogleSheet: true,
                jpThumbType: JPThumbType.image,
                myFavouriteEntity: MyFavouriteEntity(id: 10),
                linkedEstimate: LinkedWorkOrder()
            );
          });

          test("When user does not have 'Manage Estimate' permission, Quick Action should not be displayed", () {
            PermissionService.permissionList.clear();
            Map<String, List<JPQuickActionModel>> result = FileListingQuickActionsList.getWorkOrderActions(
                FilesListingQuickActionParams(
                  fileList: [tempFile!],
                  onActionComplete: (_, __) { },
                )
            );
            final tempResult = result[FileListingQuickActionsList.fileActions]!;
            expect(tempResult.contains(FileListingQuickActionOptions.viewLinkedEstimate), isFalse);
          });

          test("When user does have 'Manage Estimate' permission, Quick Action should be displayed", () {
            PermissionService.permissionList = [PermissionConstants.manageEstimates];
            Map<String, List<JPQuickActionModel>> result = FileListingQuickActionsList.getWorkOrderActions(
                FilesListingQuickActionParams(
                  fileList: [tempFile!],
                  onActionComplete: (_, __) { },
                )
            );
            final tempResult = result[FileListingQuickActionsList.fileActions]!;
            expect(tempResult.contains(FileListingQuickActionOptions.viewLinkedEstimate), isTrue);
          });
        });
     
        group("'View Linked Form / Proposal' label should be replaced with 'View Linked Documents'", () {
          test("''View Linked Form / Proposal' label should not be displayed", () {
            expect(FileListingQuickActionOptions.viewLinkedForm.label.contains('View Linked Form / Proposal'), isFalse);
          });

          test("'View Linked Document' label should be displayed", () {
            expect(FileListingQuickActionOptions.viewLinkedForm.label.contains('View Linked Document'), isTrue);
          });
        });
        
        group("'Sign Form / Proposal' label should be replaced with 'Sign Document'", () {
          test("''Sign Form / Proposal' label should not be displayed", () {
            expect(FileListingQuickActionOptions.signTemplateProposal.label.contains('Sign Form / Proposal'), isFalse);
          });

          test("'Sign Document' label should be displayed", () {
            expect(FileListingQuickActionOptions.signTemplateProposal.label.contains('Sign Document'), isTrue);
          });
        });

        group("'Open Public Form / Proposal Page' label should be replaced with 'Open Public Page'", () {
          test("''Open Public Form / Proposal Page' label should not be displayed", () {
            expect(FileListingQuickActionOptions.openPublicForm.label.contains('Open Public Form / Proposal Page'), isFalse);
          });

          test("'Open Public Page' label should be displayed", () {
            expect(FileListingQuickActionOptions.openPublicForm.label.contains('Open Public Page'), isTrue);
          });
        });

        group("'Form / Proposal Note' label should be replaced with 'Document Note'", () {
          test("''Form / Proposal Note' label should not be displayed", () {
            expect(FileListingQuickActionOptions.formProposalNote.label.contains('Form / Proposal Note'), isFalse);
          });

          test("'Document Note' label should be displayed", () {
            expect(FileListingQuickActionOptions.formProposalNote.label.contains('Document Note'), isTrue);
          });
        });
        
        group("'Generate Form / Proposal' label should be replaced with 'Generate Document", () {
          test("''Generate Form / Proposal' label should not be displayed", () {
            expect(FileListingQuickActionOptions.generateFormProposal.label.contains('Generate Form / Proposal'), isFalse);
          });

          test("'Generate Document' label should be displayed", () {
            expect(FileListingQuickActionOptions.generateFormProposal.label.contains('Generate Document'), isTrue);
          });
        });

        group("'Form / Proposal Template' label should be replaced with 'Document Template'", () {
          test("''Form / Proposal Template' label should not be displayed", () {
            expect(FileListingQuickActionOptions.jobFormProposalTemplate.label.contains('Form / Proposal Template'), isFalse);
          });

          test("'Document Template' label should be displayed", () {
            expect(FileListingQuickActionOptions.jobFormProposalTemplate.label.contains('Document Template'), isTrue);
          });
        });
      });

    });

}

