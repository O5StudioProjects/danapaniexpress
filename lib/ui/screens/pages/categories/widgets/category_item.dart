import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/data_model_imports.dart';

class CategoryItem extends StatelessWidget {
  final CategoryModel data;

  const CategoryItem({
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
    return SizedBox(
      // height: totalHeight,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 🔹 Image Container
          _imageSection(imageSize),

          // 🔹 Text
          _textSection()
        ],
      ),
    );
  }

  Widget _imageSection(imageSize){
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        width: imageSize,
        height: imageSize,
        decoration: BoxDecoration(
          color: AppColors.cardColorSkin(isDark),
          borderRadius: BorderRadius.circular(12.0),

        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.0),
          child: appAsyncImage(
            data.categoryImage,
            boxFit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _textSection(){
    return SizedBox(
      // height: nameHeight,
      child: Center(
        child: appText(
          text: categoriesNameMultiLangText(data),
          maxLines: 1,
          overFlow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          textStyle: bodyTextStyle().copyWith(
            fontSize: isRightLang
                ? TAGS_FONT_SIZE + 2
                : TAGS_FONT_SIZE,
          ),
        ),
      ),
    );
  }
}