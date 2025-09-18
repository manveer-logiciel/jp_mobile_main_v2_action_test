import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/global_widgets/link_text/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../../integration_test/core/test_helper.dart';

void main() {

  String tempText = 'This is example text';
  String tempURL = "https://example.com";
  bool replaceTextWithUrl = true;

  Widget getBaseWidget() {
    return TestHelper.buildWidget(
      JPLinkText(
        text: tempText,
        replaceTextWithUrl: replaceTextWithUrl,
      )
    );
  }

  testWidgets('JPLinkText should be rendered', (WidgetTester tester) async {
    await tester.pumpWidget(getBaseWidget());
    expect(find.byType(JPLinkText), findsOneWidget);
    expect(find.byType(JPRichText), findsOneWidget);
  });

  testWidgets('JPLinkText should be rendered without replacing text with url', 
  (WidgetTester tester) async {
    replaceTextWithUrl = false;
    await tester.pumpWidget(getBaseWidget());
    expect(find.byType(JPLinkText), findsOneWidget);
    expect(find.byType(JPRichText), findsOneWidget);
  });

  group("JPLinkText@getSpans() should extract links and replace with text", () {
    setUpAll(() =>  replaceTextWithUrl = true);
    testWidgets("In case of plain text", (tester) async {
      await tester.pumpWidget(getBaseWidget());
      List<TextSpan> spans = tester.widget<JPLinkText>(find.byType(JPLinkText)).getSpans();

      expect(spans.length, 1);
      expect(spans[0].text, tempText);
    });

    group("In case of single URL", () {
      setUp(() {
        tempText = 'This is example text($tempURL)';
      });

      testWidgets("Text spans should be generated properly", (tester) async {
        await tester.pumpWidget(getBaseWidget());
        List<TextSpan> spans = tester.widget<JPLinkText>(find.byType(JPLinkText)).getSpans();

        expect(spans.length, 2);
        expect(spans[0].text, 'This is example ');
        expect(spans[0].style?.color, JPAppTheme.themeColors.text);
        expect(spans[0].style?.fontSize, 14);
        expect(spans[1].text, 'text');
        expect(spans[1].style?.color, JPAppTheme.themeColors.themeBlue);
        expect(spans[1].style?.fontSize, 14);
      });

      testWidgets("URL should not be there in rendered text", (tester) async {
        await tester.pumpWidget(getBaseWidget());
        expect(find.text(tempURL), findsNothing);
      });
    });

    group("In case of multiple URLs", () {
      setUp(() {
        tempText = 'This is example text($tempURL) text2($tempURL)';
      });

      testWidgets("Text spans should be generated properly", (tester) async {
        await tester.pumpWidget(getBaseWidget());
        List<TextSpan> spans = tester.widget<JPLinkText>(find.byType(JPLinkText)).getSpans();

        expect(spans.length, 4);
        expect(spans[0].text, 'This is example ');
        expect(spans[0].style?.color, JPAppTheme.themeColors.text);
        expect(spans[0].style?.fontSize, 14);
        expect(spans[1].text, 'text');
        expect(spans[1].style?.color, JPAppTheme.themeColors.themeBlue);
        expect(spans[1].style?.fontSize, 14);
        expect(spans[2].text, ' ');
        expect(spans[2].style?.color, JPAppTheme.themeColors.text);
        expect(spans[2].style?.fontSize, 14);
        expect(spans[3].text, 'text2');
        expect(spans[3].style?.color, JPAppTheme.themeColors.themeBlue);
        expect(spans[3].style?.fontSize, 14);
      });

      testWidgets("URL should not be there in rendered text", (tester) async {
        await tester.pumpWidget(getBaseWidget());
        expect(find.text(tempURL), findsNothing);
      });
    });

    group("In case of invalid URL", () {
      setUp(() {
        tempText = 'This is example text(hello)';
      });

      testWidgets("Text spans should be generated properly", (tester) async {
        await tester.pumpWidget(getBaseWidget());
        List<TextSpan> spans = tester.widget<JPLinkText>(find.byType(JPLinkText)).getSpans();

        expect(spans.length, 1);
        expect(spans[0].text, 'This is example text(hello)');
        expect(spans[0].style?.color, JPAppTheme.themeColors.text);
        expect(spans[0].style?.fontSize, 14);
      });
    });
  });

  group("JPLinkText@getSpans() should extract links and highlight and clickable link text in case of replaceTextWithUrl is false", () { 
    setUpAll(() => replaceTextWithUrl = false);
    testWidgets("In case of plain text", (tester) async {
      await tester.pumpWidget(getBaseWidget());
      List<TextSpan> spans = tester.widget<JPLinkText>(find.byType(JPLinkText)).getSpans();

      expect(spans.length, 1);
      expect(spans[0].text, tempText);
    });

    testWidgets("When single URL Text spans should be generated properly", (tester) async {
      tempText = 'This is example text $tempURL';
      await tester.pumpWidget(getBaseWidget());
      List<TextSpan> spans = tester.widget<JPLinkText>(find.byType(JPLinkText)).getSpans();

      expect(spans.length, 2);
      expect(spans[0].text, 'This is example text ');
      expect(spans[0].style?.color, JPAppTheme.themeColors.text);
      expect(spans[0].style?.fontSize, 14);
      expect(spans[1].text, 'https://example.com');
      expect(spans[1].style?.color, JPAppTheme.themeColors.themeBlue);
      expect(spans[1].style?.fontSize, 14);
    });

    testWidgets("When multiple URL in text, Text spans should be generated properly", (tester) async {
      tempText = 'This is example text $tempURL  text2 $tempURL';
      await tester.pumpWidget(getBaseWidget());
      List<TextSpan> spans = tester.widget<JPLinkText>(find.byType(JPLinkText)).getSpans();

      expect(spans.length, 4);
      expect(spans[0].text, 'This is example text ');
      expect(spans[0].style?.color, JPAppTheme.themeColors.text);
      expect(spans[0].style?.fontSize, 14);
      expect(spans[1].text, 'https://example.com');
      expect(spans[1].style?.color, JPAppTheme.themeColors.themeBlue);
      expect(spans[1].style?.fontSize, 14);
      expect(spans[2].text, '  text2 ' );
      expect(spans[2].style?.color, JPAppTheme.themeColors.text);
      expect(spans[2].style?.fontSize, 14);
      expect(spans[3].text, 'https://example.com');
      expect(spans[3].style?.color, JPAppTheme.themeColors.themeBlue);
      expect(spans[3].style?.fontSize, 14);
    });
  });

}