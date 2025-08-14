import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';

class AccountScreenMobile extends StatelessWidget {
  const AccountScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    var account = Get.find<AccountController>();
    var orders = Get.find<OrdersController>();

    WidgetsBinding.instance.addPostFrameCallback((callback){
      orders.getActiveOrdersCount();
    });

    return Obx((){
      return Container(
          width: size.width,
          height: size.height,
          color: AppColors.backgroundColorSkin(isDark),
          child: Column(
            children: [
              /// TOP HEADER
              TopHeaders(),
              Expanded(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  controller: account.scrollController,
                  child: Column(
                    crossAxisAlignment: isRightLang
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      setHeight(MAIN_VERTICAL_PADDING),
                      MyOrdersSection(),

                      /// PENDING FEEDBACK SECTION
                      OrdersFeedbackSection(),

                      /// MY PROFILE SECTION
                      MyProfileSection(),

                      /// LEGAL SECTION
                      PrivacySecuritySection(),

                      /// SUPPORT SECTION
                     SupportSection(),

                      /// SOCIAL MEDIA SECTION
                      SocialMediaSection(),

                      /// LOGIN/LOGOUT
                      LoginLogoutSection()
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}
