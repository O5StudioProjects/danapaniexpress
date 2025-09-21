import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';
import 'package:danapaniexpress/core/data_model_imports.dart';

class CategorySubcategoryFavoriteSection extends StatelessWidget {
  const CategorySubcategoryFavoriteSection({super.key});

  @override
  Widget build(BuildContext context) {
    final productDetail = Get.find<ProductDetailController>();
    final nav = Get.find<NavigationController>();
    final auth = Get.find<AuthController>();

    return Obx(() {
      final data = productDetail.productData.value;
      return _buildContent(
        data: data!,
        auth: auth,
        nav: nav,
        productDetail: productDetail,
      );
    });
  }

  Widget _buildContent({
    required ProductModel data,
    required AuthController auth,
    required NavigationController nav,
    required ProductDetailController productDetail,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: MAIN_HORIZONTAL_PADDING),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildTextSection(data),
          _buildFavoriteButton(data, auth, nav, productDetail),
        ],
      ),
    );
  }

  Widget _buildTextSection(ProductModel data) => Expanded(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (data.productCategory != null && data.productSubCategory != null)
          appText(
            text: '${data.productCategory} > ${data.productSubCategory}',
            textStyle: secondaryTextStyle().copyWith(
              color: AppColors.secondaryTextColorSkin(isDark).withValues(alpha: 0.7),
            ),
          ),
        appText(
          text: '${AppLanguage.productCodeStr(appLanguage)}${data.productCode?.split('_').last}',
          textDirection: setTextDirection(appLanguage),
          textStyle: secondaryTextStyle().copyWith(
            color: AppColors.secondaryTextColorSkin(isDark).withValues(alpha: 0.7),
          ),
        ),
        if(data.productFavoriteList!.isNotEmpty)
        Row(
          children: [

            appText(
              text: 'In ${data.productFavoriteList?.length.toString()} People\'s ',
              textDirection: setTextDirection(appLanguage),
              textStyle: secondaryTextStyle().copyWith(
                color: AppColors.secondaryTextColorSkin(isDark).withValues(alpha: 0.7),
              ),
            ),
            SizedBox(
              width: 14.0,
              height: 14.0,
              child: appIcon(iconType: IconType.PNG, icon: icHeartFill, color: AppColors.materialButtonSkin(isDark)),
            ),
            appText(text: ' list', textStyle: secondaryTextStyle().copyWith(
            color: AppColors.secondaryTextColorSkin(isDark).withValues(alpha: 0.7),)),

          ],
        )



      ],
    ),
  );

  Widget _buildFavoriteButton(
      ProductModel data,
      AuthController auth,
      NavigationController nav,
      ProductDetailController productDetail,
      ) =>
      Row(
        children: [
          if(data.productFavoriteList!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: appText(text: data.productFavoriteList?.length.toString() ?? '', textStyle: itemTextStyle()),
            ),
          GestureDetector(
            onTap: () async {
              if (auth.currentUser.value == null) {
                nav.gotoSignInScreen();
              } else {
                await productDetail.toggleFavorite(data.productId!);
              }
            },
            child: productDetail.toggleFavoriteStatus.value == Status.LOADING
                ? SizedBox(width: 20.0, height: 20.0, child: loadingIndicator())
                : appIcon(
              iconType: IconType.PNG,
              icon: data.isFavoriteBy(auth.userId.value ?? '') ? icHeartFill : icHeart,
              width: 20.0,
              color: data.isFavoriteBy(auth.userId.value ?? '')
                  ? AppColors.materialButtonSkin(isDark)
                  : AppColors.backgroundColorInverseSkin(isDark),
            ),
          )
        ],
      );
}