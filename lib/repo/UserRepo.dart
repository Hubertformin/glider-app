import 'package:glider/model/Response.dart';
import 'package:glider/model/UserDetail.dart';
import 'package:glider/model/UserModel.dart';
import 'package:glider/repo/FreshDio.dart' as dio;
import 'package:glider/util/Utils.dart';

Future<UserDetail> getUserDetail() async {
  UserModel model = await Utils.getUser();
  String id = model.data.id;
  var response = await dio.httpClient().get("profile/detail/$id");
  return UserDetail.fromJson(response.data);
}

Future<Response> updateUserDetails(body) async {
  UserModel model = await Utils.getUser();
  String id = model.data.id;
  var response = await dio.httpClient().put("profile/update/$id", data: body);
  return Response.fromJson(response.data);
}
