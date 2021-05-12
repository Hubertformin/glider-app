import 'package:glider/model/category/CategoryDetailModel.dart';
import 'package:glider/model/home/HomeBean.dart';

class ConsolidateCategoryDetail {
  List<SubCategory> subCategory;
  List<HomeBean> products;
  List<SliderImage> sliderImage;

  ConsolidateCategoryDetail(this.subCategory, this.products, this.sliderImage);
}
