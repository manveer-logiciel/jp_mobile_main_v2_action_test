import 'package:jobprogress/common/providers/http/interceptor.dart';
import 'package:jobprogress/common/services/cookies.dart';
import 'package:jobprogress/core/constants/urls.dart';

class CookiesRepository {
  static Future<void> getCookies() async {
    await dio.get(Urls.setCookie).then((res) {
      String allCookies = res.headers["jp-cookie"].toString();
      //Setting cookies in service to use it as a shared vairable
      CookiesService.setAndModifyCloudFrontCookies(allCookies);
    });
  }
}
