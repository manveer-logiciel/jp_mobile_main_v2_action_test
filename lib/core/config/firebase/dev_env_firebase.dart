
import 'package:firebase_core/firebase_core.dart';

class FirebaseDevEnv {

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
      apiKey: "AIzaSyAs6GBh0ukBoHfUv_iG4-8kdlCwz1z-XMU",
      authDomain: "jp-dev-datamigration.firebaseapp.com",
      databaseURL: "https://jobprogress-dev.firebaseio.com",
      projectId: "jobprogress-dev",
      storageBucket: "jobprogress-dev.appspot.com",
      messagingSenderId: "242538138662",
      androidClientId: '242538138662-6oj2d4pco0rd1cl34bprjq7qmtuugvbl.apps.googleusercontent.com',
      appId: "1:242538138662:android:180d3e30b80471eac22ae7",
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
    apiKey: 'AIzaSyDzb7aSmMCgYZ5dO1NOewL8oZAXNgCazi4',
    appId: '1:242538138662:ios:20149c5da177a464c22ae7',
    messagingSenderId: '242538138662',
    projectId: 'jobprogress-dev',
    databaseURL: 'https://jobprogress-dev.firebaseio.com',
    storageBucket: 'jobprogress-dev.appspot.com',
    iosClientId: '242538138662-6oj2d4pco0rd1cl34bprjq7qmtuugvbl.apps.googleusercontent.com',
    iosBundleId: 'com.job.progressapp',
  );

}