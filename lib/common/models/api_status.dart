import 'package:jobprogress/common/enums/api_status.dart';

/// [ApiStatusModel] holds the api status along with [reCall] to be made
/// when an api is to be reloaded. This class can be extended as per required.
class ApiStatusModel {
  /// [status] holds the api status default status is going to be [ApiStatus.pending]
  ApiStatus status;
  /// [reCall] helps in reloading the api
  Future<dynamic> Function() reCall;

  ApiStatusModel({
    required this.reCall,
    this.status = ApiStatus.pending,
  });
}