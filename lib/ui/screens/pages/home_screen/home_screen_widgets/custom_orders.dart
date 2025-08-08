import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';

class CustomOrdersBanner extends StatelessWidget {
  const CustomOrdersBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();

    return Obx(() {
      final userId = auth.currentUser.value;

      if (userId == null) {
        return const SizedBox();
      }

      return Padding(
        padding: const EdgeInsets.only(bottom: MAIN_VERTICAL_PADDING),
        child: GestureDetector(
          onTap: () {
            // Your notification dialog code here
           // showCustomDialog(context, AppNotificationDialog(data: data));
          },
          child: SizedBox(
            width: size.width,
            height: size.height * 0.14,
            child: Container(
              color: AppColors.cardColorSkin(isDark),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  clickHere(),
                  customOrderDetail()
                ],
              ),
            )
          ),
        ),
      );
    });

  }
}

Widget clickHere(){
  return Obx(
    ()=> Padding(
      padding: const EdgeInsets.only(top: MAIN_HORIZONTAL_PADDING),
      child: SizedBox(
        width: size.width,
        height: 30.0,
        child: DefaultTextStyle(
          textAlign: TextAlign.center,
          style: buttonTextStyle().copyWith(color: AppColors.sellingPriceTextSkin(isDark)),
          child: AnimatedTextKit(
            repeatForever: true,
            animatedTexts: [
              RotateAnimatedText(AppLanguage.forCustomOrdersStr(appLanguage).toString(), duration: Duration(seconds: 3)),
              RotateAnimatedText(AppLanguage.clickHereStr(appLanguage).toString(), duration: Duration(seconds: 3)),
            ],
            onTap: () {
              print("Tap Event");
            },
          ),
        ),
      ),
    ),
  );
}

Widget customOrderDetail(){
  return Expanded(
    child: Obx(
      ()=> Padding(
        padding: const EdgeInsets.only(left: MAIN_HORIZONTAL_PADDING, right: MAIN_HORIZONTAL_PADDING, top: 0.0, bottom: MAIN_HORIZONTAL_PADDING),
        child: SizedBox(
          width: size.width,
          child: Center(
            child: DefaultTextStyle(
              style: itemTextStyle(),
              textAlign: TextAlign.center,
              child: AnimatedTextKit(
                repeatForever: true,
                animatedTexts: [
                  TyperAnimatedText(AppLanguage.customOrderLongLine1Str(appLanguage).toString(), speed: Duration(milliseconds: 100), textAlign: TextAlign.center),
                  TyperAnimatedText(AppLanguage.customOrderLongLine2Str(appLanguage).toString(), speed: Duration(milliseconds: 100), textAlign: TextAlign.center),
                ],
                onTap: () {
                  print("Tap Event");
                },
              ),
            ),
          ),
        ),
      ),
    ),
  );
}