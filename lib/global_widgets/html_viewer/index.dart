import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:jobprogress/core/utils/helpers.dart';

class JPHtmlViewer extends StatelessWidget {

  const JPHtmlViewer({
    super.key, 
    required this.htmlContent, 
  });

  final String htmlContent;

  @override
  Widget build(BuildContext context) {
    return HtmlWidget(
      htmlContent,
      onTapUrl: (url) {
        Helper.launchUrl(url);
        return true;
      },
    );
  }
}
