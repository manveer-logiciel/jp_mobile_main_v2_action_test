import 'package:get/get.dart';
import 'package:jobprogress/common/models/quick_book_sync_error.dart';
import 'package:jobprogress/common/repositories/quick_book_sync_error.dart';

class QuickBookSyncErrorController extends GetxController {
  final String entity;
  final String entityId;

  bool isLoading = true;
  bool isSolutionExpanded = false;
  QuickBookSyncErrorController({required this.entity, required this.entityId});

  QuickBookSyncErrorModel? quickBookSyncError;
  double height = 1.0;

  Future<void> fetchQuickbookError(String entity, String id)async {
    try {    
      
      final quickBookErrorPram = <String, dynamic>{
        'entity': entity,
        'entity_id': entityId
      };

      quickBookSyncError = await QuickBookErrorRepository.fetchQuickBookError(quickBookErrorPram);

    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      update();
    }
 }

 void isSolutionExpandedChange(){
    isSolutionExpanded = !isSolutionExpanded;
    update();
 }


  void callBackForHeight(double neweHight){
    height = neweHight;
    update();
  }

  @override
  void onInit() {
    fetchQuickbookError(entity, entityId);
    super.onInit();
  }
  
}
