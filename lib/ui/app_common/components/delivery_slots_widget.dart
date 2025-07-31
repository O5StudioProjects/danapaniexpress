import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';


class DeliverySlotsWidget extends StatelessWidget {
  const DeliverySlotsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var checkout = Get.find<CheckoutController>();
    return Column(
      children: [
        // Days horizontal scroll
        Obx(
          ()=> SizedBox(
            height: 60,
            child: ListView.builder(
              padding: const EdgeInsets.only(left: MAIN_HORIZONTAL_PADDING),
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: checkout.deliveryDays.length,
              itemBuilder: (context, index) {
                final day = checkout.deliveryDays[index];
                // final isSelected = index == checkout.selectedDayIndex.value;
                return GestureDetector(
                  onTap: () async => checkout.onTapDayNames(index),
                  child: Obx(
                    ()=> Padding(
                      padding: const EdgeInsets.only(right: MAIN_HORIZONTAL_PADDING),
                      child: Container(
                       // margin: const EdgeInsets.symmetric(horizontal: 8),
                        padding: const EdgeInsets.symmetric(horizontal: MAIN_VERTICAL_PADDING, vertical: MAIN_HORIZONTAL_PADDING),
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
                              text:  index == 0 ? 'Today' : day.dayName,
                              textStyle: tabItemTextStyle(isSelected: index == checkout.selectedDayIndex.value ? true : false)
                            ),
                            appText(
                                text:  day.date,
                                textStyle: secondaryTextStyle().copyWith(fontSize: 12, color: index == checkout.selectedDayIndex.value ? AppColors.materialButtonTextSkin(isDark) : AppColors.secondaryTextColorSkin(isDark))
                            ),
                            // ),
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

        // Slots for selected day
        Obx(() {
          final selectedDay = checkout.deliveryDays[checkout.selectedDayIndex.value];
          final slots = selectedDay.slots;

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: MAIN_HORIZONTAL_PADDING),
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: slots.length,
            itemBuilder: (context, index) {
              final slot = slots[index];
              return Obx(
                ()=> IgnorePointer(
                  ignoring: !slot.isAvailable,
                  child: Opacity(
                    opacity: slot.isAvailable ? 1.0 : 0.5,
                    child: RadioListTile(
                      title: appText(text: slot.slotLabel, textStyle: itemTextStyle()),
                      value: slot.slotId,
                      groupValue: checkout.selectedSlotId.value,
                      onChanged: (value) {
                        checkout.selectedSlotId.value = value as int;
                        print(slot.slotLabel);
                      },
                      activeColor: AppColors.materialButtonSkin(isDark),
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
