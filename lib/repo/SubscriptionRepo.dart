import 'package:glider/model/FeatureSubscriptionList.dart';
import 'package:glider/model/SubscriptionList.dart';
import 'package:glider/model/subscription/CheckSubscriptionModel.dart';
import 'package:glider/repo/FreshDio.dart' as dio;
import 'package:glider/util/Utils.dart';

Future<FeatureSubscriptionList> getFeatureSubscriptionList() async {
  var response =
      await dio.httpClient().get("Subscription/get_feature_subscription");
  return FeatureSubscriptionList.fromJson(response.data);
}

Future<SubscriptionList> getSubscriptionList() async {
  var user = await Utils.getUser();
  var response = await dio
      .httpClient()
      .get("subscription/get_subscription_list/" + user.data.id);
  return SubscriptionList.fromJson(response.data);
}

Future<CheckSubscriptionModel> checkSubscription() async {
  var user = await Utils.getUser();
  var response = await dio
      .httpClient()
      .get("subscription/check_user_subscription/" + user.data.id);
  return CheckSubscriptionModel.fromJson(response.data);
}
