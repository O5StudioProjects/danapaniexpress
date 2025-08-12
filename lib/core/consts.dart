
import '../config/res_config/strings_config.dart';

const THEME_TYPE = 'THEMETYPE';
const THEME_VALUE = 'THEMEVALUE';
const LANGUAGE_TYPE = 'LANGUAGETYPE';
const LANGUAGE_SCREEN = 'LANGUAGE_SCREEN';
const STARTUP_SCREEN = 'STARTUP_SCREEN';
const ACCEPT_TERMS = 'ACCEPT_TERMS';
const SERVICE_AREA = 'SERVICE_AREA';
const IS_LOGGED_IN_KEY = 'IS_LOGGED_IN_KEY';
const USER_ID_KEY = 'USER_ID_KEY';
const USER_ID = 'USER_ID';
const AUTH_TOKEN = 'AUTH_TOKEN';
const FLOATING_ACTIVE = 'FLOATING_ACTIVE';
const LANGUAGE_CODE = 'language_code';
const countryCode = 'countryCode';

const FIRST_TIME_SCREEN_OPENED = 'Opened';
const FIRST_TIME_SCREEN_NOT_OPENED = 'Not Opened';

const ALL_ID = 'All';




///TESTING STRINGS
const String jsonAppbarPager = 'assets/json/appbar_pager.json';
const String jsonBodyPager = 'assets/json/body_pager.json';
const String jsonMarquee = 'assets/json/marquee.json';
const String jsonCategories = 'assets/json/categories.json';
const String jsonProducts = 'assets/json/products.json';
const String jsonSingleBannerHomeOne = 'assets/json/single_banner_home_one.json';
const String jsonSingleBannerHomeTwo = 'assets/json/single_banner_home_two.json';
const String jsonCoverImages = 'assets/json/cover_images.json';
const String jsonUsers = 'assets/json/users.json';


///IMAGE PAGER TYPES
class ImagePagerType {
  static const String CATEGORY = 'category';
  static const String PRODUCT = 'product';
  static const String FEATURED = 'featured';
  static const String POPULAR = 'popular';
  static const String FLASH_SALE = 'flash_sale';
}
///IMAGE PAGER SECTIONS
class ImagePagerSections {
  static const String BODY_PAGER = 'body_pager';
  static const String APPBAR_PAGER = 'appbar_pager';
  static const String EVENTS_POPUP = 'events_popup';

}
class SingleBanners {
  static const String BANNER_ONE = 'banner_one';
  static const String BANNER_TWO = 'banner_two';
}

///MARQUEE TYPES
class MarqueeType {
  static const String FEATURED = 'featured';
  static const String POPULAR = 'popular';
  static const String FLASH_SALE = 'flash_sale';
}

///NOTIFIATIONS TYPES
class NotificationsType {
  static const String FEATURED = 'featured';
  static const String FLASH_SALE = 'flash_sale';
}

///ORDER STATUS
class OrderStatus {
  static const String ACTIVE = 'Active';
  static const String CONFIRMED = 'Confirmed';
  static const String COMPLETED = 'Completed';
  static const String CANCELLED = 'Cancelled';
}

class OrdersFilter {
  static const String ORDER_NUMBER = 'Order Number';
  static const String SPECIFIC_DATE = 'Specific Date';
  static const String DATE_RANGE = 'Date Range';
}

class ServiceAreas {
  static const String PUNJAB = 'Punjab';
  static const String SAHIWAL = 'Sahiwal';
  static const String OKARA = 'Okara';
  static const String GUJRAT = 'Gujrat';

}
class PaymentMethods {
  static const String COD = 'Cash on delivery';
}

class Currencies {
  static const String PKR = 'Rs.';
  static const String SAR = 'SAR';
  static const String AED = 'AED';
  static const String USD = 'USD';

}


class EmailSubject{
  static String emailSubject = 'From ${EnvStrings.appNameEng} App';
}

var citiesList = [
  ServiceAreas.SAHIWAL,
  //ServiceAreas.OKARA, ServiceAreas.GUJRAT
];
var provinceList = [
  ServiceAreas.PUNJAB,
  //ServiceAreas.OKARA, ServiceAreas.GUJRAT
];
