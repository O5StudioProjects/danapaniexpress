import 'package:danapaniexpress/core/common_imports.dart';
class TopCheckoutStatus extends StatelessWidget {
  final bool isShipping;
  final bool isPayment;
  final bool isReview;
  const TopCheckoutStatus({super.key, required this.isShipping, required this.isPayment, required this.isReview});

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MAIN_HORIZONTAL_PADDING,
        vertical: MAIN_VERTICAL_PADDING,
      ),
      child: Row(
        children: [
          CheckoutDetailStatus(
            title: AppLanguage.shippingStr(appLanguage).toString(),
            isDone: isShipping,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: appDivider(),
            ),
          ),
          CheckoutDetailStatus(
            title: AppLanguage.paymentStr(appLanguage).toString(),
            isDone: isPayment,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: appDivider(),
            ),
          ),
          CheckoutDetailStatus(
            title: AppLanguage.reviewStr(appLanguage).toString(),
            isDone: isReview,
          ),
        ],
      ),
    );
  }
}
