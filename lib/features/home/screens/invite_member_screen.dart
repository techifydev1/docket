import 'package:docket/shared/chip_selector.dart';
import 'package:docket/shared/cta_section.dart';
import 'package:docket/shared/form_card.dart';
import 'package:docket/shared/header.dart';
import 'package:docket/shared/initials.dart';
import 'package:docket/shared/text_field.dart';
import 'package:docket/shared/toggle_tile.dart';
import 'package:docket/shared/trust_card.dart';
import 'package:docket/shared/vault_member.dart';
import 'package:flutter/material.dart';

class InviteMemberScreen extends StatefulWidget {
  const InviteMemberScreen({super.key});

  @override
  State<InviteMemberScreen> createState() => _InviteMemberScreenState();
}

class _InviteMemberScreenState extends State<InviteMemberScreen> {
  final TextEditingController _nameController = TextEditingController();
  String? _relation;
  bool _canAddDocuments = true;
  bool _canOwnDocuments = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  bool get _isValid =>
      _nameController.text.trim().isNotEmpty && _relation != null;

  void _sendInvite() {
    final name = _nameController.text.trim();
    Navigator.of(context).pop(
      VaultMember(
        name: name,
        relation: _relation!,
        initials: initialsOf(name),
        canAddDocuments: _canAddDocuments,
        canOwnDocuments: _canOwnDocuments,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const .all(16),
          child: Column(
            crossAxisAlignment: .stretch,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: () => Navigator.of(context).maybePop(),
                  tooltip: 'Go back',
                  visualDensity: .compact,
                  icon: Icon(
                    Icons.arrow_back,
                    size: 20,
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Header(
                icon: Icons.person_add_alt_1_outlined,
                title: "Invite a member",
                subtitle:
                    "Add someone to the family vault so they can open the documents you choose to share with them.",
              ),
              const SizedBox(height: 24),
              FormCard(
                title: "Member details",
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    DocketTextField(
                      label: "Full name",
                      placeholder: "e.g., Noah Vance",
                      controller: _nameController,
                      onChanged: () => setState(() {}),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Relation",
                      style: textTheme.labelMedium?.copyWith(
                        color: colors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ChipSelector<String>(
                      values: vaultRelations,
                      selected: _relation,
                      labelOf: (relation) => relation,
                      onChanged: (value) => setState(() => _relation = value),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              FormCard(
                title: "Access",
                child: Column(
                  children: [
                    const _StaticAccessRow(
                      icon: Icons.visibility_outlined,
                      title: "View shared documents",
                      detail: "Always on, otherwise the invite is pointless",
                    ),
                    const SizedBox(height: 12),
                    ToggleTile(
                      icon: Icons.upload_file,
                      title: "Can add documents",
                      subtitle: "Allowed to put new files into the vault",
                      value: _canAddDocuments,
                      onChanged: (value) =>
                          setState(() => _canAddDocuments = value),
                    ),
                    const SizedBox(height: 12),
                    ToggleTile(
                      icon: Icons.assignment_ind_outlined,
                      title: "Can own documents",
                      subtitle:
                          "Can be assigned ownership. Ownership can never be transferred later.",
                      value: _canOwnDocuments,
                      onChanged: (value) =>
                          setState(() => _canOwnDocuments = value),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const TrustCard(
                icon: Icons.key_outlined,
                title: "They hold their own key",
                description:
                    "Each member sets up their own encryption key when they accept. Nobody, including you, can read what they add.",
                cardRadius: 8,
                iconBgColor: null,
                iconColor: null,
              ),
              const SizedBox(height: 16),
              CtaSection(
                onPressed: _isValid ? _sendInvite : null,
                label: "Send invite",
                isEntry: false,
                helperText:
                    "They'll get a one-time code to finish setting up their account.",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StaticAccessRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String detail;
  const _StaticAccessRow({
    required this.icon,
    required this.title,
    required this.detail,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          alignment: .center,
          decoration: BoxDecoration(
            color: colors.surfaceContainerHighest,
            borderRadius: .circular(8),
          ),
          child: Icon(icon, size: 16, color: colors.onSurfaceVariant),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Text(
                title,
                style: textTheme.labelLarge?.copyWith(color: colors.onSurface),
              ),
              const SizedBox(height: 2),
              Text(
                detail,
                style: textTheme.bodySmall?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        Icon(
          Icons.check_circle,
          size: 18,
          color: Theme.of(context).primaryColor,
        ),
      ],
    );
  }
}
