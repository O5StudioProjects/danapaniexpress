import 'dart:async';

import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';
import 'package:danapaniexpress/ui/app_common/components/animate_logo.dart';

class AppFloatingIcon extends StatefulWidget {
  const AppFloatingIcon({super.key, });

  @override
  State<AppFloatingIcon> createState() => _AppFloatingIconState();
}

class _AppFloatingIconState extends State<AppFloatingIcon> {
  bool changeAnim = false;
  late Offset position; // Starting position of the draggable widget
  double avtSize = 80.0; // Size of the draggable widget

  void updatePosition(Offset newPosition) {
    setState(() {
      // Clamp the widget position to keep it within the boundaries
      position = Offset(
        newPosition.dx.clamp(0.0, size.width - avtSize),
        newPosition.dy.clamp(0.0, size.height- BOTTOM_NAV_BAR_SIZE - avtSize),
        // context.read<HomeBloc>().state.dbVersion == DBVersion.DOWNLOADABLE
        //     ? newPosition.dy.clamp(0.0, size.height- (BOTTOM_NAV_BAR_SIZE + 48.0) - avtSize)
        //     : newPosition.dy.clamp(0.0, size.height- BOTTOM_NAV_BAR_SIZE - avtSize),
      );
    });
  }

  changeAnimation(){
    if(mounted){
      setState(() {
        changeAnim = true;
      });
    }

  }

  @override
  void initState() {
    Timer(const Duration(seconds: 10), changeAnimation);
    avtSize = 80.0;
    position = Offset(0, size.height - avtSize - BOTTOM_NAV_BAR_SIZE);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: position.dx,
      top: position.dy,
      child: GestureDetector(
        onPanUpdate: (detail){
          Offset newPosition = position + detail.delta;
          updatePosition(newPosition);
          // context.read<HomeBloc>().add(UpdateAvtPosition(newPosition, screenWidth, screenHeight-100.0, avtSize));
        },
        onTap: ()=> Get.find<NavigationController>().gotoCustomerServiceScreen(),
        child: SizedBox(
            width: avtSize,
            height: avtSize,
            child: SizedBox(
                width: avtSize,
                child: AppAnimatedLogo()
            )
        ),
      ),
    );
  }
}