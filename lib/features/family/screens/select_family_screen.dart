import 'package:docket/core/theme/vault_theme.dart';
import 'package:docket/features/auth/auth_gate.dart';
import 'package:docket/features/auth/logout.dart';
import 'package:docket/features/crypto/crypto_service.dart';
import 'package:docket/features/documents/documents_provider.dart';
import 'package:docket/features/family/family_provider.dart';
import 'package:docket/features/family/screens/create_family_screen.dart';
import 'package:docket/features/family/family_response.dart';
import 'package:docket/features/family/family_service.dart';
import 'package:docket/features/family/widgets/family_card.dart';
import 'package:docket/features/http/api_response.dart';
import 'package:docket/features/recovery/screens/recovery_screen.dart';
import 'package:docket/features/recovery/screens/recovery_setup_screen.dart';
import 'package:docket/features/user/user_provider.dart';
import 'package:docket/features/user/user_response.dart';
import 'package:docket/features/user/user_service.dart';
import 'package:docket/shared/confirm_dialog.dart';
import 'package:docket/shared/cta_section.dart';
import 'package:docket/shared/docket_back_button.dart';
import 'package:docket/shared/status_message.dart';
import 'package:docket/shared/toast.dart';
import 'package:docket/shared/header.dart';
import 'package:docket/shared/section_header.dart';
import 'package:docket/shared/sign_out_button.dart';
import 'package:docket/shared/app_shell.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelectFamilyScreen extends StatefulWidget {
  final bool isPicker;
  const SelectFamilyScreen({super.key, this.isPicker = false});

  @override
  State<SelectFamilyScreen> createState() => _SelectFamilyScreenState();
}

class _SelectFamilyScreenState extends State<SelectFamilyScreen> {
  final FamilyService _service = FamilyService();
  final UserService _userService = UserService();
  bool _isLoading = true;
  bool _isContinuing = false;
  String? _error;
  FamilyResponse? _pendingSelection;

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
    final crypto = context.read<CryptoService>();
    try {
      final families = await _service.getFamilies();
      if (!mounted) return;
      context.read<FamilyProvider>().updateFamilies(families);
      for (final family in families) {
        await crypto.ensureFamilyKey(
          family.id,
          family.wrappedKey,
          family.keyVersion,
        );
      }
    } on ApiError catch (e) {
      error = e.errorMessage;
    }
    if (!mounted) return;
    setState(() {
      _isLoading = false;
      _error = error;
    });
  }

  Future<void> _logout() async {
    final navigator = Navigator.of(context);
    final confirmed = await ConfirmDialog.show(
      context,
      title: "Sign out?",
      message:
          "Your vaults stay safe, but you'll need your email and password to get back in.",
      confirmLabel: "Sign out",
      icon: Icons.logout,
      isDestructive: true,
      onConfirm: () => logout(context),
    );
    if (!confirmed) return;
    navigator.pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const AuthGate()),
      (route) => false,
    );
  }

  Future<void> _continue(FamilyResponse? selected) async {
    if (selected == null || _isContinuing) return;
    setState(() => _isContinuing = true);
    try {
      await context.read<CryptoService>().storage.prime();
    } catch (_) {
      if (!mounted) return;
      setState(() => _isContinuing = false);
      Toast.show(
        context,
        "We couldn't unlock your vault, please try again",
        variant: ToastVariant.error,
      );
      return;
    }
    UserResponse user;
    try {
      user = await _userService.getUser();
    } on ApiError {
      if (!mounted) return;
      setState(() => _isContinuing = false);
      Toast.show(
        context,
        "We're unable to log you in right now, please try again",
        variant: ToastVariant.error,
      );
      return;
    }
    if (!mounted) return;
    final crypto = context.read<CryptoService>();
    var currentUser = user;
    final hasKeys = await crypto.hasUserKeys();
    if (!mounted) return;
    if (!hasKeys) {
      final backup = currentUser.keyBackup;
      if (backup == null || backup.isEmpty) {
        setState(() => _isContinuing = false);
        Toast.show(
          context,
          "We couldn't find a recovery key for your account",
          variant: ToastVariant.error,
        );
        return;
      }
      final restored = await Navigator.of(
        context,
      ).push<bool>(MaterialPageRoute(builder: (_) => const RecoveryScreen()));
      if (!mounted) return;
      if (restored != true) {
        setState(() => _isContinuing = false);
        return;
      }
      final families = context.read<FamilyProvider>().families;
      for (final family in families) {
        await crypto.ensureFamilyKey(
          family.id,
          family.wrappedKey,
          family.keyVersion,
        );
      }
      if (!mounted) return;
    } else if (currentUser.keyBackup == null) {
      final updated = await Navigator.of(context).push<UserResponse>(
        MaterialPageRoute(
          builder: (_) => RecoverySetupScreen(user: currentUser),
        ),
      );
      if (!mounted) return;
      if (updated != null) {
        currentUser = updated;
      }
    }
    context.read<UserProvider>().updateUser(currentUser);
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const AppShell()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FamilyProvider>();
    final families = provider.families;
    final selected = widget.isPicker
        ? (_pendingSelection ?? provider.selectedFamily)
        : provider.selectedFamily;
    final showSkeleton = _isLoading && families.isEmpty;
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            padding: const .all(16),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight - 32,
              ),
              child: Column(
                mainAxisAlignment: .center,
                crossAxisAlignment: .stretch,
                children: [
                  if (ModalRoute.of(context)?.canPop ?? false) ...[
                    const Align(
                      alignment: .centerLeft,
                      child: DocketBackButton(),
                    ),
                    const SizedBox(height: 8),
                  ],
                  Header(
                    icon: Icons.groups,
                    title: "Choose a family",
                    subtitle: widget.isPicker
                        ? "Pick the family vault you want to switch to."
                        : "Select the family vault you want to open. You can switch later from settings.",
                  ),
                  const SizedBox(height: 24),
                  if (showSkeleton)
                    for (var i = 0; i < 3; i++)
                      const Padding(
                        padding: .only(bottom: 12),
                        child: _FamilyCardSkeleton(),
                      )
                  else if (families.isEmpty && _error != null)
                    StatusMessage(
                      icon: Icons.cloud_off_outlined,
                      title: "Couldn't load your families",
                      message: _error!,
                      onRetry: _fetch,
                    )
                  else if (families.isEmpty)
                    const _EmptyFamilies()
                  else ...[
                    const SectionHeader(title: "Family Vaults"),
                    const SizedBox(height: 12),
                    for (final family in families)
                      Padding(
                        padding: const .only(bottom: 12),
                        child: FamilyCard(
                          family: family,
                          isSelected: family.id == selected?.id,
                          onTap: () {
                            if (widget.isPicker) {
                              setState(() => _pendingSelection = family);
                            } else {
                              provider.updateFamily(family);
                            }
                          },
                        ),
                      ),
                  ],
                  const SizedBox(height: 16),
                  CtaSection(
                    onPressed: selected == null || _isLoading || _isContinuing
                        ? null
                        : () async {
                            if (widget.isPicker) {
                              provider.updateFamily(selected);
                              final documentsProvider = context
                                  .read<DocumentsProvider>();
                              try {
                                await context
                                    .read<CryptoService>()
                                    .storage
                                    .prime();
                              } catch (_) {
                                if (!context.mounted) return;
                                Toast.show(
                                  context,
                                  "We couldn't unlock your vault, please try again",
                                  variant: ToastVariant.error,
                                );
                                return;
                              }
                              documentsProvider.clear();
                              documentsProvider.load(
                                familyId: selected.id,
                                members: selected.familyMembers,
                                wrappedKey: selected.wrappedKey,
                                keyVersion: selected.keyVersion,
                              );
                              if (!context.mounted) return;
                              Navigator.of(context).maybePop();
                            } else {
                              _continue(selected);
                            }
                          },
                    isLoading: _isContinuing,
                    label: widget.isPicker ? "Use this vault" : "Continue",
                    isEntry: true,
                    helperText: selected == null
                        ? "Pick a family vault to continue"
                        : widget.isPicker
                        ? "Home and settings will switch to this vault"
                        : "You'll only see the documents you're allowed to view.",
                  ),
                  if (!widget.isPicker) ...[
                    const SizedBox(height: 24),
                    SignOutButton(onPressed: _isLoading ? null : _logout),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FamilyCardSkeleton extends StatefulWidget {
  const _FamilyCardSkeleton();

  @override
  State<_FamilyCardSkeleton> createState() => _FamilyCardSkeletonState();
}

class _FamilyCardSkeletonState extends State<_FamilyCardSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(
        begin: 0.4,
        end: 1,
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut)),
      child: Container(
        padding: const .all(16),
        decoration: BoxDecoration(
          color: VaultTheme.surface,
          borderRadius: .circular(VaultTheme.radiusLg),
          boxShadow: VaultTheme.e1,
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                color: VaultTheme.surfaceMuted,
                shape: .circle,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  FractionallySizedBox(
                    widthFactor: 0.6,
                    alignment: .centerLeft,
                    child: _SkeletonBar(
                      height: 12,
                      color: VaultTheme.surfaceContainerHigh,
                    ),
                  ),
                  const SizedBox(height: 8),
                  FractionallySizedBox(
                    widthFactor: 0.4,
                    alignment: .centerLeft,
                    child: _SkeletonBar(
                      height: 10,
                      color: VaultTheme.surfaceContainerHigh,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SkeletonBar extends StatelessWidget {
  final double height;
  final Color color;
  const _SkeletonBar({required this.height, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(color: color, borderRadius: .circular(4)),
    );
  }
}

class _EmptyFamilies extends StatelessWidget {
  const _EmptyFamilies();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const StatusMessage(
          icon: Icons.group_off_outlined,
          title: "No family vaults yet",
          message:
              "You're not a member of any family vault. Create one to start storing documents.",
        ),
        CtaSection(
          label: "Create a vault",
          onPressed: () => Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const CreateFamilyScreen())),
        ),
      ],
    );
  }
}
