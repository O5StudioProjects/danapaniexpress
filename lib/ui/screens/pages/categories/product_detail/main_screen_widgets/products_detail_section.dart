import 'package:danapaniexpress/core/common_imports.dart';

class ProductsDetailLoading extends StatelessWidget {
  const ProductsDetailLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx((){
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          loadingIndicator(),
          setHeight(MAIN_VERTICAL_PADDING),
          appText(
            text: AppLanguage.loadingStr(appLanguage),
            textStyle: bodyTextStyle().copyWith(
              color: AppColors.materialButtonSkin(isDark),
              fontSize: SUB_HEADING_TEXT_BUTTON_FONT_SIZE,
            ),
          ),
        ],
      );
    });
  }
}