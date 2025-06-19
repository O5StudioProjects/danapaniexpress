import 'package:flutter/cupertino.dart';

class GlobalContextService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}
var gContext = GlobalContextService.navigatorKey.currentContext!;
