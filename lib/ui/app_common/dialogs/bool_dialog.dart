import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';

class AppBoolDialog extends StatefulWidget {
  final String title;
  final String detail;
  final IconType iconType;
  final dynamic icon;
  final dynamic onTapConfirm;
  const AppBoolDialog({super.key, required this.title, required this.detail, this.onTapConfirm, required this.iconType, this.icon});

  @override
  State<AppBoolDialog> createState() => _AppBoolDialogState();
}

class _AppBoolDialogState extends State<AppBoolDialog> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  var dashboardController = Get.find<DashBoardController>();
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
    return ScaleTransition(
        scale: _scaleAnimation,
        child: PopScope(
          canPop: true,
          onPopInvokedWithResult: (onPop, result){
            _controller.reverse().then((_) => Navigator.pop(context));
          },
          child: Dialog(
              shadowColor: Colors.black.withValues(alpha: 0.3),
              backgroundColor: Colors.transparent,

              child:  SizedBox(
                width: size.width,
                height: 300,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.backgroundColorSkin(isDark),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(MAIN_HORIZONTAL_PADDING),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              setHeight(30.0),

                              appText(text: widget.title, textStyle: headingTextStyle()),
                              setHeight(20.0),
                              SizedBox(
                                width: double.infinity,
                                height: 40.0,
                                child: Center(
                                  child: appText(text: widget.detail,
                                      textAlign: TextAlign.center,
                                      maxLines: 2, textStyle: bodyTextStyle()),
                                ),
                              ),
                              setHeight(20.0),
                              appDivider(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  appTextButton(text: 'Confirm',
                                      onTap: widget.onTapConfirm),
                                  appVerticalDivider(),
                                  appTextButton(text: 'Close',
                                      onTap: (){
                                        Navigator.of(context).pop();
                                      })
                                ],
                              )

                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          width: 70.0,
                          height: 70.0,
                          decoration: BoxDecoration(
                            color: whiteColor,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.backgroundColorSkin(isDark),
                              width: 2.0,
                            ),
                          ),
                          child: ClipOval(
                            child: appAssetImage(
                              image: EnvImages.imgMainLogo,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
          ),
        )
    );
  }
}