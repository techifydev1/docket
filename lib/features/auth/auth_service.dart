import 'package:docket/features/auth/models/auth_response.dart';
import 'package:docket/features/auth/models/login_request.dart';
import 'package:docket/features/auth/models/register_request.dart';
import 'package:docket/features/auth/models/verify_email_request.dart';
import 'package:docket/features/http/api_response.dart';
import 'package:docket/features/http/dio_client.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  static Future<AuthResponse> register(RegisterRequest request) async {
    try {
      final credentials = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: request.email,
            password: request.password,
          );
      debugPrint(
        "User created on firebase for user ${credentials.user!.email}",
      );
      final client = DioClient();
      final response = await client.post<AuthResponse>(
        "/auth/register",
        request.toJson(),
        decoder: (json) => AuthResponse.json(json),
      );

      return response;
    } on ApiError {
      rethrow;
    } on FirebaseAuthException catch (e) {
      if (e.code == "weak-password") {
        throw ApiError(
          "weak_password",
          "You used a weak password, use a much stronger one",
          000,
          DateTime.now().toString(),
        );
      } else if (e.code == "email-already-in-use") {
        throw ApiError(
          "email_already_in_use",
          "The email you used already exists, please check and use the correct one",
          000,
          DateTime.now().toString(),
        );
      }
      debugPrint("Firebase auth unknown error: ${e.message}");
      throw ApiError(
        "unknown_error",
        "An unknown error occured, please try again",
        000,
        DateTime.now().toString(),
      );
    }
  }

  static Future<String> sendVerificationEmail() async {
    final client = DioClient();
    return client.post<String>(
      "/auth/send-verification-email",
      null,
      decoder: (json) => json["message"],
    );
  }

  static Future<String> verifyEmail(String code) async {
    final client = DioClient();
    return client.post<String>(
      "/auth/verify",
      VerifyEmailRequest(code).toJson(),
      decoder: (json) => json["message"],
    );
  }

  static Future<AuthResponse> login(LoginRequest request) async {
    try {
      final credentials = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: request.email,
            password: request.password,
          );
      debugPrint("User signed in for user: ${credentials.user!.email}");
      final client = DioClient();
      final response = await client.post(
        "/login",
        request.toJson(),
        decoder: (json) => AuthResponse.json(json),
      );
      return response;
    } on ApiError {
      rethrow;
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        throw ApiError(
          "user_not_found",
          "Invalid email or password",
          000,
          DateTime.now().toString(),
        );
      } else if (e.code == "wrong-password") {
        throw ApiError(
          "wrong_password",
          "Invalid email or password",
          000,
          DateTime.now().toString(),
        );
      }
      throw ApiError(
        "unknown_error",
        "An unknown error occured, please try again",
        000,
        DateTime.now().toString(),
      );
    }
  }
}
