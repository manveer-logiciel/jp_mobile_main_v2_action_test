import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/files_listing/eagleview/ev_order.dart';
import 'package:jobprogress/common/models/files_listing/eagleview/status.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_model.dart';
import 'package:jobprogress/common/models/files_listing/hover/job.dart';
import 'package:jobprogress/common/models/files_listing/srs/srs_order_detail.dart';
import 'package:jobprogress/common/models/suppliers/abc_order_details.dart';
import 'package:jobprogress/common/models/suppliers/beacon/order.dart';
import 'package:jobprogress/common/models/suppliers/suppliers.dart';
import 'package:jobprogress/common/models/worksheet/worksheet_model.dart';
import 'package:jobprogress/core/constants/assets_files.dart';
import 'package:jobprogress/core/constants/order_status_constants.dart';
import 'package:jobprogress/modules/files_listing/widgets/files_type_tag.dart';
import 'package:jp_mobile_flutter_ui/Thumb/icon_type.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

void main() {
  FilesListingModel? filesListingModel = FilesListingModel();

  group('FileTypeTag@getTagTitle', () {

    setUp(() {
      filesListingModel = FilesListingModel(jpThumbIconType: JPThumbIconType.pdf,
      worksheet: WorksheetModel(suppliers: [SuppliersModel()]),
      forSupplierId: 1
      );
    });

    test('When file type is insurance estimate', () {
      filesListingModel?.insuranceEstimate = true;
      expect(FileTypeTag.getTagTitle(filesListingModel!), 'merge'.tr);
    });

    test('When file type is clickthru and clickThru id is available', () {
      filesListingModel?.type = 'clickthru';
      filesListingModel?.clickthruId = '1';
      expect(FileTypeTag.getTagTitle(filesListingModel!), 'clickthru'.tr);
    });

    test('When file type is xactimate', () {
      filesListingModel?.type = 'xactimate';
      expect(FileTypeTag.getTagTitle(filesListingModel!), 'insurance'.tr);
    });

    test('When isSecondTag is true and SRS order status is available', () {
      filesListingModel?.srsOrderDetail = SrsOrderModel(orderStatus: 'Pending');
      expect(FileTypeTag.getTagTitle(filesListingModel!, isSecondTag: true), 'srs_order'.tr);
    });

    test('When isSecondTag is true and Beacon order status is available', () {
      filesListingModel?.isBeaconOrder = true;
      expect(FileTypeTag.getTagTitle(filesListingModel!, isSecondTag: true), 'beacon_order'.tr);
    });

    test('When isSecondTag is true and ABC order status is available', () {
      filesListingModel?.abcOrderDetail = ABCOrderDetails(orderStatus: 'Pending');
      expect(FileTypeTag.getTagTitle(filesListingModel!, isSecondTag: true), 'abc_order'.tr);
    });

    group('When File has suppliers and ', () {

      test('SRS suppliers are available', () {
        filesListingModel?.worksheet?.suppliers?[0].id = 181;
        expect(FileTypeTag.getTagTitle(filesListingModel!), 'srs_order'.tr);
      });

      test('Beacon suppliers are available', () {
        filesListingModel?.worksheet?.suppliers?[0].id = 173;
        expect(FileTypeTag.getTagTitle(filesListingModel!), 'beacon_order'.tr);
      });

      test('ABC suppliers are available', () {
        filesListingModel?.worksheet?.suppliers?[0].id = 188;
        expect(FileTypeTag.getTagTitle(filesListingModel!), 'abc_order'.tr);
      });
    });

    test('When File has hove job state and type is pdf or hove job state is completed', () {
      filesListingModel?.hoverJob = HoverJob(
        state: 'complete'
      );
      expect(FileTypeTag.getTagTitle(filesListingModel!), 'Complete');
    });

    test('When File has EV order status name', () {
      filesListingModel?.evOrder = EvOrder(
          status: EagleViewOrderStatus(name: 'Pending')
      );
      expect(FileTypeTag.getTagTitle(filesListingModel!), 'Pending');
    });
  });

  group('FileTypeTag@getTagColor', () {

    setUp(() {
      filesListingModel = FilesListingModel();
    });

    test('When hover job state is completed', () {
      filesListingModel?.hoverJob = HoverJob(
        state: 'complete'
      );
      expect(FileTypeTag.getTagColor(filesListingModel!), JPAppTheme.themeColors.success);
    });

    group('When SRS order details are available', () {

      test('SRS order status should be pending', () {
        filesListingModel?.srsOrderDetail = SrsOrderModel(
          orderStatus: OrderStatusConstants.pending
        );
        expect(FileTypeTag.getTagColor(filesListingModel!), JPAppTheme.themeColors.tertiary.withValues(alpha: 0.7));
      });

      test('SRS order status should not be pending', () {
        filesListingModel?.srsOrderDetail = SrsOrderModel(
            orderStatus: OrderStatusConstants.orderPlaced
        );
        expect(FileTypeTag.getTagColor(filesListingModel!), JPAppTheme.themeColors.success);
      });
    });

    group('When Beacon order details are available', () {

      test('Beacon order status should be pending', () {
        filesListingModel?.beaconOrderDetails = BeaconOrderDetails(
            orderStatus: OrderStatusConstants.pending
        );
        expect(FileTypeTag.getTagColor(filesListingModel!), JPAppTheme.themeColors.tertiary.withValues(alpha: 0.7));
      });

      test('Beacon order status should not be pending', () {
        filesListingModel?.beaconOrderDetails = BeaconOrderDetails(
            orderStatus: OrderStatusConstants.orderPlaced
        );
        expect(FileTypeTag.getTagColor(filesListingModel!), JPAppTheme.themeColors.success);
      });
    });

    group('When ABC order details are available', () {

      test('ABC order status should be pending', () {
        filesListingModel?.abcOrderDetail = ABCOrderDetails(
            orderStatus: OrderStatusConstants.pending
        );
        expect(FileTypeTag.getTagColor(filesListingModel!), JPAppTheme.themeColors.tertiary.withValues(alpha: 0.7));
      });

      test('ABC order status should not be pending', () {
        filesListingModel?.abcOrderDetail = ABCOrderDetails(
            orderStatus: OrderStatusConstants.orderPlaced
        );
        expect(FileTypeTag.getTagColor(filesListingModel!), JPAppTheme.themeColors.success);
      });
    });
  });

  group('FileTypeTag@getTagIcon', () {

    testWidgets('When tag title is SRS Order', (widgetTester) async {
      await widgetTester.pumpWidget(FileTypeTag.getTagIcon('srs_order'.tr));
      expect(find.image(AssetImage(AssetsFiles.srsLogo)), findsOneWidget);
    });

    testWidgets('When tag title is Beacon Order', (widgetTester) async {
      await widgetTester.pumpWidget(FileTypeTag.getTagIcon('beacon_order'.tr));
      expect(find.image(AssetImage(AssetsFiles.qxoLogo)), findsOneWidget);
    });

    testWidgets('When tag title is ABC Order', (widgetTester) async {
      await widgetTester.pumpWidget(FileTypeTag.getTagIcon('abc_order'.tr));
      expect(find.image(AssetImage(AssetsFiles.abcLogo)), findsOneWidget);
    });

    testWidgets('When tag title is not type of supplier order', (widgetTester) async {
      await widgetTester.pumpWidget(FileTypeTag.getTagIcon(''));
      expect(find.byType(Image), findsNothing);
    });
  });

  group('FileTypeTag@isIntegrationOrderIcon', () {

    test('When tag title is SRS Order', () {
      expect(FileTypeTag.isIntegrationOrderIcon('srs_order'.tr), isTrue);
    });

    test('When tag title is Beacon Order', () {
      expect(FileTypeTag.isIntegrationOrderIcon('beacon_order'.tr), isTrue);
    });

    test('When tag title is ABC Order', () {
      expect(FileTypeTag.isIntegrationOrderIcon('abc_order'.tr), isTrue);
    });
  });

  group('FileTypeTag@isIntegrationOrderStatus', () {

    test('When file has SRS order details', () {
      filesListingModel?.srsOrderDetail = SrsOrderModel();
      filesListingModel?.beaconOrderDetails = null;
      filesListingModel?.abcOrderDetail = null;
      expect(FileTypeTag.isIntegrationOrderStatus(filesListingModel!), isTrue);
    });

    test('When file has Beacon order details', () {
      filesListingModel?.srsOrderDetail = null;
      filesListingModel?.beaconOrderDetails = BeaconOrderDetails();
      filesListingModel?.abcOrderDetail = null;

      expect(FileTypeTag.isIntegrationOrderStatus(filesListingModel!), isTrue);
    });

    test('When file has ABC order details', () {
      filesListingModel?.srsOrderDetail = null;
      filesListingModel?.beaconOrderDetails = null;
      filesListingModel?.abcOrderDetail = ABCOrderDetails();
      expect(FileTypeTag.isIntegrationOrderStatus(filesListingModel!), isTrue);
    });

    test('When file has no any supplier order details', () {
      filesListingModel?.srsOrderDetail = null;
      filesListingModel?.beaconOrderDetails = null;
      filesListingModel?.abcOrderDetail = null;
      expect(FileTypeTag.isIntegrationOrderStatus(filesListingModel!), isFalse);
    });
  });
}