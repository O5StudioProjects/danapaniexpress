import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/data_model_imports.dart';
import 'package:danapaniexpress/domain/controllers/orders_controller/orders_controller.dart';
import 'package:danapaniexpress/ui/screens/pages/account/my_orders/order_detail_screen/order_feedback/feedback_utils.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class OrderFeedbackMobile extends StatelessWidget {
  const OrderFeedbackMobile({super.key});

  @override
  Widget build(BuildContext context) {
    var orders = Get.find<OrdersController>();
    var orderData = Get.arguments[DATA_ORDER] as OrderModel;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      orders.selectedOrder.value = orderData;
      orders.updateFeedbackIndex(10, '');
    });
    return Obx((){
      return Container(
        width: size.width,
        height: size.height,
        color: AppColors.backgroundColorSkin(isDark),
        child: Column(
          children: [
            appBarCommon(title: 'Order Feedback', isBackNavigation: true),
            setHeight(MAIN_VERTICAL_PADDING),
            Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: MAIN_HORIZONTAL_PADDING),
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        appText(text: 'Tell us about our service?', textStyle: bigBoldHeadingTextStyle().copyWith(fontSize: SECONDARY_HEADING_FONT_SIZE)),
                        setHeight(MAIN_VERTICAL_PADDING),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 60),
                          child: Column(
                            children: List.generate(feedbackItemList.length, (index){
                              var item = feedbackItemList[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: MAIN_HORIZONTAL_PADDING),
                                child: GestureDetector(
                                  onTap: (){
                                    orders.updateFeedbackIndex(index, item.titleEnglish);
                                  },
                                  child: Row(
                                    children: [
                                      appIcon(iconType: IconType.SVG, icon: index != orders.feedbackItemIndex.value ? icRadioButton : icRadioButtonSelected, width: 24.0, color: AppColors.materialButtonSkin(isDark)),
                                      setWidth(MAIN_VERTICAL_PADDING),
                                      Expanded(child: appText(text: isRightLang ? item.titleUrdu : item.titleEnglish, textStyle: bodyTextStyle())),
                                      setWidth(MAIN_VERTICAL_PADDING),
                                      appIcon(iconType: IconType.PNG, icon: item.icon, width: 24.0)
                                    ],
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                        setHeight(MAIN_VERTICAL_PADDING),

                        appText(text: 'Rate our rider!', textStyle: bigBoldHeadingTextStyle().copyWith(fontSize: SECONDARY_HEADING_FONT_SIZE)),
                        setHeight(MAIN_HORIZONTAL_PADDING),
                        RatingBar.builder(
                      initialRating: 0,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) async {
                        print(rating);
                        orders.riderRating.value = rating;
                      },
                    ),
                        setHeight(MAIN_VERTICAL_PADDING),

                        appText(text: 'Overall Experience', textStyle: bigBoldHeadingTextStyle().copyWith(fontSize: SECONDARY_HEADING_FONT_SIZE)),
                        setHeight(MAIN_HORIZONTAL_PADDING),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 50),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: (){
                                  orders.isPositive.value = true;
                                  orders.isNegative.value = false;
                                },
                                child: SizedBox(
                                    width: 40.0,
                                    height: 40.0,
                                    child: Center(
                                        child: appIcon(iconType: IconType.PNG, icon: orders.isPositive.value ? icLikeFilled : icLike, color: orders.isPositive.value ? AppColors.materialButtonSkin(isDark) : AppColors.primaryTextColorSkin(isDark))
                                    )
                                ),
                              ),
                              Spacer(),
                              GestureDetector(
                                onTap: (){
                                  orders.isPositive.value = false;
                                  orders.isNegative.value = true;
                                },
                                child: SizedBox(
                                    width: 40.0,
                                    height: 40.0,
                                    child: Center(
                                        child: appIcon(iconType: IconType.PNG, icon: orders.isNegative.value ? icDislikeFilled : icDislike, color: orders.isNegative.value ? AppColors.materialButtonSkin(isDark) : AppColors.primaryTextColorSkin(isDark))
                                    )
                                ),
                              )
                            ],
                          ),
                        ),

                        setHeight(MAIN_VERTICAL_PADDING),
                        appDivider(),
                        setHeight(MAIN_VERTICAL_PADDING),
                        appText(text: 'Please share your valuable feedback about our service, product quality, app experience, rider behavior, or any concerns. Your input helps us improve. Thank you!',
                        maxLines: 100,
                            textDirection: setTextDirection(appLanguage),
                            textAlign: setTextAlignment(appLanguage),
                            textStyle: itemTextStyle()
                        ),
                        setHeight(MAIN_HORIZONTAL_PADDING),
                        AppTextFormField(
                          textEditingController: orders.feedbackTextController.value,
                          hintText: 'Write your valuable feedback here...',
                          isDetail: true,
                          label: 'Feedback',

                        ),
                        setHeight(MAIN_VERTICAL_PADDING),
                        orders.insertFeedbackStatus.value == Status.LOADING
                        ? loadingIndicator()
                        : appMaterialButton(text: 'Submit', onTap: () async => orders.onSubmitFeedback()),
                        setHeight(MAIN_VERTICAL_PADDING),

                      ],
                    ),
                  ),
                )
            )
          ],
        ),
      );
    });
  }
}
