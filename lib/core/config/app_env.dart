
import 'package:jobprogress/core/config/dev_env.dart';
import 'package:jobprogress/core/config/prod_env.dart';
import 'package:jobprogress/core/config/qa_env.dart';
import 'package:jobprogress/core/config/qa_rc_env.dart';
import 'package:jobprogress/core/config/staging_env.dart';

enum Environment { dev, qa, qaRc, staging, prod }

class AppEnv {
  static Map<String, dynamic> envConfig = DevEnv.config;
  static Environment currentEnv = Environment.dev;

  static void setEnvironment(Environment env) {
    currentEnv = env;
    switch (env) {
      case Environment.dev:
        envConfig = DevEnv.config;
        break;
      case Environment.qa:
        envConfig = QaEnv.config;
        break;
      case Environment.qaRc:
        envConfig = QaRcEnv.config;
        break;
      case Environment.staging:
        envConfig = StagingEnv.config;
        break;
      case Environment.prod:
        envConfig = ProdEnv.config;
        break;
    }
  }

  static get config {
    return envConfig;
  }

}