import 'dart:io';
import 'package:dio/dio.dart';

class HttpService {
  static final Dio _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
    sendTimeout: const Duration(seconds: 30),
    headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
    },
  ));

  static Future<dynamic> sendRequest(
    String url, {
    Object data = const {},
    String method = "get",
    Map<String, String> headers = const {},
    String token = '',
  }) async {
    try {
      // Add authorization header if token provided
      Map<String, String> requestHeaders = {...headers};
      if (token.isNotEmpty) {
        requestHeaders["Authorization"] = "Bearer $token";
      }

      Response response;

      switch (method.toLowerCase()) {
        case 'get':
          response =
              await _dio.get(url, options: Options(headers: requestHeaders));
          break;
        case 'post':
          response = await _dio.post(url,
              data: data, options: Options(headers: requestHeaders));
          break;
        case 'put':
          response = await _dio.put(url,
              data: data, options: Options(headers: requestHeaders));
          break;
        case 'patch':
          response = await _dio.patch(url,
              data: data, options: Options(headers: requestHeaders));
          break;
        case 'delete':
          response =
              await _dio.delete(url, options: Options(headers: requestHeaders));
          break;
        default:
          response = await _dio.post(url,
              data: data, options: Options(headers: requestHeaders));
      }

      if (response.data != null) {
        return response.data;
      } else if (method.toLowerCase() == 'delete') {
        return {'status': 'deleted'};
      } else {
        throw const HttpException('Empty response');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw const HttpException(
            'Request timeout - please check your connection');
      } else if (e.type == DioExceptionType.connectionError) {
        throw const HttpException(
            'Connection error - please check your network');
      } else if (e.response?.statusCode == 500) {
        throw const HttpException('Internal server error');
      } else if (e.response?.data["error"] == true) {
        throw ('${e.response?.data["message"]}');
      } else {
        throw HttpException('Network error: ${e.message}');
      }
    } catch (e) {
      throw HttpException('Unexpected error: ${e.toString()}');
    }
  }
}
