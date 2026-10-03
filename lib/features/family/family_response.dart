class FamilyResponse {
  final String name;
  final String id;
  final String? pic;
  final int memberCount;
  final String createdAt;

  const FamilyResponse({
    required this.name,
    required this.id,
    required this.memberCount,
    required this.createdAt,
    this.pic,
  });

  factory FamilyResponse.fromJson(Map<String, dynamic> json) {
    return FamilyResponse(
      name: json["name"],
      id: json["id"],
      pic: json["pic"],
      memberCount: (json["memberCount"] as num).toInt(),
      createdAt: json["createdAt"],
    );
  }
}
