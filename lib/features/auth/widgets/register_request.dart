class RegisterRequest {
  late String? vaultName;
  late String fullName;
  late String email;
  late String? phone;
  late String password;
  late bool biometricsEnabled;

  RegisterRequest();

  Map<String, dynamic> toJson() => {
    "vaultName": vaultName,
    "fullName": fullName,
    "email": email,
    "password": password,
    "biometricsEnabled": biometricsEnabled,
  };
}
