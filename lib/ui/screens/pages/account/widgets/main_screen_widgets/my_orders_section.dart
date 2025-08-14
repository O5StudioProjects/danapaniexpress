import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';

class MyOrdersSection extends StatelessWidget {
  const MyOrdersSection({super.key});

  @override
  Widget build(BuildContext context) {
    var auth = Get.find<AuthController>();
    var nav = Get.find<NavigationController>();
      return Obx((){
        if(auth.currentUser.value != null){
          return _buildUI(auth, nav);
        } else {
          return SizedBox.shrink();
        }
      });
  }

  Widget _buildUI(auth, nav){
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: MAIN_VERTICAL_PADDING),
          child: HomeHeadings(
            mainHeadingText: AppLanguage.myOrdersStr(appLanguage).toString(),
            isSeeAll: true,
            isTrailingText: true,
            trailingText: AppLanguage.viewAllOrdersStr(appLanguage).toString(),
            onTapSeeAllText: ()=> nav.gotoOrdersScreen(),
          ),
        ),
        MyOrders(ordersScreen: false,),
      ],
    );
  }
}
