import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:jobprogress/core/constants/regex_expression.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

/// [JPLinkText] is a widget that converts URLs within a given text into clickable links.
///
/// The widget looks for patterns where a URL is enclosed within parentheses
/// following some text. It replaces the URL with the text before the parentheses
/// and makes it clickable.
class JPLinkText extends StatelessWidget {

  const JPLinkText({
    super.key,
    required this.text,
    this.textColor,
    this.height,
    this.textSize = JPTextSize.heading4,
    this.linkColor = JPColor.themeBlue,
    this.replaceTextWithUrl = true,
  });

  /// [text] is the input text to be processed
  final String text;

  /// [textColor] is the color of the text to be displayed
  final Color? textColor;

  /// [height] is the height of the text to be displayed
  final double? height;

  /// [linkColor] is the color of the links to be displayed
  final Color linkColor;

  /// [textSize] is the size of the text to be displayed
  final JPTextSize textSize;

  final bool replaceTextWithUrl;

  @override
  Widget build(BuildContext context) {
    return JPRichText(
      text: TextSpan(
        children: getSpans(),
      ),
    );
  }

 List<TextSpan> getSpans() {
  // Regular expression to find patterns of the form 'text(url)'
  final RegExp linkRegExp = 
  RegExp( caseSensitive: false,replaceTextWithUrl ? 
    RegexExpression.textLinkExtractor : 
    RegexExpression.urlExtractor,
  );

   // List to hold TextSpan objects for building the RichText widget
   final List<TextSpan> textSpans = [];
   int start = 0;

   // Iterate over all matches of the regular expression in the input text
   for (final RegExpMatch match in linkRegExp.allMatches(text)) {
     // Add any non-matching text before the current match as a normal text span
     if (match.start > start) {
       textSpans.add(JPTextSpan.getSpan(
         text.substring(start, match.start),
         textColor: textColor,
         textSize: textSize,
         height: height
       ));
     }
    // Extract the display text and the URL from the match
    final String linkText = replaceTextWithUrl ? match.group(1)! : match.group(0)!;
    final String url = replaceTextWithUrl ? match.group(2)! : linkText;
     // Add the display text as a clickable text span
     textSpans.add(JPTextSpan.getSpan(
       linkText,
       textColor: linkColor,
       textSize: textSize,
       height: height,
       textDecoration: TextDecoration.underline,
       recognizer: TapGestureRecognizer()
         ..onTap = () async {
           Helper.launchUrl(url);
         },
     ));

     // Update the start position for the next iteration
     start = match.end;
   }

   // Add any remaining text after the last match as a normal text span
   if (start < text.length) {
     textSpans.add(JPTextSpan.getSpan(
       text.substring(start),
       textColor: textColor,
       textSize: textSize,
       height: height,
     ));
   }

    return textSpans;
  }
}