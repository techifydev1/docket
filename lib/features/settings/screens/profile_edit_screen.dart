import 'package:docket/features/settings/profile.dart';
import 'package:docket/shared/cta_section.dart';
import 'package:docket/shared/form_card.dart';
import 'package:docket/shared/header.dart';
import 'package:docket/shared/initials_avatar.dart';
import 'package:docket/shared/text_field.dart';
import 'package:docket/shared/trust_card.dart';
import 'package:flutter/material.dart';

class ProfileEditScreen extends StatefulWidget {
  final Profile profile;
  const ProfileEditScreen({super.key, required this.profile});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  late final TextEditingController _nameController = TextEditingController(
    text: widget.profile.name,
  );
  late final TextEditingController _emailController = TextEditingController(
    text: widget.profile.email,
  );

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  bool get _isValid =>
      _nameController.text.trim().isNotEmpty &&
      _emailController.text.trim().isNotEmpty;

  void _save() {
    Navigator.of(context).pop(
      Profile(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const .all(16),
          child: Column(
            crossAxisAlignment: .stretch,
            children: [
              Align(
                alignment: .centerLeft,
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
                icon: Icons.badge_outlined,
                title: "Edit profile",
                subtitle:
                    "This is how you appear to the rest of the family, and who new documents can be assigned to.",
              ),
              const SizedBox(height: 24),
              Align(
                child: InitialsAvatar(
                  initials: _initialsFor(_nameController.text),
                ),
              ),
              const SizedBox(height: 24),
              FormCard(
                title: "Personal details",
                child: Column(
                  children: [
                    DocketTextField(
                      label: "Full legal name",
                      placeholder: "Your full legal name",
                      controller: _nameController,
                      onChanged: () => setState(() {}),
                    ),
                    const SizedBox(height: 16),
                    DocketTextField(
                      label: "Email address",
                      placeholder: "you@example.com",
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailController,
                      onChanged: () => setState(() {}),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const TrustCard(
                icon: Icons.groups_outlined,
                title: "Visible to vault members",
                description:
                    "Your name and email are shared with the people in your vault so they can recognise who owns each document.",
                cardRadius: 8,
                iconBgColor: null,
                iconColor: null,
              ),
              const SizedBox(height: 16),
              CtaSection(
                onPressed: _isValid ? _save : null,
                label: "Save changes",
                isEntry: false,
                helperText:
                    "Documents you already own will show your new name automatically.",
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _initialsFor(String name) {
    return Profile(name: name, email: '').initials;
  }
}
