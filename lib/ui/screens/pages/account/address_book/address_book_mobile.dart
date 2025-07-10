import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';
import 'package:danapaniexpress/data/models/address_model.dart';

class AddressBookMobile extends StatelessWidget {
  const AddressBookMobile({super.key});

  @override
  Widget build(BuildContext context) {
    var navigation = Get.find<NavigationController>();
    var auth = Get.find<AuthController>();
    return Obx(() {
      var addressList = auth.currentUser.value!.addressBook!;
      return Scaffold(
        backgroundColor: AppColors.backgroundColorSkin(isDark),
        body: Column(
          children: [
            appBarCommon(title: 'Address Book', isBackNavigation: true),


            Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Obx((){
                  return Column(
                    children: [
                      setHeight(MAIN_VERTICAL_PADDING),
                      HomeHeadings(
                        mainHeadingText: 'Default Shipping Address',
                        isTrailingText: false,
                        isSeeAll: false,
                      ),
                      setHeight(MAIN_VERTICAL_PADDING),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: MAIN_HORIZONTAL_PADDING),
                        child: AddressItemUI(data: auth.currentUser.value!.userDefaultAddress!),
                      ),
                      appDivider(),

                      HomeHeadings(
                        mainHeadingText: 'My Other Addresses',
                        isTrailingText: false,
                        isSeeAll: false,
                      ),

                      Padding(
                        padding: const EdgeInsets.all(MAIN_HORIZONTAL_PADDING),
                        child: Column(
                          children: List.generate(addressList.length, (index) {
                            var data = addressList[index];
                            return AddressItemUI(data: data);
                          }),
                        ),
                      ),
                    ],
                  );
                })
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(
                left: MAIN_HORIZONTAL_PADDING,
                right: MAIN_HORIZONTAL_PADDING,
                bottom: MAIN_VERTICAL_PADDING,
              ),
              child: appMaterialButton(
                customWidget: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    appIcon(
                      iconType: IconType.ICON,
                      icon: Icons.add,
                      color: AppColors.materialButtonTextSkin(isDark),
                    ),
                    //setWidth(MAIN_HORIZONTAL_PADDING),
                    appText(
                      text: 'Add New Address',
                      textStyle: buttonTextStyle(
                        color: AppColors.materialButtonTextSkin(isDark),
                      ),
                    ),
                  ],
                ),
                onTap: () => navigation.gotoAddAddressScreen(),
              ),
            ),
          ],
        ),
      );
    });
  }
}

class AddressItemUI extends StatelessWidget {
  final AddressModel data;

  const AddressItemUI({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    var logoSpaceSize = size.width * 0.15;

    return Obx(
      ()=> Padding(
        padding: const EdgeInsets.only(bottom: MAIN_HORIZONTAL_PADDING),
        child: Container(
          width: size.width,
          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: MAIN_HORIZONTAL_PADDING),
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
                    appText(text: '${data.address}, ${data.nearestPlace}, ${data.city}, ${data.province}, ${data.postalCode}',maxLines: 5, textStyle: secondaryTextStyle()),

                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
