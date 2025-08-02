import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/core/controllers_import.dart';
import 'package:danapaniexpress/domain/controllers/product_controller/products_controller.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class OtherProductsScreenMobile extends StatelessWidget {
   const OtherProductsScreenMobile({super.key});

   @override
   Widget build(BuildContext context) {
     final products = Get.find<ProductsController>();
     final home = Get.find<HomeController>();
     final otherProductsController = Get.find<OtherProductsController>();
     final navigation = Get.find<NavigationController>();

     return Obx(() {
       final screenType = otherProductsController.productScreenType.value;

       final coverImage = screenType == ProductsScreenType.FEATURED
           ? home.coverImages.value!.featured
           : screenType == ProductsScreenType.FLASHSALE
           ? home.coverImages.value!.flashSale
           : screenType == ProductsScreenType.POPULAR
           ? home.coverImages.value!.popular
           : null ;

       final productsList = screenType == ProductsScreenType.FEATURED
           ? products.featuredProducts
           : screenType == ProductsScreenType.FLASHSALE
           ? products.flashSaleProducts
           : products.popularProducts;

       final screenName = screenType == ProductsScreenType.FEATURED
           ? AppLanguage.featuredProductStr(appLanguage)
           : screenType == ProductsScreenType.FLASHSALE
           ? AppLanguage.flashSaleStr(appLanguage)
           : screenType == ProductsScreenType.POPULAR
           ? AppLanguage.popularProductsStr(appLanguage)
           : null;

       final loadStatus = screenType == ProductsScreenType.FEATURED
           ? products.featuredStatus.value
           : screenType == ProductsScreenType.FLASHSALE
           ? products.flashSaleStatus.value
           : products.popularStatus.value;


       return Column(
         children: [
           // Top Banner
           Obx(() {
             return AnimatedSwitcher(
               duration: const Duration(milliseconds: 250),
               child: otherProductsController.showTopHeader.value
                   ? TopImageHeader(
                 title: screenName!,
                 coverImage: coverImage ?? "",
               )
                   : appBarCommon(
                 title: screenName!,
                 isBackNavigation: true,
                 isTrailing: true,
                 trailingIcon: icSearch,
                 trailingIconType: IconType.SVG,
                 trailingOnTap: ()=> navigation.gotoSearchScreen(),
               ),
             );
           }),

           // Product List
           loadStatus == ProductsStatus.LOADING
               ? Expanded(child: loadingIndicator())
               : loadStatus  == ProductsStatus.FAILURE
               ? Expanded(child: appText(text: 'Error Screen'))
               : productsList.isEmpty
               ? Expanded(child: EmptyScreen(icon: AppAnims.animEmptyBoxSkin(isDark), text: AppLanguage.noProductsStr(appLanguage).toString()))
               : Expanded(
             child: SingleChildScrollView(
               controller: otherProductsController.scrollController,
               physics: BouncingScrollPhysics(),
               child: Padding(
                 padding: const EdgeInsets.symmetric(horizontal: MAIN_HORIZONTAL_PADDING, vertical: MAIN_VERTICAL_PADDING),
                 child: ConstrainedBox(
                   constraints: BoxConstraints(minHeight: size.height),
                   child: StaggeredGrid.count(
                     crossAxisCount: 2,
                     mainAxisSpacing: MAIN_HORIZONTAL_PADDING,
                     crossAxisSpacing: MAIN_HORIZONTAL_PADDING,
                     children:
                     List.generate(productsList.length, (index,) {
                       final product = productsList[index];
                       return GestureDetector(
                         onTap: () =>
                             navigation.gotoProductDetailScreen(data: product),
                         child: ProductItem(data: product),
                       );
                     }),
                   ),

                 ),
               ),
             ),

             // GridView.builder(
             //   controller: otherProductsController.scrollController,
             //   padding: EdgeInsets.symmetric(
             //     horizontal: MAIN_HORIZONTAL_PADDING,
             //     vertical: MAIN_VERTICAL_PADDING,
             //   ),
             //   itemCount: productsList.length,
             //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
             //     crossAxisCount: 2,
             //     crossAxisSpacing: MAIN_HORIZONTAL_PADDING,
             //     mainAxisSpacing: MAIN_VERTICAL_PADDING,
             //     childAspectRatio: 0.53,
             //   ),
             //   itemBuilder: (context, index) {
             //     final product = productsList[index];
             //     return GestureDetector(
             //         onTap: ()=>  navigation.gotoProductDetailScreen(data: product),
             //         child: ProductItem(data: product));
             //   },
             // ),
           ),

           // ✅ Bottom Message Section
           Obx(() {
             final screenType = otherProductsController.productScreenType.value;

             final isLoadingMore = products.isLoadingMore.value;
             final hasMore = screenType == ProductsScreenType.FEATURED
                 ? products.hasMoreFeaturedProducts.value
                 : screenType == ProductsScreenType.FLASHSALE
                 ? products.hasMoreFlashSaleProducts.value
                 : products.hasMoreAllProducts.value;

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
