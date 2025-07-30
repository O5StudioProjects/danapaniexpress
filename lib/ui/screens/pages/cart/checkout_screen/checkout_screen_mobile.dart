import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';

import '../../../../app_common/components/delivery_slots_widget.dart';

class CheckoutScreenMobile extends StatelessWidget {
  const CheckoutScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    final checkout = Get.find<CheckoutController>();

    return Obx(() {
      return Container(
        width: size.width,
        height: size.height,
        color: AppColors.backgroundColorSkin(isDark),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            appBarCommon(title: 'Checkout', isBackNavigation: true),
            setHeight(MAIN_VERTICAL_PADDING),
            // Loading indicator
            checkout.getDeliverySlotsStatus.value == Status.LOADING
              ? loadingIndicator()
                : Expanded(child: DeliverySlotsWidget()),

          ],
        ),
      );
    });
  }

}

