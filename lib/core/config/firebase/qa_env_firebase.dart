
import 'package:firebase_core/firebase_core.dart';

class FirebaseQAEnv {

  static const FirebaseOptions androidDefault = FirebaseOptions(
    apiKey: 'AIzaSyBEk6AXaOKr40qrE6VlGaVZjaRe3C1vmrA',
    appId: '1:542191645602:android:a433359a4f794492',
    messagingSenderId: '542191645602',
    projectId: 'crack-talent-99905',
    androidClientId: '542191645602-c3cdogsbmgp4hun2p0vdj2r1nfjl1hhq.apps.googleusercontent.com',
    databaseURL:
    'https://crack-talent-99905.firebaseio.com',
    storageBucket: 'crack-talent-99905.appspot.com',
  );

  static const FirebaseOptions androidData = FirebaseOptions(
    apiKey: 'AIzaSyBkOQJmK1e8D9Gxt86siYTJrxkObcF0zek',
    appId: '1:836405255524:android:bb35daeee29735083a6e71',
    messagingSenderId: '836405255524',
    projectId: 'jp-qa-c72e0',
    androidClientId: '836405255524-e79kir0m8ets72tf382q9v510q43hifq.apps.googleusercontent.com',
    databaseURL: 'https://jp-qa-c72e0.firebaseio.com',
    storageBucket: 'jp-qa-c72e0.appspot.com',
  );

  static const FirebaseOptions iosDefault = FirebaseOptions(
    apiKey: 'AIzaSyC3zy7UT_pvgHpE8-mEICIH3N151DNbLhM',
    appId: '1:542191645602:ios:f61402433f39c13494b8fb',
    messagingSenderId: '542191645602',
    projectId: 'crack-talent-99905',
    databaseURL: 'https://crack-talent-99905.firebaseio.com',
    storageBucket: 'crack-talent-99905.appspot.com',
    iosClientId: '542191645602-igs9d6ni1t2t8ip4mb0tvi020hpp6lri.apps.googleusercontent.com',
    iosBundleId: 'com.job.progressapp',
  );

  static const FirebaseOptions iosData = FirebaseOptions(
    apiKey: 'AIzaSyBcrRuXfwSiOBMZD0WagvKuoTuJSYAR49I',
    appId: '1:836405255524:ios:9c7db3ead3c0920a3a6e71',
    messagingSenderId: '836405255524',
    projectId: 'jp-qa-c72e0',
    databaseURL: 'https://jp-qa-c72e0.firebaseio.com',
    iosClientId: '836405255524-e79kir0m8ets72tf382q9v510q43hifq.apps.googleusercontent.com',
    iosBundleId: 'com.job.progressapp',
  );

}