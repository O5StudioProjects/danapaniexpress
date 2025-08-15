import 'package:danapaniexpress/core/common_imports.dart';

class FilterOrdersScreenMobile extends StatelessWidget {
  const FilterOrdersScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    var filterOrder = Get.find<FilterOrdersController>();
    return Obx((){
      return _buildUI(filterOrder);
    });
  }

  Widget _buildUI(filterOrder){
    return Container(
      width: size.width,
      height: size.height,
      color: AppColors.backgroundColorSkin(isDark),
      child: Column(
        children: [
          _appBar(),
          SelectOptionsSection(),
          _divider(),
          Expanded(child: OrdersListSection()),
          /// SHOW BOTTOM MESSAGE / LOADING INDICATOR
          _bottomMessage(filterOrder),
        ],
      ),
    );
  }


  Widget _appBar(){
    return  Padding(
      padding: const EdgeInsets.only(bottom: MAIN_VERTICAL_PADDING),
      child: appBarCommon(title: AppLanguage.searchOrdersStr(appLanguage), isBackNavigation: true),
    );
  }

  Widget _divider(){
    return Padding(
        padding: EdgeInsets.only(
            top: MAIN_HORIZONTAL_PADDING,
            bottom: MAIN_HORIZONTAL_PADDING),
      child: appDivider(),
    );
  }

  Widget _bottomMessage(filterOrder){
    return Obx(() {

      final isLoadingMore = filterOrder.isLoadingMore.value;
      final hasMore = filterOrder.hasMoreOrders.value;
      final reachedEnd = filterOrder.reachedEndOfScroll.value;

      return BottomMessagesSection(
          isLoadingMore: isLoadingMore,
          hasMore: hasMore,
          reachedEnd: reachedEnd,
          message: AppLanguage.noMoreOrdersStr(appLanguage).toString()
      );

    });
  }

}