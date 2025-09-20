import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';

class SelectDeliveryType extends StatelessWidget {
  const SelectDeliveryType({super.key});

  @override
  Widget build(BuildContext context) {
    return buildUI();
  }

  Widget buildUI(){
    var checkout = Get.find<CheckoutController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _headingAndInfoButton(),
        _deliveryButtonsUI(checkout),
        _slitDeliveryListSection(checkout),
      ],
    );
  }

  Widget _headingAndInfoButton(){
    return Padding(
      padding: const EdgeInsets.only(left: MAIN_HORIZONTAL_PADDING, right: MAIN_HORIZONTAL_PADDING, top: MAIN_VERTICAL_PADDING, bottom: MAIN_HORIZONTAL_PADDING),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          appText(text: AppLanguage.selectDeliveryStr(appLanguage), textStyle: headingTextStyle()),
          setWidth(8.0),
          GestureDetector(
              onTap: ()=> showCustomDialog(gContext, AppDeliveryInfoDialog()),
              child: appIcon(iconType: IconType.ICON, icon: Icons.info_rounded, width: 20.0, color: AppColors.secondaryTextColorSkin(isDark)))
        ],
      ),
    );
  }

  Widget _deliveryButtonsUI(CheckoutController checkout){
    return Padding(
      padding: const EdgeInsets.only(left: MAIN_HORIZONTAL_PADDING, right: MAIN_HORIZONTAL_PADDING, bottom: MAIN_HORIZONTAL_PADDING),
      child: Row(
        children: [
          _flashDeliveryButton(checkout),
          setWidth(8.0),
          _slotDeliveryButton(checkout),
        ],
      ),
    );
  }

  Widget _flashDeliveryButton(CheckoutController checkout){
    return Expanded(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: listItemIcon(
          iconType: IconType.PNG,
          leadingIcon: icFlashSale,
          trailingIcon: checkout.flashDelivery.value
              ? icRadioButtonSelected
              : icRadioButton,
          itemTitle: AppLanguage.flashStr(appLanguage),
          onItemClick: () {
            checkout.flashDelivery.value = true;
            checkout.slotDelivery.value = false;
          },
        ),
      ),
    );
  }

  Widget _slotDeliveryButton(CheckoutController checkout){
    return Expanded(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: listItemIcon(
          iconType: IconType.ICON,
          leadingIcon: Icons.calendar_month_rounded,
          trailingIcon: checkout.slotDelivery.value
              ? icRadioButtonSelected
              : icRadioButton,
          itemTitle: AppLanguage.slotStr(appLanguage),
          onItemClick: () {
            checkout.slotDelivery.value = true;
            checkout.flashDelivery.value = false;
            checkout.fetchDeliveryDaysWithSlots();
          },
        ),
      ),
    );
  }

  Widget _slitDeliveryListSection(CheckoutController checkout){
    return Obx((){
      return checkout.slotDelivery.value == true
          ? checkout.getDeliverySlotsStatus.value == Status.LOADING
          ? loadingIndicator()
          : DeliverySlotsWidget()
          : SizedBox.shrink();
    });

  }

}
