import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';

class EventsDialog extends StatefulWidget {
  final MarqueeModel data;
  const EventsDialog({super.key, required this.data});

  @override
  State<EventsDialog> createState() => _EventsDialogState();
}

class _EventsDialogState extends State<EventsDialog> with SingleTickerProviderStateMixin {
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
        canPop: true,
        onPopInvokedWithResult: (onPop, result){
          _controller.reverse().then((_) => Navigator.pop(context));
        },
        child: Dialog(
            shadowColor: data.dialogImage.isNotEmpty ? Colors.transparent : Colors.black.withValues(alpha: 0.3),
            backgroundColor: data.dialogImage.isNotEmpty ? Colors.transparent : AppColors.backgroundColorSkin(isDark),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child:  Padding(
              padding: const EdgeInsets.all(0.0),
              child: data.dialogImage.isNotEmpty
                  ? Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    clipBehavior: Clip.antiAlias,
                    constraints: BoxConstraints(maxWidth: size.width),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0)
                    ),
                    child: GestureDetector(
                        onTap: (){
                          Navigator.of(context).pop();
                          home.onTapTopNotificationDialog(widget.data);
                        } ,
                        child: appAsyncImage(data.dialogImage, boxFit: BoxFit.fitWidth, )),
                  ),
                  setHeight(MAIN_VERTICAL_PADDING),
                  appFloatingButton(iconType: IconType.ICON, icon: Icons.close, onTap: (){
                    Navigator.of(context).pop();
                  }),
                ],
              )
                  : Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  appIcon(iconType: IconType.ANIM, icon: AppAnims.animNotificationSkin(isDark), width: 70.0),
                  setHeight(20.0),
                  appText(text: appLanguage == URDU_LANGUAGE ? data.marqueeTitleUrdu : data.marqueeTitleEnglish, textStyle: headingTextStyle()),
                  setHeight(8.0),
                  appText(text: appLanguage == URDU_LANGUAGE ? data.marqueeDetailUrdu : data.marqueeDetailEnglish,
                      textAlign: TextAlign.center,
                      maxLines: 100, textStyle: bodyTextStyle()),
                  setHeight(20.0),
                  appDivider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      appTextButton(text:
                      AppLanguage.visitStr(appLanguage),
                          onTap: (){
                            Navigator.of(context).pop();
                            home.onTapTopNotificationDialog(widget.data);
                          }),
                      appTextButton(text: AppLanguage.closeStr(appLanguage),
                          onTap: (){
                            Navigator.of(context).pop();
                          })
                    ],
                  )

                ],
              ),
            )
        ),
      )
    );
  }
}