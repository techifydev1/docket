import 'package:docket/shared/initials.dart';

class Profile {
  final String name;
  final String email;
  const Profile({required this.name, required this.email});

  String get initials => initialsOf(name);
}
