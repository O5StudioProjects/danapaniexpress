import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';
import 'package:danapaniexpress/core/data_model_imports.dart';
import 'package:danapaniexpress/core/packages_import.dart';
import 'package:danapaniexpress/ui/screens/pages/categories/widgets/products_row_ui.dart';

class ProductDetailScreenMobile extends StatelessWidget {
  const ProductDetailScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    var productDetail = Get.find<ProductDetailController>();
    return Obx(() {
      final data = productDetail.productData.value;
      if (data == null) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            loadingIndicator(),
            setHeight(MAIN_VERTICAL_PADDING),
            appText(
              text: AppLanguage.loadingStr(appLanguage),
              textStyle: bodyTextStyle().copyWith(
                color: AppColors.materialButtonSkin(isDark),
                fontSize: SUB_HEADING_TEXT_BUTTON_FONT_SIZE,
              ),
            ),
          ],
        );
      }

      return Scaffold(
        bottomNavigationBar: cartSectionUI(data: data),
        body: Container(
          width: size.width,
          height: size.height,
          color: AppColors.backgroundColorSkin(isDark),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  width: size.width,
                  height: size.height * 0.444,
                  child: Stack(
                    children: [
                      Container(
                        width: size.width,
                        height: size.height * 0.44,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(imgProductBackground),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: centerImageForProductsUI(data: data),
                      ),
                      Positioned(
                        bottom: 0,
                        child: Container(
                          width: size.width,
                          height: 20.0,
                          decoration: BoxDecoration(
                            color: AppColors.backgroundColorSkin(isDark),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(26.0),
                              topRight: Radius.circular(26.0),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                productDetailPartUI(data: data),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget cartSectionUI({required ProductModel data}) {
    var productDetail = Get.find<ProductDetailController>();
    return Obx(() {
      return Container(
        color: AppColors.backgroundColorSkin(isDark),
        width: size.width,
        height: 80.0,
        child: Padding(
          padding: const EdgeInsets.all(MAIN_HORIZONTAL_PADDING),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  appText(
                    text:
                        'Rs. ${calculateTotalAmount(productPrice: data.productSellingPrice!, quantity: productDetail.quantity.value).toStringAsFixed(1)}/-',
                    textStyle: sellingPriceDetailTextStyle(),
                  ),
                  setHeight(4.0),
                  appText(
                    text: AppLanguage.totalAmountStr(appLanguage),
                    textStyle: itemTextStyle(),
                  ),
                ],
              ),
              appMaterialButton(
                text: AppLanguage.addToCartStr(appLanguage),
                onTap: () {},
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget productDetailPartUI({required ProductModel data}) {
    return SizedBox(
      width: size.width,
      child: Padding(
        padding: const EdgeInsets.only(
          left: MAIN_HORIZONTAL_PADDING,
          right: MAIN_HORIZONTAL_PADDING,
          bottom: MAIN_HORIZONTAL_PADDING,
        ),
        child: productDetailLDataUI(data: data),
      ),
    );
  }

  Widget productDetailLDataUI({required ProductModel data}) {
    var productDetail = Get.find<ProductDetailController>();
    var products = Get.find<ProductsController>();
    var nav = Get.find<NavigationController>();
    var auth = Get.find<AuthController>();
    return Obx((){
      return Column(
        crossAxisAlignment: appLanguage == URDU_LANGUAGE
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          ///CATEGORY AND SUBCATEGORY - FAVORITE BUTTON
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              appText(
                text: '${data.productCategory} > ${data.productSubCategory}',
                textStyle: secondaryTextStyle().copyWith(
                  color: AppColors.secondaryTextColorSkin(
                    isDark,
                  ).withValues(alpha: 0.7),
                ),
              ),

              GestureDetector(
                onTap: () async {
                  if (auth.currentUser.value == null) {
                    nav.gotoSignInScreen();
                  } else {
                    await productDetail.toggleFavorite(data.productId!);
                  }
                },
                child: productDetail.toggleFavoriteStatus.value == Status.LOADING
                    ? loadingIndicator()
                    : appIcon(
                  iconType: IconType.PNG,
                  icon: data.isFavoriteBy(auth.userId.value ?? '')
                      ? icHeartFill
                      : icHeart,
                  width: 20.0,
                  color: data.isFavoriteBy(auth.userId.value ?? '')
                      ? AppColors.materialButtonSkin(
                    isDark,
                  ) // or filled color
                      : AppColors.backgroundColorInverseSkin(isDark),
                ),
              ),
            ],
          ),
          setHeight(MAIN_HORIZONTAL_PADDING),

          /// PRODUCT NAME
          appText(
            text: appLanguage == URDU_LANGUAGE
                ? data.productNameUrdu
                : data.productNameEng,
            textAlign: setTextAlignment(appLanguage),
            textDirection: setTextDirection(appLanguage),
            textStyle: bigBoldHeadingTextStyle(),
          ),

          /// PRODUCT PRICE
          Padding(
            padding: const EdgeInsets.only(top: 6.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                appText(
                  text: 'Rs. ${data.productSellingPrice!.toStringAsFixed(1)}',
                  textStyle: sellingPriceDetailTextStyle(),
                ),
                if (data.productCutPrice != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: appText(
                      text: 'Rs. ${data.productCutPrice?.toStringAsFixed(1)}',
                      textStyle: cutPriceTextStyle(isDetail: true),
                    ),
                  ),
              ],
            ),
          ),

          /// WEIGHT AND SIZE
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: appText(
                    text: '${data.productWeightGrams} gm',
                    textStyle: textFormHintTextStyle(),
                  ),
                ),
                appText(text: '${data.productSize}', textStyle: itemTextStyle()),
              ],
            ),
          ),

          /// FEATURED / SALE / AVAILABILITY
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Row(
              children: [
                if (data.productBrand!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(right: 5.0),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                        color: EnvColors.specialFestiveColorDark,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(4.0),
                          bottomRight: Radius.circular(0.0),
                        ),
                      ),
                      child: appText(
                        text: data.productBrand,
                        textStyle: itemTextStyle().copyWith(color: whiteColor),
                      ),
                    ),
                  ),

                if (data.productIsFeatured == true)
                  Padding(
                    padding: const EdgeInsets.only(right: 5.0),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                        color: EnvColors.primaryColorLight,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(4.0),
                          bottomRight: Radius.circular(0.0),
                        ),
                      ),
                      child: appText(
                        text: AppLanguage.featureStr(appLanguage),
                        textStyle: itemTextStyle().copyWith(color: whiteColor),
                      ),
                    ),
                  ),

                if (data.productIsFlashsale == true)
                  Padding(
                    padding: const EdgeInsets.only(right: 5.0),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                        color: EnvColors.specialFestiveColorDark,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(4.0),
                          bottomRight: Radius.circular(0.0),
                        ),
                      ),
                      child: appText(
                        text: AppLanguage.flashSaleStr(appLanguage),
                        textStyle: itemTextStyle().copyWith(color: whiteColor),
                      ),
                    ),
                  ),
                if (data.productAvailability == false)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    decoration: BoxDecoration(
                      color: EnvColors.secondaryTextColorLight,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(4.0),
                        bottomRight: Radius.circular(0.0),
                      ),
                    ),
                    child: appText(
                      text: AppLanguage.outOfStockStr(appLanguage),
                      textStyle: itemTextStyle().copyWith(color: whiteColor),
                    ),
                  ),
              ],
            ),
          ),

          /// QUANTITY ADD DELETE
          appDivider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(20.0),
                child: counterButton(
                  icon: icMinus,
                  iconType: IconType.PNG,
                  isLimitExceed: productDetail.quantity.value == 1 ? true : false,
                  onTap: () => productDetail.onTapMinus(),
                ),
              ),

              Obx(
                    ()=> SizedBox(
                  width: 30.0,
                  child: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Center(
                      child: appText(
                        text: productDetail.quantity.string,
                        textStyle: headingTextStyle().copyWith(
                          fontSize: 22.0,
                          fontFamily: oswaldRegular,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.all(20.0),
                child: counterButton(
                  icon: icPlus,
                  iconType: IconType.PNG,
                  isLimitExceed:
                  data.productQuantityLimit == productDetail.quantity.value
                      ? true
                      : false,
                  onTap: () => productDetail.onTapPlus(
                    productLimit: data.productQuantityLimit!.toInt(),
                  ),
                ),
              ),
              //  setWidth(MAIN_HORIZONTAL_PADDING),
            ],
          ),
          appDivider(),

          if (data.productDetailEng!.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                appText(
                  text: AppLanguage.descriptionStr(appLanguage),
                  textStyle: headingTextStyle(),
                ),
                setHeight(MAIN_HORIZONTAL_PADDING),
                ReadMoreText(
                  appLanguage == URDU_LANGUAGE
                      ? data.productDetailUrdu.toString()
                      : data.productDetailEng.toString(),
                  trimLines: 2,
                  colorClickableText: Colors.blue,
                  trimMode: TrimMode.Line,
                  trimCollapsedText: ' ${AppLanguage.seeMoreStr(appLanguage)}',
                  trimExpandedText: ' ${AppLanguage.seeLessStr(appLanguage)}',
                  style: secondaryTextStyle(),
                  textDirection: setTextDirection(appLanguage),
                  textAlign: setTextAlignment(appLanguage),
                  moreStyle: appTextButtonStyle().copyWith(
                    color: AppColors.materialButtonSkin(isDark),
                  ),
                  lessStyle: appTextButtonStyle().copyWith(
                    color: AppColors.materialButtonSkin(isDark),
                  ),
                ),
                setHeight(MAIN_VERTICAL_PADDING),

                ProductsRowUi(
                  products: products.featuredProducts,
                  screenType: ProductsScreenType.FEATURED,
                  horizontalPadding: 0.0,
                  firstIndexLeftPadding: 2.0,
                ),
              ],
            ),
        ],
      );
    });
  }

  Widget centerImageForProductsUI({required ProductModel data}) {
    return Container(
      width: size.width,
      height: size.height * 0.45,
      decoration: BoxDecoration(color: Colors.black.withAlpha(50)),
      child: Stack(
        children: [
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Container(
                color: whiteColor,
                width: size.width * 0.6,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: appAsyncImage(data.productImage, boxFit: BoxFit.cover),
                ),
              ),
            ),
          ),
          Positioned(
            top: 10.0,
            left: MAIN_HORIZONTAL_PADDING,
            child: appFloatingButton(
              icon: icArrowLeft,
              onTap: () => Get.back(),
            ),
          ),
          if (data.productCutPrice != null)
            Positioned(
              bottom: MAIN_HORIZONTAL_PADDING + 20.0,
              right: MAIN_HORIZONTAL_PADDING,
              child: Container(
                width: 50.0,
                height: 50.0,
                decoration: BoxDecoration(
                  color: AppColors.floatingButtonSkin(isDark),
                  borderRadius: BorderRadius.circular(100.0),
                ),
                child: Center(
                  child: appText(
                    text:
                        '-${calculateDiscount(data.productCutPrice!, data.productSellingPrice!)}%',
                    textStyle: sellingPriceTextStyle().copyWith(
                      color: whiteColor,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
