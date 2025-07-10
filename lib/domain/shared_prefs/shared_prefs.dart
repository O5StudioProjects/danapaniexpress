import 'dart:convert';

import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/packages_import.dart';

import '../../core/data_model_imports.dart';

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
    return prefs.getString(LANGUAGE_SCREEN) ?? FIRST_TIME_SCREEN_NOT_OPENED;
  }

  static setStartupScreenPrefs(String value) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(STARTUP_SCREEN);
    await prefs.setString(STARTUP_SCREEN, value);
  }

  static Future<String> getStartupScreenPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    return prefs.getString(STARTUP_SCREEN) ?? FIRST_TIME_SCREEN_NOT_OPENED;
  }


  /// AUTH METHODS
  static saveUser(String userId, String authToken) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(AUTH_TOKEN);
    prefs.remove(USER_ID);

    await prefs.setString(AUTH_TOKEN, authToken);
    await prefs.setString(USER_ID, userId);
  }

  // static Future<String?> loadUser() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.reload();
  //   return prefs.getString(USER_ID);
  //   return prefs.getString(USER_ID);
  // }

  static Future<void> clearUserSessions() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(USER_ID);
    await prefs.remove(AUTH_TOKEN);
  }


  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(IS_LOGGED_IN_KEY);
  }


}