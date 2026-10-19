class RegisterRequest {
  late String? vaultName;
  late String fullName;
  late String email;
  late String? phone;
  late String password;
  late String publicKey;
  late String? wrappedFamilyKey;

  RegisterRequest();

  Map<String, dynamic> toJson() => {
    "vaultName": vaultName,
    "fullName": fullName,
    "email": email,
    "phone": phone,
    "password": password,
    "publicKey": publicKey,
    "wrappedFamilyKey": wrappedFamilyKey,
  };
}
