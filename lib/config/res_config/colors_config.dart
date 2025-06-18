import 'dart:ui';

import 'package:danapaniexpress/data/enums/enums.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/consts.dart';

abstract class EnvColors {

  static late Color primaryColorDark;
  static late Color primaryColorLight;

  static late Color accentCTAColorDark;
  static late Color accentCTAColorLight;

  static late Color offerHighlightColorDark;
  static late Color offerHighlightColorLight;

  static late Color backgroundColorDark;
  static late Color backgroundColorLight;

  static late Color cardColorDark;
  static late Color cardColorLight;

  static late Color primaryTextColorDark;
  static late Color primaryTextColorLight;

  static late Color secondaryTextColorDark;
  static late Color secondaryTextColorLight;

  static late Color dividerColorDark;
  static late Color dividerColorLight;

  static late Color specialFestiveColorDark;
  static late Color specialFestiveColorLight;


  static late Flavor _environment;
  static Flavor get environment => _environment;


  static setUpAppColors(Flavor environment) async {
    _environment = environment;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(THEME_TYPE, false);
    switch (environment) {
      case Flavor.dev:
        ///Main branding, consistent top navigation | AppBar / Header
        primaryColorDark = const Color(0xff43A047);
        primaryColorLight = const Color(0xff43A047);
        ///FAB / CTA Buttons | Add to Cart, Checkout, Confirm actions
        accentCTAColorDark = const Color(0xffFB8C00);
        accentCTAColorLight = const Color(0xffFB8C00);
        ///Offer / Discount Badges	Yellow	#FDD835	Flash sale, deal of the day, etc.
        offerHighlightColorDark = const Color(0xffFDD835);
        offerHighlightColorLight = const Color(0xffFDD835);
        ///Background	Dark Gray	#121212	Base background for low eye strain
        ///Background	White	#FFFFFF	Screen background for clarity
        backgroundColorDark = const Color(0xff121212);
        backgroundColorLight = const Color(0xffFFFFFF);
        ///Cards / Surfaces	Charcoal	#1E1E1E	Match background with slight contrast
        ///Product Cards / Containers	Light Gray	#F5F5F5	Card backgrounds to differentiate from main white background
        cardColorDark = const Color(0xff1E1E1E);
        cardColorLight = const Color(0xffF5F5F5);
        ///Primary Text	Light Gray	#E0E0E0	High readability in dark mode
        ///Primary Text	Near Black	#212121	Main readable text
        primaryTextColorDark = const Color(0xffE0E0E0);
        primaryTextColorLight = const Color(0xff212121);
        ///Secondary Text	Muted Gray	#BDBDBD	For subtitles, prices, etc.
        ///Secondary Text	Gray	#757575	Labels, captions, less important text
        secondaryTextColorDark = const Color(0xffBDBDBD);
        secondaryTextColorLight = const Color(0xff757575);
        ///Dividers / Borders	Border Gray	#2C2C2C	Section separators
        ///Dividers / Borders	Light Border	#E0E0E0	Separators between sections
        dividerColorDark = const Color(0xff2C2C2C);
        dividerColorLight = const Color(0xffE0E0E0);
        ///Special Festive Elements	Maroon	#8E3200	Eid sales, Ramzan bundles, traditional deals
        specialFestiveColorDark = const Color(0xff8E3200);
        specialFestiveColorLight = const Color(0xff8E3200);

        break;

      case Flavor.prod:
      ///Main branding, consistent top navigation | AppBar / Header
        primaryColorDark = const Color(0xff43A047);
        primaryColorLight = const Color(0xff43A047);
        ///FAB / CTA Buttons | Add to Cart, Checkout, Confirm actions
        accentCTAColorDark = const Color(0xffFB8C00);
        accentCTAColorLight = const Color(0xffFB8C00);
        ///Offer / Discount Badges	Yellow	#FDD835	Flash sale, deal of the day, etc.
        offerHighlightColorDark = const Color(0xffFDD835);
        offerHighlightColorLight = const Color(0xffFDD835);
        ///Background	Dark Gray	#121212	Base background for low eye strain
        ///Background	White	#FFFFFF	Screen background for clarity
        backgroundColorDark = const Color(0xff121212);
        backgroundColorLight = const Color(0xffFFFFFF);
        ///Cards / Surfaces	Charcoal	#1E1E1E	Match background with slight contrast
        ///Product Cards / Containers	Light Gray	#F5F5F5	Card backgrounds to differentiate from main white background
        cardColorDark = const Color(0xff1E1E1E);
        cardColorLight = const Color(0xffF5F5F5);
        ///Primary Text	Light Gray	#E0E0E0	High readability in dark mode
        ///Primary Text	Near Black	#212121	Main readable text
        primaryTextColorDark = const Color(0xffE0E0E0);
        primaryTextColorLight = const Color(0xff212121);
        ///Secondary Text	Muted Gray	#BDBDBD	For subtitles, prices, etc.
        ///Secondary Text	Gray	#757575	Labels, captions, less important text
        secondaryTextColorDark = const Color(0xffBDBDBD);
        secondaryTextColorLight = const Color(0xff757575);
        ///Dividers / Borders	Border Gray	#2C2C2C	Section separators
        ///Dividers / Borders	Light Border	#E0E0E0	Separators between sections
        dividerColorDark = const Color(0xff2C2C2C);
        dividerColorLight = const Color(0xffE0E0E0);
        ///Special Festive Elements	Maroon	#8E3200	Eid sales, Ramzan bundles, traditional deals
        specialFestiveColorDark = const Color(0xff8E3200);
        specialFestiveColorLight = const Color(0xff8E3200);

        break;

      case Flavor.rider:
      ///Main branding, consistent top navigation | AppBar / Header
        primaryColorDark = const Color(0xff43A047);
        primaryColorLight = const Color(0xff43A047);
        ///FAB / CTA Buttons | Add to Cart, Checkout, Confirm actions
        accentCTAColorDark = const Color(0xffFB8C00);
        accentCTAColorLight = const Color(0xffFB8C00);
        ///Offer / Discount Badges	Yellow	#FDD835	Flash sale, deal of the day, etc.
        offerHighlightColorDark = const Color(0xffFDD835);
        offerHighlightColorLight = const Color(0xffFDD835);
        ///Background	Dark Gray	#121212	Base background for low eye strain
        ///Background	White	#FFFFFF	Screen background for clarity
        backgroundColorDark = const Color(0xff121212);
        backgroundColorLight = const Color(0xffFFFFFF);
        ///Cards / Surfaces	Charcoal	#1E1E1E	Match background with slight contrast
        ///Product Cards / Containers	Light Gray	#F5F5F5	Card backgrounds to differentiate from main white background
        cardColorDark = const Color(0xff1E1E1E);
        cardColorLight = const Color(0xffF5F5F5);
        ///Primary Text	Light Gray	#E0E0E0	High readability in dark mode
        ///Primary Text	Near Black	#212121	Main readable text
        primaryTextColorDark = const Color(0xffE0E0E0);
        primaryTextColorLight = const Color(0xff212121);
        ///Secondary Text	Muted Gray	#BDBDBD	For subtitles, prices, etc.
        ///Secondary Text	Gray	#757575	Labels, captions, less important text
        secondaryTextColorDark = const Color(0xffBDBDBD);
        secondaryTextColorLight = const Color(0xff757575);
        ///Dividers / Borders	Border Gray	#2C2C2C	Section separators
        ///Dividers / Borders	Light Border	#E0E0E0	Separators between sections
        dividerColorDark = const Color(0xff2C2C2C);
        dividerColorLight = const Color(0xffE0E0E0);
        ///Special Festive Elements	Maroon	#8E3200	Eid sales, Ramzan bundles, traditional deals
        specialFestiveColorDark = const Color(0xff8E3200);
        specialFestiveColorLight = const Color(0xff8E3200);

        break;

      }
  }
}