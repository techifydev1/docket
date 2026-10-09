class DocumentRecord {
  final String id;
  final String encryptedMetadata;
  final int keyVersion;
  final String addedBy;
  final String addedAt;
  final String ownerId;
  final String publicId;
  final String cloudinaryVersion;

  const DocumentRecord({
    required this.id,
    required this.encryptedMetadata,
    required this.keyVersion,
    required this.addedBy,
    required this.addedAt,
    required this.ownerId,
    required this.publicId,
    required this.cloudinaryVersion,
  });

  factory DocumentRecord.fromJson(Map<String, dynamic> json) {
    return DocumentRecord(
      id: json["id"],
      encryptedMetadata: json["encryptedMetadata"],
      keyVersion: (json["keyVersion"] as num).toInt(),
      addedBy: json["addedBy"],
      addedAt: json["addedAt"],
      ownerId: json["ownerId"],
      publicId: json["publicId"],
      cloudinaryVersion: json["cloudinaryVersion"],
    );
  }
}
