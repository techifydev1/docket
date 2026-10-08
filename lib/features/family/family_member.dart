class FamilyMember {
  String name;
  String userId;
  String role;
  String? profilePic;

  FamilyMember({
    required this.name,
    required this.userId,
    required this.role,
    this.profilePic,
  });

  factory FamilyMember.fromJson(Map<String, dynamic> json) {
    return FamilyMember(
      name: json["name"],
      userId: json["userId"],
      role: json["role"],
      profilePic: json["profilePic"],
    );
  }
}
