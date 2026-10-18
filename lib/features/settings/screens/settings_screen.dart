import 'package:docket/features/family/family_provider.dart';
import 'package:docket/features/family/screens/create_family_screen.dart';
import 'package:docket/features/family/screens/select_family_screen.dart';
import 'package:docket/features/settings/profile.dart';
import 'package:docket/features/settings/screens/profile_edit_screen.dart';
import 'package:docket/features/settings/widgets/profile_settings_card.dart';
import 'package:docket/features/settings/widgets/settings_header.dart';
import 'package:docket/features/settings/widgets/sign_out_row.dart';
import 'package:docket/features/settings/widgets/vault_info_card.dart';
import 'package:docket/core/theme/vault_theme.dart';
import 'package:docket/shared/action_tile.dart';
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
    final provider = context.watch<FamilyProvider>();
    final family = provider.selectedFamily;
    final families = provider.families;
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
                padding: const .fromLTRB(16, 0, 16, VaultTheme.navClearance),
                child: Column(
                  crossAxisAlignment: .stretch,
                  children: [
                    ProfileSettingsCard(
                      profile: profile,
                      onEdit: () => _editProfile(profile),
                    ),
                    const SizedBox(height: 24),
                    const SectionHeader(
                      title: "Security",
                      action: "Coming soon",
                      enabled: false,
                    ),
                    const SizedBox(height: 12),
                    const ToggleTile(
                      icon: Icons.fingerprint,
                      title: "Biometric / Face ID Lock",
                      subtitle: "Require biometric passkey to open the vault",
                      value: true,
                      enabled: false,
                    ),
                    const SizedBox(height: 12),
                    const ToggleTile(
                      icon: Icons.lock_outline,
                      title: "Lock on exit",
                      subtitle: "Re-authenticate whenever the app is reopened",
                      value: false,
                      enabled: false,
                    ),
                    const SizedBox(height: 12),
                    const ToggleTile(
                      icon: Icons.notifications_none,
                      title: "Vault email alerts",
                      subtitle: "Notify me when a document is added or shared",
                      value: true,
                      enabled: false,
                    ),
                    if (family != null) ...[
                      const SizedBox(height: 24),
                      const SectionHeader(title: "Vault"),
                      const SizedBox(height: 12),
                      VaultInfoCard(family: family),
                      if (families.length > 1) ...[
                        const SizedBox(height: 12),
                        ActionTile(
                          icon: Icons.swap_horiz,
                          title: "Switch vault",
                          subtitle: "Open a different family vault",
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) =>
                                  const SelectFamilyScreen(isPicker: true),
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 12),
                      ActionTile(
                        icon: Icons.add,
                        title: "Create new vault",
                        subtitle: "Start a separate family vault",
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const CreateFamilyScreen(),
                          ),
                        ),
                      ),
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
    );
  }
}
