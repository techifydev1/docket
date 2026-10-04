class VerifyEmailRequest {
  final String code;

  const VerifyEmailRequest(this.code);

  Map<String, dynamic> toJson() => {"code": code};
}
