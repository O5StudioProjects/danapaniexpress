import 'package:danapaniexpress/core/data_model_imports.dart';
import 'package:danapaniexpress/core/common_imports.dart';

class HomeRepository extends HomeDatasource {
  /// GET PAGERS DATA - API
  Future<List<PagerImagesModel>> getPagerItems(String section) async {
    return await getPagerDataApi(section);
  }

  /// GET MARQUEE DATA - API
  Future<MarqueeModel> getMarquee() async {
    return await getMarqueeApi();
  }

  /// GET COVER IMAGES DATA - API
  Future<CoverImagesModel> getCoverImages() async {
    return await getCoverImagesApi();
  }
}