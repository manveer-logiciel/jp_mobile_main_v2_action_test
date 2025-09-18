import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/enums/jpchip_type.dart';
import 'package:jobprogress/common/extensions/color/index.dart';
import 'package:jobprogress/common/models/sql/flag/flag.dart';
import 'package:jobprogress/core/constants/widget_keys.dart';
import 'package:jobprogress/global_widgets/chip_with_avatar/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

void main() {
  testWidgets('JPChipWithAvatar@JPAvatar should render with correct color', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Material(
          child: JPChipWithAvatar(
            jpChipType: JPChipType.flags,
            flagList: [
              FlagModel(title: 'Flag 1', actualColor:  Colors.red, id: 1, reserved: true, type: '',color: JPAppTheme.themeColors.primary.toHex()),
              FlagModel(title: 'Flag 2',actualColor: Colors.blue, id: 2, reserved: true, type: '',),
            ],
          ),
        ),
      ),
    );

    expect(find.byKey(const ValueKey(WidgetKeys.chipWithAvatarKey)), findsOneWidget);
    
    final avatar1 = tester.widget<JPAvatar>(find.byKey(const ValueKey('${WidgetKeys.chipWithAvatarKey}[0]')));
    expect(avatar1.backgroundColor, equals(JPAppTheme.themeColors.primary));

    final avatar2 = tester.widget<JPAvatar>(find.byKey(const ValueKey('${WidgetKeys.chipWithAvatarKey}[1]')));
    expect(avatar2.backgroundColor, equals(JPAppTheme.themeColors.darkGray));
  });
}