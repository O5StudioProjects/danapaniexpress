import 'package:danapaniexpress/core/common_imports.dart';

class OrdersListSection extends StatelessWidget {
  const OrdersListSection({super.key});

  @override
  Widget build(BuildContext context) {
    var filter = Get.find<FilterOrdersController>();
    return _buildUI(filter);
  }

  _buildUI(filter){
    return Obx((){
      var status = filter.ordersStatus.value;
      var orderList = filter.ordersList;
      if (status == Status.LOADING) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            appIcon(iconType: IconType.ANIM, icon: animSearch, width: 150.0),
            setHeight(MAIN_HORIZONTAL_PADDING),
            appText(text: AppLanguage.searchingStr(appLanguage),
                textDirection: setTextDirection(appLanguage),
                textStyle: bodyTextStyle().copyWith(color: AppColors.materialButtonSkin(isDark)))
          ],
        );
      }
      if (status == Status.FAILURE) return ErrorScreen();
      if (orderList.isEmpty) {
        return EmptyScreen(
          icon: AppAnims.animEmptyBoxSkin(isDark),
          iconType: IconType.ANIM,
          text: AppLanguage.ordersNotFoundStr(appLanguage).toString(),
          color: AppColors.materialButtonSkin(isDark),
        );
      }

      return ListView.builder(
        controller: filter.scrollController,
        itemCount: orderList.length,
        shrinkWrap: true,
        padding: const EdgeInsets.only(bottom: MAIN_HORIZONTAL_PADDING, left: MAIN_HORIZONTAL_PADDING, right: MAIN_HORIZONTAL_PADDING),
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, i) {
          final data = orderList[i];
          return OrderItemUI(data: data, isFilterScreen: true, index: i + 1);
        },
      );

    });
  }
}