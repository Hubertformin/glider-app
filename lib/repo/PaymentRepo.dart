import 'package:glider/model/Response.dart';
import 'package:glider/model/StripPaymentSecret.dart';
import 'package:glider/repo/FreshDio.dart' as dio;
import 'package:glider/util/Utils.dart';

Future<StripPaymentSecret> getStripePaymentSecret(
    String packageId, String note) async {
  var body = Map();
  var user = await Utils.getUser();
  body["user_id"] = user.data.id;
  body["package_id"] = packageId;
  body["note"] = note;
  var response = await dio.httpClient().post("paysubsription", data: body);
  return StripPaymentSecret.fromJson(response.data);
}

Future<Response> subscribeFeatureGlider(
    String productId, String subscriptionid, String msg) async {
  var body = Map();
  var user = await Utils.getUser();
  body["product_id"] = productId;
  body["subscription_id"] = subscriptionid;
  body["user_id"] = user.data.id;
  body["details"] = msg;
  var response = await dio.httpClient().post("Subscription/create", data: body);
  return Response.fromJson(response.data);
}

Future<Response> subscribeUser(String subscriptionid, String msg) async {
  var body = Map();
  var user = await Utils.getUser();
  body["package_id"] = subscriptionid;
  body["user_id"] = user.data.id;
  body["details"] = msg;
  var response = await dio
      .httpClient()
      .post("subscription/add_user_subscription", data: body);
  return Response.fromJson(response.data);
}
