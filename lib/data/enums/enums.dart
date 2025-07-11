
enum Flavor { dev, prod, rider }
enum AdsStatus {ADS_ENABLED, ADS_DISABLED, SUBSCRIBED}

enum IconType {
  ANIM,
  PNG,
  SVG,
  ICON,
  URL
}

enum AppbarPagerImagesStatus {
  IDLE, LOADING, SUCCESS, FAILURE
}
enum BodyPagerImagesStatus {
  IDLE, LOADING, SUCCESS, FAILURE
}
enum MarqueeStatus {
  IDLE, LOADING, SUCCESS, FAILURE
}
enum CoverImagesStatus {
  IDLE, LOADING, SUCCESS, FAILURE
}
enum SingleBannerOneStatus {
  IDLE, LOADING, SUCCESS, FAILURE
}

enum SingleBannerTwoStatus {
  IDLE, LOADING, SUCCESS, FAILURE
}

enum HomeSingleBanner {
  ONE, TWO
}

enum CategoriesStatus { IDLE, LOADING, SUCCESS, FAILURE }
enum ProductsStatus { IDLE, LOADING, SUCCESS, FAILURE }
enum OtherProductsStatus { IDLE, LOADING, SUCCESS, FAILURE }
enum ProductFilterType {
  all,
  featured,
  flashSale,
  popular,
}

enum ProductsByCatStatus { IDLE, LOADING, SUCCESS, FAILURE }

enum ProductsScreenType {
  CATEGORIES, FEATURED, FLASHSALE, POPULAR
}

enum AuthStatus {IDLE, LOADING, SUCCESS, FAILURE}

enum CurdType {ADD, UPDATE, READ, DELETE}