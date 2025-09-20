import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/data_model_imports.dart';

class AddressSection extends StatelessWidget {
  final OrderModel orderData;

  const AddressSection({super.key, required this.orderData});

  @override
  Widget build(BuildContext context) {
    return _buildUI();
  }

  _buildUI() {
    return Padding(
      padding: const EdgeInsets.only(top: MAIN_VERTICAL_PADDING),
      child: orderDetailSectionsUI(
          titleText: AppLanguage.shippingAddressStr(appLanguage),
          column: Column(
            children: [
              appText(text: '${orderData.shippingAddress}', maxLines: 50,
                  textStyle: bodyTextStyle().copyWith(fontSize: NORMAL_TEXT_FONT_SIZE-2)
              ),
              setHeight(8.0),
              orderDetailItemsFixedUI(
                  titleText: AppLanguage.shippingStr(appLanguage),
                  detailText: orderData.shippingMethod!
              ),
            ],
          )
      ),
    );
  }



}