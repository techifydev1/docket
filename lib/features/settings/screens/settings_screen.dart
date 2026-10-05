import 'package:docket/features/family/family_provider.dart';
import 'package:docket/features/settings/profile.dart';
import 'package:docket/features/settings/screens/profile_edit_screen.dart';
import 'package:docket/features/settings/widgets/profile_settings_card.dart';
import 'package:docket/features/settings/widgets/settings_header.dart';
import 'package:docket/features/settings/widgets/sign_out_row.dart';
import 'package:docket/features/settings/widgets/vault_info_card.dart';
import 'package:docket/shared/bottom_nav.dart';
import 'package:docket/shared/section_header.dart';
import 'package:docket/features/user/user_provider.dart';
import 'package:docket/shared/toggle_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Profile? _editedProfile;
  bool _biometrics = true;
  bool _lockOnExit = false;
  bool _emailAlerts = true;

  Future<void> _editProfile(Profile profile) async {
    final updated = await Navigator.of(context).push<Profile>(
      MaterialPageRoute(builder: (_) => ProfileEditScreen(profile: profile)),
    );
    if (updated == null) return;
    setState(() => _editedProfile = updated);
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().userResponse;
    final family = context.watch<FamilyProvider>().selectedFamily;
    if (user == null) {
      return const Scaffold(
        body: SafeArea(
          child: Center(child: CircularProgressIndicator.adaptive()),
        ),
      );
    }
    final profile =
        _editedProfile ?? Profile(name: user.fullName, email: user.email);
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: .stretch,
          children: [
            const Padding(
              padding: .fromLTRB(16, 16, 16, 0),
              child: SettingsHeader(),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                padding: const .fromLTRB(16, 0, 16, 16),
                child: Column(
                  crossAxisAlignment: .stretch,
                  children: [
                    ProfileSettingsCard(
                      profile: profile,
                      onEdit: () => _editProfile(profile),
                    ),
                    const SizedBox(height: 24),
                    const SectionHeader(title: "Security"),
                    const SizedBox(height: 12),
                    ToggleTile(
                      icon: Icons.fingerprint,
                      title: "Biometric / Face ID Lock",
                      subtitle: "Require biometric passkey to open the vault",
                      value: _biometrics,
                      onChanged: (value) => setState(() => _biometrics = value),
                    ),
                    const SizedBox(height: 12),
                    ToggleTile(
                      icon: Icons.lock_outline,
                      title: "Lock on exit",
                      subtitle: "Re-authenticate whenever the app is reopened",
                      value: _lockOnExit,
                      onChanged: (value) => setState(() => _lockOnExit = value),
                    ),
                    const SizedBox(height: 12),
                    ToggleTile(
                      icon: Icons.notifications_none,
                      title: "Vault email alerts",
                      subtitle: "Notify me when a document is added or shared",
                      value: _emailAlerts,
                      onChanged: (value) =>
                          setState(() => _emailAlerts = value),
                    ),
                    if (family != null) ...[
                      const SizedBox(height: 24),
                      const SectionHeader(title: "Vault"),
                      const SizedBox(height: 12),
                      VaultInfoCard(family: family),
                    ],
                    const SizedBox(height: 16),
                    const SignOutRow(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNav(currentIndex: 2),
    );
  }
}
