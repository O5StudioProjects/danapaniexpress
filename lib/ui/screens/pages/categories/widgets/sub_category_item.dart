import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/data_model_imports.dart';

class SubCategoryItem extends StatelessWidget {
  final SubCategoriesModel data;

  const SubCategoryItem({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final itemWidth = constraints.maxWidth;
      final imageSize = itemWidth; // square container
      return _buildUI(imageSize);
    });
  }

  Widget _buildUI(imageSize){
    return  SizedBox(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 🔹 Image Container
          _imageSection(imageSize),
          // 🔹 Text
          _textSection(),
        ],
      ),
    );
  }

  Widget _imageSection(imageSize){
    return  Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        width: imageSize,
        height: imageSize,
        decoration: BoxDecoration(
          color: AppColors.cardColorSkin(isDark),
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(40),
              blurRadius: 6,
              spreadRadius: 1,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.0),
          child: appAsyncImage(
            data.subCategoryImage,
            boxFit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _textSection(){
    return Flexible(
      child: Center(
        child: appText(
          text: subCategoriesNameMultiLangText(data),
          maxLines: 1,
          overFlow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          textStyle: bodyTextStyle().copyWith(
            fontSize: isRightLang
                ? SUB_HEADING_TEXT_BUTTON_FONT_SIZE + 2
                : SUB_HEADING_TEXT_BUTTON_FONT_SIZE,
          ),
        ),
      ),
    );
  }

}