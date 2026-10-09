import 'package:docket/features/auth/auth_gate.dart';
import 'package:docket/features/crypto/crypto_service.dart';
import 'package:docket/features/family/family_provider.dart';
import 'package:docket/features/family/screens/create_family_screen.dart';
import 'package:docket/features/family/family_response.dart';
import 'package:docket/features/family/family_service.dart';
import 'package:docket/features/family/widgets/family_card.dart';
import 'package:docket/features/home/screens/home_screen.dart';
import 'package:docket/features/http/api_response.dart';
import 'package:docket/features/user/user_provider.dart';
import 'package:docket/features/user/user_response.dart';
import 'package:docket/features/user/user_service.dart';
import 'package:docket/shared/confirm_dialog.dart';
import 'package:docket/shared/cta_section.dart';
import 'package:docket/shared/toast.dart';
import 'package:docket/shared/header.dart';
import 'package:docket/shared/section_header.dart';
import 'package:docket/shared/sign_out_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    final confirmed = await ConfirmDialog.show(
      context,
      title: "Sign out?",
      message:
          "Your vaults stay safe, but you'll need your email and password to get back in.",
      confirmLabel: "Sign out",
      icon: Icons.logout,
      isDestructive: true,
    );
    if (!confirmed || !context.mounted) return;
    await FirebaseAuth.instance.signOut();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const AuthGate()),
      (route) => false,
    );
  }

  Future<void> _continue(FamilyResponse? selected) async {
    if (selected == null || _isContinuing) return;
    setState(() => _isContinuing = true);
    UserResponse? user;
    var failed = false;
    try {
      user = await _userService.getUser();
    } on ApiError {
      failed = true;
    }
    if (!mounted) return;
    if (failed || user == null) {
      setState(() => _isContinuing = false);
      Toast.show(
        context,
        "We're unable to log you in right now, please try again",
        variant: ToastVariant.error,
      );
      return;
    }
    context.read<UserProvider>().updateUser(user);
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
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
                    _FamiliesError(message: _error!, onRetry: _fetch)
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
                        : () {
                            if (widget.isPicker) {
                              provider.updateFamily(selected);
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
    final colors = Theme.of(context).colorScheme;
    return FadeTransition(
      opacity: Tween<double>(
        begin: 0.4,
        end: 1,
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut)),
      child: Container(
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
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: colors.surfaceContainerHigh,
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
                      color: colors.surfaceContainerHigh,
                    ),
                  ),
                  const SizedBox(height: 8),
                  FractionallySizedBox(
                    widthFactor: 0.4,
                    alignment: .centerLeft,
                    child: _SkeletonBar(
                      height: 10,
                      color: colors.surfaceContainerHigh,
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

class _FamiliesError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _FamiliesError({required this.message, required this.onRetry});

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
            child: Icon(
              Icons.cloud_off_outlined,
              size: 24,
              color: colors.error,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "Couldn't load your families",
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
      ),
    );
  }
}

class _EmptyFamilies extends StatelessWidget {
  const _EmptyFamilies();

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
            child: Icon(
              Icons.group_off_outlined,
              size: 24,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "No family vaults yet",
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: .w600,
              color: colors.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "You're not a member of any family vault. Create one to start storing documents.",
            textAlign: .center,
            style: textTheme.bodySmall?.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          CtaSection(
            label: "Create a vault",
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const CreateFamilyScreen()),
            ),
          ),
        ],
      ),
    );
  }
}
