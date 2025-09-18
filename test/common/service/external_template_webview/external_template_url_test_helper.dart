class ExternalTemplateTestHelper {

  final String baseUrl;
  String path = "";
  String completeUrl = "";
  List<String> pathSegments = [];
  Map<String, dynamic> queryParams = {};

  ExternalTemplateTestHelper(this.baseUrl);

  void splitIntoPieces(String url) {
    completeUrl = url;
    String withoutBaseUrl = url.replaceAll(baseUrl, "");
    path = withoutBaseUrl.split("?").first;
    pathSegments = path.split("/");
    String paramsString = withoutBaseUrl.split("?").last;

    queryParams.clear();
    paramsString.split("&").forEach((element) {
      final key = element.split("=").first;
      final value = element.split("=").last;
      queryParams.putIfAbsent(key, () => value);
    });
  }

  String getJustAfter(String segment) {
    return pathSegments[pathSegments.indexOf(segment) + 1];
  }

}