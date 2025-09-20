import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';
import 'package:danapaniexpress/core/data_model_imports.dart';
import 'package:danapaniexpress/ui/app_common/dialogs/bool_dialog.dart';

class CartProductItem extends StatelessWidget {
  final ProductModel product;
  const CartProductItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final cart = Get.find<CartController>();
    final nav = Get.find<NavigationController>();
    return Obx((){
      var isLoading = cart.deleteCartItemStatus[product.productId] == Status.LOADING ? true : false;
      var isAddQuantityLoading = cart.addQuantityCartStatus[product.productId] == Status.LOADING ? true : false;
      var isRemoveQuantityLoading = cart.removeQuantityCartStatus[product.productId] == Status.LOADING ? true : false;
      return _buildUI(cart, nav, isLoading,isAddQuantityLoading, isRemoveQuantityLoading);
    });

  }

  Widget _buildUI(cart, nav, isLoading, isAddQuantityLoading, isRemoveQuantityLoading){
    return GestureDetector(
      onTap: ()=> nav.gotoProductDetailScreen(data: product),
      child: Padding(
        padding: const EdgeInsets.only(bottom: MAIN_HORIZONTAL_PADDING),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final imageSize = constraints.maxWidth * 0.16;

            return Container(
              width: size.width,
              //  height: imageSize * 3, // fixes container height based on image size + padding
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
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _imageSection(imageSize),
                      setWidth(MAIN_HORIZONTAL_PADDING),
                      _detailSection(context, cart, isLoading, isRemoveQuantityLoading, isAddQuantityLoading),

                    ],
                  ),

                ],
              ),
            );
          },
        ),
      ),
    );
  }


  Widget _imageSection(imageSize){
    return  ClipRRect(
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
    );
  }
  Widget _detailSection(context, cart, isLoading, isRemoveQuantityLoading, isAddQuantityLoading){
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _detailSectionUpperRow(context, cart, isLoading),

          _detailSectionLowerRow(cart, isRemoveQuantityLoading, isAddQuantityLoading)

        ],
      ),
    );
  }

  Widget _detailSectionUpperRow(context, cart, isLoading){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _upperRowProductName(),
                _upperRowWeightAndSize(),
                _upperRowPrices()
              ],
            )
        ),
        _upperRowRemoveProductFromCart(context, cart, isLoading),
      ],
    );
  }
  Widget _upperRowProductName(){
    return appText(
      text: productNameMultiLangText(product),
      textStyle: itemTextStyle().copyWith(fontSize: NORMAL_TEXT_FONT_SIZE),
      textDirection: TextDirection.ltr,
      maxLines: 1,
    );
  }
  Widget _upperRowWeightAndSize(){
    return Row(
      children: [
        if(product.productWeightGrams != null)
          appText(
            text: '${product.productWeightGrams} gm',
            textStyle: textFormHintTextStyle().copyWith(fontSize: NORMAL_TEXT_FONT_SIZE -2),
            maxLines: 1,
          ),
        if(product.productSize != null)
          Padding(
            padding: const EdgeInsets.only(left: 6.0),
            child: appText(
              text: product.productSize,
              textStyle: itemTextStyle(),
              maxLines: 1,
            ),
          ),
      ],
    );
  }
  Widget _upperRowPrices(){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if(product.productSellingPrice != null)
          appText(
            text: 'Rs. ${product.productSellingPrice}',
            textStyle: sellingPriceTextStyle(),
            maxLines: 1,
          ),
        setWidth(8.0),
        if(product.productCutPrice != null)
          appText(
            text: 'Rs. ${product.productCutPrice}',
            maxLines: 1,
            textStyle: cutPriceTextStyle(isDetail: false),
          ),
      ],
    );
  }
  Widget _upperRowRemoveProductFromCart(context, cart, isLoading){
    return GestureDetector(
      onTap: (){
        showCustomDialog(context, AppBoolDialog(
          title: AppLanguage.removeProductStr(appLanguage).toString(),
          detail: AppLanguage.removeProductConfirmStr(appLanguage).toString(),
          iconType: IconType.SVG,
          onTapConfirm: () async {
            Navigator.of(context).pop();
            await cart.deleteCartItem(product.productId!);
          },
          icon: icDelete,
        ));
      },
      child: isLoading ? SizedBox(
        width: 24.0,
        child: loadingIndicator(),
      ) : appIcon(
          icon: icDelete,
          iconType: IconType.PNG,
          width: 24.0,
          color: AppColors.materialButtonSkin(isDark)
      ),
    );
  }

  Widget _detailSectionLowerRow(cart, isRemoveQuantityLoading, isAddQuantityLoading){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _lowerRowQuantityAndPrice(),
        _lowerRowCounterButtonsAndQuantity(cart, isRemoveQuantityLoading, isAddQuantityLoading),

      ],
    );
  }
  Widget _lowerRowQuantityAndPrice() {
    final quantity = product.productQuantity ?? 0;
    final price = product.productSellingPrice ?? 0.0;

    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 2.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: appText(
          text: '$quantity x ${price.toStringAsFixed(0)} = $appCurrency ${(quantity * price).toStringAsFixed(0)}',
          textStyle: secondaryTextStyle().copyWith(
            color: AppColors.sellingPriceDetailTextSkin(isDark),
          ),
        ),
      ),
    );
  }

  Widget _lowerRowCounterButtonsAndQuantity(cart, isRemoveQuantityLoading, isAddQuantityLoading){
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [

        /// MINUS BUTTON
        SizedBox(
          width: 20.0,
          height: 20.0,
          child: isRemoveQuantityLoading
              ? loadingIndicator()
              : counterButton(
            icon: icMinus,
            iconType: IconType.PNG,
            isLimitExceed: (product.productQuantity ?? 0) <= 1,
            onTap: () async {
              final quantity = product.productQuantity ?? 0;
              if (quantity <= 1) {
                showToast(AppLanguage.selectAtLeastOneProductStr(appLanguage).toString());
              } else {
                await cart.removeQuantityFromCart(product.productId ?? '');
              }
            },
          ),
        ),

        /// QUANTITY
        SizedBox(
          width: 40.0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Center(
              child: appText(
                text: '${product.productQuantity ?? 0}',
                textStyle: bodyTextStyle().copyWith(fontSize: 20.0),
              ),
            ),
          ),
        ),

        /// PLUS BUTTON
        SizedBox(
          width: 20.0,
          height: 20.0,
          child: isAddQuantityLoading
              ? loadingIndicator()
              : counterButton(
            icon: icPlus,
            iconType: IconType.PNG,
            isLimitExceed: (product.productQuantityLimit ?? 0) <= (product.productQuantity ?? 0),
            onTap: () async {
              final quantity = product.productQuantity ?? 0;
              final limit = product.productQuantityLimit ?? 999999; // fallback large number
              if (quantity >= limit) {
                showToast(AppLanguage.quantityLimitExceededStr(appLanguage).toString());
              } else {
                await cart.addQuantityToCart(product.productId ?? '');
              }
            },
          ),
        ),



      ],
    );
  }


}
