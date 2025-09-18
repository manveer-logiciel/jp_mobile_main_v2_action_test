import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/models/financial_product/financial_product_model.dart';
import 'package:jobprogress/global_widgets/network_image/index.dart';
import 'package:jobprogress/modules/financial_product_search/widget/supplier_icon.dart';

void main() {
  testWidgets('In case product has logo, it should be displayed', (WidgetTester tester) async {
    await tester.pumpWidget(
      FinancialProductSupplierIcon(
        product: FinancialProductModel(branchLogo: 'http://example.com'),
      ),
    );
    expect(find.byType(JPNetworkImage), findsOneWidget);
  });

  group("In case product does not have logo", () {
    testWidgets('In case of Beacon product, Default beacon logo should be displayed', (tester) async {
      await tester.pumpWidget(
        FinancialProductSupplierIcon(
          product: FinancialProductModel(isBeaconProduct: true),
        ),
      );
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('In case of non Beacon product, Default logo should not be displayed', (WidgetTester tester) async {
      await tester.pumpWidget(
        FinancialProductSupplierIcon(
          product: FinancialProductModel(),
        ),
      );
      expect(find.byType(SizedBox), findsOneWidget);
    });
  });
}