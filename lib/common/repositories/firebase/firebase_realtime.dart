
import 'package:jobprogress/common/providers/firebase/realtime_db.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/core/constants/firebase/firebase_paths.dart';
import 'package:jobprogress/global_widgets/from_firebase/realtime_streams_list.dart';

class FirebaseRealtimeRepo {

  static FirebasePaths? firebasePaths;

  static void initAllStreams() {

    firebasePaths = FirebasePaths(
      AuthService.userDetails!.companyDetails!.id.toString(),
      AuthService.userDetails!.id.toString(),
    );

    for (var streamData in RealtimeStreams.streamsData(firebasePaths!)) {
      RealtimeDBProvider.createOneStream(streamData: streamData);
    }
  }

  static Future<void> disposeAllStreams() async {
    if(firebasePaths == null) return;

    for (var streamData in RealtimeStreams.streamsData(firebasePaths!)) {
      await RealtimeDBProvider.removeOneStream(keyType: streamData.keyType);
    }
  }

}