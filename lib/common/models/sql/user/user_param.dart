import 'package:jobprogress/core/constants/pagination_constants.dart';

/// this modal is used for requesting data from local db
class UserParamModel {
  int limit;
  int page;
  bool inactive;
  bool withInactive;

  /// [includeAllDivisionUser] will be in action when we are passing division ids
  /// to filter users on division id's.
  /// [true] - users having access to all divisions will be included
  /// [false] - user only having id's listed in [divisionIds] will be included
  bool includeAllDivisionUser;
  bool withSubContractorPrime;
  bool onlySub;
  
  String name;
  List<int>? divisionIds = [];
  List<String>? includes = [];
  
  UserParamModel({
    this.limit = PaginationConstants.pageLimit,
    this.page = 0,
    this.name = '',
    this.inactive = false,
    this.withInactive = false,
    this.withSubContractorPrime = false,
    this.onlySub = false,
    this.divisionIds = const [],
    this.includeAllDivisionUser = true,
    this.includes = const [] // values -  divisions, tags
  });
}