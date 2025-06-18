
import 'package:flutter/material.dart';

import '../config/res_config/colors_config.dart';
import '../resources/res/app_colors.dart';

class Styles {
  static ThemeData themeData(
      bool isDarkTheme, String language, BuildContext context) {
    return ThemeData(
        dividerColor: AppColors.dividerColorSkin(isDarkTheme),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: AppColors.backgroundColorSkin(isDarkTheme),
          selectedItemColor: isDarkTheme
              ? EnvColors.backgroundColorLight
              : EnvColors.backgroundColorDark,
        ),
        scaffoldBackgroundColor:
        AppColors.backgroundColorSkin(isDarkTheme),
        primaryColor: AppColors.backgroundColorSkin(isDarkTheme),
        colorScheme: ThemeData().colorScheme.copyWith(
          secondary: AppColors.backgroundColorSkin(isDarkTheme),
          brightness: isDarkTheme ? Brightness.dark : Brightness.light,
        ),
        cardColor: AppColors.cardColorSkin(isDarkTheme),
        canvasColor: isDarkTheme ? Colors.black : Colors.grey[50],
        buttonTheme: Theme.of(context).buttonTheme.copyWith(
          colorScheme: isDarkTheme
              ? const ColorScheme.dark()
              : const ColorScheme.light(),
        ),
        dialogTheme: DialogThemeData(backgroundColor: AppColors.backgroundColorSkin(isDarkTheme)));
  }
}