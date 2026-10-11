enum FamilyRole {
  member("MEMBER", "Member"),
  admin("ADMIN", "Admin"),
  viewer("VIEWER", "Viewer");

  final String value;
  final String label;
  const FamilyRole(this.value, this.label);

  static const List<FamilyRole> assignable = [member, admin, viewer];
}
