import 'package:docket/features/crypto/crypto_service.dart';
import 'package:docket/features/family/family_provider.dart';
import 'package:docket/features/family/family_service.dart';
import 'package:docket/features/http/api_response.dart';
import 'package:docket/features/invitation/invitation.dart';
import 'package:docket/features/invitation/invitation_service.dart';
import 'package:docket/shared/header.dart';
import 'package:docket/shared/toast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InvitationsScreen extends StatefulWidget {
  const InvitationsScreen({super.key});

  @override
  State<InvitationsScreen> createState() => _InvitationsScreenState();
}

class _InvitationsScreenState extends State<InvitationsScreen> {
  final InvitationService _service = InvitationService();
  bool _isLoading = true;
  String? _error;
  List<Invitation> _invitations = const [];
  final Set<String> _busy = {};

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Future<void> _fetch() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    String? error;
    List<Invitation> invitations = const [];
    try {
      invitations = await _service.getInvitations();
    } on ApiError catch (e) {
      error = e.errorMessage;
    }
    if (!mounted) return;
    setState(() {
      _isLoading = false;
      _invitations = invitations;
      _error = error;
    });
  }

  void _remove(String id) {
    _invitations = _invitations
        .where((invitation) => invitation.id != id)
        .toList();
  }

  Future<void> _accept(Invitation invitation) async {
    setState(() => _busy.add(invitation.id));
    String? error;
    String? familyName;
    final crypto = context.read<CryptoService>();
    try {
      final family = await _service.acceptInvitation(invitation.id);
      familyName = family.name;
      final families = await FamilyService().getFamilies();
      for (final item in families) {
        await crypto.ensureFamilyKey(item.id, item.wrappedKey, item.keyVersion);
      }
      if (!mounted) return;
      context.read<FamilyProvider>().updateFamilies(families);
    } on ApiError catch (e) {
      error = e.errorMessage;
    }
    if (!mounted) return;
    setState(() {
      _busy.remove(invitation.id);
      if (error == null) _remove(invitation.id);
    });
    if (error != null) {
      Toast.show(context, error, variant: ToastVariant.error);
      return;
    }
    Toast.show(
      context,
      "You've joined ${familyName ?? 'the vault'}",
      variant: ToastVariant.success,
    );
  }

  Future<void> _decline(Invitation invitation) async {
    setState(() => _busy.add(invitation.id));
    String? error;
    try {
      await _service.declineInvitation(invitation.id);
    } on ApiError catch (e) {
      error = e.errorMessage;
    }
    if (!mounted) return;
    setState(() {
      _busy.remove(invitation.id);
      if (error == null) _remove(invitation.id);
    });
    if (error != null) {
      Toast.show(context, error, variant: ToastVariant.error);
      return;
    }
    Toast.show(context, "Invitation declined", variant: ToastVariant.info);
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
              if (ModalRoute.of(context)?.canPop ?? false) ...[
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
              ],
              const Header(
                icon: Icons.mail_outline,
                title: "Invitations",
                subtitle:
                    "Family vaults you've been invited to join. Accept to gain access.",
              ),
              const SizedBox(height: 24),
              ..._buildContent(colors),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildContent(ColorScheme colors) {
    if (_isLoading) {
      return const [
        Padding(
          padding: .symmetric(vertical: 48),
          child: Center(child: CircularProgressIndicator.adaptive()),
        ),
      ];
    }
    if (_error != null) {
      return [
        _InvitationsMessage(
          icon: Icons.cloud_off_outlined,
          title: "Couldn't load your invitations",
          message: _error!,
          onRetry: _fetch,
        ),
      ];
    }
    if (_invitations.isEmpty) {
      return const [
        _InvitationsMessage(
          icon: Icons.mark_email_read_outlined,
          title: "No invitations yet",
          message:
              "When someone invites you to a family vault, it'll show up here.",
        ),
      ];
    }
    return [
      for (final invitation in _invitations)
        Padding(
          padding: const .only(bottom: 12),
          child: _InvitationCard(
            invitation: invitation,
            isBusy: _busy.contains(invitation.id),
            onAccept: () => _accept(invitation),
            onDecline: () => _decline(invitation),
          ),
        ),
    ];
  }
}

class _InvitationCard extends StatelessWidget {
  final Invitation invitation;
  final bool isBusy;
  final VoidCallback onAccept;
  final VoidCallback onDecline;

  const _InvitationCard({
    required this.invitation,
    required this.isBusy,
    required this.onAccept,
    required this.onDecline,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const .all(16),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLowest,
        borderRadius: .circular(12),
        boxShadow: [
          BoxShadow(
            color: colors.onSurface.withValues(alpha: 0.05),
            offset: const Offset(0, 1),
            blurRadius: 2,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: .stretch,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                alignment: .center,
                decoration: BoxDecoration(
                  color: colors.surfaceContainerHigh,
                  shape: .circle,
                ),
                child: Icon(
                  Icons.folder_shared_outlined,
                  size: 22,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      invitation.familyName,
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: .w700,
                        color: colors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "Invited by ${invitation.inviterEmail}",
                      style: textTheme.bodySmall?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (isBusy)
            const Center(
              child: Padding(
                padding: .symmetric(vertical: 8),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            )
          else
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 44,
                    child: OutlinedButton(
                      onPressed: onDecline,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: colors.onSurface,
                        side: BorderSide(color: colors.outlineVariant),
                        shape: RoundedRectangleBorder(
                          borderRadius: .circular(8),
                        ),
                      ),
                      child: const Text("Decline"),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 44,
                    child: FilledButton(
                      onPressed: onAccept,
                      style: FilledButton.styleFrom(
                        backgroundColor: colors.primary,
                        foregroundColor: colors.onPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: .circular(8),
                        ),
                      ),
                      child: const Text("Accept"),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _InvitationsMessage extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final VoidCallback? onRetry;

  const _InvitationsMessage({
    required this.icon,
    required this.title,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const .all(16),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: .circular(12),
      ),
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            alignment: .center,
            decoration: BoxDecoration(
              color: colors.surfaceContainerHigh,
              shape: .circle,
            ),
            child: Icon(icon, size: 24, color: colors.onSurfaceVariant),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: .w600,
              color: colors.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            message,
            textAlign: .center,
            style: textTheme.bodySmall?.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: onRetry,
              style: OutlinedButton.styleFrom(
                foregroundColor: Theme.of(context).primaryColor,
                side: BorderSide(color: colors.outlineVariant),
                minimumSize: const Size(0, 40),
                shape: RoundedRectangleBorder(borderRadius: .circular(8)),
                textStyle: textTheme.labelMedium,
              ),
              child: const Text("Try again"),
            ),
          ],
        ],
      ),
    );
  }
}
