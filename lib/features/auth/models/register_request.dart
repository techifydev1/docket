class RegisterRequest {
  late String? vaultName;
  late String fullName;
  late String email;
  late String? phone;
  late String password;
  late bool isBiometricsEnabled;
  late String publicKey;
  late String? wrappedFamilyKey;

  RegisterRequest();

  Map<String, dynamic> toJson() => {
    "vaultName": vaultName,
    "fullName": fullName,
    "email": email,
    "phone": phone,
    "password": password,
    "isBiometricsEnabled": isBiometricsEnabled,
    "publicKey": publicKey,
    "wrappedFamilyKey": wrappedFamilyKey,
  };
}
