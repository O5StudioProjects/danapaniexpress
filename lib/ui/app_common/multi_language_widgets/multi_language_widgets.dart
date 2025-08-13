import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/data_model_imports.dart';


/// IN PRODUCTS SCREEN
String subCategoriesRowMultiLangText(SubCategoriesModel subCategory){
  return setMultiLanguageText(language: appLanguage,
      urdu: subCategory.subCategoryNameUrdu.toString(),
      arabic: subCategory.subCategoryNameArabic.toString(),
      english: subCategory.subCategoryNameEnglish.toString()
  );
}

String topBannerProductsMultiLangText(CategoryModel? categoriesData){
  return setMultiLanguageText(language: appLanguage,
    urdu: categoriesData!.categoryNameUrdu.toString(),
    arabic: categoriesData.categoryNameArabic.toString(),
    english: categoriesData.categoryNameEnglish.toString(),
  );
}

/// IN HOME SCREEN AND MARQUEE TEXT

String marqueeTitleMultiLangText(MarqueeModel? data){
  return setMultiLanguageText(language: appLanguage,
    urdu: data!.marqueeTitleUrdu,
    arabic: data.marqueeTitleArabic,
    english: data.marqueeTitleEnglish,
  );
}

String marqueeDetailMultiLangText(MarqueeModel? data){
  return setMultiLanguageText(language: appLanguage,
    urdu: data!.marqueeDetailUrdu,
    arabic: data.marqueeDetailArabic,
    english: data.marqueeDetailEnglish,
  );
}

String productNameMultiLangText(ProductModel? data){
  return setMultiLanguageText(language: appLanguage,
    urdu: data!.productNameUrdu,
    arabic: data.productNameArabic,
    english: data.productNameEng,
  );
}

String productDetailMultiLangText(ProductModel? data){
  return setMultiLanguageText(language: appLanguage,
    urdu: data?.productDetailUrdu,
    arabic: data?.productDetailArabic,
    english: data?.productDetailEng,
  );
}

String categoriesNameMultiLangText(CategoryModel? data){
  return setMultiLanguageText(language: appLanguage,
    urdu: data?.categoryNameUrdu,
    arabic: data?.categoryNameArabic,
    english: data?.categoryNameEnglish,
  );
}

String subCategoriesNameMultiLangText(SubCategoriesModel data){
  return setMultiLanguageText(language: appLanguage,
    urdu: data.subCategoryNameUrdu,
    arabic: data.subCategoryNameArabic,
    english: data.subCategoryNameEnglish,
  );
}