import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';

import '../../../data/models/pager_image_model.dart';

class AppEventsDialog extends StatefulWidget {
  final PagerImagesModel? data;
  const AppEventsDialog({super.key, required this.data});

  @override
  State<AppEventsDialog> createState() => _AppEventsDialogState();
}

class _AppEventsDialogState extends State<AppEventsDialog> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  var home = Get.find<HomeController>();
  @override
  void initState() {

    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    // Start the animation on dialog open
    _controller.forward();

  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    var data = widget.data;
    return ScaleTransition(
      scale: _scaleAnimation,
      child: PopScope(
        canPop: false,
        // onPopInvokedWithResult: (onPop, result){
        //   _controller.reverse().then((_) => Navigator.pop(context));
        // },
        child: Dialog(
            shadowColor: Colors.black.withValues(alpha: 0.3),
            backgroundColor:AppColors.cardColorSkin(isDark),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child:  Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: MAIN_HORIZONTAL_PADDING, bottom: MAIN_HORIZONTAL_PADDING),
              child:  Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Container(
                          width: 40.0,
                          height: 40.0,
                          decoration: BoxDecoration(
                              color: AppColors.backgroundColorSkin(isDark),
                              borderRadius: BorderRadius.circular(100),
                            border: Border.all(color: AppColors.materialButtonSkin(isDark))
                          ),
                          child: appAssetImage(image: EnvImages.imgMainLogo,)),
                      setWidth(8.0),
                      Expanded(child: appText(text: AppLanguage.welcomeToAppNameStr(appLanguage),
                          maxLines: 2,
                          textAlign: setTextAlignment(appLanguage),
                          textDirection: setTextDirection(appLanguage),
                          textStyle: headingTextStyle().copyWith(color: AppColors.materialButtonSkin(isDark)))),

                    ],
                  ),


                  setHeight(MAIN_HORIZONTAL_PADDING),
                  Container(
                    height: 450.0,
                    clipBehavior: Clip.antiAlias,
                    constraints: BoxConstraints(maxWidth: size.width),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0)
                    ),
                    child: GestureDetector(
                        onTap: (){
                          Navigator.of(context).pop();
                          home.onTapTopNotificationEventDialog(widget.data!);
                        } ,
                        child: appAsyncImage(data!.imageUrl, boxFit: BoxFit.cover, )),
                  ),
                  setHeight(MAIN_VERTICAL_PADDING),
                  Row(
                    children: [
                      Expanded(
                        child: appMaterialButton(
                            text: AppLanguage.closeStr(appLanguage),
                            onTap: (){
                              Navigator.of(context).pop();
                            }
                        ),
                      ),
                      setWidth(MAIN_HORIZONTAL_PADDING),
                      Expanded(
                        child: appMaterialButton(
                          text: AppLanguage.visitStr(appLanguage),
                          onTap: (){
                            Navigator.of(context).pop();
                            home.onTapTopNotificationEventDialog(widget.data!);
                          }
                        ),
                      ),


                    ],
                  )
                ],
              )

            )
        ),
      )
    );
  }
}