class Invitation {
  final String id;
  final String familyId;
  final String familyName;
  final String inviterEmail;
  final String status;
  final String? createdAt;

  const Invitation({
    required this.id,
    required this.familyId,
    required this.familyName,
    required this.inviterEmail,
    required this.status,
    this.createdAt,
  });

  factory Invitation.fromJson(Map<String, dynamic> json) {
    return Invitation(
      id: json["id"],
      familyId: json["familyId"],
      familyName: json["familyName"],
      inviterEmail: json["inviterEmail"],
      status: json["status"],
      createdAt: json["createdAt"],
    );
  }
}

class InviteTarget {
  final String publicKey;
  final int keyVersion;

  const InviteTarget({required this.publicKey, required this.keyVersion});
}
