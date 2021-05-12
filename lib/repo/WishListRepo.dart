import 'package:glider/model/Response.dart';
import 'package:glider/model/UserModel.dart';
import 'package:glider/model/wishlist/WishList.dart';
import 'package:glider/repo/FreshDio.dart' as dio;
import 'package:glider/util/Utils.dart';

Future<WishList> getWishList() async {
  UserModel model = await Utils.getUser();
  String id = model.data.id;
  var response = await dio.httpClient().get("WishList/detail/$id");
  return WishList.fromJson(response.data);
}

Future<Response> like(String productId) async {
  UserModel model = await Utils.getUser();
  String id = model.data.id;
  var body = Map();
  body["product_id"] = productId;
  body["user_id"] = id;
  var response = await dio.httpClient().post("WishList/create", data: body);
  return Response.fromJson(response.data);
}

Future<Response> unlike(String productId) async {
  UserModel model = await Utils.getUser();
  String id = model.data.id;
  var body = Map();
  body["product_id"] = productId;
  body["user_id"] = id;
  var response = await dio.httpClient().put("WishList/delete/$id", data: body);
  return Response.fromJson(response.data);
}
