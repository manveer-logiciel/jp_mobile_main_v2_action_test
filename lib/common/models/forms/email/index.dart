import 'package:jobprogress/common/models/email.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class EmailFormData {
  JPInputBoxController emailController = JPInputBoxController();

  EmailFormData({
    String val = "",
  }) {
    emailController.text = val.trim();
  }

  EmailModel toEmailModel() {
    return EmailModel(
      email: emailController.text,
    );
  }

}
