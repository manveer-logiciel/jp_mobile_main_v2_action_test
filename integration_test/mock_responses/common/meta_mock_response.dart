class MetaMockResponse {

  static const Map<String,dynamic> value = {
    "pagination":{
      "total":20,
      "count":1,
      "per_page":10,
      "current_page":1,
      "total_pages":1,
    }
  };

  static Map<String,dynamic> valueWithCount(int total) => {
    "pagination":{
      "total":total,
      "count":1,
      "per_page":10,
      "current_page":1,
      "total_pages":1,
    }
  };
}