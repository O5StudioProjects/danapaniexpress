import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';

class CheckoutScreenMobile extends StatelessWidget {
  const CheckoutScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    final checkout = Get.find<CheckoutController>();
    return Obx(() {
      return _buildUI(checkout);
    });
  }

  Widget _buildUI(checkout){
    return Container(
      width: size.width,
      height: size.height,
      color: AppColors.backgroundColorSkin(isDark),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          appBarCommon(
            title: AppLanguage.checkoutStr(appLanguage),
            isBackNavigation: true,
          ),
          /// TOP CHECKOUT DETAIL STATUS
          TopCheckoutStatus(
            isShipping: checkout.shippingValue && checkout.shippingSlotCheck,
            isPayment: checkout.paymentValue,
            isReview: checkout.review.value,
          ),
          setHeight(20.0),
          Expanded(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  /// SHIPPING ADDRESS SECTION
                  CheckoutAddressSection(),
                  _checkoutDivider(),
                  /// DELIVERY TYPE
                  SelectDeliveryType(),
                  _checkoutDivider(),
                  /// SELECT PAYMENT METHOD
                  SelectPaymentMethod(isSelected: checkout.cod.value),
                  _checkoutDivider(),
                  /// REVIEW PRODUCTS
                  ReviewProducts(),
                  _checkoutDivider(),
                  /// BILLING SECTION
                  BillingInfo(),
                  _specialNoteForRider(checkout),
                  //setHeight(MAIN_VERTICAL_PADDING),
                  _placeOrderButton(checkout),
                  setHeight(MAIN_VERTICAL_PADDING),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _checkoutDivider ()=> Padding(
    padding: const EdgeInsets.only(top: MAIN_VERTICAL_PADDING),
    child: appDivider(),
  );

  Widget _specialNoteForRider(checkout){
    return Padding(
      padding: const EdgeInsets.only(
        top: MAIN_VERTICAL_PADDING,
        left: MAIN_HORIZONTAL_PADDING,
        right: MAIN_HORIZONTAL_PADDING,
        bottom: MAIN_HORIZONTAL_PADDING / 2,
      ),
      child: AppTextFormField(
        textEditingController: checkout.specialNoteTextController.value,
        hintText: AppLanguage.specialNoteOptionalStr(appLanguage),
        isDetail: true,
        label: AppLanguage.specialNoteOptionalStr(appLanguage),
      ),
    );
  }

  Widget _placeOrderButton(checkout) =>  Padding(
    padding: const EdgeInsets.all(MAIN_HORIZONTAL_PADDING),
    child:
    checkout.checkOutStatus.value == Status.LOADING
        ? loadingIndicator()
        : appMaterialButton(
      text: AppLanguage.placeOrderStr(appLanguage),
      isDisable:
      checkout.shippingValue && checkout.paymentValue
          ? false
          : true,
      onTap: () async => checkout.onTapCheckout(),
    ),
  );

}
