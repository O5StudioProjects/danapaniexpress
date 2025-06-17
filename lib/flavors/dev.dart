import 'package:danapaniexpress/data/enums/enums.dart';
import 'package:flutter/cupertino.dart';

import '../config/flavor_config.dart';
import '../entry/common_main.dart';

void main(){
  WidgetsFlutterBinding.ensureInitialized();
  AppConfig.setUpEnv(Flavor.dev);
  commonMain();
}