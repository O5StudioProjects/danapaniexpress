import 'package:danapaniexpress/core/common_imports.dart';

Widget appBarCommon({title, isBackNavigation = false}){
  return Container(
    width: size.width,
    height: 80,
    decoration: BoxDecoration(
      color: AppColors.appBarColorSkin(isDark),
    ),
    child: Padding(
      padding: const EdgeInsets.only(left: MAIN_HORIZONTAL_PADDING, right: MAIN_HORIZONTAL_PADDING, bottom: 8.0),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isBackNavigation
                ? GestureDetector(
                onTap: () async {
                  // Navigator.pop(context);
                  // NavigationBlocHelper.instance.clearTextControllersEvent();
                  // SearchBlocHelper.instance.clearSearchFilterEvent();
                  // ThemeBlocHelper.instance.selectIconEvent(iconSelection: IconSelection.NULL);
                  // Navigator.pop(context);
                  // context.read(context).pop()<HomeBloc>().add(ClearContentFilterEvent());
                },
                child: appSvgIcon(icon: icArrowLeft, color: AppColors.cardColorSkin(isDark), width: 24.0))
                : const SizedBox(width: 24.0,),
            setWidth(12.0),
            Expanded(child:
            appText(text: title, textAlign: TextAlign.center, textStyle: appBarTextStyle())),
            setWidth(12.0),
            const SizedBox(width: 24.0),

          ],
        ),
      ),
    ),
  );
}