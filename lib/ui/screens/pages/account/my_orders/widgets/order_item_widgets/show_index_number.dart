import 'package:danapaniexpress/core/common_imports.dart';

class ShowIndexNumber extends StatelessWidget {
  final int index;
  const ShowIndexNumber({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return Obx((){
      return SizedBox(
        width: 30,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                padding: EdgeInsets.symmetric(horizontal: 2.0,vertical: 2.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  //   color: AppColors.materialButtonSkin(isDark)
                ),
                child: Center(child: appText(text: index.toString(), textStyle: itemTextStyle().copyWith(
                    fontSize: isRightLang ? NORMAL_TEXT_FONT_SIZE :  NORMAL_TEXT_FONT_SIZE-2
                ))))
          ],
        ),
      );
    });
  }
}