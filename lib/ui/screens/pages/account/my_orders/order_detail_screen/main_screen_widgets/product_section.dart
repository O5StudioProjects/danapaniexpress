import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/data_model_imports.dart';

class ProductSection extends StatelessWidget {
  final OrderModel orderData;
  const ProductSection({super.key, required this.orderData});

  @override
  Widget build(BuildContext context) {
    return _buildUI();
  }

  _buildUI(){
    var products = orderData.orderedProducts!;
    return Padding(
      padding: const EdgeInsets.only(top: MAIN_VERTICAL_PADDING),
      child: orderDetailSectionsUI(
          titleText: AppLanguage.orderedProductsStr(appLanguage),
          column: Column(
            children: [
              Column(
                children: List.generate(products.length, (index) {
                  var product = products[index];
                  return  _productItem(index,product,products);
                }),
              ),
            ],
          )
      ),
    );
  }

  _productItem(index,product,products){
    return Column(
      children: [
        Row(
          children: [
            _productNumber(index),
            _productImage(product),
            _productDetailSection(product),
            _productQuantityAndPrice(product),
          ],
        ),
        if (index < products.length - 1)
          setHeight(MAIN_HORIZONTAL_PADDING),
      ],
    );
  }

  _productNumber(index){
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: appText(
        text: (index + 1).toString(),
        textStyle: itemTextStyle(),
      ),
    );
  }

  _productImage(product){
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

  _productDetailSection(product){
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _productName(product),
          _productWeightAndSize(product),
          _productCutPrice(product),
          _productSellingPrice(product),
        ],
      ),
    );
  }

  _productName(product){
    return appText(
      text: orderedProductNameMultiLangText(product),
      textStyle: itemTextStyle().copyWith(
        fontSize: SUB_HEADING_TEXT_BUTTON_FONT_SIZE,
      ),
      textDirection: setTextDirection(appLanguage),
      maxLines: 1,
    );
  }

  _productWeightAndSize(product){
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

  _productCutPrice(product){
    if (product.productCutPrice != null){
      return appText(
        text: '$appCurrency ${product.productCutPrice}',
        maxLines: 1,
        textStyle:
        cutPriceTextStyle(
          isDetail: false,
        ).copyWith(
          fontSize:
          TAGS_FONT_SIZE,
        ),
      );
    }else {
      return SizedBox.shrink();
    }

  }

  _productSellingPrice(product){
    return appText(
      text: '$appCurrency ${product.productSellingPrice}',
      textStyle: sellingPriceTextStyle().copyWith(
        fontSize: TAGS_FONT_SIZE,
      ),
      maxLines: 1,
    );
  }

  _productQuantityAndPrice(product){
    return Padding(
      padding: const EdgeInsets.only(left: MAIN_HORIZONTAL_PADDING),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          appText(
            text:
            '${product.productQty} x ${product.productSellingPrice!.toStringAsFixed(0)} = $appCurrency ${(product.productQty!.toInt() * product.productSellingPrice!.toDouble()).toStringAsFixed(0)}',
            textStyle: secondaryTextStyle().copyWith(
              color: AppColors.sellingPriceDetailTextSkin(
                isDark,
              ),
              fontSize: TAGS_FONT_SIZE,
            ),
          ),
        ],
      ),
    );
  }

}
