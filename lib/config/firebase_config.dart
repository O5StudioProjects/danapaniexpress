import '../data/enums/enums.dart';

abstract class FirebaseConfig {
  static late String webApiKey;
  static late String androidApiKey;
  static late String iosApiKey;

  static late String webAppId;
  static late String androidAppId;
  static late String iosAppId;

  static late String messagingSenderId;
  static late String projectId;
  static late String authDomain;
  static late String storageBucket;
  static late String measurementId;
  static late String iosBundleId;

  static late Flavor _environment;

  static Flavor get environment => _environment;

  static setUpFirebaseStrings(Flavor environment) {
    _environment = environment;
    switch (environment) {
      case Flavor.dev:

        webApiKey = 'AIzaSyBzRLvlDDUw6a43QzevZ7C2DBNKTe_5nr0';
        androidApiKey = 'AIzaSyAAgS10cyaoayfMIISjSJf6H_igwQxc6Ys';
        iosApiKey = 'AIzaSyCu0Q1Ne3d87SNF3N1PJAH9girGNggo0gg';

        webAppId = '1:923621930500:web:7110c9fed599a1858da751';
        androidAppId = '1:923621930500:android:8a83a0ff63e8b4088da751';
        iosAppId = '1:923621930500:ios:bf1931d3e71686038da751';

        messagingSenderId = '923621930500';
        projectId = 'developpoetryenv';
        authDomain = 'developpoetryenv.firebaseapp.com';
        storageBucket = 'developpoetryenv.appspot.com';
        measurementId = 'G-ENV0K6FC1T';
        iosBundleId = 'com.o5studio.poetry.main.poetryProjectMain';
        break;

      case Flavor.prod:
        webApiKey = 'AIzaSyAhx_meZ6uCcj3rhjdk_v8Q14jhzRkrEs8';
        androidApiKey = 'AIzaSyC28NwAdaVSTDGn7hct1xFWw18jginEupk';
        iosApiKey = 'AIzaSyDWSYZgGBuPY55PMimqaUJQy6-sENiMl0A';

        webAppId = '1:49323930888:web:421ea63b3ea79ae59ce8bd';
        androidAppId = '1:49323930888:android:55724bf3014ba8e09ce8bd';
        iosAppId = '1:49323930888:ios:a75e482fbd30704a9ce8bd';

        messagingSenderId = '49323930888';
        projectId = 'zainshakeelpoetryflutterenv';
        authDomain = 'zainshakeelpoetryflutterenv.firebaseapp.com';
        storageBucket = 'zainshakeelpoetryflutterenv.appspot.com';
        measurementId = 'G-8874YPJ5SB';
        iosBundleId = 'com.o5studio.poetry.main.poetryProjectMain';

        break;

      case Flavor.rider:
        webApiKey = 'AIzaSyAhx_meZ6uCcj3rhjdk_v8Q14jhzRkrEs8';
        androidApiKey = 'AIzaSyC28NwAdaVSTDGn7hct1xFWw18jginEupk';
        iosApiKey = 'AIzaSyDWSYZgGBuPY55PMimqaUJQy6-sENiMl0A';

        webAppId = '1:49323930888:web:5e3893b7f31c213c9ce8bd';
        androidAppId = '1:49323930888:android:98d39cd5095c746c9ce8bd';
        iosAppId = '1:49323930888:ios:6c46ecb2e41bb5f19ce8bd';

        messagingSenderId = '49323930888';
        projectId = 'zainshakeelpoetryflutterenv';
        authDomain = 'zainshakeelpoetryflutterenv.firebaseapp.com';
        storageBucket = 'zainshakeelpoetryflutterenv.appspot.com';
        measurementId = 'G-1PYKPX9HBY';
        iosBundleId = 'com.o5appstudio.zainshakeelbookspremium';

        break;

      }
  }
}
