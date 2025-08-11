import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/domain/controllers/service_area_controller/service_area_controller.dart';

import '../../../../domain/controllers/navigation_controller/navigation_controller.dart';

class ServiceAreasScreenMobile extends StatelessWidget {
  const ServiceAreasScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    var isStart = Get.arguments[IS_START] as bool;
    return Obx((){
      var nav = Get.find<NavigationController>();
      var serviceArea = Get.find<ServiceAreaController>();
      return Container(
        width: size.width,
        height: size.height,
        color: AppColors.backgroundColorSkin(isDark),
        child: Column(
          children: [
            appBarCommon(
              title: AppLanguage.selectCityStr(appLanguage),
              isBackNavigation: isStart ? false : true,
            ),
            Expanded(
                child: SizedBox(
                  width: size.width,
                  child: Column(
                    crossAxisAlignment: appLanguage == !isRightLang ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      setHeight(24.0),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: MAIN_HORIZONTAL_PADDING),
                        child: appText(
                            text: AppLanguage.availableServiceAreasStr(appLanguage),
                            textStyle: headingTextStyle()),
                      ),
                      setHeight(12.0),
                      showServiceAreaList(),
                      setHeight(24.0),

                    ],
                  ),
                )),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child:
              serviceArea.serviceAreaStatus.value == Status.LOADING
              ? loadingIndicator()
              : appMaterialButton(text: AppLanguage.confirmStr(appLanguage),
                  isDisable: serviceArea.serviceArea.value.isEmpty ? true : false,
                  onTap: () async {
                if(serviceArea.serviceArea.value.isEmpty){
                  showSnackbar(title: AppLanguage.selectCityStr(appLanguage).toString(), message: AppLanguage.cityNotSelectedStr(appLanguage).toString());
                  return;
                } else {
                  await SharedPrefs.setServiceArea(serviceArea.serviceArea.value);
                  if(isStart){
                    serviceArea.onTapConfirm(serviceArea.serviceArea.value);
                  } else {
                    Get.back();
                  }
                }

              }),
            ),
            setHeight(60.0)
          ],
        ),
      );
    });
  }
}


Widget showServiceAreaList() {
  final serviceArea = Get.find<ServiceAreaController>();
  return Obx(
        ()=> Column(
      children: List.generate(citiesList.length, (index) {
        var data = citiesList[index];
        return Padding(padding: const EdgeInsets.only(bottom: 12.0),
          child: listItemIcon(iconType: IconType.ICON ,leadingIcon: Icons.location_on_rounded,
              trailingIcon: serviceArea.serviceArea.value.isNotEmpty ? icRadioButtonSelected : icRadioButton,
              itemTitle: data, onItemClick: (){
              serviceArea.serviceArea.value = data;

              }),
        );
      }),
    ),
  );
}