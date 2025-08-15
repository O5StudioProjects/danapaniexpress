import 'package:danapaniexpress/core/common_imports.dart';

class SpecificDateSelection extends StatelessWidget {
  const SpecificDateSelection({super.key});

  @override
  Widget build(BuildContext context) {
    var filterOrder = Get.find<FilterOrdersController>();
    return Obx(() {
      return _buildUI(filterOrder, context);
    });
  }

  _buildUI(filterOrder, context) {
    return GestureDetector(
      onTap: () => pickDate(context: context, target: filterOrder.selectedDate),
      child: Container(
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.materialButtonSkin(isDark)),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          children: [
            Expanded(
              child: appText(
                text: filterOrder.selectedDate.value.isNotEmpty
                    ? filterOrder.selectedDate.value
                    : AppLanguage.selectDateStr(appLanguage),
                textStyle: itemTextStyle(),
              ),
            ),
            setWidth(MAIN_HORIZONTAL_PADDING),
            appIcon(
              iconType: IconType.ICON,
              icon: Icons.calendar_month_rounded,
              width: 24.0,
              color: AppColors.materialButtonSkin(isDark),
            ),
          ],
        ),
      ),
    );
  }
}
