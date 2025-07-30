
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
  static String getCoverImages = "$path/cover_img.php/get_cover_img";
  static String getCategories = "$path/get_categories.php/categories";
  static String getCategoryById = "$path/cat_entry.php/get_categorybyID";
  static String getSingleProduct = "$path/get_products.php/get_single_product";
  static String getPopularProducts = "$path/get_products.php/get_popular_products";
  static String getFeaturedProducts = "$path/featured_products.php/get_featured_products";
  static String getFlashSaleProducts = "$path/flashsale_products.php/get_flashsale_products";
  static String getProductsByCategories = "$path/get_products.php/get_products_by_category";
  static String getProductsByCategoriesAndSubCategories = "$path/get_products.php/get_products_by_cat_subcat";
  static String toggleFavorite = "$path/favorites_entry.php/toggle_favorite";
  static String getFavorites = "$path/favorites_entry.php/get_user_favorites";

  static String addToCartWithQuantity = "$path/dpe_cart.php/add_to_cart_w_quantity";
  static String addToCart = "$path/dpe_cart.php/add_to_cart_incr_qty"; //same api is used for quantity increment in Cart Product
  static String decrementQuantityFromCart = "$path/dpe_cart.php/decr_qty_from_cart"; // api is used for quantity decrement in Cart Product
  static String getCart = "$path/dpe_cart.php/get_cart";
  static String deleteCartItem = "$path/dpe_cart.php/delete_from_cart";
  static String emptyCart = "$path/dpe_cart.php/emptyCart";

  static String getDeliveryDaysAndSlots = "https://danapaniexpress.com/rest_api/get_delivery_days.php";


  ///GET APIS
  static String getRegisteredUsers = "$path/register.php/get_users";

}