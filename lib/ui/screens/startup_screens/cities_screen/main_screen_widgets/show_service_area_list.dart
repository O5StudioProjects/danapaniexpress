import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';

class ShowServiceAreaList extends StatelessWidget {
  const ShowServiceAreaList({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildUI();
  }

  Widget _buildUI(){
    final serviceArea = Get.find<ServiceAreaController>();
    return Obx(
          ()=> Column(
        children: List.generate(citiesList.length, (index) {
          var data = citiesList[index];
          return Padding(padding: const EdgeInsets.only(bottom: 12.0),
            child: listItemIcon(iconType: IconType.ICON ,leadingIcon: Icons.location_on_rounded,
                trailingIcon: serviceArea.serviceArea.value.isNotEmpty ? icRadioButtonSelected : icRadioButton,
                itemTitle: data, onItemClick: (){
                  serviceArea.serviceArea.value = data;

                }),
          );
        }),
      ),
    );
  }
}
