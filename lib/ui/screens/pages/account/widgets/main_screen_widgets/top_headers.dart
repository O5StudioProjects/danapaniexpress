import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';

class TopHeaders extends StatelessWidget {
  const TopHeaders({super.key});

  @override
  Widget build(BuildContext context) {
    var account = Get.find<AccountController>();
    return Obx(() {
      return AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: account.showTopHeader.value
              ?  AccountHeader()
              : AccountHeaderSmall()
      );
    });
  }
}
