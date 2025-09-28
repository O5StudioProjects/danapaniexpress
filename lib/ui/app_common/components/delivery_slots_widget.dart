import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';
import 'package:intl/intl.dart';

class DeliverySlotsWidget extends StatelessWidget {
  const DeliverySlotsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var checkout = Get.find<CheckoutController>();

    return Column(
      children: [
        // Days horizontal scroll
        Obx(
              () => SizedBox(
            height: 70,
            child: ListView.builder(
              padding: const EdgeInsets.only(left: MAIN_HORIZONTAL_PADDING),
              scrollDirection: Axis.horizontal,
              itemCount: checkout.deliveryDays.length,
              itemBuilder: (context, index) {
                final day = checkout.deliveryDays[index];
                return GestureDetector(
                  onTap: () async => checkout.onTapDayNames(index),
                  child: Obx(
                        () => Padding(
                      padding: const EdgeInsets.only(right: MAIN_HORIZONTAL_PADDING),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: MAIN_VERTICAL_PADDING,
                            vertical: MAIN_HORIZONTAL_PADDING),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: index == checkout.selectedDayIndex.value
                              ? AppColors.materialButtonSkin(isDark)
                              : AppColors.cardColorSkin(isDark),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            appText(
                              text: index == 0 ? AppLanguage.todayStr(appLanguage) : day.dayName,
                              textStyle: tabItemTextStyle(
                                  isSelected: index == checkout.selectedDayIndex.value),
                            ),
                            appText(
                              text: day.date,
                              textStyle: secondaryTextStyle().copyWith(
                                fontSize: 12,
                                color: index == checkout.selectedDayIndex.value
                                    ? AppColors.materialButtonTextSkin(isDark)
                                    : AppColors.secondaryTextColorSkin(isDark),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),

        const SizedBox(height: 16),
        setHeight(MAIN_HORIZONTAL_PADDING),

        HomeHeadings(
          mainHeadingText: AppLanguage.selectAvailableSlotsStr(appLanguage).toString(),
          isSeeAll: false,
          isTrailingText: false,
        ),
        setHeight(MAIN_HORIZONTAL_PADDING),

        // Slots for selected day
        Obx(() {
          final selectedDay = checkout.deliveryDays[checkout.selectedDayIndex.value];
          final slots = selectedDay.slots;

          // Parse selected day's date string
          final selectedDate = DateFormat('yyyy-MM-dd').parse(selectedDay.date);
          final isToday = DateTime.now().year == selectedDate.year &&
              DateTime.now().month == selectedDate.month &&
              DateTime.now().day == selectedDate.day;

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: MAIN_HORIZONTAL_PADDING),
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: slots.length,
            itemBuilder: (context, index) {
              final slot = slots[index];

              // Disable only today's past slots
              if (isToday) {
                final now = DateTime.now();
                final endTime = DateFormat('HH:mm:ss').parse(slot.endTime);
                final slotEndDateTime = DateTime(
                  selectedDate.year,
                  selectedDate.month,
                  selectedDate.day,
                  endTime.hour,
                  endTime.minute,
                );
                slot.isAvailable = slot.isAvailable && slotEndDateTime.isAfter(now);
              }

              return Obx(
                    () => IgnorePointer(
                  ignoring: !slot.isAvailable,
                  child: Opacity(
                    opacity: slot.isAvailable ? 1.0 : 0.4,
                    child: RadioGroup<int>(
                      groupValue: checkout.selectedSlotId.value,
                      onChanged: (value) {
                        checkout.selectedSlotId.value = value!;
                        checkout.selectedSlotLabel.value = slot.slotLabel;
                        checkout.selectedSlotDate.value = selectedDay.date;
                        print(checkout.selectedSlotLabel.value);
                      },
                      child: RadioListTile(
                        title: slot.isAvailable
                            ? Row(
                          children: [
                            appText(
                              text: slot.slotLabel,
                              textStyle: itemTextStyle(),
                            ),
                            setWidth(8.0),
                            appText(
                              text: AppLanguage.availableStr(appLanguage),
                              textStyle: itemTextStyle().copyWith(
                                color: AppColors.materialButtonSkin(isDark),
                              ),
                            )
                          ],
                        )
                            : appText(
                          text:
                          '${slot.slotLabel} ${AppLanguage.bookedStr(appLanguage)}',
                          textStyle: itemTextStyle(),
                        ),
                        value: slot.slotId,
                        activeColor: AppColors.materialButtonSkin(isDark),
                      ),
                    ),
                  ),
                ),
              );

            },
          );
        }),
      ],
    );
  }
}
