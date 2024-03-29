import 'package:glider/model/category/CategoryDetailModel.dart';
import 'package:glider/model/category/CategoryList.dart';
import 'package:glider/model/category/ConsolidateCategoryDetail.dart';
import 'package:glider/model/category/SubCategoryDetailModel.dart'
    as subCategory;
import 'package:glider/model/home/HomeBean.dart';
import 'package:glider/model/home/Separator.dart';
import 'package:glider/repo/FreshDio.dart' as dio;

Future<CategoryList> getCategoryList() async {
  var response = await dio.httpClient().get("category/");
  return CategoryList.fromJson(response.data);
}

Future getSubCategory() async {
  return Future.delayed(Duration(milliseconds: 50));
}

Future<ConsolidateCategoryDetail> getCategoryDetails(id) async {
  var response =
      await dio.httpClient().get("category/getSubCategoryByCategoryv2/" + id);

  var res = CategoryDetailModel.fromJson(response.data);
  return ConsolidateCategoryDetail(res.data.subCategory,
      await parsedProduct(res.data.products), res.data.sliderImage);
}

Future<List<HomeBean>> parsedProduct(List<Product> product) async {
  var response = List<HomeBean>();
  product.forEach((element) {
    response.add(Separator(element.subCategoryName));
    response.add(element);
  });
  return response;
}

Future<subCategory.SubCategoryDetailModel> getSubCategoryDetail(
    String id, int page) async {
  var response = await dio.httpClient().get(
      "Product/getProductBySubCategory/" + id,
      queryParameters: {"page": page});
  var res = subCategory.SubCategoryDetailModel.fromJson(response.data);
  return res;
}
