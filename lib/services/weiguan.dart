import 'dart:io';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:cookie_jar/cookie_jar.dart';

import '../config.dart';
import '../factory.dart';
import 'weiguan_api_mock.dart';

part 'weiguan.g.dart';

@JsonSerializable()
@immutable
class WgApiResponse {
  static const int codeResponseError = -2;
  static const int codeRequestError = -1;
  static const int codeOk = 0;

  final int code;
  final String message;
  final Map<String, dynamic> data;

  WgApiResponse({
    this.code = codeOk,
    this.message = "",
    this.data,
  });

  factory WgApiResponse.fromJson(Map<String, dynamic> json) =>
      _$WgApiResponseFromJson(json);

  Map<String, dynamic> toJson() => _$WgApiResponseToJson(this);
}

class WgService {
  final _client = Dio();
  final _logger = WgFactory().getLogger('wgservice');

  WgService(PersistCookieJar cookieJar) {
    _client.options.baseUrl = WgConfig.wgApiBaseUrl;
    _client.interceptors.add(CookieManager(cookieJar));
  }

  Future<WgApiResponse> request(
    String method,
    String path, {
    dynamic data,
  }) async {
    if (WgConfig.isLogApi) {
      _logger.fine('request: $method $path');
    }

    var response = Response();
    if (WgConfig.isMockApi) {
      assert(mockApis[path] != null, 'api $path not mocked');
      response.statusCode = HttpStatus.ok;
      response.data = await mockApis[path](method, data);
    } else {
      try {
        response = await _client.request(
          path,
          data: data,
          options: Options(method: method),
        );
      } catch (e) {
        return WgApiResponse(
          code: WgApiResponse.codeRequestError,
          message: 'DioError: ${e.type} ${e.message}',
        );
      }
    }

    if (WgConfig.isLogApi) {
      _logger.fine('response: ${response.statusCode} ${response.data}');
    }

    if (response.statusCode == HttpStatus.ok) {
      return WgApiResponse.fromJson(response.data);
    } else {
      return WgApiResponse(
        code: WgApiResponse.codeResponseError,
        message: response.statusCode.toString(),
      );
    }
  }

  Future<WgApiResponse> get(String path, {Map<String, dynamic> data}) async {
    return request('GET', path, data: data);
  }

  Future<WgApiResponse> post(String path, {Map<String, dynamic> data}) async {
    return request('POST', path, data: data);
  }

  Future<WgApiResponse> postForm(String path, {FormData data}) async {
    return request('POST', path, data: data);
  }
}
