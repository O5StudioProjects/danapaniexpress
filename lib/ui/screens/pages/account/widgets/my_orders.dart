import 'package:danapaniexpress/core/common_imports.dart';

import '../account_utils.dart';

class MyOrders extends StatelessWidget {
  const MyOrders({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.only(left: MAIN_HORIZONTAL_PADDING),
        child: Row(
          children: List.generate(orderTabsModelList.length, (index){
            var orderData = orderTabsModelList[index];
            return Padding(
              padding: const EdgeInsets.only(right: MAIN_HORIZONTAL_PADDING, bottom: MAIN_VERTICAL_PADDING),
              child: Container(
                width: size.width * 0.3,
                padding: EdgeInsets.all(MAIN_HORIZONTAL_PADDING),
                decoration: BoxDecoration(
                  color: AppColors.cardColorSkin(isDark),
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(30),
                      blurRadius: 1,
                      spreadRadius: 0,
                      offset: const Offset(1, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    appIcon(iconType: IconType.PNG, icon: orderData.icon, width: 40.0, color: AppColors.materialButtonSkin(isDark)),
                    setHeight(MAIN_HORIZONTAL_PADDING/2),
                    appText(text: appLanguage == URDU_LANGUAGE ? orderData.titleUrdu : orderData.titleEng, textStyle: itemTextStyle())
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
