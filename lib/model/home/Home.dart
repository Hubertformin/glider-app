import 'package:glider/model/home/HomeBean.dart';
import 'package:glider/model/home/HomeModel.dart';

class Home {
  List<HomeSliderImage> homeSliderImage;
  List<dynamic> category;
  List<FeaturedProductElement> featuredProducts;
  List<HomeBean> products;
  List<dynamic> sliderImage;

  Home(this.homeSliderImage, this.category, this.featuredProducts,
      this.products, this.sliderImage);
}
