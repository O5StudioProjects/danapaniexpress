import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/data_model_imports.dart';


class SpecialNoteForRider extends StatelessWidget {
  final OrderModel orderData;

  const SpecialNoteForRider({super.key, required this.orderData});

  @override
  Widget build(BuildContext context) {
    return _buildUI();
  }

  _buildUI() {
    return orderData.specialNoteForRider == null || orderData.specialNoteForRider!.isEmpty
        ? SizedBox.shrink()
        : Padding(
      padding: const EdgeInsets.only(top: MAIN_VERTICAL_PADDING),
      child: GestureDetector(
        // onTap: ()=> Get.find<NavigationController>().gotoOrdersFeedbackScreen(orderModel: orderData),
        child: orderDetailSectionsUI(
            titleText: 'Special Note For Rider',
            column:
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: appText(text: orderData.specialNoteForRider.toString(), maxLines: 100,
                            textStyle: bodyTextStyle().copyWith(fontSize: NORMAL_TEXT_FONT_SIZE-2)
                        ),
                      ),
                    ],
                  )
              ],
            )
        ),
      ),
    );
  }



}