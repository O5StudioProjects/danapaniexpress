import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/data_model_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';

class UserFeedbackSection extends StatelessWidget {
  final OrderModel orderData;

  const UserFeedbackSection({super.key, required this.orderData});

  @override
  Widget build(BuildContext context) {
    return _buildUI();
  }

  _buildUI() {
    return orderData.orderFeedback == null
        ? SizedBox.shrink()
        : Padding(
      padding: const EdgeInsets.only(top: MAIN_VERTICAL_PADDING),
      child: GestureDetector(
        onTap: ()=> Get.find<NavigationController>().gotoOrdersFeedbackScreen(orderModel: orderData),
        child: orderDetailSectionsUI(
            titleText: AppLanguage.myFeedbackStr(appLanguage),
            column:
            Column(
              children: [
                orderDetailItemsFixedUI(
                    titleText: AppLanguage.aboutOurServiceStr(appLanguage),
                    detailText: orderData.orderFeedback!.feedbackType
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: orderDetailItemsFixedUI(
                      titleText: AppLanguage.appExperienceStr(appLanguage),
                      detailText: orderData.orderFeedback!.isPositive == true ? AppLanguage.positiveStr(appLanguage) : AppLanguage.negativeStr(appLanguage)
                  ),
                ),
                if(orderData.orderFeedback!.feedbackDetail!.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      setHeight(8.0),
                      appDivider(),
                      setHeight(8.0),
                      appText(
                        text: AppLanguage.feedbackCommentsStr(appLanguage),
                        textStyle: itemTextStyle().copyWith(fontWeight: FontWeight.w800,
                          color: AppColors.primaryTextColorSkin(isDark),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: appText(text: orderData.orderFeedback!.feedbackDetail.toString(), maxLines: 100,
                            textStyle: bodyTextStyle().copyWith(fontSize: NORMAL_TEXT_FONT_SIZE-2)
                        ),
                      ),
                    ],
                  )
              ],
            )
        ),
      ),
    );
  }



}