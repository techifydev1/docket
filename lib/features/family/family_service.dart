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
}
