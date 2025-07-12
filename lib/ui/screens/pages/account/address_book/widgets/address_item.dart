import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/data_model_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';

class AddressItemUI extends StatelessWidget {
  final AddressModel data;
  final bool isDefault;

  const AddressItemUI({super.key, required this.data, this.isDefault = false});

  @override
  Widget build(BuildContext context) {
    var logoSpaceSize = size.width * 0.15;
    var navigation = Get.find<NavigationController>();

    return Obx((){
      return GestureDetector(
        onTap: ()=> navigation.gotoAddAddressScreen(data: data, curdType: CurdType.UPDATE),
        child: Padding(
          padding: const EdgeInsets.only(bottom: MAIN_HORIZONTAL_PADDING),
          child: Stack(
            children: [
              Container(
                width: size.width,
                padding: EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: MAIN_HORIZONTAL_PADDING,
                ),
                decoration: BoxDecoration(
                  color: AppColors.cardColorSkin(isDark),
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(30),
                      blurRadius: 2,
                      spreadRadius: 0,
                      offset: const Offset(1, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: logoSpaceSize,
                      height: logoSpaceSize,
                      child: appIcon(
                        iconType: IconType.ICON,
                        icon: Icons.location_on_rounded,
                        width: 34.0,
                        color: AppColors.materialButtonSkin(isDark),
                      ),
                    ),
                    setWidth(8.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          appText(text: data.name, textStyle: itemTextStyle()),
                          setHeight(2.0),
                          appText(text: data.phone, textStyle: itemTextStyle()),
                          setHeight(4.0),
                          appText(
                            text:
                            '${data.address}, ${data.nearestPlace}, ${data.city}, ${data.province}, ${data.postalCode}',
                            maxLines: 5,
                            textStyle: secondaryTextStyle(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if(isDefault)
                Positioned(
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.materialButtonSkin(isDark),
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(12.0),
                          bottomLeft: Radius.circular(12.0)

                      ),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: MAIN_HORIZONTAL_PADDING,
                      vertical: 2.0,
                    ),
                    child: appText(text: AppLanguage.defaultStr(appLanguage), textStyle: itemTextStyle().copyWith(color: AppColors.materialButtonTextSkin(isDark))),
                  ),
                ),
            ],
          ),
        ),
      );
    });
  }
}