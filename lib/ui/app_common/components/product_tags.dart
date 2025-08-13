import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/data_model_imports.dart';

class ProductTags extends StatelessWidget {
  final Color? color;
  final bool isTopRight;
  final String tagText;
  final bool isLeftPadding;
  const ProductTags({super.key, this.color, this.isTopRight = true, required this.tagText, required this.isLeftPadding});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: isLeftPadding ? 5.0 : 0.0, right: !isLeftPadding ? 5.0 : 0.0),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 8.0,
          vertical: 4.0,
        ),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.only(
            topRight: isTopRight ? Radius.circular(4.0) : Radius.zero,
            topLeft: !isTopRight ? Radius.circular(4.0) : Radius.zero,
            bottomRight: Radius.circular(0.0),
          ),
        ),
        child: appText(
          text: tagText,
          textStyle: itemTextStyle().copyWith(color: whiteColor),
        ),
      ),
    );
  }
}
