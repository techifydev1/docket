class FamilyResponse {
  final String name;
  final String id;
  final String pic;
  final int memberCount;

  const FamilyResponse({
    required this.name,
    required this.id,
    required this.pic,
    required this.memberCount,
  });

  factory FamilyResponse.fromJson(Map<String, dynamic> json) {
    return FamilyResponse(
      name: json["name"],
      id: json["id"],
      pic: json["pic"],
      memberCount: json["memberCount"],
    );
  }
}
