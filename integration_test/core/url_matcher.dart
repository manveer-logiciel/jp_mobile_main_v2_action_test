import 'package:dio/src/options.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

class JPHttpUrlMatcher extends HttpRequestMatcher{
  /// [isFullMatch] control whether the entire URL signature should be matched
  bool isFullMatch;

  JPHttpUrlMatcher({this.isFullMatch = false});

  set setIsFullMatch(bool value) {
    isFullMatch = value;
  }

  @override
  bool matches(RequestOptions ongoingRequest, Request matcher) {
    if(isFullMatch) {
      final routeMatched = ongoingRequest.doesRouteMatch(ongoingRequest.path, matcher.route);
      final queryParametersMatched = ongoingRequest.matches(ongoingRequest.queryParameters, matcher.queryParameters ?? {});
      return routeMatched && queryParametersMatched;
    } else {
      return ongoingRequest.doesRouteMatch(ongoingRequest.path, matcher.route);
    }
  }

}