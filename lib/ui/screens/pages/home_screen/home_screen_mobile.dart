import 'package:danapaniexpress/core/common_imports.dart';

class HomeScreenMobile extends StatelessWidget {
  const HomeScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      ()=> Container(
        height: size.height,
        width: size.width,
        color: AppColors.backgroundColorSkin(isDark),
        child: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: [
            appSliverAppbarHome(),

            SliverToBoxAdapter(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      color: Colors.red,
                      width: size.width,
                      height: 100.0,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      color: Colors.red,
                      width: size.width,
                      height: 100.0,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      color: Colors.red,
                      width: size.width,
                      height: 100.0,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      color: Colors.red,
                      width: size.width,
                      height: 100.0,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      color: Colors.red,
                      width: size.width,
                      height: 100.0,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      color: Colors.red,
                      width: size.width,
                      height: 100.0,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      color: Colors.red,
                      width: size.width,
                      height: 100.0,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      color: Colors.red,
                      width: size.width,
                      height: 100.0,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      color: Colors.red,
                      width: size.width,
                      height: 100.0,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      color: Colors.red,
                      width: size.width,
                      height: 100.0,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      color: Colors.red,
                      width: size.width,
                      height: 100.0,
                    ),
                  ),

                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}
