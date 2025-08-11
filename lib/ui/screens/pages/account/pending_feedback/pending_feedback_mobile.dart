import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';

import '../../../../../data/models/order_model.dart';

class PendingFeedbackMobile extends StatelessWidget {
  const PendingFeedbackMobile({super.key});

  @override
  Widget build(BuildContext context) {
    final pendingFeedback = Get.find<PendingFeedbackController>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      pendingFeedback.fetchCompletedOrdersWithoutFeedback();
    });
    return Container(
      width: size.width,
      height: size.height,
      color: AppColors.backgroundColorSkin(isDark),
      child: Column(
        children: [
          appBarCommon(title: AppLanguage.ordersFeedbackStr(appLanguage), isBackNavigation: true),
          Expanded(child: PendingFeedbackListSection()),
          ShowBottomMessagesSection()
        ],
      ),
    );
  }
}

class PendingFeedbackListSection extends StatelessWidget {
  const PendingFeedbackListSection({super.key});

  @override
  Widget build(BuildContext context) {
    var pendingFeedback = Get.find<PendingFeedbackController>();
    return Obx((){
      var list = pendingFeedback.completedOrdersWithoutFeedback;
      if(pendingFeedback.ordersWithoutFeedbackStatus.value == Status.LOADING){
        return loadingIndicator();
      }
      if(pendingFeedback.ordersWithoutFeedbackStatus.value == Status.FAILURE){
        return ErrorScreen();
      }
      if(pendingFeedback.completedOrdersWithoutFeedback.isEmpty){
        return EmptyScreen(icon: Icons.feedback_rounded, text: AppLanguage.noPendingOrderFeedbackStr(appLanguage).toString(), iconType: IconType.ICON, color: AppColors.materialButtonSkin(isDark),);
      }
      return ListView.builder(
          padding: EdgeInsets.only(top: MAIN_VERTICAL_PADDING),
          physics: BouncingScrollPhysics(),
          controller: pendingFeedback.scrollController,
          shrinkWrap: true,
          itemCount: list.length,
          itemBuilder: (context, index){
            var data = list[index];
            return PendingFeedbackItem(data: data, index: index+1,);
          }
      );
    });
  }
}


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
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                appText(text: '$index', textStyle: itemTextStyle()),
                setWidth(8.0),
                Expanded(
                    child: Text.rich(
                        TextSpan(
                      children: [
                        TextSpan(
                          text: 'Order number ',
                          style: bodyTextStyle()
                        ),
                        TextSpan(
                            text: '${data.orderNumber?.split('_').last} ',
                          style: itemTextStyle()
                        ),
                        TextSpan(
                            text: 'is completed. feedback is pending please give your valuable feedback.',
                            style: bodyTextStyle()
                        ),
                      ]
                    ))
                ),
              ],
            ),
            setHeight(MAIN_HORIZONTAL_PADDING),
            appMaterialButton(text: 'Give your feedback', onTap: ()=> nav.gotoOrdersFeedbackScreen(orderModel: data))
          ],
        ),
      ),
    );
  }
}

class ShowBottomMessagesSection extends StatelessWidget {
  const ShowBottomMessagesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final pendingFeedback = Get.find<PendingFeedbackController>();

    return Obx(() {
      final isLoadingMore = pendingFeedback.isLoadingMoreOrdersWithoutFeedback.value;
      final hasMore = pendingFeedback.hasMoreOrdersWithoutFeedback.value;
      final reachedEnd = pendingFeedback.reachedEndOfScroll.value;

      // ✅ Only show when all products are scrolled & no more left
      if (!hasMore && reachedEnd) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 0),
          child: Center(
            child: appText(text: 'No more Products', textStyle: itemTextStyle()),
          ),
        );
      }

      // ✅ Show loading if fetching more
      if (isLoadingMore) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: loadingIndicator(),
        );
      }

      return const SizedBox(); // nothing to show
    });
  }
}