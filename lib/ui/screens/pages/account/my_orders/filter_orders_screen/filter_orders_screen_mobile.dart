import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/domain/controllers/orders_controller/filter_orders_controller.dart';
import 'package:intl/intl.dart';

import '../widgets/order_item.dart';

class FilterOrdersScreenMobile extends StatelessWidget {
  const FilterOrdersScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    var filterOrder = Get.find<FilterOrdersController>();
    return Obx((){

      return Container(
        width: size.width,
        height: size.height,
        color: AppColors.backgroundColorSkin(isDark),
        child: Column(
          children: [
            appBarCommon(title: AppLanguage.searchOrdersStr(appLanguage), isBackNavigation: true),
            setHeight(MAIN_VERTICAL_PADDING),
            SelectOptionsSection(),
            setHeight(MAIN_HORIZONTAL_PADDING),
            appDivider(),
            setHeight(MAIN_HORIZONTAL_PADDING),
            Expanded(child: OrdersListSection()),
            /// SHOW BOTTOM MESSAGE / LOADING INDICATOR
            Obx(() {

              final isLoadingMore = filterOrder.isLoadingMore.value;
              final hasMore = filterOrder.hasMoreOrders.value;
              final reachedEnd = filterOrder.reachedEndOfScroll.value;

              // ✅ Only show when all products are scrolled & no more left
              if (!hasMore && reachedEnd) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 0),
                  child: Center(
                    child: appText(
                      text: AppLanguage.noMoreOrdersStr(appLanguage),
                      textStyle: itemTextStyle(),
                    ),
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
            }),
          ],
        ),
      );
    });
  }
}

class SelectOptionsSection extends StatelessWidget {
  const SelectOptionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    var filterOrder = Get.find<FilterOrdersController>();
    return Obx((){
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: MAIN_HORIZONTAL_PADDING),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            SizedBox(
              width: size.width,
              child: appText(text: AppLanguage.selectFilterOptionsStr(appLanguage),
                  textDirection: setTextDirection(appLanguage),
                  textAlign: setTextAlignment(appLanguage),
                  textStyle: itemTextStyle()),
            ),
            setHeight(MAIN_VERTICAL_PADDING),
            Row(
              children: [

                GestureDetector(
                  onTap: (){
                    filterOrder.clearFilters();
                    filterOrder.selectedFilterOption.value = OrdersFilter.SPECIFIC_DATE;
                  },
                  child: Row(
                    children: [
                      appIcon(iconType: IconType.SVG, icon: filterOrder.selectedFilterOption.value == OrdersFilter.SPECIFIC_DATE ? icRadioButtonSelected : icRadioButton, width: 20.0, color: AppColors.materialButtonSkin(isDark)),
                      setWidth(8.0),
                      appText(text: AppLanguage.specificDateStr(appLanguage), textStyle: itemTextStyle())
                    ],
                  ),
                ),
                Spacer(),
                GestureDetector(
                  onTap: (){
                    filterOrder.clearFilters();
                    filterOrder.selectedFilterOption.value = OrdersFilter.DATE_RANGE;
                  },
                  child: Row(
                    children: [
                      appIcon(iconType: IconType.SVG, icon: filterOrder.selectedFilterOption.value == OrdersFilter.DATE_RANGE ? icRadioButtonSelected : icRadioButton, width: 20.0, color: AppColors.materialButtonSkin(isDark)),
                      setWidth(8.0),
                      appText(text: AppLanguage.dateRangeStr(appLanguage),textStyle: itemTextStyle())
                    ],
                  ),
                )

              ],
            ),

            if(filterOrder.selectedFilterOption.value == OrdersFilter.SPECIFIC_DATE)
            Padding(
              padding: const EdgeInsets.only(top: MAIN_HORIZONTAL_PADDING),
              child: specificDateSelection(context)
            ),

            if(filterOrder.selectedFilterOption.value == OrdersFilter.DATE_RANGE)
              Padding(
                padding: const EdgeInsets.only(top: MAIN_HORIZONTAL_PADDING),
                child: dateRangeSelection(context)
            ),

            Padding(
              padding: const EdgeInsets.only(top: MAIN_HORIZONTAL_PADDING),
              child: filterOrder.ordersStatus.value == Status.LOADING ? loadingIndicator() : appMaterialButton(text: AppLanguage.searchOrdersStr(appLanguage), onTap:()=> filterOrder.onTapSearchButton()),
            )

          ],
        ),
      );
    });
  }
}

/// ORDERS SECTION LIST
class OrdersListSection extends StatelessWidget {
  const OrdersListSection({super.key});

  @override
  Widget build(BuildContext context) {
    var filter = Get.find<FilterOrdersController>();
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



Widget specificDateSelection(BuildContext context){
  var filterOrder = Get.find<FilterOrdersController>();
  return Obx((){
    return GestureDetector(
      onTap: ()=> _pickDate(context: context, target: filterOrder.selectedDate),
      child: Container(
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
            border: Border.all(color: AppColors.materialButtonSkin(isDark)),
            borderRadius: BorderRadius.circular(8.0)
        ),
        child: Row(
          children: [
            Expanded(child: appText(text: filterOrder.selectedDate.value.isNotEmpty ? filterOrder.selectedDate.value : AppLanguage.selectDateStr(appLanguage), textStyle: itemTextStyle())),
            setWidth(MAIN_HORIZONTAL_PADDING),
            appIcon(iconType: IconType.ICON, icon: Icons.calendar_month_rounded, width: 24.0, color: AppColors.materialButtonSkin(isDark))
          ],
        ),
      ),
    );
  });
}

Widget dateRangeSelection(BuildContext context){
  var filterOrder = Get.find<FilterOrdersController>();
  return Obx((){
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: ()=> _pickDate(context: context, target: filterOrder.startDate),
            child: Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                  border: Border.all(color: AppColors.materialButtonSkin(isDark)),
                  borderRadius: BorderRadius.circular(8.0)
              ),
              child: Row(
                children: [
                  Expanded(child: appText(text: filterOrder.startDate.value.isNotEmpty ? filterOrder.startDate.value : AppLanguage.startFromStr(appLanguage), textStyle: itemTextStyle())),
                  setWidth(MAIN_HORIZONTAL_PADDING),
                  appIcon(iconType: IconType.ICON, icon: Icons.calendar_month_rounded, width: 24.0, color: AppColors.materialButtonSkin(isDark))
                ],
              ),
            ),
          ),
        ),
        setWidth(MAIN_VERTICAL_PADDING),
        Expanded(
          child: GestureDetector(
            onTap: ()=> _pickDate(context: context, target: filterOrder.endDate),
            child: Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                  border: Border.all(color: AppColors.materialButtonSkin(isDark)),
                  borderRadius: BorderRadius.circular(8.0)
              ),
              child: Row(
                children: [
                  Expanded(child: appText(text: filterOrder.endDate.value.isNotEmpty ? filterOrder.endDate.value : AppLanguage.toEndStr(appLanguage), textStyle: itemTextStyle())),
                  setWidth(MAIN_HORIZONTAL_PADDING),
                  appIcon(iconType: IconType.ICON, icon: Icons.calendar_month_rounded, width: 24.0, color: AppColors.materialButtonSkin(isDark))
                ],
              ),
            ),
          ),
        ),

      ],
    );
  });
}




Future<void> _pickDate({
  required BuildContext context,
  required RxString target,
}) async {
  DateTime? picked = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(2000),
    lastDate: DateTime(2100),
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: isDark
              ? ColorScheme.dark(
            primary: EnvColors.accentCTAColorDark,      // Header background
            onPrimary: EnvColors.cardColorDark,         // Header text
            onSurface: EnvColors.primaryTextColorDark,  // Dates text
          )
              : ColorScheme.light(
            primary: EnvColors.primaryColorLight,       // Header background
            onPrimary: EnvColors.cardColorLight,        // Header text
            onSurface: EnvColors.primaryTextColorLight, // Dates text
          ),
          dialogTheme: DialogThemeData(
            backgroundColor: AppColors.backgroundColorSkin(isDark),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12), // optional rounded corners
            ),
          ),
        ),
        child: child!,
      );
    },
  );

  if (picked != null) {
    target.value = DateFormat('yyyy-MM-dd').format(picked);
  }
}

