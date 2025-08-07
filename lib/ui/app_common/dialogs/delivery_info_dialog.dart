import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';

import '../../../data/models/pager_image_model.dart';

class AppDeliveryInfoDialog extends StatefulWidget {
  const AppDeliveryInfoDialog({super.key});

  @override
  State<AppDeliveryInfoDialog> createState() => _AppDeliveryInfoDialogState();
}

class _AppDeliveryInfoDialogState extends State<AppDeliveryInfoDialog> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late TabController _tabController;
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
    _tabController = TabController(length: 2, vsync: this);

    // Start the animation on dialog open
    _controller.forward();

  }
  @override
  void dispose() {
    _tabController.dispose();
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
            backgroundColor:AppColors.cardColorSkin(isDark),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child:  Padding(
              padding: const EdgeInsets.only( top: MAIN_HORIZONTAL_PADDING,bottom: MAIN_HORIZONTAL_PADDING, right: 8.0, left: 8.0),
              child:  Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /// TABS HERE
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.backgroundColorSkin(isDark),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      padding: EdgeInsets.zero,
                      dividerColor: Colors.transparent,
                      indicatorWeight: 0.0,
                      indicatorPadding: EdgeInsets.zero,
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicator: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      labelColor: AppColors.primaryTextColorSkin(isDark),
                      unselectedLabelColor: AppColors.disableMaterialButtonSkin(isDark).withValues(alpha: 0.5),
                      labelStyle: bodyTextStyle().copyWith(fontWeight: FontWeight.w800),
                      tabs:  [
                        Tab(text: AppLanguage.flashDeliveryStr(appLanguage)),
                        Tab(text: AppLanguage.slotDeliveryStr(appLanguage)),
                      ],
                    ),
                  ),

                  setHeight(16.0),

                  /// Tab Views
                  SizedBox(
                    height: 300, // Adjust based on your content
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        /// Flash Delivery content
                        SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: appText(
                              text: AppLanguage.flashDeliveryInfo(appLanguage),
                              maxLines: 100,
                              textStyle: bodyTextStyle().copyWith(
                                fontSize: NORMAL_TEXT_FONT_SIZE-2
                              ),
                            ),
                          ),
                        ),

                        /// Slot Delivery content
                        SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: appText(
                              text: AppLanguage.slotDeliveryInfo(appLanguage),
                              maxLines: 100,
                              textStyle: bodyTextStyle().copyWith(
                                  fontSize: NORMAL_TEXT_FONT_SIZE-2
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  setHeight(MAIN_VERTICAL_PADDING),

                  /// Close button
                  setHeight(MAIN_VERTICAL_PADDING),
                  appTextButton(text: AppLanguage.closeStr(appLanguage), onTap: (){
                    Navigator.of(context).pop();
                  })
                ],
              )

            )
        ),
      )
    );
  }
}