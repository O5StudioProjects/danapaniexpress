import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/data_model_imports.dart';


String? getMultiLanguageValue({
  required String language,
  required Map<String, String?> textMap,
  required Map<String, bool> availabilityMap,
}) {
  // Fallback order for each language
  final Map<String, List<String>> fallbackOrder = {
    URDU_LANGUAGE: [URDU_LANGUAGE, ENGLISH_LANGUAGE, ARABIC_LANGUAGE],
    ENGLISH_LANGUAGE: [ENGLISH_LANGUAGE, URDU_LANGUAGE, ARABIC_LANGUAGE],
    ARABIC_LANGUAGE: [ARABIC_LANGUAGE, ENGLISH_LANGUAGE, URDU_LANGUAGE],
  };

  // Loop through preferred fallback order
  for (var lang in fallbackOrder[language] ?? []) {
    if (availabilityMap[lang] == true) {
      return textMap[lang];
    }
  }

  return null;
}


String setMultiLanguageText({
  required String language,
  String? urdu,
  String? arabic,
  String? english,
}) {
  return getMultiLanguageValue(
    language: language,
    textMap: {
      URDU_LANGUAGE: urdu,
      ARABIC_LANGUAGE: arabic,
      ENGLISH_LANGUAGE: english,
    },
    availabilityMap: {
      URDU_LANGUAGE: urdu?.isNotEmpty ?? false,
      ARABIC_LANGUAGE: arabic?.isNotEmpty ?? false,
      ENGLISH_LANGUAGE: english?.isNotEmpty ?? false,
    },
  ) ??
      '';
}


String? setFontDynamicDataMarquee({
  required String language,
  MarqueeModel? data,
  String? urdu,
  String? arabic,
  String? english,
}) {
  if (data == null) return null;

  return getMultiLanguageValue(
    language: language,
    textMap: {
      URDU_LANGUAGE: urdu,
      ARABIC_LANGUAGE: arabic,
      ENGLISH_LANGUAGE: english,
    },
    availabilityMap: {
      URDU_LANGUAGE: data.marqueeTitleUrdu.isNotEmpty && data.marqueeDetailUrdu.isNotEmpty,
      ARABIC_LANGUAGE: data.marqueeTitleArabic.isNotEmpty && data.marqueeDetailArabic.isNotEmpty,
      ENGLISH_LANGUAGE: data.marqueeTitleEnglish.isNotEmpty && data.marqueeDetailEnglish.isNotEmpty,
    },
  );
}



int calculateDiscount(double cutPrice, double sellingPrice) {
  if (cutPrice == 0) return 0;
  return ((cutPrice - sellingPrice) / cutPrice * 100).round();
}