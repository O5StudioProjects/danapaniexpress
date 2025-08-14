import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/data_model_imports.dart';

class ReviewProductsItem extends StatelessWidget {
  final ProductModel product;
  final int listLength;
  final int index;
  const ReviewProductsItem({super.key, required this.product, required this.listLength, required this.index});

  @override
  Widget build(BuildContext context) {
    return _buildUI();
  }

  Widget _buildUI(){
    return Column(
      children: [
        Row(
          children: [
            _productNumber(),
            _productImage(),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _productName(),
                  _productWeightAndSize(),
                  _productPrice(),
                ],
              ),
            ),
            setWidth(MAIN_HORIZONTAL_PADDING),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _productQuantityAndPrice(),
              ],
            ),
          ],
        ),
        if (index < listLength - 1)
          setHeight(MAIN_HORIZONTAL_PADDING),
      ],
    );
  }

  Widget _productNumber(){
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: appText(
        text: (index + 1).toString(),
        textStyle: itemTextStyle(),
      ),
    );
  }

  Widget _productImage(){
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: Container(
          color: whiteColor,
          width: size.width * 0.12,
          height: size.width * 0.12,
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
      textStyle: itemTextStyle().copyWith(
        fontSize: SUB_HEADING_TEXT_BUTTON_FONT_SIZE,
      ),
      textDirection: setTextDirection(appLanguage),
      maxLines: 1,
    );
  }

  Widget _productWeightAndSize(){
    return Row(
      children: [
        if (product.productWeightGrams != null)
          appText(
            text: '${product.productWeightGrams} gm',
            textStyle: textFormHintTextStyle().copyWith(
              fontSize: TAGS_FONT_SIZE,
            ),
            maxLines: 1,
          ),
        if (product.productSize != null)
          Padding(
            padding: const EdgeInsets.only(left: 6.0),
            child: appText(
              text: product.productSize,
              textStyle: itemTextStyle().copyWith(
                fontSize: TAGS_FONT_SIZE,
              ),
              maxLines: 1,
            ),
          ),
      ],
    );
  }

  Widget _productPrice(){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        appText(
          text: '$appCurrency ${product.productSellingPrice}',
          textStyle: sellingPriceTextStyle().copyWith(
            fontSize: SUB_HEADING_TEXT_BUTTON_FONT_SIZE,
          ),
          maxLines: 1,
        ),
        setWidth(8.0),
        if (product.productCutPrice != null)
          appText(
            text: '$appCurrency ${product.productCutPrice}',
            maxLines: 1,
            textStyle:
            cutPriceTextStyle(
              isDetail: false,
            ).copyWith(
              fontSize:
              SUB_HEADING_TEXT_BUTTON_FONT_SIZE,
            ),
          ),
      ],
    );
  }

  Widget _productQuantityAndPrice(){
    return appText(
      text:
      '${product.productQuantity} x ${product.productSellingPrice!.toStringAsFixed(0)} = $appCurrency ${(product.productQuantity!.toInt() * product.productSellingPrice!.toDouble()).toStringAsFixed(0)}',
      textStyle: secondaryTextStyle().copyWith(
        color: AppColors.sellingPriceDetailTextSkin(
          isDark,
        ),
        fontSize: TAGS_FONT_SIZE,
      ),
    );
  }



}
