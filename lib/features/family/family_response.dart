import 'package:docket/features/family/family_member.dart';

class FamilyResponse {
  final String name;
  final String id;
  final String? pic;
  final int memberCount;
  final String createdAt;
  final List<FamilyMember> familyMembers;

  const FamilyResponse({
    required this.name,
    required this.id,
    required this.memberCount,
    required this.createdAt,
    this.pic,
    required this.familyMembers,
  });

  factory FamilyResponse.fromJson(Map<String, dynamic> json) {
    return FamilyResponse(
      name: json["name"],
      id: json["id"],
      pic: json["pic"],
      memberCount: (json["memberCount"] as num).toInt(),
      createdAt: json["createdAt"],
      familyMembers: (json["familyMembers"] as List)
          .cast<Map<String, dynamic>>()
          .map(FamilyMember.fromJson)
          .toList(),
    );
  }
}
