class UserResponse {
  String fullName;
  String id;
  String email;
  String phone;
  String? profilePic;

  UserResponse({
    required this.fullName,
    required this.id,
    required this.email,
    required this.phone,
    this.profilePic,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      fullName: json["fullName"],
      id: json["id"],
      email: json["email"],
      phone: json["phone"],
      profilePic: json["profilePic"],
    );
  }
}
