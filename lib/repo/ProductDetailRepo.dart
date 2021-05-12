import 'package:rentors/model/productdetail/AllProductModel.dart';
import 'package:rentors/model/productdetail/ProductDetailModel.dart';
import 'package:rentors/repo/FreshDio.dart' as dio;

Future<ProductDetailModel> getProductDetails(id) async {
  var response = await dio.httpClient().get("product/detail/" + id);
  return ProductDetailModel.fromJson(response.data);
}

Future<AppProductModel> getAllProduct(String id, int page) async {
  var response = await dio.httpClient().get(
      "Product/getProductBySubCategory/" + id,
      queryParameters: {"page": page});
  return AppProductModel.fromJson(response.data);
}
