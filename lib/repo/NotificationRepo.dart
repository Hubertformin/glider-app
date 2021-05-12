import 'package:glider/model/NotificationModel.dart';
import 'package:glider/model/UserModel.dart';
import 'package:glider/repo/FreshDio.dart' as dio;
import 'package:glider/util/Utils.dart';

Future<NotificationModel> getNotification() async {
  UserModel model = await Utils.getUser();
  String id = model.data.id;
  var response = await dio.httpClient().get("Notification/detail/$id");
  return NotificationModel.fromJson(response.data);
}
