import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/file_listing.dart';
import 'package:jobprogress/common/models/customer/customer.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/global_widgets/recent_files/controller.dart';
import 'package:jobprogress/modules/job/job_summary/controller.dart';

void main() {

  JobModel jobModel = JobModel(id: 1, customerId: 1, customer: CustomerModel());

  RecentFilesController controller = RecentFilesController(jobModel, FLModule.jobPhotos, JobSummaryController());

  group("RecentFilesController@getRecentFilesPlaceHolderIcon() Should return icon bases on type of files are being displayed", () {
    test('When files are photos and documents', () {
      expect(controller.getRecentFilesPlaceHolderIcon(FLModule.jobPhotos), equals(Icons.perm_media_outlined));
    });

    test('When files are estimate', () {
      expect(controller.getRecentFilesPlaceHolderIcon(FLModule.estimate), equals(Icons.description_outlined));
    });

    test('When files are forms / proposals', () {
      expect(controller.getRecentFilesPlaceHolderIcon(FLModule.jobProposal), equals(Icons.description_outlined));
    });

    test('When files are of some other type', () {
      expect(controller.getRecentFilesPlaceHolderIcon(FLModule.materialLists), equals(Icons.folder));
    });
  });

  group("RecentFilesController@getRecentFilesPlaceTitle() Should return title of error message bases on type of files", () {
    test('When files are photos and documents', () {
      expect(controller.getRecentFilesPlaceTitle(FLModule.jobPhotos), equals('no_photo_document_found'.tr));
    });

    test('When files are estimate', () {
      expect(controller.getRecentFilesPlaceTitle(FLModule.estimate), equals('no_estimating_found'.tr));
    });

    test('When files are forms / proposals', () {
      expect(controller.getRecentFilesPlaceTitle(FLModule.jobProposal), equals('no_form_proposal_found'.tr));
    });

    test('When files are of some other type', () {
      expect(controller.getRecentFilesPlaceTitle(FLModule.materialLists), equals('no_file_found'.tr));
    });
  });
}