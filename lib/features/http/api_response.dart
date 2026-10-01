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
  final String timestamp;
  final List<FieldError>? fieldErrors;
  ApiError(
    this.errorCode,
    this.errorMessage,
    this.statusCode,
    this.timestamp, {
    this.fieldErrors,
  });

  factory ApiError.fromJson(Map<String, dynamic> json) {
    return ApiError(
      json["errorCode"],
      json["errorMessage"],
      json["statusCode"],
      json["timestamp"],
      fieldErrors: json["fieldErrors"]?.map(
        (e) => FieldError.fromJson(e as Map<String, dynamic>),
      ),
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

  factory FieldError.fromJson(Map<String, dynamic> json) {
    return FieldError(json["name"], json["reason"]);
  }
}
