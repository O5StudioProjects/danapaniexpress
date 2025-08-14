import 'package:danapaniexpress/core/controllers_import.dart';
import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/data_model_imports.dart';

class PendingFeedbackItem extends StatelessWidget {
  final OrderModel data;
  final int index;
  const PendingFeedbackItem({super.key, required this.data, required this.index});

  @override
  Widget build(BuildContext context) {
    final nav = Get.find<NavigationController>();
    return Padding(
      padding: const EdgeInsets.only(bottom: MAIN_HORIZONTAL_PADDING, left: MAIN_HORIZONTAL_PADDING, right: MAIN_HORIZONTAL_PADDING),
      child: Container(
        width: size.width,
        padding: EdgeInsets.all(MAIN_HORIZONTAL_PADDING),
        decoration: BoxDecoration(
            color: AppColors.cardColorSkin(isDark),
            borderRadius: BorderRadius.circular(12.0)
        ),
        child: Column(
          children: [
            isRightLang
                ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _contentText(
                    orderNumberText: '${AppLanguage.orderNumberStr(appLanguage)} ',
                    orderNumber: '${data.orderNumber?.split('_').last} ',
                    contentText: AppLanguage.isCompletedFeedbackPendingStr(appLanguage)
                ),
                setWidth(8.0),
                appText(text: '$index', textStyle: itemTextStyle()),
              ],
            )
                : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                appText(text: '$index', textStyle: itemTextStyle()),
                setWidth(8.0),
                _contentText(
                    orderNumberText: '${AppLanguage.orderNumberStr(appLanguage)} ',
                    orderNumber: '${data.orderNumber?.split('_').last} ',
                    contentText: AppLanguage.isCompletedFeedbackPendingStr(appLanguage)
                ),
              ],
            ),
            setHeight(MAIN_HORIZONTAL_PADDING),
            appMaterialButton(text: AppLanguage.giveYourFeedbackStr(appLanguage), onTap: ()=> nav.gotoOrdersFeedbackScreen(orderModel: data))
          ],
        ),
      ),
    );
  }
}

_contentText({orderNumberText, orderNumber, contentText }){
  return Expanded(
    child: Text.rich(
        textDirection: setTextDirection(appLanguage),
        TextSpan(
            children: [
              TextSpan(
                  text: orderNumberText,
                  style: bodyTextStyle()
              ),
              TextSpan(
                  text: orderNumber,
                  style: itemTextStyle()
              ),
              TextSpan(
                  text: contentText,
                  style: bodyTextStyle()
              ),
            ]
        )),
  );
}