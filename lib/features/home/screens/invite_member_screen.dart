import 'dart:convert';

import 'package:docket/features/crypto/crypto_service.dart';
import 'package:docket/features/family/family_provider.dart';
import 'package:docket/features/http/api_response.dart';
import 'package:docket/features/invitation/invitation_service.dart';
import 'package:docket/shared/chip_selector.dart';
import 'package:docket/shared/cta_section.dart';
import 'package:docket/shared/form_card.dart';
import 'package:docket/shared/header.dart';
import 'package:docket/shared/text_field.dart';
import 'package:docket/shared/toast.dart';
import 'package:docket/shared/toggle_tile.dart';
import 'package:docket/shared/trust_card.dart';
import 'package:docket/shared/vault_member.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sodium/sodium.dart';

class InviteMemberScreen extends StatefulWidget {
  const InviteMemberScreen({super.key});

  @override
  State<InviteMemberScreen> createState() => _InviteMemberScreenState();
}

class _InviteMemberScreenState extends State<InviteMemberScreen> {
  final InvitationService _service = InvitationService();
  final TextEditingController _emailController = TextEditingController();
  String? _relation;
  bool _canAddDocuments = true;
  bool _canOwnDocuments = false;
  bool _isSending = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  bool get _isValid => _emailController.text.trim().isNotEmpty;

  Future<void> _sendInvite() async {
    if (!_isValid || _isSending) return;
    final email = _emailController.text.trim();
    final family = context.read<FamilyProvider>().selectedFamily;
    if (family == null) {
      Toast.show(
        context,
        "Choose a family vault before inviting members",
        variant: ToastVariant.error,
      );
      return;
    }
    setState(() => _isSending = true);
    final crypto = context.read<CryptoService>();
    String? error;
    SecureKey? familyKey;
    try {
      final target = await _service.initiateInvite(email, family.id);
      familyKey = await crypto.loadFamilyKeyLocally(
        family.id,
        target.keyVersion,
      );
      if (familyKey == null) {
        error = "This device doesn't hold this vault's key";
      } else {
        final wrapped = crypto.wrapFamilyKey(
          familyKey,
          base64Decode(target.publicKey),
        );
        await _service.invite(
          inviteeEmail: email,
          familyId: family.id,
          inviteePublicKey: target.publicKey,
          wrappedFamilyKey: wrapped,
        );
      }
    } on ApiError catch (e) {
      error = e.errorMessage;
    } finally {
      familyKey?.dispose();
    }
    if (!mounted) return;
    setState(() => _isSending = false);
    if (error != null) {
      Toast.show(context, error, variant: ToastVariant.error);
      return;
    }
    Toast.show(
      context,
      "Invitation sent to $email",
      variant: ToastVariant.success,
    );
    Navigator.of(context).pop();
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
                      label: "Email address",
                      placeholder: "e.g., noah@example.com",
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailController,
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
                isLoading: _isSending,
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
