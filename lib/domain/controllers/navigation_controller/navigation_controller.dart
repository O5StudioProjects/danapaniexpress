import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/data_model_imports.dart';
import 'package:danapaniexpress/data/models/address_model.dart';
import 'package:danapaniexpress/data/repositories/navigation_repository/navigation_repository.dart';

class NavigationController extends GetxController{

  final navigationRepo = NavigationRepository();

  Future<void> gotoSignInScreen() async {
    JumpTo.gotoSignInScreen();
  }
  Future<void> gotoNoInternetScreen({bool isStart = false}) async {
    JumpTo.gotoNoInternetScreen(isStart: isStart);
  }
  Future<void> gotoStartupMainScreen() async {
    JumpTo.gotoStartupMainScreen();
  }
  Future<void> gotoRegisterScreen() async {
    JumpTo.gotoRegisterScreen();
  }

  Future<void> gotoForgotPasswordScreen() async {
    JumpTo.gotoForgotPasswordScreen();
  }

  Future<void> gotoDashboardScreen() async {
    JumpTo.gotoDashboardScreen();
  }

  Future<void> gotoHomeScreen() async {
    JumpTo.gotoHomeScreen();
  }

  Future<void> gotoLanguageThemeScreen({required bool isNavigation, required bool isStart}) async {
    JumpTo.gotoLanguageThemeScreen(isNavigation: isNavigation, isStart: isStart);
  }

  Future<void> gotoProductsScreen({required CategoryModel data, int subCategoryIndex = 0}) async {
    JumpTo.gotoProductsScreen(data: data, subCategoryIndex: subCategoryIndex);
  }

  Future<void> gotoOtherProductsScreen({required ProductsScreenType screenType}) async {
    JumpTo.gotoOtherProductsScreen(productScreenType: screenType);
  }

  Future<void> gotoProductDetailScreen({required ProductModel data}) async {
    JumpTo.gotoProductDetailScreen(data: data);
  }

  /// CHECKOUT SCREENS
  Future<void> gotoCheckoutScreen() async {
    JumpTo.gotoCheckoutScreen();
  }

  Future<void> gotoOrderedPlacedScreen({OrderModel? orderData}) async {
    JumpTo.gotoOrderedPlacedScreen(orderData: orderData);
  }

  /// ACCOUNT SCREENS
  Future<void> gotoAccountInformationScreen() async {
    JumpTo.gotoAccountInformationScreen();
  }
  Future<void> gotoAddressBookScreen({AddressScreenType addressScreenType = AddressScreenType.ADDRESSBOOK}) async {
    JumpTo.gotoAddressBookScreen(addressScreenType: addressScreenType);
  }
  Future<void> gotoAddAddressScreen({required AddressModel? data, CurdType curdType = CurdType.ADD}) async {
    JumpTo.gotoAddAddressScreen(data: data, curdType: curdType);
  }
  Future<void> gotoSettingsScreen() async {
    JumpTo.gotoSettingsScreen();
  }
  Future<void> gotoPrivacyPolicyScreen() async {
    JumpTo.gotoPrivacyPolicyScreen();
  }
  Future<void> gotoTermsConditionsScreen({required bool isStart}) async {
    JumpTo.gotoTermsConditionsScreen(isStart: isStart);
  }
  Future<void> gotoReturnsRefundsScreen() async {
    JumpTo.gotoReturnsRefundsScreen();
  }
  Future<void> gotoLanguageScreen({required bool isNavigation, required bool isStart}) async {
    JumpTo.gotoLanguageScreen(isNavigation: isNavigation, isStart: isStart);
  }



  /// LAUNCH URLS
  Future<void> launchInstagram({url}) async{
    await navigationRepo.launchSocialMediaAppURLIfInstalledEvent(url: url);
  }
  Future<void> launchFacebook({pageUserName}) async{
    await navigationRepo.launchFacebookPage(pageUserName: pageUserName);
  }
  Future<void> launchWhatsApp({phone}) async{
    await navigationRepo.launchWhatsapp(phone: phone);
  }
  Future<void> launchEmail({email}) async{
    await navigationRepo.launchEmail(email: email);
  }
  Future<void> launchPhoneCall({phoneNumber}) async{
    await navigationRepo.launchPhoneCall(phoneNumber: phoneNumber);
  }

}