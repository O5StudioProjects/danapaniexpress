import 'package:shared_preferences/shared_preferences.dart';
import '../../core/consts.dart';
import '../../resources/common_resources_strings/common_strings.dart';

class SharedPrefs {
  static setLanguage(String value) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(LANGUAGE_TYPE);
    await prefs.setString(LANGUAGE_TYPE, value);
  }

  static Future<String> getLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    return prefs.getString(LANGUAGE_TYPE) ?? ENGLISH_LANGUAGE;
  }

  static setDarkTheme(bool value) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(THEME_VALUE);
    await prefs.setBool(THEME_VALUE, value);
  }

  static Future<bool> getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    return prefs.getBool(THEME_VALUE) ?? false;
  }


  // static setAvatar(bool value) async{
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.remove(AVATAR_ACTIVE);
  //   await prefs.setBool(AVATAR_ACTIVE, value);
  // }
  //
  // static Future<bool> getAvatar() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.reload();
  //   return prefs.getBool(AVATAR_ACTIVE) ?? true;
  // }

  // static setTextAlignment(String value) async{
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.remove(ALIGN);
  //   await prefs.setString(ALIGN, value);
  // }
  //
  // static Future<String> getTextAlignment() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.reload();
  //   return prefs.getString(ALIGN) ?? CENTER_ALIGN;
  // }
  //
  // static setTextSize(double value) async{
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.remove(FONT_SIZE);
  //   await prefs.setDouble(FONT_SIZE, value);
  // }
  //
  // static Future<double> getTextSize() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.reload();
  //   return prefs.getDouble(FONT_SIZE) ?? SMALL_TEXT_FONT_SIZE;
  // }

  // static setSubscription(bool value) async{
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.remove(SUBSCRIPTION);
  //   await prefs.setBool(SUBSCRIPTION, value);
  // }
  //
  // static Future<bool> getSubscription() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.reload();
  //   return prefs.getBool(SUBSCRIPTION) ?? false;
  // }

  static setLanguageScreen(String value) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(LANGUAGE_SCREEN);
    await prefs.setString(LANGUAGE_SCREEN, value);
  }

  static Future<String> getLanguageScreen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    return prefs.getString(LANGUAGE_SCREEN) ?? LANGUAGE_SCREEN_NOT_OPENED;
  }

}