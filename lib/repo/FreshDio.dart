import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:glider/model/UserModel.dart';
import 'package:glider/repo/LoginRepo.dart';
import 'package:glider/util/CommonConstant.dart';
import 'package:glider/util/Utils.dart';

BaseOptions options = new BaseOptions(
  baseUrl: CommonConstant.baseURL,
  connectTimeout: 1000 * 60,
  receiveTimeout: 1000 * 60,
);

var _freshDio = new Dio(options);

Dio httpClient() {
  _freshDio.interceptors.add(PrettyDioLogger(
    requestHeader: !kReleaseMode,
    requestBody: !kReleaseMode,
    responseBody: !kReleaseMode,
  ));
  _freshDio.interceptors.add(HeaderInterceptor());
  return _freshDio;
}

class HeaderInterceptor extends Interceptor {
  @override
  Future onRequest(RequestOptions options) async {
    Map<String, String> headers = Map();
    headers["Client-Service"] = "frontend-client";
    headers["Auth-Key"] = "simplerestapi";
    UserModel model = await Utils.getUser();
    if (model != null) {
      headers["User-ID"] = model.data.id;
      headers["Token"] = model.data.token;
    }
    options.headers.addAll(headers);
    return super.onRequest(options);
  }

  @override
  Future onResponse(Response response) {
    if (response.data['status'] == 401) {
      sessionExpired.value = true;
    } else {
      sessionExpired.value = false;
    }

    return super.onResponse(response);
  }

  @override
  Future onError(DioError err) {
    return super.onError(err);
  }
}
