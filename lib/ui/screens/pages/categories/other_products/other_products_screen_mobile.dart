import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';
import 'package:danapaniexpress/domain/controllers/product_controller/other_products_controller.dart';

class OtherProductsScreenMobile extends StatelessWidget {
   const OtherProductsScreenMobile({super.key});

   @override
   Widget build(BuildContext context) {
     final dashboardController = Get.find<DashBoardController>();
     final otherProductsController = Get.find<OtherProductsController>();

     WidgetsBinding.instance.addPostFrameCallback((_) {
       if (!otherProductsController.scrollController.hasListeners) {
         otherProductsController.initScrollListener(dashboardController);
       }
     });

     return Obx(() {
       final screenType = otherProductsController.productScreenType.value;

       final productsList = screenType == ProductsScreenType.FEATURED
           ? dashboardController.featuredProducts
           : screenType == ProductsScreenType.FLASHSALE
           ? dashboardController.flashSaleProducts
           : dashboardController.popularProducts;

       final screenName = screenType == ProductsScreenType.FEATURED
           ? AppLanguage.featuredProductStr(appLanguage)
           : screenType == ProductsScreenType.FLASHSALE
           ? AppLanguage.flashSaleStr(appLanguage)
           : screenType == ProductsScreenType.POPULAR
           ? AppLanguage.popularProductsStr(appLanguage)
           : null;

       final loadStatus = screenType == ProductsScreenType.FEATURED
           ? dashboardController.featuredStatus.value
           : screenType == ProductsScreenType.FLASHSALE
           ? dashboardController.flashSaleStatus.value
           : dashboardController.popularStatus.value;


       return Column(
         children: [
           // Top Banner
           TopImageHeader(title: screenName!, coverImage: dashboardController.singleBannerTwo.value?.imageUrl ?? ""),
           // Product List
           loadStatus == ProductsStatus.LOADING
               ? Expanded(child: loadingIndicator())
               : loadStatus  == ProductsStatus.FAILURE
               ? Expanded(child: appText(text: 'Error Screen'))
               : productsList.isEmpty
               ? EmptyScreen(icon: AppAnims.animEmptyBoxSkin(isDark), text: AppLanguage.noProductsStr(appLanguage).toString())
               : Expanded(
             child: GridView.builder(
               controller: otherProductsController.scrollController,
               padding: EdgeInsets.symmetric(
                 horizontal: MAIN_HORIZONTAL_PADDING,
                 vertical: MAIN_VERTICAL_PADDING,
               ),
               itemCount: productsList.length,
               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                 crossAxisCount: 2,
                 crossAxisSpacing: MAIN_HORIZONTAL_PADDING,
                 mainAxisSpacing: MAIN_VERTICAL_PADDING,
                 childAspectRatio: 0.6,
               ),
               itemBuilder: (context, index) {
                 final product = productsList[index];
                 return ProductItem(data: product);
               },
             ),
           ),

           // ✅ Bottom Message Section
           Obx(() {
             final screenType = otherProductsController.productScreenType.value;

             final isLoadingMore = dashboardController.isLoadingMore.value;
             final hasMore = screenType == ProductsScreenType.FEATURED
                 ? dashboardController.hasMoreFeatured.value
                 : screenType == ProductsScreenType.FLASHSALE
                 ? dashboardController.hasMoreFlashSale.value
                 : dashboardController.hasMoreAllProducts.value;

             final reachedEnd = otherProductsController.reachedEndOfScroll.value;

             // ✅ Only show when all products are scrolled & no more left
             if (!hasMore && reachedEnd) {
               return Padding(
                 padding: const EdgeInsets.only(bottom: 0),
                 child: appText(text: 'No more products', textStyle: itemTextStyle()),
               );
             }

             // ✅ Show loading if fetching more
             if (isLoadingMore) {
               return Padding(
                 padding: const EdgeInsets.all(16),
                 child: loadingIndicator(),
               );
             }

             return SizedBox(); // nothing to show
           }),

         ],
       );
     });
   }

}
