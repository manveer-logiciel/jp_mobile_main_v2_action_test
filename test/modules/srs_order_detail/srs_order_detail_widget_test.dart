import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/attachment.dart';
import 'package:jobprogress/common/models/custom_fields/custom_fields.dart';
import 'package:jobprogress/common/models/files_listing/srs/srs_order_detail.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/attachments_detail/index.dart';
import 'package:jobprogress/global_widgets/custom_fields/widgets/custom_field_tile.dart';
import 'package:jobprogress/modules/supplier_order_details/controller.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

void main() {

   Widget buildTestableWidget(Widget widget) {
    return MaterialApp(
      home: widget,
    );
  }
  group('Tracking Description Tile', () {
    
    // Set up variables and dependencies
    bool isDeliveryCompleted;

    testWidgets('should display the correct text based on delivery completion', (WidgetTester tester) async {
      isDeliveryCompleted = true;
      await tester.pumpWidget(
        buildTestableWidget( 
          JPText(
            text: isDeliveryCompleted ? 'download_pdf'.tr : 'n_a'.tr,
            textAlign: TextAlign.start,
            textColor: isDeliveryCompleted ? JPAppTheme.themeColors.primary : JPAppTheme.themeColors.text,
            textSize: JPTextSize.heading4,
          )
        )
      );

      // Assert that the text is 'download_pdf'
      expect(find.text('download_pdf'), findsOneWidget);
    });

    testWidgets('should display "n_a" when delivery is not completed', (WidgetTester tester) async {
      isDeliveryCompleted = false;
      
      await tester.pumpWidget(
        buildTestableWidget( 
          JPText(
            text: isDeliveryCompleted ? 'download_pdf'.tr : 'n_a'.tr,
            textAlign: TextAlign.start,
            textColor: isDeliveryCompleted ? JPAppTheme.themeColors.primary : JPAppTheme.themeColors.text,
            textSize: JPTextSize.heading4,
          )
        )
      );

      // Assert that the text is 'n_a'
      expect(find.text('n_a'), findsOneWidget);
    });

    testWidgets('should display the correct color based on delivery completion', (WidgetTester tester) async {
      isDeliveryCompleted = true;
      await tester.pumpWidget(
        buildTestableWidget( 
          JPText(
            text: isDeliveryCompleted ? 'download_pdf'.tr : 'n_a'.tr,
            textAlign: TextAlign.start,
            textColor: isDeliveryCompleted ? JPAppTheme.themeColors.primary : JPAppTheme.themeColors.text,
            textSize: JPTextSize.heading4,
          )
        )
      );

      // Assert that the text color is JPAppTheme.themeColors.primary
      expect(find.byWidgetPredicate((widget) {
        return widget is Text && widget.style?.color == JPAppTheme.themeColors.primary;
      }), findsOneWidget);
    });

    testWidgets('should display the correct color when delivery is not completed', (WidgetTester tester) async {
      isDeliveryCompleted = false;
      await tester.pumpWidget(
        buildTestableWidget( 
          JPText(
            text: isDeliveryCompleted ? 'download_pdf'.tr : 'n_a'.tr,
            textAlign: TextAlign.start,
            textColor: isDeliveryCompleted ? JPAppTheme.themeColors.primary : JPAppTheme.themeColors.text,
            textSize: JPTextSize.heading4,
          )
        )
      );

      // Assert that the text color is JPAppTheme.themeColors.text
      expect(find.byWidgetPredicate((widget) {
        return widget is Text && widget.style?.color == JPAppTheme.themeColors.text;
      }), findsOneWidget);
    });
  });

group('Visibility tests', () {
  final controller = SupplierOrderDetailController();

  testWidgets('Visible when attachments are not null or empty', (WidgetTester tester) async {
    controller.srsOrder = SrsOrderModel(attachments: [AttachmentResourceModel(id: 1,)]);

    await tester.pumpWidget(
      MaterialApp(
        home: Visibility(
          visible: !Helper.isValueNullOrEmpty(controller.srsOrder?.attachments),
          child: Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 16),
            child: JPAttachmentDetail(
              paddingLeft: 14,
              attachments: controller.srsOrder?.attachments ?? [],
            ),
          ),
        ),
      ),
    );

    final jpAttachmentFinder = find.byType(JPAttachmentDetail);
    expect(jpAttachmentFinder, findsOneWidget);
  });

  testWidgets('Not visible when attachments are null or empty', (WidgetTester tester) async {
    controller.srsOrder = SrsOrderModel(attachments: null);

    await tester.pumpWidget(
      MaterialApp(
        home: Visibility(
          visible: !Helper.isValueNullOrEmpty(controller.srsOrder?.attachments),
          child: Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 16),
            child: JPAttachmentDetail(
              paddingLeft: 14,
              attachments: controller.srsOrder?.attachments ?? [],
            ),
          ),
        ),
      ),
    );

    final jpAttachmentFinder = find.byType(JPAttachmentDetail);
    expect(jpAttachmentFinder, findsNothing);
  });
});

  group('customFieldTextTile', () {
    Widget customFieldTextTile({CustomFieldsModel? field}) => Column(
      children: [
        Visibility(
          visible: !Helper.isValueNullOrEmpty(field?.value) && Helper.isTrue(field?.isVisible),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: CustomFieldTile(
              label: Visibility(
                visible: !Helper.isValueNullOrEmpty(field?.name),
                child: JPText(
                  text: field?.name ?? "",
                  textAlign: TextAlign.start,
                  textSize: JPTextSize.heading5,
                  textColor: JPAppTheme.themeColors.tertiary,
                ),
              ),
              description: JPText(
                text: field?.value ?? "",
                textAlign: TextAlign.start,
                textSize: JPTextSize.heading4,
              ),
            ),
          ),
        ),
        Visibility(
          visible: false,
          child: Divider(height: 1, color: JPAppTheme.themeColors.dimGray),
        ),
      ],
    );
  
    testWidgets('should display CustomFieldTile when field is visible and has a value', (WidgetTester tester) async {
      final field = CustomFieldsModel(value: 'Some value', isVisible: true);
  
      await tester.pumpWidget(buildTestableWidget(customFieldTextTile(field: field)));
  
      expect(find.byType(CustomFieldTile), findsOneWidget);
      expect(field.value, isNotEmpty);
    });
  
    testWidgets('should not display CustomFieldTile when field is not visible', (WidgetTester tester) async {
      final field = CustomFieldsModel(value: 'Some value', isVisible: false);
  
      await tester.pumpWidget(buildTestableWidget(customFieldTextTile(field: field)));
  
      expect(find.byType(CustomFieldTile), findsNothing);
    });
  
    testWidgets('should not display CustomFieldTile when field has no value', (WidgetTester tester) async {
      final field = CustomFieldsModel(value: null, isVisible: true);
  
      await tester.pumpWidget(buildTestableWidget(customFieldTextTile(field: field)));
  
      expect(find.byType(CustomFieldTile), findsNothing);
      expect(field.value, isNull);
    });
  
    testWidgets('should display correct label and description texts', (WidgetTester tester) async {
      final field = CustomFieldsModel(name: 'Name', value: 'Value', isVisible: true);
  
      await tester.pumpWidget(buildTestableWidget(customFieldTextTile(field: field)));
  
      expect(find.text('Name'), findsOneWidget);
      expect(find.text('Value'), findsOneWidget);
    });
  });
}