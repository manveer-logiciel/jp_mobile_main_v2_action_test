import 'package:get/get.dart';
import 'package:jobprogress/translations/en_US/index.dart';
import 'package:jobprogress/translations/es_US/index.dart';

class JPTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': EnUsTranslationStrings.allStrings,
    'es_US': EsUsTranslationStrings.allStrings
  };
}
