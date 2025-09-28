import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';
import 'package:danapaniexpress/core/data_model_imports.dart';

class FavoriteProductItem extends StatelessWidget {
  final ProductModel product;
  const FavoriteProductItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final favorites = Get.find<FavoritesController>();
    final cart = Get.find<CartController>();
    final nav = Get.find<NavigationController>();
    return Padding(
      padding: const EdgeInsets.only(bottom: MAIN_HORIZONTAL_PADDING),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final imageSize = constraints.maxWidth * 0.15;

          return Obx((){
            final isLoading = cart.addCartStatus[product.productId] == Status.LOADING;
            return GestureDetector(
              onTap: ()=> nav.gotoProductDetailScreen(data: product),
              child: _buildUI(favorites, cart, nav, imageSize, isLoading),
            );
          });
        },
      ),
    );
  }


  Widget _buildUI(favorites, cart, nav, imageSize, isLoading){
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: AppColors.cardColorSkin(isDark),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(30),
            blurRadius: 1,
            spreadRadius: 0,
            offset: const Offset(1, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _upperRow(imageSize,favorites),
          _lowerRow(isLoading, cart),
        ],
      ),
    );
  }

  Widget _upperRow(imageSize,favorites){
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _productImage(imageSize),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _productName(),
                _productWeightAndSize(),
                _productPriceSection(),

              ],
            ),
          ),
          setHeight(8.0),
          _favoriteButtonSection(favorites)
        ],
      ),
    );
  }

  Widget _productImage(imageSize){
    return Padding(
      padding: const EdgeInsets.only(right: MAIN_HORIZONTAL_PADDING),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: Container(
          color: whiteColor,
          width: imageSize,
          height: imageSize,
          child: appAsyncImage(
            product.productImage,
            boxFit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _productName(){
    return appText(
      text: productNameMultiLangText(product),
      textStyle: itemTextStyle().copyWith(fontSize: NORMAL_TEXT_FONT_SIZE),
      textDirection: setTextDirection(appLanguage),
      maxLines: 1,
    );
  }

  Widget _productWeightAndSize(){
    return Row(
      children: [
        appText(
          text: '${product.productWeightGrams} gm',
          textStyle: textFormHintTextStyle().copyWith(fontSize: TAGS_FONT_SIZE),
          maxLines: 1,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 6.0),
          child: appText(
            text: product.productSize,
            textStyle: itemTextStyle().copyWith(fontSize: TAGS_FONT_SIZE),
            maxLines: 1,
          ),
        ),
      ],
    );
  }

  Widget _productPriceSection(){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        appText(
          text: '$appCurrency ${product.productSellingPrice}',
          textStyle: sellingPriceTextStyle(),
          maxLines: 1,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 6.0),
          child: appText(
            text: '$appCurrency ${product.productCutPrice}',
            maxLines: 1,
            textStyle: cutPriceTextStyle(isDetail: false),
          ),
        ),
      ],
    );
  }

  Widget _favoriteButtonSection(favorites){
    return Obx((){
      final isLoading = favorites.favoriteLoadingStatus[product.productId] == Status.LOADING;
      return GestureDetector(
        onTap: (){
          favorites.toggleFavorite(product.productId!);
        },
        child: isLoading
            ? SizedBox(
          width: 24.0,
          height: 24.0,
          child: loadingIndicator(),
        )
            :appIcon(
          iconType: IconType.PNG,
          icon: icHeartFill,
          width: 24.0,
          color: AppColors.materialButtonSkin(isDark),
        ),
      );
    });
  }

  Widget _lowerRow(isLoading, cart){
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        if (product.productBrand!.isNotEmpty)
          ProductTags(color: EnvColors.specialFestiveColorDark, tagText: product.productBrand.toString(), isLeftPadding: true,),

        if (product.productIsFlashsale == true)
          ProductTags(color: EnvColors.primaryColorLight, tagText: AppLanguage.flashSaleStr(appLanguage).toString(), isLeftPadding: true,),

        Spacer(),
        isLoading ? SizedBox(
          height: 35.0,
          width: 100.0,
          child: loadingIndicator(),
        ) : SizedBox(
          height: 35.0,
          child: appMaterialButton(
              text: product.productAvailability == false || product.productQuantity == 0 ? AppLanguage.outOfStockStr(appLanguage) :AppLanguage.addToCartStr(appLanguage),
              fontSize: SUB_HEADING_TEXT_BUTTON_FONT_SIZE,
              isDisable: product.productAvailability == false || product.productQuantity == 0,
              onTap: () async {
                if(product.productAvailability == true && product.productQuantity! > 0){
                  await cart.addToCart(product.productId!);
                } else {
                  showToast(AppLanguage.outOfStockStr(appLanguage).toString());
                }
              }
          ),
        ),

      ],
    );
  }

}
