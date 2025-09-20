import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/data_model_imports.dart';

class RiderSection extends StatelessWidget {
  final OrderModel orderData;

  const RiderSection({super.key, required this.orderData});

  @override
  Widget build(BuildContext context) {
    return _buildUI();
  }

  _buildUI() {
    return orderData.rider == null
        ? SizedBox.shrink()
        : Padding(
      padding: const EdgeInsets.only(top: MAIN_VERTICAL_PADDING),
      child: orderDetailSectionsUI(
          titleText: AppLanguage.riderDetailStr(appLanguage),
          column:
          Column(
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: SizedBox(
                        width: 30.0,
                        height: 30.0,
                        child: (orderData.rider!.riderImage == null || orderData.rider!.riderImage!.isEmpty) ? appAssetImage(image: EnvImages.imgMainLogo) : appAsyncImage(orderData.rider!.riderImage, width: 24.0)),
                  ),
                  setWidth(8.0),
                  Expanded(
                    child: orderDetailItemsFixedUI(
                        titleText: AppLanguage.riderNameStr(appLanguage),
                        detailText: orderData.rider!.riderName
                    ),
                  ),
                ],
              )

            ],
          )
      ),
    );
  }



}