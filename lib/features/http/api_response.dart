sealed class ApiResponse {
  ApiResponse();
  factory ApiResponse.fromJson(Map<String, dynamic> map) {
    return ApiSuccess<dynamic>.fromJson(map);
  }
}

class ApiSuccess<T> extends ApiResponse {
  final T data;

  ApiSuccess({required this.data});

  ApiSuccess.fromJson(Map<String, dynamic> json) : data = json as T;
}

class ApiError implements Exception {
  final String errorCode;
  final String errorMessage;
  final int statusCode;
  final List<FieldError>? fieldErrors;
  ApiError(
    this.errorCode,
    this.errorMessage,
    this.statusCode, {
    this.fieldErrors,
  });

  factory ApiError.fromJson(Map<String, dynamic> json) {
    return ApiError(
      json["errorCode"],
      json["errorMessage"],
      json["statusCode"],
      fieldErrors: json["fieldErrors"],
    );
  }

  @override
  String toString() {
    return "$errorCode, $errorMessage, $statusCode ${fieldErrors.toString()}";
  }
}

class FieldError {
  final String name;
  final String reason;
  FieldError(this.name, this.reason);
}
