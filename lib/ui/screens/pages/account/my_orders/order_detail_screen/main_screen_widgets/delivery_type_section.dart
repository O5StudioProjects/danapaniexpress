import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/data_model_imports.dart';

class DeliveryTypeSection extends StatelessWidget {
  final OrderModel orderData;
  const DeliveryTypeSection({super.key, required this.orderData});

  @override
  Widget build(BuildContext context) {
    return _buildUI();
  }

  _buildUI(){
    return Padding(
      padding: const EdgeInsets.only(top: MAIN_VERTICAL_PADDING),
      child: orderDetailSectionsUI(
          titleText: AppLanguage.deliveryStr(appLanguage),
          column: Column(
            children: [
              orderDetailItemsFixedUI(
                  titleText: AppLanguage.deliveryTypeStr(appLanguage),
                  detailText: orderData.isFlashDelivery == true ? AppLanguage.flashDeliveryStr(appLanguage) : AppLanguage.slotDeliveryStr(appLanguage)
              ),
              if(orderData.isSlotDelivery == true)
                setHeight(8.0),
              if(orderData.isSlotDelivery == true)
                orderDetailItemsFixedUI(
                    titleText: AppLanguage.deliveryDateStr(appLanguage),
                    detailText: orderData.slotDate.toString()
                ),
              if(orderData.isSlotDelivery == true)
                setHeight(8.0),
              if(orderData.isSlotDelivery == true)
                orderDetailItemsFixedUI(
                    titleText: AppLanguage.orderedSlotStr(appLanguage),
                    detailText: orderData.slotLabel
                ),
            ],
          )
      ),
    );
  }
}
