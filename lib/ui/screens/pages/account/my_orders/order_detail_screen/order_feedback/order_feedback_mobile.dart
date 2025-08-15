import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/data_model_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';
import 'package:danapaniexpress/core/packages_import.dart';

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
    return _buildUI(orders);
  }

  _buildUI(orders){
    return Obx((){
      return Container(
        width: size.width,
        height: size.height,
        color: AppColors.backgroundColorSkin(isDark),
        child: Column(
          children: [
            _appBar(),

            Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: MAIN_HORIZONTAL_PADDING),
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        _tellUsAboutOurService(),
                        _feedbackItemList(orders),
                        _rateOurRiderHeading(),
                        _ratingBar(orders),
                        _overAllExperienceHeading(),
                        _positiveNegativeFeedback(orders),
                        _divider(),
                        _shareValuableFeedbackHeading(),
                        _feedbackFormField(orders),
                        _feedbackButtonSection(orders),
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

  _appBar(){
    return Padding(
      padding: const EdgeInsets.only(bottom: MAIN_VERTICAL_PADDING),
      child: appBarCommon(title: AppLanguage.orderFeedbackStr(appLanguage), isBackNavigation: true),
    );
  }

  _tellUsAboutOurService(){
    return Padding(
      padding: const EdgeInsets.only(bottom: MAIN_VERTICAL_PADDING),
      child: appText(text: AppLanguage.tellUsAboutOurServiceStr(appLanguage), textStyle: bigBoldHeadingTextStyle().copyWith(fontSize: SECONDARY_HEADING_FONT_SIZE)),
    );
  }

  _feedbackItemList(orders){
    return Obx((){
      var feedbackItemList = [
        FeedbackItemModel(AppLanguage.excellentStr(appLanguage).toString(), icExcellent),
        FeedbackItemModel(AppLanguage.veryGoodStr(appLanguage).toString(), icGood),
        FeedbackItemModel(AppLanguage.neutralStr(appLanguage).toString(), icNeutral),
        FeedbackItemModel(AppLanguage.poorStr(appLanguage).toString(), icPoor),
        FeedbackItemModel(AppLanguage.veryPoorStr(appLanguage).toString(), icVeryPoor),

      ];
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 60),
        child: Column(
          children: List.generate(feedbackItemList.length, (index){
            var item = feedbackItemList[index];
            return  _feedbackListItem(orders, index, item);
          }),
        ),
      );
    });
  }

  _feedbackListItem(orders, index, item){
    return Padding(
      padding: const EdgeInsets.only(bottom: MAIN_HORIZONTAL_PADDING),
      child: GestureDetector(
        onTap: (){
          orders.updateFeedbackIndex(index, item.title);
        },
        child: Row(
          children: [
            appIcon(iconType: IconType.SVG, icon: index != orders.feedbackItemIndex.value ? icRadioButton : icRadioButtonSelected, width: 24.0, color: AppColors.materialButtonSkin(isDark)),
            setWidth(MAIN_VERTICAL_PADDING),
            Expanded(child: appText(text: item.title, textStyle: bodyTextStyle())),
            setWidth(MAIN_VERTICAL_PADDING),
            appIcon(iconType: IconType.PNG, icon: item.icon, width: 24.0)
          ],
        ),
      ),
    );
  }

  _rateOurRiderHeading(){
    return Padding(
      padding: const EdgeInsets.only(top: MAIN_VERTICAL_PADDING, bottom: MAIN_HORIZONTAL_PADDING),
      child: appText(text: AppLanguage.rateOurRiderStr(appLanguage),
          textDirection: setTextDirection(appLanguage),
          textStyle: bigBoldHeadingTextStyle().copyWith(fontSize: SECONDARY_HEADING_FONT_SIZE)),
    );
  }
  _ratingBar(orders){
    return Padding(
      padding: const EdgeInsets.only(bottom: MAIN_VERTICAL_PADDING),
      child: RatingBar.builder(
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
    );
  }

  _overAllExperienceHeading(){
    return Padding(
      padding: const EdgeInsets.only(bottom: MAIN_HORIZONTAL_PADDING),
      child: appText(text: AppLanguage.overallExperienceStr(appLanguage), textStyle: bigBoldHeadingTextStyle().copyWith(fontSize: SECONDARY_HEADING_FONT_SIZE)),
    );
  }

  _positiveNegativeFeedback(orders){
    return  Padding(
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
    );
  }

  _divider(){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: MAIN_VERTICAL_PADDING),
      child: appDivider(),
    );
  }

  _shareValuableFeedbackHeading(){
    return Padding(
      padding: const EdgeInsets.only(bottom: MAIN_HORIZONTAL_PADDING),
      child: appText(text: AppLanguage.pleaseShareYourValuableFeedbackStr(appLanguage),
          maxLines: 100,
          textDirection: setTextDirection(appLanguage),
          textAlign: setTextAlignment(appLanguage),
          textStyle: itemTextStyle()
      ),
    );
  }

  _feedbackFormField(orders){
    return Padding(
      padding: const EdgeInsets.only(bottom: MAIN_VERTICAL_PADDING),
      child: AppTextFormField(
        textEditingController: orders.feedbackTextController.value,
        hintText: AppLanguage.writeYourValuableFeedbackHereStr(appLanguage),
        isDetail: true,
        label: AppLanguage.feedbackStr(appLanguage),
      ),
    );
  }

  _feedbackButtonSection(orders){
    return
      orders.insertFeedbackStatus.value == Status.LOADING
          ? loadingIndicator()
          : appMaterialButton(text: AppLanguage.submitStr(appLanguage), onTap: () async => orders.onSubmitFeedback());
  }

}
