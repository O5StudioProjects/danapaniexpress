import 'package:danapaniexpress/core/common_imports.dart';

class DateRangeSelection extends StatelessWidget {
  const DateRangeSelection({super.key});

  @override
  Widget build(BuildContext context) {
    var filterOrder = Get.find<FilterOrdersController>();
    return Obx((){
      return _buildUI(filterOrder, context);
    });
  }

  _buildUI(filterOrder, context){
    return Row(
      children: [
        _startFromDate(filterOrder, context),
        setWidth(MAIN_VERTICAL_PADDING),
        _toEndDate(filterOrder, context),

      ],
    );
  }

  _startFromDate(filterOrder, context){
    return Expanded(
      child: GestureDetector(
        onTap: ()=> pickDate(context: context, target: filterOrder.startDate),
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
    );
  }

  _toEndDate(filterOrder, context){
    return Expanded(
      child: GestureDetector(
        onTap: ()=> pickDate(context: context, target: filterOrder.endDate),
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
    );
  }

}
