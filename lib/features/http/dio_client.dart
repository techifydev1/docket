import 'package:dio/dio.dart';
import 'package:docket/features/http/api_response.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();
  final BaseOptions baseOptions;
  final Dio dio;

  final tokenInterceptor = InterceptorsWrapper(
    onRequest: (options, handler) async {
      String? token = await FirebaseAuth.instance.currentUser?.getIdToken();
      debugPrint("Firebase token: $token");
      if (token != null) options.headers["Authorization"] = "Bearer $token";
      options.contentType = Headers.jsonContentType;
      return handler.next(options);
    },
  );

  DioClient._internal()
    : baseOptions = BaseOptions(
        baseUrl: "https://nutmeg-repent-cilantro.ngrok-free.dev/api",
      ),
      dio = Dio() {
    dio.options = baseOptions;
    dio.interceptors.add(tokenInterceptor);
  }

  factory DioClient() {
    return _instance;
  }

  Future<T> post<T>(
    String endpoint,
    Map<String, dynamic>? body, {
    required Function(Map<String, dynamic>) decoder,
  }) async {
    try {
      final response = await dio.post(endpoint, data: body);
      return decoder(response.data);
    } on DioException catch (e) {
      Map<String, dynamic>? errRes = e.response!.data;
      if (errRes != null) throw ApiError.fromJson(errRes);
      debugPrint(e.message);
      throw ApiError(
        "unknown_error",
        "An unknown error occured, please try again",
        000,
        DateTime.now().toString(),
      );
    } catch (e) {
      debugPrint(e.toString());
      throw ApiError(
        "unknown_error",
        "An unknown error occured, please try again",
        000,
        DateTime.now().toString(),
      );
    }
  }

  Future<ApiResponse> get(String endpoint) async {
    try {
      final response = await dio.get(endpoint);
      return ApiSuccess.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      Map<String, dynamic>? errRes = e.response!.data;
      if (errRes != null) throw ApiError.fromJson(errRes);
      debugPrint(e.message);
      throw ApiError(
        "unknown_error",
        "An unknown error occured, please try again",
        000,
        DateTime.now().toString(),
      );
    } catch (e) {
      debugPrint(e.toString());
      throw ApiError(
        "unknown_error",
        "An unknown error occured, please try again",
        000,
        DateTime.now().toString(),
      );
    }
  }
}
