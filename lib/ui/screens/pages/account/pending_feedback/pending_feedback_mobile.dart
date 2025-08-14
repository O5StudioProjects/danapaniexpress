import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';

class PendingFeedbackMobile extends StatelessWidget {
  const PendingFeedbackMobile({super.key});

  @override
  Widget build(BuildContext context) {
    final pendingFeedback = Get.find<PendingFeedbackController>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      pendingFeedback.fetchCompletedOrdersWithoutFeedback();
    });
    return Obx(
      ()=> Container(
        width: size.width,
        height: size.height,
        color: AppColors.backgroundColorSkin(isDark),
        child: Column(
          children: [
            appBarCommon(title: AppLanguage.ordersFeedbackStr(appLanguage), isBackNavigation: true),
            Expanded(child: PendingFeedbackList()),
            BottomMessagesSection(
                isLoadingMore: pendingFeedback.isLoadingMoreOrdersWithoutFeedback.value,
                hasMore:  pendingFeedback.hasMoreOrdersWithoutFeedback.value,
                reachedEnd: pendingFeedback.reachedEndOfScroll.value,
                message: AppLanguage.noMorePendingFeedbacksStr(appLanguage).toString()
            )
          ],
        ),
      ),
    );
  }
}




