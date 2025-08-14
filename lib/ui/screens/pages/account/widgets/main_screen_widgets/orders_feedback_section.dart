import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';

class OrdersFeedbackSection extends StatelessWidget {
  const OrdersFeedbackSection({super.key});

  @override
  Widget build(BuildContext context) {
    var auth = Get.find<AuthController>();
    var pendingFeedback = Get.find<PendingFeedbackController>();
    var nav = Get.find<NavigationController>();

      return Obx((){
        var icArrow = isRightLang ? icArrowLeftSmall : icArrowRightSmall;
        return _buildUI(auth,pendingFeedback,nav,icArrow);
      });
    }

    Widget _buildUI(auth,pendingFeedback,nav,icArrow){
      if(auth.currentUser.value != null){
        return  Column(
          crossAxisAlignment: isRightLang
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            _heading(),

            ///ORDERS FEED BACK
            _feedbackSection(auth,pendingFeedback,nav,icArrow),

          ],
        );
      } else {
        return SizedBox.shrink();
      }
    }

    Widget _heading(){
    return Padding(
      padding: const EdgeInsets.only(bottom: MAIN_VERTICAL_PADDING),
      child: HomeHeadings(
        mainHeadingText: AppLanguage.ordersFeedbackStr(appLanguage).toString(),
        isSeeAll: false,
        isTrailingText: false,
      ),
    );
    }

    Widget _feedbackSection(auth,pendingFeedback,nav,icArrow){
    return Padding(
      padding: const EdgeInsets.only(
        bottom: MAIN_VERTICAL_PADDING,
      ),
      child: listItemIcon(
        iconType: IconType.ICON,
        leadingIcon: Icons.feedback_rounded,
        itemTitle: AppLanguage.ordersFeedbackStr(appLanguage).toString(),
        trailingIcon: icArrow,
        isActiveNotification: pendingFeedback.completedOrdersWithoutFeedback.isNotEmpty ? true : false,
        onItemClick: ()=> nav.gotoPendingFeedbackScreen(),
      ),
    );
    }

}
