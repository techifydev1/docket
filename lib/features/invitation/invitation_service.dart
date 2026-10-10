import 'package:docket/features/family/family_response.dart';
import 'package:docket/features/http/api_response.dart';
import 'package:docket/features/http/dio_client.dart';
import 'package:docket/features/invitation/invitation.dart';

class InvitationService {
  final DioClient client = DioClient();

  Future<InviteTarget> initiateInvite(
    String inviteeEmail,
    String familyId,
  ) async {
    try {
      return await client.post<InviteTarget>(
        "/invitation/initiate",
        {"inviteeEmail": inviteeEmail, "familyId": familyId},
        decoder: (json) => InviteTarget(
          publicKey: json["publicKey"],
          keyVersion: (json["keyVersion"] as num).toInt(),
        ),
      );
    } on ApiError {
      rethrow;
    }
  }

  Future<void> invite({
    required String inviteeEmail,
    required String familyId,
    required String inviteePublicKey,
    required String wrappedFamilyKey,
  }) async {
    try {
      await client.post<void>("/invitation", {
        "inviteeEmail": inviteeEmail,
        "familyId": familyId,
        "inviteePublicKey": inviteePublicKey,
        "wrappedFamilyKey": wrappedFamilyKey,
      }, decoder: (_) {});
    } on ApiError {
      rethrow;
    }
  }

  Future<List<Invitation>> getInvitations() async {
    try {
      return await client.get<List<Invitation>, List<dynamic>>(
        "/invitation",
        decoder: (json) => json
            .map((item) => Invitation.fromJson(item as Map<String, dynamic>))
            .toList(),
      );
    } on ApiError {
      rethrow;
    }
  }

  Future<FamilyResponse> acceptInvitation(String id) async {
    try {
      return await client.post<FamilyResponse>(
        "/invitation/$id/accept",
        null,
        decoder: (json) => FamilyResponse.fromJson(json),
      );
    } on ApiError {
      rethrow;
    }
  }

  Future<void> declineInvitation(String id) async {
    try {
      await client.post<void>("/invitation/$id/decline", null, decoder: (_) {});
    } on ApiError {
      rethrow;
    }
  }
}
