import 'package:docket/features/family/family_response.dart';
import 'package:docket/features/http/api_response.dart';
import 'package:docket/features/http/dio_client.dart';

class FamilyService {
  final DioClient client = DioClient();

  Future<List<FamilyResponse>> getFamilies() async {
    try {
      final response = await client.get<List<FamilyResponse>, List<dynamic>>(
        "/family/all",
        decoder: (usersJsonLists) => usersJsonLists
            .map((family) => FamilyResponse.fromJson(family))
            .toList(),
      );
      return response;
    } on ApiError {
      rethrow;
    }
  }

  Future<FamilyResponse> createFamily(
    String name,
    String wrappedFamilyKey,
  ) async {
    try {
      final response = await client.post<FamilyResponse>("/family", {
        "name": name,
        "wrappedFamilyKey": wrappedFamilyKey,
      }, decoder: (json) => FamilyResponse.fromJson(json));
      return response;
    } on ApiError {
      rethrow;
    }
  }
}
