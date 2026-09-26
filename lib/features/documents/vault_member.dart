class VaultMember {
  final String name;
  final String relation;
  final String initials;
  const VaultMember({
    required this.name,
    required this.relation,
    required this.initials,
  });
}

const List<VaultMember> vaultMembers = [
  VaultMember(name: "Eleanor Vance", relation: "Vault owner", initials: "EV"),
  VaultMember(name: "James Vance", relation: "Spouse", initials: "JV"),
  VaultMember(name: "Sophie Vance", relation: "Daughter", initials: "SV"),
  VaultMember(name: "Michael Vance", relation: "Son", initials: "MV"),
];
