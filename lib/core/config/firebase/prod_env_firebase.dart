
import 'package:firebase_core/firebase_core.dart';

class FirebaseProdEnv {

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
      apiKey: "AIzaSyARoA_dkQrkasOdutr6iCsaNXeJfOvKlFA",
      authDomain: "jobprogress-live.firebaseio.com",
      databaseURL: "https://jobprogress-live.firebaseio.com",
      projectId: "jobprogress-live",
      storageBucket: "jobprogress-live.appspot.com",
      messagingSenderId: "57368839138",
      appId: "1:57368839138:android:a89af7a05ec2d38d852fbb",
      androidClientId: '57368839138-2fnkcj3secsv3a4veai2k11cn20srif4.apps.googleusercontent.com'
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
    apiKey: 'AIzaSyBi5zDb6oTVFdl5ZH2KwVBnrxWsnM6_cUI',
    appId: '1:57368839138:ios:538a5505b5eeeb6a852fbb',
    messagingSenderId: '57368839138',
    projectId: 'jobprogress-live',
    databaseURL: 'https://jobprogress-live.firebaseio.com',
    storageBucket: 'jobprogress-live.appspot.com',
    iosBundleId: 'com.job.progressapp',
    iosClientId: '57368839138-2fnkcj3secsv3a4veai2k11cn20srif4.apps.googleusercontent.com'
  );

}