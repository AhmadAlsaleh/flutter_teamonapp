import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_teamonapp/core/constants/app_constants.dart';

abstract class NetworkService {
  Future<Map<String, dynamic>> get(String endpoint,
      {String? token, Map<String, dynamic>? queryParameters});
  Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> data,
      {String? token});
  Future<Map<String, dynamic>> put(String endpoint, Map<String, dynamic> data,
      {String? token});
  Future<Map<String, dynamic>> delete(String endpoint, {String? token});
}

class NetworkServiceImpl implements NetworkService {
  final Dio _dio;

  NetworkServiceImpl(this._dio);

  @override
  Future<Map<String, dynamic>> get(String endpoint,
      {String? token, Map<String, dynamic>? queryParameters}) async {
    Options options = _getOptions(token);

    String url = endpoint;
    if (queryParameters != null) {
      url += '?${_encodeQueryParameters(queryParameters)}';
    }

    final response = await _dio.get(url, options: options);
    return response.data;
  }

  @override
  Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> data,
      {String? token}) async {
    Options options = _getOptions(token);
    final response = await _dio.post(endpoint, data: data, options: options);
    return response.data;
  }

  @override
  Future<Map<String, dynamic>> put(String endpoint, Map<String, dynamic> data,
      {String? token}) async {
    Options options = _getOptions(token);
    final response = await _dio.put(endpoint, data: data, options: options);
    return response.data;
  }

  @override
  Future<Map<String, dynamic>> delete(String endpoint, {String? token}) async {
    Options options = _getOptions(token);
    final response = await _dio.delete(endpoint, options: options);
    return response.data;
  }

  String _encodeQueryParameters(Map<String, dynamic> params) {
    return params.entries
        .map((e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value.toString())}')
        .join('&');
  }

  Options _getOptions(String? token) {
    return Options(
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
  }
}

final networkServiceProvider = Provider<NetworkService>((ref) {
  Dio dio = Dio(BaseOptions(baseUrl: AppConstants.baseUrl));
  return NetworkServiceImpl(dio);
});
