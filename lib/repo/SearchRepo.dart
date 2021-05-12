import 'package:glider/model/SearchModel.dart';
import 'package:glider/repo/FreshDio.dart' as dio;

Future<SearchModel> searchResult(String query) async {
  var map = Map();
  map["value"] = query;
  var response = await dio.httpClient().post("product/search", data: map);
  return SearchModel.fromJson(response.data);
}
