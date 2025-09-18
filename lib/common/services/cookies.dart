import 'package:jobprogress/common/services/run_mode/index.dart';
import 'package:jobprogress/core/constants/regex_expression.dart';
import 'package:jobprogress/core/constants/shared_pref_constants.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/common/repositories/cookies.dart';
import 'package:jobprogress/modules/dev_console/cache_management/controller.dart';
import '../providers/http/interceptor.dart';

class CookiesService {
  static Map<String, String> savedCookies = {"Cookie": ""};
  static int? lastCookieRefreshTime;
  static int? cookieExpirationTime;

  // Setting cloud front cookies in a shared static variable
  static void setAndModifyCloudFrontCookies(String allCookies) {
    String cookieForSave = '';

    allCookies.replaceAll(" ", "").split(",").forEach((obj) {
      List<String> objList = obj.split(";");
      cookieForSave = '$cookieForSave${objList[0].split("=")[0]}=${objList[0].split("=")[1]}; ';
    });

    // Don't use substring if string is too short, and adjust indices to preserve the first character
    if (cookieForSave.length > 2) {
      cookieForSave = cookieForSave.substring(1, cookieForSave.length - 2);
    }

    savedCookies = {"Cookie": cookieForSave};
    setCookieTimings(allCookies);
  }

  static void setCookieTimings(String allCookies) {
    try {
      // Store the current time when cookies were refreshed
      lastCookieRefreshTime = DateTime.now().millisecondsSinceEpoch;

      // Extract expiration time from cookies
      extractExpirationTime(allCookies);

      // Save timestamp to SharedPreferences for app restarts
      saveCookieRefreshTime();
      saveCookieExpirationTime();
    } catch (e) {
      Helper.recordError(e);
    }
  }

  // Extract expiration time from cookie string
  static void extractExpirationTime(String allCookies) {
    final expirationRegex = RegExp(RegexExpression.cookieExpirationTime);
    final match = expirationRegex.firstMatch(allCookies);

    if (match != null && match.groupCount >= 1) {
      final extractedValue = match.group(1) ?? '0';
      cookieExpirationTime = int.tryParse(extractedValue);
    }
  }

  // Calculate the point at which we should refresh cookies (50% of total lifetime)
  static int calculateRefreshPoint() {
    if (lastCookieRefreshTime == null || cookieExpirationTime == null) {
      throw Exception('Cannot calculate refresh point without refresh and expiration times');
    }

    // CloudFront expiration time is in seconds since epoch, convert to milliseconds
    final expirationTimeMs = cookieExpirationTime! * 1000;

    // Total lifetime from when the cookie was issued until expiration
    final totalLifetime = expirationTimeMs - lastCookieRefreshTime!;

    // Calculate the halfway point between issue and expiration
    return lastCookieRefreshTime! + (totalLifetime * 0.5).round();
  }

  // Save the cookie refresh timestamp to persistent storage
  static Future<void> saveCookieRefreshTime() async {
    await preferences.save(PrefConstants.cookieRefreshTime, lastCookieRefreshTime);
  }

  // Save the cookie expiration timestamp to persistent storage
  static Future<void> saveCookieExpirationTime() async {
    await preferences.save(PrefConstants.cookieExpirationTime, cookieExpirationTime);
  }

  // Load the cookie refresh timestamp from persistent storage
  static Future<void> loadCookieRefreshTime() async {
    lastCookieRefreshTime = await preferences.read(PrefConstants.cookieRefreshTime);
    cookieExpirationTime = await preferences.read(PrefConstants.cookieExpirationTime);
  }

  // Check if cookies need refreshing (at 50% of time until expiration)
  static bool needsRefresh() {
    if (lastCookieRefreshTime == null || cookieExpirationTime == null) {
      return true;
    }

    final currentTime = DateTime.now().millisecondsSinceEpoch;
    final refreshPoint = calculateRefreshPoint();

    // If current time is past the refresh point, we need to refresh
    final needsRefresh = currentTime >= refreshPoint;


    return needsRefresh;
  }

  // Check if cookies exist
  static bool cookiesExist() {
    return savedCookies["Cookie"]?.isNotEmpty ?? false;
  }

  // Comprehensive function to check cookie status and refresh if needed
  static Future<void> validateAndRefreshCookiesIfNeeded() async {
    // No need to check cookie validation in unit tests
    if (RunModeService.isUnitTestMode) return;
    try {
      // First load the refresh time if not already loaded
      if (lastCookieRefreshTime == null) {
        await loadCookieRefreshTime();
      }

      // Check if cookies exist at all
      bool hasCookies = cookiesExist();

      // Check if refresh timestamp exists
      bool hasRefreshTimestamp = lastCookieRefreshTime != null;
      
      // Check if expiration timestamp exists
      bool hasExpirationTimestamp = cookieExpirationTime != null;

      // Check if refresh is needed based on age
      bool needsRefreshing = needsRefresh();

      // If any condition requires a refresh, perform it
      bool doRefreshCookie = !hasCookies || !hasRefreshTimestamp || !hasExpirationTimestamp || needsRefreshing;
      if (doRefreshCookie) {
        // Import here to avoid circular dependency
        // We need to use dynamic import since CookiesRepository depends on CookiesService
        try {
          // Using dynamic import to avoid circular dependency
          await CookiesRepository.getCookies();

          // Clear cache and uploads when cookies are renewed
          CacheManagementController.clearCacheAndUploadsOnCookieRenewal();
        } catch (e) {
          Helper.recordError(e);
        }
      }
    } catch (e) {
      Helper.recordError(e);
    }
  }

  static void clearCookies() {
    savedCookies = {"Cookie": ""};
    lastCookieRefreshTime = null;
    cookieExpirationTime = null;
  }
}
