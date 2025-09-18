import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/models/files_listing/delivery_date.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_model.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_quick_action_params.dart';
import 'package:jobprogress/common/models/files_listing/linked_material.dart';
import 'package:jobprogress/common/models/files_listing/linked_measurement.dart';
import 'package:jobprogress/common/models/files_listing/linked_work_order.dart';
import 'package:jobprogress/common/models/files_listing/my_favourite_entity.dart';
import 'package:jobprogress/common/models/files_listing/srs/srs_order_detail.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/sql/user/user.dart';
import 'package:jobprogress/common/models/suppliers/beacon/order.dart';
import 'package:jobprogress/common/models/suppliers/suppliers.dart';
import 'package:jobprogress/common/models/worksheet/worksheet_model.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/common/services/connected_third_party.dart';
import 'package:jobprogress/common/services/files_listing/quick_action_helpers.dart';
import 'package:jobprogress/common/services/files_listing/quick_action_options.dart';
import 'package:jobprogress/common/services/files_listing/quick_actions_list.dart';
import 'package:jobprogress/common/services/permission.dart';
import 'package:jobprogress/core/constants/common_constants.dart';
import 'package:jobprogress/core/constants/connected_third_party_constants.dart';
import 'package:jobprogress/core/constants/user_roles.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/core/constants/permission.dart';
import 'package:jobprogress/modules/files_listing/controller.dart';
import 'package:jp_mobile_flutter_ui/QuickAction/model.dart';
import 'package:jp_mobile_flutter_ui/Thumb/type.dart';
import 'file_listing_test.dart';


void main() {

  FilesListingModel tempFileList = FilesListingModel(
    isWorkSheet: true,
    isShownOnCustomerWebPage: false,
    isFile: true,
    isMaterialList: false,
    isDir: 0,
    isGoogleSheet: true,
    jpThumbType: JPThumbType.image,
  );



    group('For material list', () {
      final controller = FilesListingController();
      controller.resourceList = tempResourceList;
      setUpAll(() {
        AuthService.userDetails = UserModel(
            id: '1',
            firstName: 'Demo',
            fullName: 'Demo User',
            email: 'abc@test.com'
        );
      });

      group('In case of directory', () {
        test(
            'When folder is not locked only rename and delete options should be displayed', () {
          Map<String,
              List<JPQuickActionModel>> result = FileListingQuickActionsList
              .getMaterialListActions(
              FilesListingQuickActionParams(
                fileList: [controller.resourceList[4]],
                onActionComplete: (_, __) {},
              )
          );

          final tempResult = result[FileListingQuickActionsList.folderActions]!;

          expect(
              tempResult.contains(FileListingQuickActionOptions.delete), true);
          expect(
              tempResult.contains(FileListingQuickActionOptions.rename), true);
        });

        test('When folder is locked no options should be displayed', () {
          Map<String,
              List<JPQuickActionModel>> result = FileListingQuickActionsList
              .getMaterialListActions(
              FilesListingQuickActionParams(
                fileList: [controller.resourceList[5]],
                onActionComplete: (_, __) {},
              )
          );

          final tempResult = result[FileListingQuickActionsList.folderActions]!;

          expect(
              tempResult.contains(FileListingQuickActionOptions.delete), false);
          expect(
              tempResult.contains(FileListingQuickActionOptions.rename), false);
        });
      });

      group('In case of file', () {
        test(
            'When file is an image file rotate option should be displayed', () {
          Map<String,
              List<JPQuickActionModel>> result = FileListingQuickActionsList
              .getMaterialListActions(
              FilesListingQuickActionParams(
                fileList: [controller.resourceList[6]],
                onActionComplete: (_, __) {},
              )
          );

          final tempResult = result[FileListingQuickActionsList.fileActions]!;

          expect(
              tempResult.contains(FileListingQuickActionOptions.delete), true);
          expect(
              tempResult.contains(FileListingQuickActionOptions.rename), true);
          expect(
              tempResult.contains(FileListingQuickActionOptions.rotate), true);
          expect(tempResult.contains(FileListingQuickActionOptions.info), true);
          expect(tempResult.contains(FileListingQuickActionOptions.move), !CommonConstants.restrictFolderStructure);
          expect(
              tempResult.contains(FileListingQuickActionOptions.print), true);
          expect(tempResult.contains(
              FileListingQuickActionOptions.showOnCustomerWebPage), false);
          expect(tempResult.contains(
              FileListingQuickActionOptions.removeFromCustomerWebPage), false);
          expect(tempResult.contains(FileListingQuickActionOptions.sendViaText),
              true);
          expect(tempResult.contains(
              FileListingQuickActionOptions.markAsFavourite), false);
          expect(tempResult.contains(
              FileListingQuickActionOptions.unMarkAsFavourite), false);
          expect(
              tempResult.contains(FileListingQuickActionOptions.viewLinkedForm),
              false);
          expect(tempResult.contains(
              FileListingQuickActionOptions.viewLinkedWorkOrder), false);
          expect(tempResult.contains(
              FileListingQuickActionOptions.viewLinkedMeasurement), false);
          expect(tempResult.contains(
              FileListingQuickActionOptions.viewLinkedMaterialList()), false);
          expect(tempResult.contains(
              FileListingQuickActionOptions.viewDeliveryDate), false);
          expect(tempResult.contains(
              FileListingQuickActionOptions.setDeliveryDate), true);
        });

        test(
            'When file is an not image file rotate option should be hidden', () {
          FilesListingQuickActionParams params = FilesListingQuickActionParams(
            fileList: [controller.resourceList[7]],
            onActionComplete: (_, __) {},
          );
          Map<String,
              List<JPQuickActionModel>> result = FileListingQuickActionsList
              .getMaterialListActions(params);

          final tempResult = result[FileListingQuickActionsList.fileActions]!;

          expect(
              tempResult.contains(FileListingQuickActionOptions.delete), true);
          expect(
              tempResult.contains(FileListingQuickActionOptions.rename), true);
          expect(
              tempResult.contains(FileListingQuickActionOptions.rotate), false);
          expect(tempResult.contains(FileListingQuickActionOptions.move), !CommonConstants.restrictFolderStructure);
          expect(tempResult.contains(FileListingQuickActionOptions.info), true);
          expect(
              tempResult.contains(FileListingQuickActionOptions.print), true);
          expect(tempResult.contains(
              FileListingQuickActionOptions.showOnCustomerWebPage), false);
          expect(tempResult.contains(
              FileListingQuickActionOptions.removeFromCustomerWebPage), false);
          if(!FileListingQuickActionHelpers.checkIfAllSelectedFilesAreImages(params)) {
            expect(tempResult.contains(FileListingQuickActionOptions.sendViaText),
                true);
          } else {
            expect(tempResult.contains(FileListingQuickActionOptions.sendViaJobProgress),
                true);
          }
          expect(tempResult.contains(
              FileListingQuickActionOptions.markAsFavourite), false);
          expect(tempResult.contains(
              FileListingQuickActionOptions.unMarkAsFavourite), false);
          expect(
              tempResult.contains(FileListingQuickActionOptions.viewLinkedForm),
              false);
          expect(tempResult.contains(
              FileListingQuickActionOptions.viewLinkedWorkOrder), false);
          expect(tempResult.contains(
              FileListingQuickActionOptions.viewLinkedMeasurement), false);
          expect(tempResult.contains(
              FileListingQuickActionOptions.viewLinkedMaterialList()), false);
          expect(tempResult.contains(
              FileListingQuickActionOptions.viewDeliveryDate), false);
          expect(tempResult.contains(
              FileListingQuickActionOptions.setDeliveryDate), true);
        });

        test('When file is material list corresponding options should be displayed', () {
          List<String> permissionList = ["manage_company_files"];
          PermissionService.permissionList = permissionList;
          Map<String,List<JPQuickActionModel>> result = FileListingQuickActionsList
              .getCompanyFilesActionsList(
              FilesListingQuickActionParams(
                fileList: [
                  controller.resourceList[8]
                    ..isMaterialList = true
                ],
                onActionComplete: (_, __) {},
              )
          );
          
          final tempResult = result[FileListingQuickActionsList.fileActions]!;

          expect(
              tempResult.contains(FileListingQuickActionOptions.delete), true);
          expect(
              tempResult.contains(FileListingQuickActionOptions.rename), true);
          expect(
              tempResult.contains(FileListingQuickActionOptions.rotate), false);
          expect(tempResult.contains(FileListingQuickActionOptions.info), true);
          expect(tempResult.contains(FileListingQuickActionOptions.move), true);
          expect(
              tempResult.contains(FileListingQuickActionOptions.print), true);
          expect(tempResult.contains(
              FileListingQuickActionOptions.showOnCustomerWebPage), false);
          expect(tempResult.contains(FileListingQuickActionOptions.sendViaText),
              false);
          expect(tempResult.contains(
              FileListingQuickActionOptions.showOnCustomerWebPage), false);
          expect(tempResult.contains(
              FileListingQuickActionOptions.removeFromCustomerWebPage), false);
          expect(tempResult.contains(
              FileListingQuickActionOptions.markAsFavourite), false);
          expect(tempResult.contains(
              FileListingQuickActionOptions.unMarkAsFavourite), false);
          expect(tempResult.contains(
              FileListingQuickActionOptions.viewLinkedWorkOrder), false);
          expect(tempResult.contains(
              FileListingQuickActionOptions.viewLinkedMeasurement), false);
          expect(tempResult.contains(
              FileListingQuickActionOptions.viewLinkedMaterialList()), false);
        });

        test('viewLinkedForm should be displayed', () {
          Map<String,
              List<JPQuickActionModel>> result = FileListingQuickActionsList
              .getMaterialListActions(
              FilesListingQuickActionParams(
                fileList: [
                  FilesListingModel(
                      isWorkSheet: true,
                      isShownOnCustomerWebPage: false,
                      isFile: true,
                      isDir: 0,
                      isGoogleSheet: false,
                      isMaterialList: true,
                      jpThumbType: JPThumbType.image,
                      linkedWorkProposal: LinkedWorkOrder(id: 0)
                  )
                ],
                onActionComplete: (_, __) {},
              )
          );
          final tempResult = result[FileListingQuickActionsList.fileActions]!;
          expect(
              tempResult.contains(FileListingQuickActionOptions.viewLinkedForm),
              true);
        });

        test('viewLinkedWorkOrder should be displayed', () {
          Map<String,
              List<JPQuickActionModel>> result = FileListingQuickActionsList
              .getMaterialListActions(
              FilesListingQuickActionParams(
                fileList: [
                  FilesListingModel(
                      isWorkSheet: true,
                      isShownOnCustomerWebPage: false,
                      isFile: true,
                      isDir: 0,
                      isGoogleSheet: false,
                      isMaterialList: true,
                      jpThumbType: JPThumbType.image,
                      linkedWorkOrder: LinkedWorkOrder(id: 0)
                  )
                ],
                onActionComplete: (_, __) {},
              )
          );
          final tempResult = result[FileListingQuickActionsList.fileActions]!;
          expect(tempResult.contains(
              FileListingQuickActionOptions.viewLinkedWorkOrder), true);
        });

        test('viewLinkedMeasurement should be displayed', () {
          Map<String,
              List<JPQuickActionModel>> result = FileListingQuickActionsList
              .getMaterialListActions(
              FilesListingQuickActionParams(
                fileList: [
                  FilesListingModel(
                    isWorkSheet: true,
                    isShownOnCustomerWebPage: false,
                    isFile: true,
                    isDir: 0,
                    isGoogleSheet: false,
                    jpThumbType: JPThumbType.image,
                    isMaterialList: true,
                    linkedMeasurement: LinkedMeasurement(id: 0),
                  )
                ],
                onActionComplete: (_, __) {},
              )
          );
          final tempResult = result[FileListingQuickActionsList.fileActions]!;
          expect(tempResult.contains(
              FileListingQuickActionOptions.viewLinkedMeasurement), true);
        });

        test('viewLinkedMaterialList should be displayed', () {
          final file = FilesListingModel(
            isWorkSheet : true,
            isShownOnCustomerWebPage: false,
            isFile: true,
            isDir: 0,
            isGoogleSheet: false,
            isMaterialList: true,
            jpThumbType: JPThumbType.image,
            linkedMaterialLists: [LinkedMaterialModel(id: 0, forSupplierId: null)],
            type: 'worksheet',
            status: 'draft',
          );

          Map<String, List<JPQuickActionModel>> result = FileListingQuickActionsList.getMaterialListActions(
              FilesListingQuickActionParams(
                fileList: [file],
                onActionComplete: (_, __) { },
              )
          );
          final action = FileListingQuickActionOptions.viewLinkedMaterialList(materials: file.linkedMaterialLists);
          final tempResult = result[FileListingQuickActionsList.fileActions]!;
          expect(tempResult.any((option) => option.id == action.id), true);
        });

        test('unMarkAsFavourite should be displayed', () {
          Map<String,
              List<JPQuickActionModel>> result = FileListingQuickActionsList
              .getMaterialListActions(
              FilesListingQuickActionParams(
                fileList: [
                  FilesListingModel(
                      isWorkSheet: true,
                      isShownOnCustomerWebPage: false,
                      isFile: true,
                      isDir: 0,
                      isMaterialList: false,
                      isGoogleSheet: true,
                      jpThumbType: JPThumbType.image,
                      myFavouriteEntity: MyFavouriteEntity(id: 10, markedBy: 1)
                  )
                ],
                onActionComplete: (_, __) {},
              )
          );
          final tempResult = result[FileListingQuickActionsList.fileActions]!;
          expect(tempResult.contains(
              FileListingQuickActionOptions.unMarkAsFavourite), true);
          expect(tempResult.contains(
              FileListingQuickActionOptions.markAsFavourite), false);
        });

        test('markAsFavourite should be displayed', () {
          Map<String, List<JPQuickActionModel>> result = FileListingQuickActionsList
              .getMaterialListActions(
              FilesListingQuickActionParams(
                fileList: [
                  FilesListingModel(
                    isWorkSheet: true,
                    isShownOnCustomerWebPage: false,
                    isFile: true,
                    isMaterialList: false,
                    isDir: 0,
                    isGoogleSheet: true,
                    jpThumbType: JPThumbType.image,
                  )
                ],
                onActionComplete: (_, __) {},
              )
          );
          final tempResult = result[FileListingQuickActionsList.fileActions]!;
          expect(tempResult.contains(
              FileListingQuickActionOptions.unMarkAsFavourite), false);
          expect(tempResult.contains(
              FileListingQuickActionOptions.markAsFavourite), true);
        });

        test('markAsPending should be displayed', () {
            Map<String, List<JPQuickActionModel>> result = FileListingQuickActionsList.getMaterialListActions(
              FilesListingQuickActionParams(
                fileList: [
                  FilesListingModel(
                    isWorkSheet: true,
                    isShownOnCustomerWebPage: false,
                    isFile: true,
                    isMaterialList: false,
                    isDir: 0,
                    isGoogleSheet: true,
                    jpThumbType: JPThumbType.image,
                    status: 'completed',
                  )
                ],
                onActionComplete: (_, __) {},
              ),
            );
          final tempResult = result[FileListingQuickActionsList.fileActions]!;
          expect(tempResult.contains(FileListingQuickActionOptions.markAsCompleted), false);
          expect(tempResult.contains(FileListingQuickActionOptions.markAsPending), true);
        });
    
        test('markAsCompleted should be displayed', () {
          Map<String, List<JPQuickActionModel>> result = FileListingQuickActionsList.getMaterialListActions(
            FilesListingQuickActionParams(
              fileList: [
                FilesListingModel(
                  isWorkSheet: true,
                  isShownOnCustomerWebPage: false,
                  isFile: true,
                  isMaterialList: false,
                  isDir: 0,
                  isGoogleSheet: true,
                  jpThumbType: JPThumbType.image,
                  status: 'open',
                )
              ],
              onActionComplete: (_, __) {},
            ),
          );
          final tempResult = result[FileListingQuickActionsList.fileActions]!;
          expect(tempResult.contains(FileListingQuickActionOptions.markAsPending), false);
          expect(tempResult.contains(FileListingQuickActionOptions.markAsCompleted), true);
        });
    
        test('viewDeliveryDate should be displayed', () {
          Map<String,
              List<JPQuickActionModel>> result = FileListingQuickActionsList
              .getMaterialListActions(
              FilesListingQuickActionParams(
                fileList: [
                  FilesListingModel(
                      isWorkSheet: true,
                      isShownOnCustomerWebPage: false,
                      isFile: true,
                      isMaterialList: false,
                      isDir: 0,
                      isGoogleSheet: true,
                      jpThumbType: JPThumbType.image,
                      deliveryDateModel: DeliveryDateModel()
                  )
                ],
                onActionComplete: (_, __) {},
              )
          );
          final tempResult = result[FileListingQuickActionsList.fileActions]!;
          expect(tempResult.contains(
              FileListingQuickActionOptions.setDeliveryDate), false);
          expect(tempResult.contains(
              FileListingQuickActionOptions.viewDeliveryDate), true);
        });

        group("'Generate Beacon Order' should be displayed conditionally", () {
          group('Quick Action should not be displayed', () {
            test('When file is not a material list', () {
              tempFileList.isMaterialList = false;
              Map<String, List<JPQuickActionModel>> result = FileListingQuickActionsList.getMaterialListActions(
                  FilesListingQuickActionParams(
                    fileList: [tempFileList],
                    onActionComplete: (_, __) {}
                  ),
              );
              final tempResult = result[FileListingQuickActionsList.fileActions]!;
              expect(tempResult.contains(FileListingQuickActionOptions.generateBeaconOrderForm), isFalse);
            });

            test('When file is a beacon order itself', () {
              tempFileList.forSupplierId = Helper.getSupplierId(key: CommonConstants.beaconId);
              Map<String, List<JPQuickActionModel>> result = FileListingQuickActionsList.getMaterialListActions(
                  FilesListingQuickActionParams(
                    fileList: [tempFileList],
                    onActionComplete: (_, __) {}
                  ),
              );
              final tempResult = result[FileListingQuickActionsList.fileActions]!;
              expect(tempResult.contains(FileListingQuickActionOptions.generateBeaconOrderForm), isFalse);
            });

            test('When worksheet does not have "Beacon" Supplier', () {
              tempFileList.worksheet = WorksheetModel(
                suppliers: []
              );
              Map<String, List<JPQuickActionModel>> result = FileListingQuickActionsList.getMaterialListActions(
                FilesListingQuickActionParams(
                    fileList: [tempFileList],
                    onActionComplete: (_, __) {}
                ),
              );
              final tempResult = result[FileListingQuickActionsList.fileActions]!;
              expect(tempResult.contains(FileListingQuickActionOptions.generateBeaconOrderForm), isFalse);
            });

            test('When logged in user is Sub Contractor', () {
              AuthService.userDetails?.groupId = UserGroupIdConstants.subContractorPrime;
              Map<String, List<JPQuickActionModel>> result = FileListingQuickActionsList.getMaterialListActions(
                FilesListingQuickActionParams(
                    fileList: [tempFileList],
                    onActionComplete: (_, __) {}
                ),
              );
              final tempResult = result[FileListingQuickActionsList.fileActions]!;
              expect(tempResult.contains(FileListingQuickActionOptions.generateBeaconOrderForm), isFalse);
            });

            test('When job is a multi job', () {
              Map<String, List<JPQuickActionModel>> result = FileListingQuickActionsList.getMaterialListActions(
                FilesListingQuickActionParams(
                    fileList: [tempFileList],
                    jobModel: JobModel(
                        isMultiJob: true,
                        id: -1,
                        customerId: -1
                    ),
                    onActionComplete: (_, __) {}
                ),
              );
              final tempResult = result[FileListingQuickActionsList.fileActions]!;
              expect(tempResult.contains(FileListingQuickActionOptions.generateBeaconOrderForm), isFalse);
            });
          });

          test('Quick Action should be displayed if all requirements are met', () {
            tempFileList.isMaterialList = true;
            tempFileList.forSupplierId = null;
            tempFileList.worksheet = WorksheetModel(
                suppliers: [
                  SuppliersModel(
                    id: Helper.getSupplierId(key: CommonConstants.beaconId),
                  ),
                ]
            );
            AuthService.userDetails?.groupId = UserGroupIdConstants.standard;
            Map<String, List<JPQuickActionModel>> result = FileListingQuickActionsList.getMaterialListActions(
              FilesListingQuickActionParams(
                  fileList: [tempFileList],
                  jobModel: JobModel(
                      isMultiJob: false,
                      id: -1,
                      customerId: -1
                  ),
                  onActionComplete: (_, __) {}
              ),
            );
            final tempResult = result[FileListingQuickActionsList.fileActions]!;
            expect(tempResult.contains(FileListingQuickActionOptions.generateBeaconOrderForm), isTrue);
          });
        });

        group("'Place Beacon Order' should be displayed conditionally", () {
          group('Quick Action should not be displayed', () {
            test("When file is not a worksheet", () {
              tempFileList.isWorkSheet = false;
              Map<String, List<JPQuickActionModel>> result = FileListingQuickActionsList.getMaterialListActions(
                FilesListingQuickActionParams(
                    fileList: [tempFileList],
                    onActionComplete: (_, __) {}
                ),
              );
              final tempResult = result[FileListingQuickActionsList.fileActions]!;
              expect(tempResult.contains(FileListingQuickActionOptions.placeBeaconOrder), isFalse);
            });

            test('When worksheet does not have "Beacon" Supplier', () {
              tempFileList.worksheet = WorksheetModel(
                  suppliers: []
              );
              Map<String, List<JPQuickActionModel>> result = FileListingQuickActionsList.getMaterialListActions(
                FilesListingQuickActionParams(
                    fileList: [tempFileList],
                    onActionComplete: (_, __) {}
                ),
              );
              final tempResult = result[FileListingQuickActionsList.fileActions]!;
              expect(tempResult.contains(FileListingQuickActionOptions.placeBeaconOrder), isFalse);
            });

            test('When "Beacon" is not connected', () {
              ConnectedThirdPartyService.connectedThirdParty = {};
              Map<String, List<JPQuickActionModel>> result = FileListingQuickActionsList.getMaterialListActions(
                FilesListingQuickActionParams(
                    fileList: [tempFileList],
                    onActionComplete: (_, __) {}
                ),
              );
              final tempResult = result[FileListingQuickActionsList.fileActions]!;
              expect(tempResult.contains(FileListingQuickActionOptions.placeBeaconOrder), isFalse);
            });

            test("When material has beacon order details", () {
              tempFileList.beaconOrderDetails = BeaconOrderDetails();
              Map<String, List<JPQuickActionModel>> result = FileListingQuickActionsList.getMaterialListActions(
                FilesListingQuickActionParams(
                    fileList: [tempFileList],
                    onActionComplete: (_, __) {}
                ),
              );
              final tempResult = result[FileListingQuickActionsList.fileActions]!;
              expect(tempResult.contains(FileListingQuickActionOptions.placeBeaconOrder), isFalse);
            });

            test("When material is not 'Generated Beacon Order Form'", () {
              tempFileList.forSupplierId = null;
              Map<String, List<JPQuickActionModel>> result = FileListingQuickActionsList.getMaterialListActions(
                FilesListingQuickActionParams(
                    fileList: [tempFileList],
                    onActionComplete: (_, __) {}
                ),
              );
              final tempResult = result[FileListingQuickActionsList.fileActions]!;
              expect(tempResult.contains(FileListingQuickActionOptions.placeBeaconOrder), isFalse);
            });
          });

          test('Quick Action should be displayed when all the requirements are met', () {
            tempFileList.isWorkSheet = true;
            tempFileList.beaconOrderDetails = null;
            tempFileList.forSupplierId = Helper.getSupplierId(key: CommonConstants.beaconId);
            tempFileList.worksheet = WorksheetModel(
                suppliers: [
                  SuppliersModel(
                    id: Helper.getSupplierId(key: CommonConstants.beaconId)
                  )
                ]
            );
            ConnectedThirdPartyService.connectedThirdParty = {
              ConnectedThirdPartyConstants.beacon: true
            };
            Map<String, List<JPQuickActionModel>> result = FileListingQuickActionsList.getMaterialListActions(
              FilesListingQuickActionParams(
                  fileList: [tempFileList],
                  onActionComplete: (_, __) {}
              ),
            );
            final tempResult = result[FileListingQuickActionsList.fileActions]!;
            expect(tempResult.contains(FileListingQuickActionOptions.placeBeaconOrder), isTrue);
          });
        });

        group('FilesListingModel@hasLinkedMaterialItem should check whether there is any linked material list', () {
          group('In case of linked material supplier', () {
            test('If there is linked SRS material list, result should be true', () {
              final result = FilesListingModel(
                linkedMaterialLists: [
                  LinkedMaterialModel(
                    forSupplierId: Helper.getSupplierId(key: CommonConstants.srsId)
                  )
                ]
              ).hasLinkedMaterialItem(key: CommonConstants.srsId);
              expect(result, isTrue);
            });

            test('If there is not linked SRS material list, result should be false', () {
              final result = FilesListingModel(
                  linkedMaterialLists: [
                    LinkedMaterialModel(
                        forSupplierId: Helper.getSupplierId(key: CommonConstants.beaconId)
                    )
                  ]
              ).hasLinkedMaterialItem(key: CommonConstants.srsId);
              expect(result, isFalse);
            });

            test('If there is no linked material list, result should be false', () {
              final result = FilesListingModel(
                  linkedMaterialLists: []
              ).hasLinkedMaterialItem(key: CommonConstants.srsId);
              expect(result, isFalse);
            });

            test('If there is linked Beacon material list, result should be true', () {
              final result = FilesListingModel(
                  linkedMaterialLists: [
                    LinkedMaterialModel(
                        forSupplierId: Helper.getSupplierId(key: CommonConstants.beaconId)
                    )
                  ]
              ).hasLinkedMaterialItem(key: CommonConstants.beaconId);
              expect(result, isTrue);
            });

            test('If there is no linked Beacon material list, result should be false', () {
              final result = FilesListingModel(
                  linkedMaterialLists: [
                    LinkedMaterialModel(
                        forSupplierId: Helper.getSupplierId(key: CommonConstants.srsId)
                    )
                  ]
              ).hasLinkedMaterialItem(key: CommonConstants.beaconId);
              expect(result, isFalse);
            });
          });

          test('If there is linked material list, result should be true', () {
            final result = FilesListingModel(
                linkedMaterialLists: [
                  LinkedMaterialModel(
                      forSupplierId: null
                  )
                ]
            ).hasLinkedMaterialItem();
            expect(result, isTrue);
          });
        });

        group("Edit action should be displayed conditionally", () {
          group("Edit action should not be displayed", () {
            test("Action should not be displayed, When SRS order has been placed", () {
              Map<String, List<JPQuickActionModel>> result = FileListingQuickActionsList.getMaterialListActions(
                FilesListingQuickActionParams(
                    fileList: [tempFileList..srsOrderDetail = SrsOrderModel(orderId: "123")],
                    onActionComplete: (_, __) {}
                ),
              );
              final tempResult = result[FileListingQuickActionsList.fileActions]!;
              expect(tempResult.contains(FileListingQuickActionOptions.editWorksheet), isFalse);
            });

            test("Action should not be displayed, When Beacon order has been placed", () {
              Map<String, List<JPQuickActionModel>> result = FileListingQuickActionsList.getMaterialListActions(
                FilesListingQuickActionParams(
                    fileList: [tempFileList..beaconOrderDetails = BeaconOrderDetails(orderId: 123)],
                    onActionComplete: (_, __) {}
                )
              );
              final tempResult = result[FileListingQuickActionsList.fileActions]!;
              expect(tempResult.contains(FileListingQuickActionOptions.editWorksheet), isFalse);
            });

            group("Action should not be displayed, When supplier is not known", () {
              test("When worksheet does not have a supplier", () {
                Map<String, List<JPQuickActionModel>> result = FileListingQuickActionsList.getMaterialListActions(
                    FilesListingQuickActionParams(
                        fileList: [tempFileList..forSupplierId = null],
                        onActionComplete: (_, __) {}
                    )
                );
                final tempResult = result[FileListingQuickActionsList.fileActions]!;
                expect(tempResult.contains(FileListingQuickActionOptions.editWorksheet), isFalse);
              });

              test("When worksheet have supplier other than SRS or Beacon", () {
                Map<String, List<JPQuickActionModel>> result = FileListingQuickActionsList.getMaterialListActions(
                    FilesListingQuickActionParams(
                        fileList: [tempFileList..forSupplierId = -23],
                        onActionComplete: (_, __) {}
                    )
                );
                final tempResult = result[FileListingQuickActionsList.fileActions]!;
                expect(tempResult.contains(FileListingQuickActionOptions.editWorksheet), isFalse);
              });

              test("When worksheet does not have suppliers", () {
                Map<String, List<JPQuickActionModel>> result = FileListingQuickActionsList.getMaterialListActions(
                    FilesListingQuickActionParams(
                        fileList: [tempFileList..worksheet = WorksheetModel(suppliers: [])],
                        onActionComplete: (_, __) {}
                    )
                );
                final tempResult = result[FileListingQuickActionsList.fileActions]!;
                expect(tempResult.contains(FileListingQuickActionOptions.editWorksheet), isFalse);
              });

              test("When worksheet has SRS supplier but SRS is not connected", () {
                Map<String, List<JPQuickActionModel>> result = FileListingQuickActionsList.getMaterialListActions(
                    FilesListingQuickActionParams(
                        fileList: [tempFileList..worksheet = WorksheetModel(
                            suppliers: [
                              SuppliersModel(
                                id: Helper.getSupplierId(key: CommonConstants.srsId),
                              )
                            ],
                        )],
                        onActionComplete: (_, __) {}
                    )
                );
                ConnectedThirdPartyService.connectedThirdParty = {};
                final tempResult = result[FileListingQuickActionsList.fileActions]!;
                expect(tempResult.contains(FileListingQuickActionOptions.editWorksheet), isFalse);
              });

              test("When worksheet has Beacon supplier but Beacon is not connected", () {
                Map<String, List<JPQuickActionModel>> result = FileListingQuickActionsList.getMaterialListActions(
                    FilesListingQuickActionParams(
                        fileList: [tempFileList..worksheet = WorksheetModel(
                            suppliers: [
                              SuppliersModel(
                                id: Helper.getSupplierId(key: CommonConstants.beaconId),
                              )
                            ],
                        )],
                        onActionComplete: (_, __) {}
                    )
                );
                ConnectedThirdPartyService.connectedThirdParty = {};
                final tempResult = result[FileListingQuickActionsList.fileActions]!;
                expect(tempResult.contains(FileListingQuickActionOptions.editWorksheet), isFalse);
              });
            });
          });

          group("Edit action should be displayed", () {
            setUp(() {
              tempFileList
                ..forSupplierId = null
                ..worksheet = null
                ..jpThumbType = JPThumbType.icon
                ..beaconOrderDetails = null
                ..isFile = false
                ..srsOrderDetail = null;
            });

            test("Action should be displayed, When SRS order has not been placed", () {
              Map<String, List<JPQuickActionModel>> result = FileListingQuickActionsList.getMaterialListActions(
                FilesListingQuickActionParams(
                    fileList: [tempFileList],
                    onActionComplete: (_, __) {}
                ),
              );
              final tempResult = result[FileListingQuickActionsList.fileActions]!;
              expect(tempResult.contains(FileListingQuickActionOptions.editWorksheet), isTrue);
            });

            test("Action should be displayed, When Beacon order has not been placed", () {
              Map<String, List<JPQuickActionModel>> result = FileListingQuickActionsList.getMaterialListActions(
                FilesListingQuickActionParams(
                    fileList: [tempFileList],
                    onActionComplete: (_, __) {}
                )
              );
              final tempResult = result[FileListingQuickActionsList.fileActions]!;
              expect(tempResult.contains(FileListingQuickActionOptions.editWorksheet), isTrue);
            });

            group("Action should not be displayed, When supplier is known", () {
              test("When worksheet has SRS supplier", () {
                Map<String, List<JPQuickActionModel>> result = FileListingQuickActionsList.getMaterialListActions(
                    FilesListingQuickActionParams(
                        fileList: [tempFileList..forSupplierId = Helper.getSupplierId(key: CommonConstants.srsId)],
                        onActionComplete: (_, __) {}
                    )
                );
                final tempResult = result[FileListingQuickActionsList.fileActions]!;
                expect(tempResult.contains(FileListingQuickActionOptions.editWorksheet), isTrue);
              });

              test("When worksheet has Beacon supplier", () {
                Map<String, List<JPQuickActionModel>> result = FileListingQuickActionsList.getMaterialListActions(
                    FilesListingQuickActionParams(
                        fileList: [tempFileList..forSupplierId = Helper.getSupplierId(key: CommonConstants.beaconId)],
                        onActionComplete: (_, __) {}
                    )
                );
                final tempResult = result[FileListingQuickActionsList.fileActions]!;
                expect(tempResult.contains(FileListingQuickActionOptions.editWorksheet), isTrue);
              });
            });

        group("'View Linked Estimate' should be displayed conditionally as per 'Manage Estimate' permission", () {
          setUp(() {
            tempFileList = FilesListingModel(
                isWorkSheet: true,
                isShownOnCustomerWebPage: false,
                isFile: true,
                isDir: 0,
                isGoogleSheet: false,
                isMaterialList: true,
                jpThumbType: JPThumbType.image,
                linkedEstimate: LinkedWorkOrder(id: 0)
            );
            PermissionService.permissionList = [];
          });

          test("When user does not have 'Manage Estimate' permission, Quick Action should not be displayed", () {
            Map<String, List<JPQuickActionModel>> result = FileListingQuickActionsList.getMaterialListActions(
                FilesListingQuickActionParams(
                  fileList: [tempFileList],
                  onActionComplete: (_, __) { },
                )
            );
            final tempResult = result[FileListingQuickActionsList.fileActions]!;
            expect(tempResult.contains(FileListingQuickActionOptions.viewLinkedEstimate), isFalse);
          });

          test("When user does have 'Manage Estimate' permission, Quick Action should be displayed", () {
            PermissionService.permissionList.add(PermissionConstants.manageEstimates);
            Map<String, List<JPQuickActionModel>> result = FileListingQuickActionsList.getMaterialListActions(
                FilesListingQuickActionParams(
                  fileList: [tempFileList],
                  onActionComplete: (_, __) { },
                )
            );
            final tempResult = result[FileListingQuickActionsList.fileActions]!;
            expect(tempResult.contains(FileListingQuickActionOptions.viewLinkedEstimate), isTrue);
          });
        });
      });
    });
     });
    });
}

