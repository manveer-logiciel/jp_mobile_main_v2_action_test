import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/models/files_listing/srs/srs_order_detail.dart';
import 'package:jobprogress/modules/supplier_order_details/controller.dart';
import 'package:jp_mobile_flutter_ui/Theme/index.dart';

void main() {
  test('labelColor should return tertiary color with opacity 0.7 when srsOrder inProgress value is true', () {
    final controller = SupplierOrderDetailController();
    controller.srsOrder = SrsOrderModel(inProgress: true);

    final labelColor = controller.labelColor;

    expect(labelColor, JPAppTheme.themeColors.tertiary.withValues(alpha: 0.7));
  });

  test('labelColor should return success color when srsOrder inProgress value is false', () {
    final controller = SupplierOrderDetailController();
    controller.srsOrder = SrsOrderModel(inProgress: false);

    final labelColor = controller.labelColor;

    expect(labelColor, JPAppTheme.themeColors.success);
  });
}
