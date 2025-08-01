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
          checkoutDetailStatus(
            title: AppLanguage.shippingStr(appLanguage),
            isDone: isShipping,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: appDivider(),
            ),
          ),
          checkoutDetailStatus(
            title: AppLanguage.paymentStr(appLanguage),
            isDone: isPayment,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: appDivider(),
            ),
          ),
          checkoutDetailStatus(
            title: AppLanguage.reviewStr(appLanguage),
            isDone: isReview,
          ),
        ],
      ),
    );
  }
}
