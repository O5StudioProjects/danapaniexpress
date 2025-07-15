
import 'package:danapaniexpress/config/flavor_config.dart';

class APiEndpoints {
  static String path = "${AppConfig.baseUrl}${AppConfig.apiPath}";
  ///POST APIS
  static String registerUser = "$path/register.php/create_user";
  static String addUserAddress = "$path/register.php/add_address";
  static String loginUser = "$path/login.php/login";
  static String getUserProfile = "$path/login.php/get_profile";
  static String logoutUser = "$path/login.php/logout";
  static String updateAddress = "$path/update_address.php/update_address";
  static String deleteAddress = "$path/delete_address.php/delete_address";
  static String updateUserImage = "$path/update_user.php/upload_user_image";
  static String deleteUserImage = "$path/update_user.php/delete_user_image";
  static String updateUserInfo = "$path/update_user.php/update_user";
  static String getPagerData = "$path/pager.php/get_pager_data";
  static String getMarquee = "$path/marquee_slider.php/get_marquee";

  ///GET APIS
  static String getRegisteredUsers = "$path/register.php/get_users";

}