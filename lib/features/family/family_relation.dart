enum FamilyRelation {
  owner("OWNER", "Owner"),
  spouse("SPOUSE", "Spouse"),
  child("CHILD", "Child"),
  parent("PARENT", "Parent"),
  sibling("SIBLING", "Sibling"),
  executor("EXECUTOR", "Executor");

  final String value;
  final String label;
  const FamilyRelation(this.value, this.label);

  static const List<FamilyRelation> assignable = [
    spouse,
    child,
    parent,
    sibling,
    executor,
  ];

  static FamilyRelation? fromValue(String value) {
    for (final relation in FamilyRelation.values) {
      if (relation.value == value) return relation;
    }
    return null;
  }
}
