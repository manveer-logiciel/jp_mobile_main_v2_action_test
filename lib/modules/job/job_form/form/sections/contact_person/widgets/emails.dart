
import 'package:flutter/material.dart';
import 'package:jobprogress/common/models/email.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class JobFormContactPersonEmails extends StatelessWidget {

  const JobFormContactPersonEmails({
    super.key,
    this.emails
  });

  final List<EmailModel>? emails;

  @override
  Widget build(BuildContext context) {

    if (emails == null) return const SizedBox();

    return ListView.separated(
        shrinkWrap: true,
        primary: false,
        itemBuilder: (_, index) {
          return JPText(
            text: emails![index].email,
            textAlign: TextAlign.start,
          );
        },
        separatorBuilder: (_, index) {
          return const SizedBox(
            height: 10,
          );
        },
        itemCount: emails!.length,
    );

  }
}
