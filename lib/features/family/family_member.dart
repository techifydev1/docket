class FamilyMember {
  String name;
  String userId;
  String role;
  String relation;
  String? profilePic;

  FamilyMember({
    required this.name,
    required this.userId,
    required this.role,
    required this.relation,
    this.profilePic,
  });

  factory FamilyMember.fromJson(Map<String, dynamic> json) {
    return FamilyMember(
      name: json["name"],
      userId: json["userId"],
      role: json["role"],
      relation: json["relation"],
      profilePic: json["profilePic"],
    );
  }
}
