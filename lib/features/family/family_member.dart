class FamilyMember {
  String name;
  String userId;
  String? profilePic;

  FamilyMember({required this.name, required this.userId, this.profilePic});

  factory FamilyMember.fromJson(Map<String, dynamic> json) {
    return FamilyMember(
      name: json["name"],
      userId: json["userId"],
      profilePic: json["profilePic"],
    );
  }
}
