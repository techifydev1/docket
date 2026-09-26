class VaultMember {
  final String name;
  final String relation;
  final String initials;
  final bool canAddDocuments;
  final bool canOwnDocuments;
  const VaultMember({
    required this.name,
    required this.relation,
    required this.initials,
    this.canAddDocuments = true,
    this.canOwnDocuments = false,
  });
}

final List<VaultMember> vaultMembers = [
  const VaultMember(
    name: "Eleanor Vance",
    relation: "Vault owner",
    initials: "EV",
  ),
  const VaultMember(name: "James Vance", relation: "Spouse", initials: "JV"),
  const VaultMember(name: "Sophie Vance", relation: "Daughter", initials: "SV"),
  const VaultMember(name: "Michael Vance", relation: "Son", initials: "MV"),
];

const List<String> vaultRelations = [
  "Spouse",
  "Child",
  "Parent",
  "Sibling",
  "Executor",
  "Other",
];
