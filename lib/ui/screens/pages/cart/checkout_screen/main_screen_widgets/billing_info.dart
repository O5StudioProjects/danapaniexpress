import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';

class BillingInfo extends StatelessWidget {
  const BillingInfo({super.key});

  @override
  Widget build(BuildContext context) {
    var cart = Get.find<CartController>();
    var checkout = Get.find<CheckoutController>();
    return Obx(() {
      return _buildUI(cart, checkout);
    });
  }

  Widget _buildUI(cart, checkout){
    return Column(
      children: [
        /// HEADING
        Padding(
          padding: const EdgeInsets.only(top: MAIN_VERTICAL_PADDING, bottom: MAIN_HORIZONTAL_PADDING),
          child: HomeHeadings(
            mainHeadingText: AppLanguage.billingInformationStr(
              appLanguage,
            ).toString(),
            isSeeAll: false,
            isTrailingText: false,
          ),
        ),

        Container(
          padding: EdgeInsets.only(top: MAIN_HORIZONTAL_PADDING),
          decoration: BoxDecoration(color: AppColors.cardColorSkin(isDark)),
          child: Column(
            children: [
              _billingInfoUpperSection(checkout, cart),
              appDivider(),
              _totalAmountRow(cart),
              _billingInfoLowerSection(cart, checkout),
              _totalPayableAmount(checkout),
            ],
          ),
        ),
      ],
    );
  }

  Widget _billingInfoUpperSection(checkout, cart){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        billingInfoItems(
          title: AppLanguage.shippingColonStr(appLanguage),
          detail: checkout.shippingMethod.value.toString(),
          detailTextStyle: itemTextStyle(),
        ),
        if(checkout.slotDelivery.value || checkout.flashDelivery.value)
          billingInfoItems(
            title: AppLanguage.deliveryTypeColonStr(appLanguage),
            detail: checkout.deliveryType,
            detailTextStyle: itemTextStyle(),
          ),
        if (checkout.slotDelivery.value &&
            checkout.selectedSlotId.value != 0)
          billingInfoItems(
            title: AppLanguage.deliverySlotColonStr(appLanguage),
            detail: checkout.selectedSlotLabel.value,
            detailTextStyle: itemTextStyle(),
          ),
        billingInfoItems(
          title: AppLanguage.totalProductsColonStr(appLanguage),
          detail: cart.cartProducts.length.toString(),
          detailTextStyle: itemTextStyle(),
        ),
        billingInfoItems(
          title: AppLanguage.productsQuantityColonStr(appLanguage),
          detail: cart.totalProductsQuantity.value.toString(),
          detailTextStyle: itemTextStyle(),
        ),
      ],
    );
  }

  Widget _totalAmountRow(cart){
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: MAIN_HORIZONTAL_PADDING,
        vertical: 8.0,
      ),
      child: isRightLang
          ? Row(
        children: [
          appText(
            text:
            '$appCurrency ${cart.totalSellingPrice.value.toStringAsFixed(1)} ',
            textStyle: itemTextStyle().copyWith(
              color: AppColors.sellingPriceDetailTextSkin(
                isDark,
              ),
            ),
          ),
          setWidth(4.0),
          appText(
              text:
              '$appCurrency ${cart.totalCutPrice.value.toStringAsFixed(1)} ',
              textStyle: cutPriceTextStyle().copyWith(
                color: AppColors.cutPriceDetailTextColorSkin(
                  isDark,
                ),
              ),
              textAlign: setTextAlignment(appLanguage),
              textDirection: setTextDirection(appLanguage)
          ),
          setWidth(8.0),
          Expanded(
            child: appText(
                text: AppLanguage.totalAmountColonStr(
                  appLanguage,
                ),
                textStyle: bodyTextStyle(),
                textAlign: setTextAlignment(appLanguage),
                textDirection: setTextDirection(appLanguage)
            ),
          ),
        ],
      )
          : Row(
        children: [
          Expanded(
            child: appText(
              text: AppLanguage.totalAmountColonStr(
                appLanguage,
              ),
              textStyle: bodyTextStyle(),
            ),
          ),
          setWidth(8.0),
          appText(
              text:
              '$appCurrency ${cart.totalCutPrice.value.toStringAsFixed(1)} ',
              textStyle: cutPriceTextStyle().copyWith(
                color: AppColors.cutPriceDetailTextColorSkin(
                  isDark,
                ),
              ),
              textAlign: setTextAlignment(appLanguage),
              textDirection: setTextDirection(appLanguage)
          ),
          setWidth(4.0),
          appText(
              text:
              '$appCurrency ${cart.totalSellingPrice.value.toStringAsFixed(1)} ',
              textStyle: itemTextStyle().copyWith(
                color: AppColors.sellingPriceDetailTextSkin(
                  isDark,
                ),
              ),
              textAlign: setTextAlignment(appLanguage),
              textDirection: setTextDirection(appLanguage)
          ),
        ],
      ),
    );
  }

  Widget _billingInfoLowerSection(cart, checkout){
    return Padding(
      padding: const EdgeInsets.only(bottom: MAIN_HORIZONTAL_PADDING),
      child: Column(
        children: [
          billingInfoItems(
            title: AppLanguage.discountColonStr(appLanguage),
            detail:
            '$appCurrency ${(cart.totalCutPrice.value - cart.totalSellingPrice.value).toStringAsFixed(1)}',
            detailTextStyle: itemTextStyle().copyWith(
              color: AppColors.materialButtonSkin(isDark),
            ),
          ),
          billingInfoItems(
            title: AppLanguage.deliveryChargesColonStr(appLanguage),
            detail:
            '$appCurrency ${checkout.deliveryChargesValue.toStringAsFixed(1)}',
            detailTextStyle: itemTextStyle(),
          ),
          billingInfoItems(
            title: AppLanguage.gstColonStr(appLanguage),
            detail: '$appCurrency ${checkout.tax.value.toStringAsFixed(1)}',
            detailTextStyle: itemTextStyle(),
          ),
        ],
      ),
    );
  }

  Widget _totalPayableAmount(checkout){
    return Padding(
      padding: const EdgeInsets.only(bottom: MAIN_HORIZONTAL_PADDING),
      child: Container(
        padding: EdgeInsets.all(MAIN_HORIZONTAL_PADDING),
        color: AppColors.backgroundColorSkin(isDark),
        child: isRightLang
            ? Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            appText(
              text:
              '$appCurrency ${checkout.totalPayableAmount.toStringAsFixed(1)}',
              textStyle: sellingPriceTextStyle().copyWith(
                fontSize: HEADING_FONT_SIZE,
                color: AppColors.sellingPriceDetailTextSkin(isDark),
              ),
            ),
            setWidth(8.0),
            Expanded(
              child: appText(
                text: AppLanguage.totalPayableAmountColonStr(
                  appLanguage,
                ),
                textStyle: headingTextStyle(),
                textDirection: setTextDirection(appLanguage),
                textAlign: setTextAlignment(appLanguage),
              ),
            ),
          ],
        )
            : Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: appText(
                text: AppLanguage.totalPayableAmountColonStr(
                  appLanguage,
                ),
                textStyle: headingTextStyle(),
                textDirection: setTextDirection(appLanguage),
                textAlign: setTextAlignment(appLanguage),
              ),
            ),
            setWidth(8.0),
            appText(
              text:
              '$appCurrency ${checkout.totalPayableAmount.toStringAsFixed(1)}',
              textStyle: sellingPriceTextStyle().copyWith(
                fontSize: HEADING_FONT_SIZE,
                color: AppColors.sellingPriceDetailTextSkin(isDark),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget billingInfoItems({title, detail, detailTextStyle}) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: MAIN_HORIZONTAL_PADDING,
        vertical: 8.0,
      ),
      child: isRightLang
          ? Row(
        children: [
          appText(
            text: detail,
            textStyle: detailTextStyle,
            textDirection: setTextDirection(appLanguage),
            textAlign: setTextAlignment(appLanguage),
          ),
          setWidth(8.0),
          Expanded(
            child: appText(
              text: title,
              textStyle: bodyTextStyle(),
              textDirection: setTextDirection(appLanguage),
              textAlign: setTextAlignment(appLanguage),
            ),
          ),
        ],
      )
          : Row(
        children: [
          Expanded(
            child: appText(text: title, textStyle: bodyTextStyle(),
              textDirection: setTextDirection(appLanguage),
              textAlign: setTextAlignment(appLanguage),
            ),
          ),
          setWidth(8.0),
          appText(text: detail, textStyle: detailTextStyle,
            textDirection: setTextDirection(appLanguage),
            textAlign: setTextAlignment(appLanguage),
          ),
        ],
      ),
    );
  }
}
