import 'package:docket/features/family/family_member.dart';

class FamilyResponse {
  final String name;
  final String id;
  final String? pic;
  final int memberCount;
  final String createdAt;
  final List<FamilyMember> familyMembers;
  final int keyVersion;
  final String? wrappedKey;

  const FamilyResponse({
    required this.name,
    required this.id,
    required this.memberCount,
    required this.createdAt,
    this.pic,
    required this.familyMembers,
    required this.keyVersion,
    this.wrappedKey,
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
      keyVersion: (json["keyVersion"] as num).toInt(),
      wrappedKey: json["wrappedKey"] as String?,
    );
  }
}
