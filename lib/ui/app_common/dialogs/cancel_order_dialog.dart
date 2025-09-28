
import 'package:danapaniexpress/core/controllers_import.dart';

import '../../../core/common_imports.dart';

class CancelOrderDialog extends StatefulWidget {

  final TextEditingController? textEditingControl;
  final dynamic onTapConfirm;
  final Rx<Status> status;
  const CancelOrderDialog({super.key,this.onTapConfirm,this.textEditingControl, required this.status});

  @override
  State<CancelOrderDialog> createState() => _CancelOrderDialogState();
}

class _CancelOrderDialogState extends State<CancelOrderDialog> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  // var dashboardController = Get.find<DashBoardController>();
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
    Get.find<OrdersController>().reasonForCancelTag.value = '';
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

              child:  Container(
                padding: EdgeInsets.all(MAIN_HORIZONTAL_PADDING),
                decoration: BoxDecoration(
                  color: AppColors.backgroundColorSkin(isDark),
                  borderRadius: BorderRadius.circular(12.0)
                ),
                child: Obx((){
                  return SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        appText(text: AppLanguage.cancelOrderStr(appLanguage), textStyle:  headingTextStyle()),
                       _appDivider(),
                        appText(text: AppLanguage.writeReasonToCancelOrderStr(appLanguage), textStyle:  itemTextStyle().copyWith(color: AppColors.materialButtonSkin(isDark))),
                        _reasonTags(),
                        if(Get.find<OrdersController>().reasonForCancelTag.value == AppLanguage.othersStr(appLanguage))
                        Padding(
                          padding: const EdgeInsets.only(top: MAIN_HORIZONTAL_PADDING),
                          child: AppTextFormField(
                            textEditingController: widget.textEditingControl,
                            hintText: AppLanguage.moreDetailedReasonToCancelOrderStr(appLanguage),
                            isDetail: true,
                            maxLines: 8,
                          ),
                        ),
                    
                        setHeight(20.0),
                        appDivider(),
                        widget.status.value == Status.LOADING
                            ? loadingIndicator()
                            : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            appTextButton(text: AppLanguage.confirmStr(appLanguage),
                                onTap: widget.onTapConfirm),
                            appVerticalDivider(),
                            appTextButton(text: AppLanguage.closeStr(appLanguage),
                                onTap: (){
                                  Navigator.of(context).pop();
                                })
                          ],
                        )
                      ],
                    ),
                  );
                }),
              )
          ),
        )
    );
  }

  _reasonTags(){
    var order = Get.find<OrdersController>();
    return Obx((){
      var reasonTagsList = [
        AppLanguage.changeOfMindStr(appLanguage).toString(),
        AppLanguage.notNeededStr(appLanguage).toString(),
        AppLanguage.iOrderedMistakenlyStr(appLanguage).toString(),
        AppLanguage.othersStr(appLanguage).toString()
      ];
      return Padding(
        padding: const EdgeInsets.only(top: MAIN_HORIZONTAL_PADDING),
        child: Column(
          children: List.generate(reasonTagsList.length, (index){
            var isSelected = order.reasonForCancelTag.value == reasonTagsList[index];
            return Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: GestureDetector(
                onTap: (){
                  order.reasonForCancelTag.value = reasonTagsList[index];
                },
                child: Row(
                  children: [
                    appIcon(iconType: IconType.SVG, icon: isSelected ? icRadioButtonSelected : icRadioButton, width: 24.0,
                        color: isSelected ? AppColors.materialButtonSkin(isDark) : AppColors.materialButtonTextSkin(isDark)),
                    setWidth(8.0),
                    Expanded(child: appText(text: reasonTagsList[index], textStyle: itemTextStyle()))
                  ],
                ),
              ),
            );
          }),
        ),
      );
    });
  }

  _appDivider(){
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: appDivider(),
    );
  }

}