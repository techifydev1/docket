import 'package:docket/features/crypto/crypto_service.dart';
import 'package:docket/features/family/family_provider.dart';
import 'package:docket/features/family/family_response.dart';
import 'package:docket/features/family/family_service.dart';
import 'package:docket/features/http/api_response.dart';
import 'package:docket/features/invitation/invitation.dart';
import 'package:docket/features/invitation/invitation_service.dart';
import 'package:docket/shared/docket_back_button.dart';
import 'package:docket/shared/docket_card.dart';
import 'package:docket/shared/header.dart';
import 'package:docket/shared/icon_tile.dart';
import 'package:docket/shared/status_message.dart';
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
    final crypto = context.read<CryptoService>();
    FamilyResponse family;
    try {
      family = await _service.acceptInvitation(invitation.id);
      final families = await FamilyService().getFamilies();
      for (final item in families) {
        await crypto.ensureFamilyKey(item.id, item.wrappedKey, item.keyVersion);
      }
      if (!mounted) return;
      context.read<FamilyProvider>().updateFamilies(families);
    } on ApiError catch (e) {
      if (!mounted) return;
      setState(() => _busy.remove(invitation.id));
      Toast.show(context, e.errorMessage, variant: ToastVariant.error);
      return;
    }
    if (!mounted) return;
    setState(() {
      _busy.remove(invitation.id);
      _remove(invitation.id);
    });
    Toast.show(
      context,
      "You've joined ${family.name}",
      variant: ToastVariant.success,
    );
  }

  Future<void> _decline(Invitation invitation) async {
    setState(() => _busy.add(invitation.id));
    try {
      await _service.declineInvitation(invitation.id);
    } on ApiError catch (e) {
      if (!mounted) return;
      setState(() => _busy.remove(invitation.id));
      Toast.show(context, e.errorMessage, variant: ToastVariant.error);
      return;
    }
    if (!mounted) return;
    setState(() {
      _busy.remove(invitation.id);
      _remove(invitation.id);
    });
    Toast.show(context, "Invitation declined", variant: ToastVariant.info);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const .all(16),
          child: Column(
            crossAxisAlignment: .stretch,
            children: [
              if (ModalRoute.of(context)?.canPop ?? false) ...[
                const Align(alignment: .centerLeft, child: DocketBackButton()),
                const SizedBox(height: 8),
              ],
              const Header(
                icon: Icons.mail_outline,
                title: "Invitations",
                subtitle:
                    "Family vaults you've been invited to join. Accept to gain access.",
              ),
              const SizedBox(height: 24),
              ..._buildContent(),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildContent() {
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
        StatusMessage(
          icon: Icons.cloud_off_outlined,
          title: "Couldn't load your invitations",
          message: _error!,
          onRetry: _fetch,
        ),
      ];
    }
    if (_invitations.isEmpty) {
      return const [
        StatusMessage(
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
    return DocketCard(
      child: Column(
        crossAxisAlignment: .stretch,
        children: [
          Row(
            children: [
              const IconTile(
                icon: Icons.folder_shared_outlined,
                size: 48,
                iconSize: 22,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(invitation.familyName, style: textTheme.titleSmall),
                    const SizedBox(height: 2),
                    Text(
                      "Invited by ${invitation.inviterEmail}",
                      maxLines: 1,
                      overflow: .ellipsis,
                      style: textTheme.bodySmall,
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
                  child: OutlinedButton(
                    onPressed: onDecline,
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(0, 44),
                    ),
                    child: const Text("Decline"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: onAccept,
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(0, 44),
                    ),
                    child: const Text("Accept"),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
