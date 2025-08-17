import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';
import 'package:danapaniexpress/core/data_model_imports.dart';

class ProductDetailImageSection extends StatelessWidget {
  const ProductDetailImageSection({super.key});

  @override
  Widget build(BuildContext context) {
    var productDetail = Get.find<ProductDetailController>();
    return Obx((){
      final data = productDetail.productData.value;
      return SizedBox(
        width: size.width,
        height: size.height * 0.444,
        child: Stack(
          children: [
            Container(
              width: size.width,
              height: size.height * 0.44,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(imgProductBackground),
                  fit: BoxFit.cover,
                ),
              ),
              child: _centerImageForProductsUI(data: data!),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                width: size.width,
                height: 20.0,
                decoration: BoxDecoration(
                  color: AppColors.backgroundColorSkin(isDark),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(26.0),
                    topRight: Radius.circular(26.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
  Widget _centerImageForProductsUI({required ProductModel data}) {
    return Container(
      width: size.width,
      height: size.height * 0.45,
      decoration: BoxDecoration(color: Colors.black.withAlpha(50)),
      child: Stack(
        children: [
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Container(
                color: whiteColor,
                width: size.width * 0.6,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: appAsyncImage(data.productImage, boxFit: BoxFit.cover),
                ),
              ),
            ),
          ),
          Positioned(
            top: 10.0,
            left: MAIN_HORIZONTAL_PADDING,
            child: appFloatingButton(
              icon: icArrowLeft,
              onTap: () => Get.back(),
            ),
          ),
          if (data.productCutPrice != null)
            Positioned(
              bottom: MAIN_HORIZONTAL_PADDING + 20.0,
              right: MAIN_HORIZONTAL_PADDING,
              child: Container(
                width: 50.0,
                height: 50.0,
                decoration: BoxDecoration(
                  color: AppColors.floatingButtonSkin(isDark),
                  borderRadius: BorderRadius.circular(100.0),
                ),
                child: Center(
                  child: appText(
                    text:
                    '-${calculateDiscount(data.productCutPrice!, data.productSellingPrice!)}%',
                    textStyle: sellingPriceTextStyle().copyWith(
                      color: whiteColor,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}