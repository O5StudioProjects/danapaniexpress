import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/data_model_imports.dart';

class PaymentSection extends StatelessWidget {
  final OrderModel orderData;

  const PaymentSection({super.key, required this.orderData});

  @override
  Widget build(BuildContext context) {
    return _buildUI();
  }

  _buildUI() {
    return Padding(
      padding: const EdgeInsets.only(top: MAIN_VERTICAL_PADDING),
      child: orderDetailSectionsUI(
          titleText: AppLanguage.paymentStr(appLanguage),
          column: Column(
            children: [
              orderDetailItemsFixedUI(
                  titleText: AppLanguage.paymentMethodStr(appLanguage),
                  detailText: orderData.paymentMethod!
              ),
              setHeight(8.0),
              orderDetailItemsFixedUI(
                  titleText: AppLanguage.totalAmountStr(appLanguage),
                  detailText: '$appCurrency ${orderData.totalCutPriceAmount!}'
              ),
              setHeight(8.0),
              orderDetailItemsFixedUI(
                  titleText: AppLanguage.discountStr(appLanguage),
                  detailText: '- $appCurrency ${orderData.totalDiscount!}'
              ),
              setHeight(8.0),
              orderDetailItemsFixedUI(
                  titleText: AppLanguage.discountedAmountStr(appLanguage),
                  detailText: '$appCurrency ${orderData.totalSellingAmount!}'
              ),
              setHeight(8.0),
              orderDetailItemsFixedUI(
                  titleText: AppLanguage.deliveryChargesStr(appLanguage),
                  detailText: '$appCurrency ${orderData.deliveryCharges!}'
              ),
              setHeight(8.0),
              orderDetailItemsFixedUI(
                  titleText: AppLanguage.gstStr(appLanguage),
                  detailText: '$appCurrency ${orderData.salesTax!}'
              ),
              appDivider(),
              orderDetailItemsFixedUI(
                  titleText: AppLanguage.payableAmountStr(appLanguage),
                  detailText: '$appCurrency ${(orderData.totalSellingAmount! + orderData.deliveryCharges! + orderData.salesTax!).toString()}'
              ),

            ],
          )
      ),
    );
  }



}