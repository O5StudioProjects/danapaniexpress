import 'package:danapaniexpress/core/common_imports.dart';

class SelectOptionsSection extends StatelessWidget {
  const SelectOptionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    var filterOrder = Get.find<FilterOrdersController>();
    return Obx((){
      return _buildUI(filterOrder);
    });
  }

  Widget _buildUI(filterOrder){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: MAIN_HORIZONTAL_PADDING),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          _mainHeading(),

          _selectOptionsTitle(filterOrder),

          _optionSelectors(filterOrder),

          _searchButton(filterOrder)

        ],
      ),
    );
  }

  Widget _mainHeading(){
    return  Padding(
      padding: const EdgeInsets.only(bottom: MAIN_VERTICAL_PADDING),
      child: SizedBox(
        width: size.width,
        child: appText(text: AppLanguage.selectFilterOptionsStr(appLanguage),
            textDirection: setTextDirection(appLanguage),
            textAlign: setTextAlignment(appLanguage),
            textStyle: itemTextStyle()),
      ),
    );
  }

  _selectOptionsTitle(filterOrder){
    return Row(
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
    );
  }

  _optionSelectors(filterOrder){
    if(filterOrder.selectedFilterOption.value == OrdersFilter.SPECIFIC_DATE){
      return Padding(
          padding: const EdgeInsets.only(top: MAIN_HORIZONTAL_PADDING),
          child: SpecificDateSelection()
      );
    }
    if(filterOrder.selectedFilterOption.value == OrdersFilter.DATE_RANGE){
      return Padding(
          padding: const EdgeInsets.only(top: MAIN_HORIZONTAL_PADDING),
          child: DateRangeSelection()
      );
    }
  }

  _searchButton(filterOrder){
    return Padding(
      padding: const EdgeInsets.only(top: MAIN_HORIZONTAL_PADDING),
      child: filterOrder.ordersStatus.value == Status.LOADING ? loadingIndicator() : appMaterialButton(text: AppLanguage.searchOrdersStr(appLanguage), onTap:()=> filterOrder.onTapSearchButton()),
    );
  }


}