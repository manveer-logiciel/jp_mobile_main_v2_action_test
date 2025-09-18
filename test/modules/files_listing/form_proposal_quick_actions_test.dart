import 'dart:ui';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_model.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_quick_action_params.dart';
import 'package:jobprogress/common/models/files_listing/linked_material.dart';
import 'package:jobprogress/common/models/files_listing/linked_measurement.dart';
import 'package:jobprogress/common/models/files_listing/linked_work_order.dart';
import 'package:jobprogress/common/models/files_listing/my_favourite_entity.dart';
import 'package:jobprogress/common/models/job/job_invoices.dart';
import 'package:jobprogress/common/models/sql/user/user.dart';
import 'package:jobprogress/common/models/worksheet/worksheet_model.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/common/services/connected_third_party.dart';
import 'package:jobprogress/common/services/files_listing/quick_action_options.dart';
import 'package:jobprogress/common/services/files_listing/quick_actions_list.dart';
import 'package:jobprogress/common/services/permission.dart';
import 'package:jobprogress/core/constants/common_constants.dart';
import 'package:jobprogress/core/constants/connected_third_party_constants.dart';
import 'package:jobprogress/core/constants/permission.dart';
import 'package:jobprogress/modules/files_listing/controller.dart';
import 'package:jp_mobile_flutter_ui/QuickAction/model.dart';
import 'package:jp_mobile_flutter_ui/Thumb/type.dart';
import 'file_listing_test.dart';


void main() {

  FilesListingModel? tempFile;

  setUpAll(() {
    Get.locale = const Locale('en', 'US');
    PermissionService.permissionList = [
      PermissionConstants.manageProposals,
    ];

    AuthService.userDetails = UserModel(
        id: '1',
        firstName: 'Demo',
        fullName: 'Demo User',
        email: 'abc@test.com'
    );
  });

    group('For form proposals', (){

      final controller = FilesListingController();
      controller.resourceList = tempResourceList;

      group('In case of directory', () {

        test('When folder is not locked only rename and delete options should be displayed', () {

          Map<String, List<JPQuickActionModel>> result = FileListingQuickActionsList.getJobProposalActionList(
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

          Map<String, List<JPQuickActionModel>> result = FileListingQuickActionsList.getJobProposalActionList(
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

          Map<String, List<JPQuickActionModel>> result = FileListingQuickActionsList.getJobProposalActionList(
              FilesListingQuickActionParams(
                fileList: [controller.resourceList[6]],
                onActionComplete: (_, __) { },
              )
          );

          final tempResult = result[FileListingQuickActionsList.fileActions]!;

          expect(tempResult.contains(FileListingQuickActionOptions.delete), true);
          expect(tempResult.contains(FileListingQuickActionOptions.rename), true);
          expect(tempResult.contains(FileListingQuickActionOptions.rotate), true);
          expect(tempResult.contains(FileListingQuickActionOptions.expiresOn), true);
          expect(tempResult.contains(FileListingQuickActionOptions.info), true);
          expect(tempResult.contains(FileListingQuickActionOptions.move), !CommonConstants.restrictFolderStructure);
          expect(tempResult.contains(FileListingQuickActionOptions.print), true);
          expect(tempResult.contains(FileListingQuickActionOptions.showOnCustomerWebPage), false);
          expect(tempResult.contains(FileListingQuickActionOptions.removeFromCustomerWebPage), false);
          expect(tempResult.contains(FileListingQuickActionOptions.sendViaText), true);
          expect(tempResult.contains(FileListingQuickActionOptions.markAsFavourite), false);
          expect(tempResult.contains(FileListingQuickActionOptions.unMarkAsFavourite), false);
          expect(tempResult.contains(FileListingQuickActionOptions.viewLinkedForm), false);
          expect(tempResult.contains(FileListingQuickActionOptions.viewLinkedWorkOrder), false);
          expect(tempResult.contains(FileListingQuickActionOptions.viewLinkedMeasurement), false);
          expect(tempResult.contains(FileListingQuickActionOptions.viewLinkedMaterialList()), false);
          expect(tempResult.contains(FileListingQuickActionOptions.openPublicForm), true);
          expect(tempResult.contains(FileListingQuickActionOptions.formProposalNote), true);
          expect(tempResult.contains(FileListingQuickActionOptions.updateStatus), true);
          expect(tempResult.contains(FileListingQuickActionOptions.makeACopy), true);

        });

        test('When file is an not image file rotate option should be hidden', () {

          Map<String, List<JPQuickActionModel>> result = FileListingQuickActionsList.getJobProposalActionList(
              FilesListingQuickActionParams(
                fileList: [controller.resourceList[7]],
                onActionComplete: (_, __) { },
              )
          );

          final tempResult = result[FileListingQuickActionsList.fileActions]!;

          expect(tempResult.contains(FileListingQuickActionOptions.delete), true);
          expect(tempResult.contains(FileListingQuickActionOptions.rename), true);
          expect(tempResult.contains(FileListingQuickActionOptions.rotate), false);
          expect(tempResult.contains(FileListingQuickActionOptions.expiresOn), true);
          expect(tempResult.contains(FileListingQuickActionOptions.info), true);
          expect(tempResult.contains(FileListingQuickActionOptions.move), !CommonConstants.restrictFolderStructure);
          expect(tempResult.contains(FileListingQuickActionOptions.print), true);
          expect(tempResult.contains(FileListingQuickActionOptions.showOnCustomerWebPage), false);
          expect(tempResult.contains(FileListingQuickActionOptions.removeFromCustomerWebPage), false);
          expect(tempResult.contains(FileListingQuickActionOptions.sendViaJobProgress), true);
          expect(tempResult.contains(FileListingQuickActionOptions.markAsFavourite), false);
          expect(tempResult.contains(FileListingQuickActionOptions.unMarkAsFavourite), false);
          expect(tempResult.contains(FileListingQuickActionOptions.viewLinkedForm), false);
          expect(tempResult.contains(FileListingQuickActionOptions.viewLinkedWorkOrder), false);
          expect(tempResult.contains(FileListingQuickActionOptions.viewLinkedMeasurement), false);
          expect(tempResult.contains(FileListingQuickActionOptions.viewLinkedMaterialList()), false);
          expect(tempResult.contains(FileListingQuickActionOptions.openPublicForm), true);
          expect(tempResult.contains(FileListingQuickActionOptions.formProposalNote), true);
          expect(tempResult.contains(FileListingQuickActionOptions.updateStatus), true);
          expect(tempResult.contains(FileListingQuickActionOptions.makeACopy), true);

        });

        test('When file is worksheet corresponding options should be displayed', () {

          Map<String, List<JPQuickActionModel>> result = FileListingQuickActionsList.getJobProposalActionList(
              FilesListingQuickActionParams(
                fileList: [
                  controller.resourceList[8]
                    ..isWorkSheet = true
                    ..insuranceEstimate = false
                    ..type = 'worksheet'
                ],
                onActionComplete: (_, __) { },
              )
          );

          final tempResult = result[FileListingQuickActionsList.fileActions]!;

          expect(tempResult.contains(FileListingQuickActionOptions.delete), true);
          expect(tempResult.contains(FileListingQuickActionOptions.rename), true);
          expect(tempResult.contains(FileListingQuickActionOptions.rotate), false);
          expect(tempResult.contains(FileListingQuickActionOptions.expiresOn), true);
          expect(tempResult.contains(FileListingQuickActionOptions.info), true);
          expect(tempResult.contains(FileListingQuickActionOptions.move), !CommonConstants.restrictFolderStructure);
          expect(tempResult.contains(FileListingQuickActionOptions.print), true);
          expect(tempResult.contains(FileListingQuickActionOptions.showOnCustomerWebPage), false);
          expect(tempResult.contains(FileListingQuickActionOptions.sendViaJobProgress), true);
          expect(tempResult.contains(FileListingQuickActionOptions.removeFromCustomerWebPage), true);
          expect(tempResult.contains(FileListingQuickActionOptions.sendViaJobProgress), true);
          expect(tempResult.contains(FileListingQuickActionOptions.markAsFavourite), true);
          expect(tempResult.contains(FileListingQuickActionOptions.unMarkAsFavourite), false);
          expect(tempResult.contains(FileListingQuickActionOptions.viewLinkedWorkOrder), false);
          expect(tempResult.contains(FileListingQuickActionOptions.viewLinkedMeasurement), false);
          expect(tempResult.contains(FileListingQuickActionOptions.viewLinkedMaterialList()), false);
          expect(tempResult.contains(FileListingQuickActionOptions.openPublicForm), true);
          expect(tempResult.contains(FileListingQuickActionOptions.formProposalNote), true);
          expect(tempResult.contains(FileListingQuickActionOptions.updateStatus), true);
          expect(tempResult.contains(FileListingQuickActionOptions.makeACopy), true);

        });

        test('viewLinkedWorkOrder should be displayed', (){
          Map<String, List<JPQuickActionModel>> result = FileListingQuickActionsList.getJobProposalActionList(
              FilesListingQuickActionParams(
                fileList: [
                  FilesListingModel(
                      isWorkSheet : true,
                      isShownOnCustomerWebPage: false,
                      isFile: true,
                      isDir: 0,
                      isGoogleSheet: false,
                      jpThumbType: JPThumbType.image,
                      linkedWorkOrder: LinkedWorkOrder(id: 0),
                      type: 'worksheet',
                      status: 'draft',
                  )
                ],
                onActionComplete: (_, __) { },
              )
          );
          final tempResult = result[FileListingQuickActionsList.fileActions]!;
          expect(tempResult.contains(FileListingQuickActionOptions.viewLinkedWorkOrder), true);
        });

        test('viewLinkedMeasurement should be displayed', (){
          Map<String, List<JPQuickActionModel>> result = FileListingQuickActionsList.getJobProposalActionList(
              FilesListingQuickActionParams(
                fileList: [
                  FilesListingModel(
                    isWorkSheet : true,
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

          final file = FilesListingModel(
            isWorkSheet : true,
            isShownOnCustomerWebPage: false,
            isFile: true,
            isDir: 0,
            isGoogleSheet: false,
            jpThumbType: JPThumbType.image,
            linkedMaterialLists: [LinkedMaterialModel(id: 0, forSupplierId: null)],
            type: 'worksheet',
            status: 'draft'
          );

          Map<String, List<JPQuickActionModel>> result = FileListingQuickActionsList.getJobProposalActionList(
              FilesListingQuickActionParams(
                fileList: [file],
                onActionComplete: (_, __) { },
              )
          );
          final action = FileListingQuickActionOptions.viewLinkedMaterialList(materials: file.linkedMaterialLists);
          final tempResult = result[FileListingQuickActionsList.fileActions]!;
          expect(tempResult.any((option) => option.id == action.id), true);
        });

        test('Print/Make a copy/Open public form option should hide in case of google sheet', (){
          Map<String, List<JPQuickActionModel>> result = FileListingQuickActionsList.getJobProposalActionList(
              FilesListingQuickActionParams(
                fileList: [
                  FilesListingModel(
                    isWorkSheet : true,
                    isShownOnCustomerWebPage: false,
                    isFile: true,
                    isDir: 0,
                    isGoogleSheet: true,
                    jpThumbType: JPThumbType.image,

                  )
                ],
                onActionComplete: (_, __) { },
              )
          );
          final tempResult = result[FileListingQuickActionsList.fileActions]!;
          expect(tempResult.contains(FileListingQuickActionOptions.print), false);
          expect(tempResult.contains(FileListingQuickActionOptions.makeACopy), false);
          expect(tempResult.contains(FileListingQuickActionOptions.openPublicForm), false);
        });

        test('unMarkAsFavourite should be displayed', (){
          Map<String, List<JPQuickActionModel>> result = FileListingQuickActionsList.getJobProposalActionList(
              FilesListingQuickActionParams(
                fileList: [
                  FilesListingModel(
                      isWorkSheet : true,
                      isShownOnCustomerWebPage: false,
                      isFile: true,
                      isDir: 0,
                      isGoogleSheet: false,
                      jpThumbType: JPThumbType.image,
                      myFavouriteEntity: MyFavouriteEntity(id: 10, markedBy: 1),
                      type: 'worksheet',
                      insuranceEstimate: false
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
          Map<String, List<JPQuickActionModel>> result = FileListingQuickActionsList.getJobProposalActionList(
              FilesListingQuickActionParams(
                fileList: [
                  FilesListingModel(
                    isWorkSheet : true,
                    isShownOnCustomerWebPage: false,
                    isFile: true,
                    isDir: 0,
                    isGoogleSheet: false,
                    jpThumbType: JPThumbType.image,
                    type: 'worksheet',
                    insuranceEstimate: false
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
              isGoogleSheet: false,
              jpThumbType: JPThumbType.image,
              linkedEstimate: LinkedWorkOrder(id: 0),
              type: 'worksheet',
              status: 'draft',
            );
            PermissionService.permissionList = [PermissionConstants.manageProposals];
          });

          test("When user does not have 'Manage Estimate' permission, Quick Action should not be displayed", () {
            Map<String, List<JPQuickActionModel>> result = FileListingQuickActionsList.getJobProposalActionList(
                FilesListingQuickActionParams(
                  fileList: [tempFile!],
                  onActionComplete: (_, __) { },
                )
            );
            final tempResult = result[FileListingQuickActionsList.fileActions]!;
            expect(tempResult.contains(FileListingQuickActionOptions.viewLinkedEstimate), isFalse);
          });

          test("When user does have 'Manage Estimate' permission, Quick Action should be displayed", () {
            PermissionService.permissionList.add(PermissionConstants.manageEstimates);
            Map<String, List<JPQuickActionModel>> result = FileListingQuickActionsList.getJobProposalActionList(
                FilesListingQuickActionParams(
                  fileList: [tempFile!],
                  onActionComplete: (_, __) { },
                )
            );
            final tempResult = result[FileListingQuickActionsList.fileActions]!;
            expect(tempResult.contains(FileListingQuickActionOptions.viewLinkedEstimate), isTrue);
          });
        });

        test('Generate Job Invoice should be displayed', () {
          PermissionService.permissionList = [
            PermissionConstants.manageProposals,
            PermissionConstants.changeProposalStatus,
          ];
          
          Map<String, List<JPQuickActionModel>> result = FileListingQuickActionsList.getJobProposalActionList(
              FilesListingQuickActionParams(
                fileList: [
                  FilesListingModel(
                    isWorkSheet : true,
                    isGoogleSheet: false,
                    type: 'worksheet',
                    isShownOnCustomerWebPage: false,
                    worksheet: WorksheetModel(
                      overhead: null,
                      profit: null,
                      commission: null,
                      lineTax: 0,
                      lineMarginMarkup: 0,
                    )
                  )
                ],
                onActionComplete: (_, __) { },
                jobModel: tempJob,
              )
          );

          final tempResult = result[FileListingQuickActionsList.fileActions]!;
          expect(tempResult.contains(FileListingQuickActionOptions.generateJobInvoice), isTrue);
        });

        group('Generate Job Invoice should not be visible', () {
          setUpAll(() {
            tempJob.jobInvoices = [JobInvoices()];
          });
          test('When user does not have "Manage proposal" permission', () {
            PermissionService.permissionList.clear();
            Map<String, List<JPQuickActionModel>> result = FileListingQuickActionsList.getJobProposalActionList(
                FilesListingQuickActionParams(
                  fileList: [
                    FilesListingModel(
                      isWorkSheet : true,
                      isGoogleSheet: false,
                      type: 'worksheet',
                      isShownOnCustomerWebPage: false,
                      worksheet: WorksheetModel(
                        overhead: null,
                        profit: null,
                        commission: null,
                        lineTax: 0,
                        lineMarginMarkup: 0,
                      )
                    )
                  ],
                  onActionComplete: (_, __) { },
                  jobModel: tempJob,
                )
            );

            final tempResult = result[FileListingQuickActionsList.fileActions]!;
            expect(tempResult.contains(FileListingQuickActionOptions.generateJobInvoice), isFalse);
          });

          test('When there is no Linked Job Invoice', () {
            FilesListingModel temp = FilesListingModel(
              isWorkSheet : false,
              isGoogleSheet: false,
              type: 'worksheet',
              isShownOnCustomerWebPage: false,
              worksheet: WorksheetModel(
                overhead: null,
                profit: null,
                commission: null,
                lineTax: 0,
                lineMarginMarkup: 0,
              )
            );

            temp.linkedInvoicesLists = tempJob.jobInvoices;
            Map<String, List<JPQuickActionModel>> result = FileListingQuickActionsList.getJobProposalActionList(
                FilesListingQuickActionParams(
                  fileList: [
                    temp
                  ],
                  onActionComplete: (_, __) { },
                  jobModel: tempJob,
                )
            );

            final tempResult = result[FileListingQuickActionsList.fileActions]!;
            expect(tempResult.contains(FileListingQuickActionOptions.generateJobInvoice), isFalse);
          });

          test('When worksheet contains overhead/profit/commission', () {
            FilesListingModel temp = FilesListingModel(
              isWorkSheet : true,
              isGoogleSheet: false,
              type: 'worksheet',
              isShownOnCustomerWebPage: false,
              worksheet: WorksheetModel(
                overhead: '30',
                profit: '20',
                commission: '10',
                lineTax: 0,
                lineMarginMarkup: 0,
              )
            );

            Map<String, List<JPQuickActionModel>> result = FileListingQuickActionsList.getJobProposalActionList(
                FilesListingQuickActionParams(
                  fileList: [
                    temp
                  ],
                  onActionComplete: (_, __) { },
                  jobModel: tempJob,
                )
            );

            final tempResult = result[FileListingQuickActionsList.fileActions]!;
            expect(tempResult.contains(FileListingQuickActionOptions.generateJobInvoice), isFalse);
          });

          test('When user can block financial', () {
            tempJob.financialDetails?.canBlockFinancial = true;
            FilesListingModel temp = FilesListingModel(
              isWorkSheet : true,
              isGoogleSheet: false,
              type: 'worksheet',
              isShownOnCustomerWebPage: false,
              worksheet: WorksheetModel(
                overhead: null,
                profit: null,
                commission: null,
                lineTax: 0,
                lineMarginMarkup: 0,
              )
            );

            Map<String, List<JPQuickActionModel>> result = FileListingQuickActionsList.getJobProposalActionList(
                FilesListingQuickActionParams(
                  fileList: [
                    temp
                  ],
                  onActionComplete: (_, __) { },
                  jobModel: tempJob,
                )
            );

            final tempResult = result[FileListingQuickActionsList.fileActions]!;
            expect(tempResult.contains(FileListingQuickActionOptions.generateJobInvoice), isFalse);
          });

          test('When invoice is linked to proposal', () {
            tempJob.jobInvoices?.first.proposalId = '12';
            FilesListingModel temp = FilesListingModel(
              isWorkSheet : true,
              isGoogleSheet: false,
              type: 'worksheet',
              isShownOnCustomerWebPage: false,
              worksheet: WorksheetModel(
                overhead: null,
                profit: null,
                commission: null,
                lineTax: 0,
                lineMarginMarkup: 0,
              )
            );

            Map<String, List<JPQuickActionModel>> result = FileListingQuickActionsList.getJobProposalActionList(
                FilesListingQuickActionParams(
                  fileList: [
                    temp
                  ],
                  onActionComplete: (_, __) { },
                  jobModel: tempJob,
                )
            );

            final tempResult = result[FileListingQuickActionsList.fileActions]!;
            expect(tempResult.contains(FileListingQuickActionOptions.generateJobInvoice), isFalse);
          });

          test('When user has multiple job', () {
            tempJob.isMultiJob = true;
            FilesListingModel temp = FilesListingModel(
              isWorkSheet : true,
              isGoogleSheet: false,
              type: 'worksheet',
              isShownOnCustomerWebPage: false,
              worksheet: WorksheetModel(
                overhead: null,
                profit: null,
                commission: null,
                lineTax: 0,
                lineMarginMarkup: 0,
              )
            );

            Map<String, List<JPQuickActionModel>> result = FileListingQuickActionsList.getJobProposalActionList(
                FilesListingQuickActionParams(
                  fileList: [
                    temp
                  ],
                  onActionComplete: (_, __) { },
                  jobModel: tempJob,
                )
            );

            final tempResult = result[FileListingQuickActionsList.fileActions]!;
            expect(tempResult.contains(FileListingQuickActionOptions.generateJobInvoice), isFalse);
          });

          test('When file is not a worksheet', () {
            FilesListingModel temp = FilesListingModel(
              isWorkSheet : false,
              isGoogleSheet: false,
              type: 'worksheet',
              isShownOnCustomerWebPage: false,
              worksheet: WorksheetModel(
                overhead: null,
                profit: null,
                commission: null,
                lineTax: 0,
                lineMarginMarkup: 0,
              )
            );

            Map<String, List<JPQuickActionModel>> result = FileListingQuickActionsList.getJobProposalActionList(
                FilesListingQuickActionParams(
                  fileList: [
                    temp
                  ],
                  onActionComplete: (_, __) { },
                  jobModel: tempJob,
                )
            );

            final tempResult = result[FileListingQuickActionsList.fileActions]!;
            expect(tempResult.contains(FileListingQuickActionOptions.generateJobInvoice), isFalse);
          });

          test('When tax is applied on worksheet', () {
            FilesListingModel temp = FilesListingModel(
              isWorkSheet : true,
              isGoogleSheet: false,
              type: 'worksheet',
              isShownOnCustomerWebPage: false,
              worksheet: WorksheetModel(
                overhead: null,
                profit: null,
                commission: null,
                lineTax: 10,
                lineMarginMarkup: 0,
              )
            );

            Map<String, List<JPQuickActionModel>> result = FileListingQuickActionsList.getJobProposalActionList(
                FilesListingQuickActionParams(
                  fileList: [
                    temp
                  ],
                  onActionComplete: (_, __) { },
                  jobModel: tempJob,
                )
            );

            final tempResult = result[FileListingQuickActionsList.fileActions]!;
            expect(tempResult.contains(FileListingQuickActionOptions.generateJobInvoice), isFalse);
          });

          test('When margin markup is applied on worksheet', () {
            FilesListingModel temp = FilesListingModel(
              isWorkSheet : true,
              isGoogleSheet: false,
              type: 'worksheet',
              isShownOnCustomerWebPage: false,
              worksheet: WorksheetModel(
                overhead: null,
                profit: null,
                commission: null,
                lineTax: 0,
                lineMarginMarkup: 10,
              )
            );

            Map<String, List<JPQuickActionModel>> result = FileListingQuickActionsList.getJobProposalActionList(
                FilesListingQuickActionParams(
                  fileList: [
                    temp
                  ],
                  onActionComplete: (_, __) { },
                  jobModel: tempJob,
                )
            );

            final tempResult = result[FileListingQuickActionsList.fileActions]!;
            expect(tempResult.contains(FileListingQuickActionOptions.generateJobInvoice), isFalse);
          });

          test('When labor and material tax is applied on worksheet', () {
            ConnectedThirdPartyService.connectedThirdParty.clear();
            ConnectedThirdPartyService.connectedThirdParty.addAll({
              ConnectedThirdPartyConstants.quickbook: {
                ConnectedThirdPartyConstants.quickbookCompanyId: '1',
              }
            });
            
            FilesListingModel temp = FilesListingModel(
              isWorkSheet : true,
              isGoogleSheet: false,
              type: 'worksheet',
              isShownOnCustomerWebPage: false,
              worksheet: WorksheetModel(
                overhead: null,
                profit: null,
                commission: null,
                lineTax: 0,
                lineMarginMarkup: 0,
                materialTaxRate: '12',
                laborTaxRate: '12'
              )
            );

            Map<String, List<JPQuickActionModel>> result = FileListingQuickActionsList.getJobProposalActionList(
                FilesListingQuickActionParams(
                  fileList: [
                    temp
                  ],
                  onActionComplete: (_, __) { },
                  jobModel: tempJob,
                )
            );

            final tempResult = result[FileListingQuickActionsList.fileActions]!;
            expect(tempResult.contains(FileListingQuickActionOptions.generateJobInvoice), isFalse);
          });

          test('When quick book is not connected and Labor/Material tax is applied on worksheet', () {
            ConnectedThirdPartyService.connectedThirdParty.clear();
            ConnectedThirdPartyService.connectedThirdParty.addAll({
              ConnectedThirdPartyConstants.quickbook: null
            });
            
            FilesListingModel temp = FilesListingModel(
              isWorkSheet : true,
              isGoogleSheet: false,
              type: 'worksheet',
              isShownOnCustomerWebPage: false,
              worksheet: WorksheetModel(
                overhead: null,
                profit: null,
                commission: null,
                lineTax: 0,
                lineMarginMarkup: 0,
                materialTaxRate: '12',
              )
            );

            Map<String, List<JPQuickActionModel>> result = FileListingQuickActionsList.getJobProposalActionList(
                FilesListingQuickActionParams(
                  fileList: [
                    temp
                  ],
                  onActionComplete: (_, __) { },
                  jobModel: tempJob,
                )
            );

            final tempResult = result[FileListingQuickActionsList.fileActions]!;
            expect(tempResult.contains(FileListingQuickActionOptions.generateJobInvoice), isFalse);
          });

        });
      
        group('Update Job Invoice should not be visible', () {
          test('When user does not have "Manage proposal" permission', () {
            PermissionService.permissionList.clear();
            Map<String, List<JPQuickActionModel>> result = FileListingQuickActionsList.getJobProposalActionList(
                FilesListingQuickActionParams(
                  fileList: [
                    FilesListingModel(
                      isWorkSheet : true,
                      isGoogleSheet: false,
                      type: 'worksheet',
                      isShownOnCustomerWebPage: false,
                      worksheet: WorksheetModel(
                        overhead: null,
                        profit: null,
                        commission: null,
                        lineTax: 0,
                        lineMarginMarkup: 0,
                      )
                    )
                  ],
                  onActionComplete: (_, __) { },
                  jobModel: tempJob,
                )
            );

            final tempResult = result[FileListingQuickActionsList.fileActions]!;
            expect(tempResult.contains(FileListingQuickActionOptions.updateJobInvoice), isFalse);
          });

          test('When there is no Linked Job Invoice', () {
            FilesListingModel temp = FilesListingModel(
              isWorkSheet : false,
              isGoogleSheet: false,
              type: 'worksheet',
              isShownOnCustomerWebPage: false,
              worksheet: WorksheetModel(
                overhead: null,
                profit: null,
                commission: null,
                lineTax: 0,
                lineMarginMarkup: 0,
              )
            );

            temp.linkedInvoicesLists = tempJob.jobInvoices;
            Map<String, List<JPQuickActionModel>> result = FileListingQuickActionsList.getJobProposalActionList(
                FilesListingQuickActionParams(
                  fileList: [
                    temp
                  ],
                  onActionComplete: (_, __) { },
                  jobModel: tempJob,
                )
            );

            final tempResult = result[FileListingQuickActionsList.fileActions]!;
            expect(tempResult.contains(FileListingQuickActionOptions.updateJobInvoice), isFalse);
          });

          test('When worksheet contains overhead/profit/commission', () {
            FilesListingModel temp = FilesListingModel(
              isWorkSheet : true,
              isGoogleSheet: false,
              type: 'worksheet',
              isShownOnCustomerWebPage: false,
              worksheet: WorksheetModel(
                overhead: '30',
                profit: '20',
                commission: '10',
                lineTax: 0,
                lineMarginMarkup: 0,
              )
            );

            Map<String, List<JPQuickActionModel>> result = FileListingQuickActionsList.getJobProposalActionList(
                FilesListingQuickActionParams(
                  fileList: [
                    temp
                  ],
                  onActionComplete: (_, __) { },
                  jobModel: tempJob,
                )
            );

            final tempResult = result[FileListingQuickActionsList.fileActions]!;
            expect(tempResult.contains(FileListingQuickActionOptions.updateJobInvoice), isFalse);
          });

          test('When user can block financial', () {
            tempJob.financialDetails?.canBlockFinancial = true;
            FilesListingModel temp = FilesListingModel(
              isWorkSheet : true,
              isGoogleSheet: false,
              type: 'worksheet',
              isShownOnCustomerWebPage: false,
              worksheet: WorksheetModel(
                overhead: null,
                profit: null,
                commission: null,
                lineTax: 0,
                lineMarginMarkup: 0,
              )
            );

            Map<String, List<JPQuickActionModel>> result = FileListingQuickActionsList.getJobProposalActionList(
                FilesListingQuickActionParams(
                  fileList: [
                    temp
                  ],
                  onActionComplete: (_, __) { },
                  jobModel: tempJob,
                )
            );

            final tempResult = result[FileListingQuickActionsList.fileActions]!;
            expect(tempResult.contains(FileListingQuickActionOptions.updateJobInvoice), isFalse);
          });

          test('When invoice is linked to proposal', () {
            tempJob.jobInvoices?.first.proposalId = '12';
            FilesListingModel temp = FilesListingModel(
              isWorkSheet : true,
              isGoogleSheet: false,
              type: 'worksheet',
              isShownOnCustomerWebPage: false,
              worksheet: WorksheetModel(
                overhead: null,
                profit: null,
                commission: null,
                lineTax: 0,
                lineMarginMarkup: 0,
              )
            );

            Map<String, List<JPQuickActionModel>> result = FileListingQuickActionsList.getJobProposalActionList(
                FilesListingQuickActionParams(
                  fileList: [
                    temp
                  ],
                  onActionComplete: (_, __) { },
                  jobModel: tempJob,
                )
            );

            final tempResult = result[FileListingQuickActionsList.fileActions]!;
            expect(tempResult.contains(FileListingQuickActionOptions.updateJobInvoice), isFalse);
          });

          test('When more than one invoice is linked', () {
            tempJob.jobInvoices?.add(JobInvoices());
            FilesListingModel temp = FilesListingModel(
              isWorkSheet : true,
              isGoogleSheet: false,
              type: 'worksheet',
              isShownOnCustomerWebPage: false,
              worksheet: WorksheetModel(
                overhead: null,
                profit: null,
                commission: null,
                lineTax: 0,
                lineMarginMarkup: 0,
              ),
            );
            
            temp.linkedInvoicesLists = tempJob.jobInvoices;
            Map<String, List<JPQuickActionModel>> result = FileListingQuickActionsList.getJobProposalActionList(
                FilesListingQuickActionParams(
                  fileList: [
                    temp
                  ],
                  onActionComplete: (_, __) { },
                  jobModel: tempJob,
                )
            );

            final tempResult = result[FileListingQuickActionsList.fileActions]!;
            expect(tempResult.contains(FileListingQuickActionOptions.updateJobInvoice), isFalse);
          });

          test('When user has multiple job', () {
            tempJob.isMultiJob = true;
            FilesListingModel temp = FilesListingModel(
              isWorkSheet : true,
              isGoogleSheet: false,
              type: 'worksheet',
              isShownOnCustomerWebPage: false,
              worksheet: WorksheetModel(
                overhead: null,
                profit: null,
                commission: null,
                lineTax: 0,
                lineMarginMarkup: 0,
              )
            );

            Map<String, List<JPQuickActionModel>> result = FileListingQuickActionsList.getJobProposalActionList(
                FilesListingQuickActionParams(
                  fileList: [
                    temp
                  ],
                  onActionComplete: (_, __) { },
                  jobModel: tempJob,
                )
            );

            final tempResult = result[FileListingQuickActionsList.fileActions]!;
            expect(tempResult.contains(FileListingQuickActionOptions.updateJobInvoice), isFalse);
          });

          test('When file is not a worksheet', () {
            FilesListingModel temp = FilesListingModel(
              isWorkSheet : false,
              isGoogleSheet: false,
              type: 'worksheet',
              isShownOnCustomerWebPage: false,
              worksheet: WorksheetModel(
                overhead: null,
                profit: null,
                commission: null,
                lineTax: 0,
                lineMarginMarkup: 0,
              )
            );

            Map<String, List<JPQuickActionModel>> result = FileListingQuickActionsList.getJobProposalActionList(
                FilesListingQuickActionParams(
                  fileList: [
                    temp
                  ],
                  onActionComplete: (_, __) { },
                  jobModel: tempJob,
                )
            );

            final tempResult = result[FileListingQuickActionsList.fileActions]!;
            expect(tempResult.contains(FileListingQuickActionOptions.updateJobInvoice), isFalse);
          });

          test('When tax is applied on worksheet', () {
            FilesListingModel temp = FilesListingModel(
              isWorkSheet : true,
              isGoogleSheet: false,
              type: 'worksheet',
              isShownOnCustomerWebPage: false,
              worksheet: WorksheetModel(
                overhead: null,
                profit: null,
                commission: null,
                lineTax: 10,
                lineMarginMarkup: 0,
              )
            );

            Map<String, List<JPQuickActionModel>> result = FileListingQuickActionsList.getJobProposalActionList(
                FilesListingQuickActionParams(
                  fileList: [
                    temp
                  ],
                  onActionComplete: (_, __) { },
                  jobModel: tempJob,
                )
            );

            final tempResult = result[FileListingQuickActionsList.fileActions]!;
            expect(tempResult.contains(FileListingQuickActionOptions.updateJobInvoice), isFalse);
          });

          test('When margin markup is applied on worksheet', () {
            FilesListingModel temp = FilesListingModel(
              isWorkSheet : true,
              isGoogleSheet: false,
              type: 'worksheet',
              isShownOnCustomerWebPage: false,
              worksheet: WorksheetModel(
                overhead: null,
                profit: null,
                commission: null,
                lineTax: 0,
                lineMarginMarkup: 10,
              )
            );

            Map<String, List<JPQuickActionModel>> result = FileListingQuickActionsList.getJobProposalActionList(
                FilesListingQuickActionParams(
                  fileList: [
                    temp
                  ],
                  onActionComplete: (_, __) { },
                  jobModel: tempJob,
                )
            );

            final tempResult = result[FileListingQuickActionsList.fileActions]!;
            expect(tempResult.contains(FileListingQuickActionOptions.updateJobInvoice), isFalse);
          });

          test('When labor and material tax is applied on worksheet', () {
            ConnectedThirdPartyService.connectedThirdParty.clear();
            ConnectedThirdPartyService.connectedThirdParty.addAll({
              ConnectedThirdPartyConstants.quickbook: {
                ConnectedThirdPartyConstants.quickbookCompanyId: '1',
              }
            });
            
            FilesListingModel temp = FilesListingModel(
              isWorkSheet : true,
              isGoogleSheet: false,
              type: 'worksheet',
              isShownOnCustomerWebPage: false,
              worksheet: WorksheetModel(
                overhead: null,
                profit: null,
                commission: null,
                lineTax: 0,
                lineMarginMarkup: 0,
                materialTaxRate: '12',
                laborTaxRate: '12'
              )
            );

            Map<String, List<JPQuickActionModel>> result = FileListingQuickActionsList.getJobProposalActionList(
                FilesListingQuickActionParams(
                  fileList: [
                    temp
                  ],
                  onActionComplete: (_, __) { },
                  jobModel: tempJob,
                )
            );

            final tempResult = result[FileListingQuickActionsList.fileActions]!;
            expect(tempResult.contains(FileListingQuickActionOptions.updateJobInvoice), isFalse);
          });
        });
      
      });
    });
}

