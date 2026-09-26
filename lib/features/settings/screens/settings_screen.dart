import 'package:docket/features/settings/profile.dart';
import 'package:docket/features/settings/screens/profile_edit_screen.dart';
import 'package:docket/features/settings/widgets/profile_settings_card.dart';
import 'package:docket/features/settings/widgets/settings_header.dart';
import 'package:docket/features/settings/widgets/sign_out_row.dart';
import 'package:docket/features/settings/widgets/vault_info_card.dart';
import 'package:docket/shared/bottom_nav.dart';
import 'package:docket/shared/section_header.dart';
import 'package:docket/shared/toggle_tile.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Profile _profile = const Profile(
    name: "Eleanor Vance",
    email: "eleanor@vance.family",
  );
  bool _biometrics = true;
  bool _lockOnExit = false;
  bool _emailAlerts = true;

  Future<void> _editProfile() async {
    final updated = await Navigator.of(context).push<Profile>(
      MaterialPageRoute(builder: (_) => ProfileEditScreen(profile: _profile)),
    );
    if (updated == null) return;
    setState(() => _profile = updated);
  }

  @override
  Widget build(BuildContext context) {
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
                      profile: _profile,
                      onEdit: _editProfile,
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
                    const SizedBox(height: 24),
                    const SectionHeader(title: "Vault"),
                    const SizedBox(height: 12),
                    const VaultInfoCard(),
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
