import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/enums/file_listing.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_quick_action_params.dart';
import 'package:jobprogress/common/models/files_listing/hover/hover_image.dart';
import 'package:jobprogress/common/models/files_listing/hover/hover_report.dart';
import 'package:jobprogress/common/models/files_listing/hover/job.dart';
import 'package:jobprogress/common/models/subscriber/hover_client.dart';
import 'package:jobprogress/common/models/subscriber/subscriber_details.dart';
import 'package:jobprogress/common/services/files_listing/quick_action_options.dart';
import 'package:jobprogress/common/services/files_listing/quick_actions_list.dart';
import 'package:jobprogress/core/constants/common_constants.dart';
import 'package:jobprogress/modules/files_listing/controller.dart';
import 'package:jp_mobile_flutter_ui/Icon/index.dart';
import 'package:jp_mobile_flutter_ui/QuickAction/model.dart';

import 'file_listing_test.dart';


void main() {

    group('For measurements', (){

      final controller = FilesListingController();
      controller.resourceList = tempResourceList;

      group('In case of directory', () {

        test('When folder is not locked only rename and delete options should be displayed', () {

          Map<String, List<JPQuickActionModel>> result = FileListingQuickActionsList.getMeasurementsActionList(
              FilesListingQuickActionParams(
                fileList: [
                  controller.resourceList[0]
                    ..isHoverJobCompleted = false,
                ],
                onActionComplete: (_, __) { },
              )
          );

          final tempResult = result[FileListingQuickActionsList.folderActions]!;

          expect(tempResult.contains(FileListingQuickActionOptions.delete), true);
          expect(tempResult.contains(FileListingQuickActionOptions.rename), true);

        });

        test('When folder is locked no options should be displayed', () {

          Map<String, List<JPQuickActionModel>> result = FileListingQuickActionsList.getMeasurementsActionList(
              FilesListingQuickActionParams(
                fileList: [
                  controller.resourceList[1]
                    ..isHoverJobCompleted = false,
                ],
                isInSelectionMode: false,
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

          Map<String, List<JPQuickActionModel>> result = FileListingQuickActionsList.getMeasurementsActionList(
              FilesListingQuickActionParams(
                fileList: [
                  controller.resourceList[2]],
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
          expect(tempResult.contains(FileListingQuickActionOptions.hoverImages), false);
          expect(tempResult.contains(FileListingQuickActionOptions.open3DModel), false);
          expect(tempResult.contains(FileListingQuickActionOptions.upgradeToHoverRoofOnly), false);
          expect(tempResult.contains(FileListingQuickActionOptions.upgradeToHoverRoofComplete), false);
          expect(tempResult.contains(FileListingQuickActionOptions.viewInfo), false);
          expect(tempResult.contains(FileListingQuickActionOptions.viewReports(subList: [])), false);

        });

        test('When file is an not image file rotate option should be hidden', () {

          Map<String, List<JPQuickActionModel>> result = FileListingQuickActionsList.getMeasurementsActionList(
              FilesListingQuickActionParams(
                fileList: [controller.resourceList[3]],
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
          expect(tempResult.contains(FileListingQuickActionOptions.hoverImages), false);
          expect(tempResult.contains(FileListingQuickActionOptions.open3DModel), false);
          expect(tempResult.contains(FileListingQuickActionOptions.upgradeToHoverRoofOnly), false);
          expect(tempResult.contains(FileListingQuickActionOptions.upgradeToHoverRoofComplete), false);
          expect(tempResult.contains(FileListingQuickActionOptions.viewInfo), false);
          expect(tempResult.contains(FileListingQuickActionOptions.viewReports(subList: [])), false);

        });

        test('When hover job is completed delete/info/viewInfo/open3DModel/print/sendViaText/rename/rotate should hide', () {

          Map<String, List<JPQuickActionModel>> result = FileListingQuickActionsList.getMeasurementsActionList(
              FilesListingQuickActionParams(
                fileList: [
                  controller.resourceList[3]
                    ..hoverJob = HoverJob(id: 10, hoverJobId: 10, jobId: 10)
                    ..isHoverJobCompleted = true,
                ],
                onActionComplete: (_, __) { },
              )
          );

          final tempResult = result[FileListingQuickActionsList.fileActions]!;

          expect(tempResult.contains(FileListingQuickActionOptions.rename), false);
          expect(tempResult.contains(FileListingQuickActionOptions.rotate), false);
          expect(tempResult.contains(FileListingQuickActionOptions.expiresOn), true);
          expect(tempResult.contains(FileListingQuickActionOptions.info), false);
          expect(tempResult.contains(FileListingQuickActionOptions.move), !CommonConstants.restrictFolderStructure);
          expect(tempResult.contains(FileListingQuickActionOptions.print), false);
          expect(tempResult.contains(FileListingQuickActionOptions.hoverImages), false);
          expect(tempResult.contains(FileListingQuickActionOptions.open3DModel), false);
          expect(tempResult.contains(FileListingQuickActionOptions.sendViaJobProgress), false);
          expect(tempResult.contains(FileListingQuickActionOptions.upgradeToHoverRoofOnly), false);
          expect(tempResult.contains(FileListingQuickActionOptions.upgradeToHoverRoofComplete), false);
          expect(tempResult.contains(FileListingQuickActionOptions.viewInfo), false);
          expect(tempResult.contains(FileListingQuickActionOptions.viewReports(subList: [])), false);

        });

        test('When file is hover and hover images exist', () {

          Map<String, List<JPQuickActionModel>> result = FileListingQuickActionsList.getMeasurementsActionList(
              FilesListingQuickActionParams(
                fileList: [
                  controller.resourceList[3]
                    ..hoverJob = HoverJob(id: 10, hoverJobId: 10, jobId: 10, hoverImages: [HoverImage()])
                    ..isHoverJobCompleted = false,
                ],
                onActionComplete: (_, __) { },
              )
          );

          final tempResult = result[FileListingQuickActionsList.fileActions]!;

          expect(tempResult.contains(FileListingQuickActionOptions.hoverImages), true);

        });

        test('When file is hover and hover job is not completed', () {

          Map<String, List<JPQuickActionModel>> result = FileListingQuickActionsList.getMeasurementsActionList(
              FilesListingQuickActionParams(
                fileList: [
                  controller.resourceList[3]
                    ..hoverJob = HoverJob(id: 10, hoverJobId: 10, jobId: 10, hoverImages: [HoverImage()])
                    ..isHoverJobCompleted = false,
                ],
                onActionComplete: (_, __) { },
              )
          );

          final tempResult = result[FileListingQuickActionsList.fileActions]!;

          expect(tempResult.contains(FileListingQuickActionOptions.open3DModel), true);

        });

        test('When file is hover and report file exists', () {

          expect(FileListingQuickActionOptions.viewReports(subList: [ReportFile(id: 0, hoverJobId: 10, fileName: '', filePath: '')].map((report){
            return JPQuickActionModel(
              child: const JPIcon(Icons.remove_red_eye_outlined, size: 20),
              label: report.fileName.toString(),
              id: '${FLQuickActions.viewReportsSubOption} ${report.filePath}',
            );
          }).toList()).sublist?.length, 1);

        });

        test('upgradeToHoverRoofOnly should be displayed', () {

          Map<String, List<JPQuickActionModel>> result = FileListingQuickActionsList.getMeasurementsActionList(
              FilesListingQuickActionParams(
                fileList: [
                  controller.resourceList[3]
                    ..hoverJob = HoverJob(id: 10,ownerId: 5 ,hoverJobId: 10, jobId: 10, hoverImages: [HoverImage()])
                    ..isUpgradeToHoverRoofOnlyVisible = true,
                ],
                subscriberDetails: SubscriberDetailsModel(
                    hoverClient: HoverClient(ownerId: 5)
                ),
                onActionComplete: (_, __) { },
              )
          );

          final tempResult = result[FileListingQuickActionsList.fileActions]!;

          expect(tempResult.contains(FileListingQuickActionOptions.upgradeToHoverRoofOnly), true);

        });

        test('upgradeToHoverRoofCompleteVisible should be displayed', () {

          Map<String, List<JPQuickActionModel>> result = FileListingQuickActionsList.getMeasurementsActionList(
              FilesListingQuickActionParams(
                fileList: [
                  controller.resourceList[3]
                    ..hoverJob = HoverJob(id: 10, ownerId: 5 ,hoverJobId: 10, jobId: 10, hoverImages: [HoverImage()])
                    ..isUpgradeToHoverRoofCompleteVisible = true,
                ],
                subscriberDetails: SubscriberDetailsModel(
                    hoverClient: HoverClient(ownerId: 5)
                ),
                onActionComplete: (_, __) { },
              )
          );

          final tempResult = result[FileListingQuickActionsList.fileActions]!;

          expect(tempResult.contains(FileListingQuickActionOptions.upgradeToHoverRoofComplete), true);

        });


      });

    });

}

