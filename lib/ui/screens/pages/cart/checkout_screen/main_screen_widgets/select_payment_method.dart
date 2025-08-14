import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';

class SelectPaymentMethod extends StatelessWidget {
  final bool isSelected;
  const SelectPaymentMethod({super.key, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    var checkout = Get.find<CheckoutController>();
    return Obx(
          () => _buildUI(checkout),
    );
  }

  Widget _buildUI(checkout){
    return Column(
      children: [
        _headingSection(),
        _selectionButton(checkout),
      ],
    );
  }

  Widget _headingSection(){
    return Padding(
      padding: const EdgeInsets.only(top: MAIN_VERTICAL_PADDING, bottom: MAIN_HORIZONTAL_PADDING),
      child: HomeHeadings(
        mainHeadingText: AppLanguage.paymentMethodStr(appLanguage).toString(),
        isSeeAll: false,
        isTrailingText: false,
      ),
    );
  }

  Widget _selectionButton(checkout){
    return listItemIcon(
      iconType: IconType.ICON,
      leadingIcon: Icons.payment,
      trailingIcon: isSelected ? icRadioButtonSelected : icRadioButton,
      itemTitle: AppLanguage.cashOnDeliveryStr(appLanguage),
      onItemClick: () {
        checkout.cod.value = true;
      },
    );
  }

}
