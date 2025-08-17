import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';

class ShowLanguageList extends StatelessWidget {
  const ShowLanguageList({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildUI();
  }

  Widget _buildUI(){
    var themeController = Get.put(ThemeController());

    return Obx(
          ()=> Column(
        children: List.generate(languageList.length, (index) {
          var data = languageList[index];
          return Padding(padding: const EdgeInsets.only(bottom: 12.0),
            child: listItemIcon(iconType: IconType.ICON ,leadingIcon: Icons.language_rounded,

                trailingIcon: data == appLanguage ? icRadioButtonSelected : icRadioButton,

                itemTitle: data, onItemClick: (){
                  themeController.changeLanguage(language: data);
                }),
          );
        }),
      ),
    );
  }
}
