import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBTau1xLLB8K0T_saHLtLGRq9pLtYODAHU',
    appId: '1:1057237013142:web:22f509b4a0dcabce8ea8b7',
    messagingSenderId: '1057237013142',
    projectId: 'test-fa4d6',
    authDomain: 'test-fa4d6.firebaseapp.com',
    storageBucket: 'test-fa4d6.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD7oVhnFgad9a4_UQP__pCc6s5PQkcCSO8',
    appId: '1:1057237013142:android:c84bff814bc1d3a08ea8b7',
    messagingSenderId: '1057237013142',
    projectId: 'test-fa4d6',
    storageBucket: 'test-fa4d6.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAkr3zQ83UHU2_Y4unSu0pl7leKM3Qzv-4',
    appId: '1:1057237013142:ios:616f5cdacf6287638ea8b7',
    messagingSenderId: '1057237013142',
    projectId: 'test-fa4d6',
    storageBucket: 'test-fa4d6.appspot.com',
    iosBundleId: 'com.example.firebaseSetup2',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAkr3zQ83UHU2_Y4unSu0pl7leKM3Qzv-4',
    appId: '1:1057237013142:ios:c2f213231546cfe08ea8b7',
    messagingSenderId: '1057237013142',
    projectId: 'test-fa4d6',
    storageBucket: 'test-fa4d6.appspot.com',
    iosBundleId: 'com.example.firebaseSetup2.RunnerTests',
  );
}
