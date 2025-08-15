import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/data_model_imports.dart';

class OrderStatusSection extends StatelessWidget {
  final OrderModel orderData;
  const OrderStatusSection({super.key, required this.orderData});

  @override
  Widget build(BuildContext context) {
    return _buildUI(orderData);
  }

  _buildUI(orderData){
    return Obx(() {
      final statusTextColor = getStatusTextColor(orderData.orderStatus!);
      final statusBgColor = getStatusBgColor(orderData.orderStatus!);

      return orderDetailSectionsUI(
        titleText: AppLanguage.orderStatusStr(appLanguage),
        column: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            orderDetailItemsFixedUI(
              titleText: AppLanguage.currentStatusStr(appLanguage),
              detailText: orderData.orderStatus,
              detailColor: statusTextColor,
              detailBgColor: statusBgColor,
            ),
            setHeight(8.0),
            appDivider(),
            setHeight(8.0),
            _statusRow(
              dateTime: orderData.orderPlacedDateTime,
              label: AppLanguage.orderPlacedStr(appLanguage).toString(),
              status: orderData.orderStatus!,
              dotColor: EnvColors.offerHighlightColorDark,
            ),
            setHeight(8.0),
            _statusRow(
              dateTime: orderData.orderConfirmedDateTime,
              label: AppLanguage.confirmedStr(appLanguage).toString(),
              status: orderData.orderStatus!,
              dotColor: EnvColors.accentCTAColorLight,
            ),
            setHeight(8.0),
            _statusRow(
              dateTime: orderData.orderCompletedDateTime,
              label:  AppLanguage.completedStr(appLanguage).toString(),
              status: orderData.orderStatus!,
              dotColor: EnvColors.primaryColorLight,
            ),
            if(orderData.orderCancelledDateTime != null)
              setHeight(8.0),
            if(orderData.orderCancelledDateTime != null)
              _statusRow(
                dateTime: orderData.orderCancelledDateTime,
                label:  AppLanguage.cancelledStr(appLanguage).toString(),
                status: orderData.orderStatus!,
                dotColor: EnvColors.specialFestiveColorLight,
              ),
          ],
        ),
      );
    });
  }

  Widget _statusRow({
    required String? dateTime,
    required String label,
    required String status,
    required Color dotColor,
  }) {
    final isPending = dateTime == null || dateTime.isEmpty;
    final isCancel = (dateTime == null || dateTime.isEmpty) && status == OrderStatus.CANCELLED;
    final title = isCancel ? AppLanguage.orderCancelledStr(appLanguage) : isPending ? AppLanguage.pendingStr(appLanguage) :  formatDateTime(dateTime);
    final titleColor = AppColors.primaryTextColorSkin(isDark).withValues(alpha: isPending ? 0.6 : 1.0);
    final detailColor = AppColors.primaryTextColorSkin(isDark).withValues(alpha: isPending ? 0.4 : 1.0);
    final indicatorColor = isPending ? AppColors.cardColorSkin(isDark) : dotColor;

    return isRightLang
        ? Row(
      children: [
        Container(
          width: 20.0,
          height: 20.0,
          decoration: BoxDecoration(
            color: indicatorColor,
            borderRadius: BorderRadius.circular(100),
          ),
        ),
        setWidth(8.0),
        Expanded(
          child: orderDetailItemsFixedUI(
              titleText: title,
              detailText: label,
              titleColor: titleColor,
              detailColor: detailColor,
              isDate: true
          ),
        ),
      ],
    )
        : Row(
      children: [
        Expanded(
          child: orderDetailItemsFixedUI(
            titleText: title,
            detailText: label,
            titleColor: titleColor,
            detailColor: detailColor,
          ),
        ),
        setWidth(8.0),
        Container(
          width: 20.0,
          height: 20.0,
          decoration: BoxDecoration(
            color: indicatorColor,
            borderRadius: BorderRadius.circular(100),
          ),
        ),
      ],
    );
  }



}

