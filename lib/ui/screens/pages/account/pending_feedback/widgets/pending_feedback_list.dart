import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';

class PendingFeedbackList extends StatelessWidget {
  const PendingFeedbackList({super.key});

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
