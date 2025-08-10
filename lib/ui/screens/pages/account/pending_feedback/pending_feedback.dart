import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/ui/screens/pages/account/pending_feedback/pending_feedback_mobile.dart';

class PendingFeedback extends StatelessWidget {
  const PendingFeedback({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: ResponsiveLayout(
          mobileView: buildMobileUI(),
          tabletView: buildTabletUI(),
          desktopView: buildDesktopUI(),
        ),
      ),
    );
  }
}

Widget buildMobileUI() {
  return PendingFeedbackMobile();

}

Widget buildTabletUI() {
  return Container();
}

Widget buildDesktopUI() {
  return Container();
}
