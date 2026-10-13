import 'package:docket/features/crypto/crypto_service.dart';
import 'package:docket/features/http/api_response.dart';
import 'package:docket/features/recovery/recovery_service.dart';
import 'package:docket/features/user/user_response.dart';
import 'package:docket/shared/cta_section.dart';
import 'package:docket/shared/header.dart';
import 'package:docket/shared/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class RecoverySetupScreen extends StatefulWidget {
  final UserResponse user;
  const RecoverySetupScreen({super.key, required this.user});

  @override
  State<RecoverySetupScreen> createState() => _RecoverySetupScreenState();
}

class _RecoverySetupScreenState extends State<RecoverySetupScreen> {
  final RecoveryService _service = RecoveryService();
  late final CryptoService _crypto;
  late final List<String> _words;
  bool _confirmed = false;
  bool _isSaving = false;

  String get _phrase => _words.join(' ');

  @override
  void initState() {
    super.initState();
    _crypto = context.read<CryptoService>();
    _words = _crypto.generateRecoveryPhrase().split(' ');
  }

  Future<void> _copy() async {
    await Clipboard.setData(ClipboardData(text: _phrase));
    if (!mounted) return;
    Toast.show(context, "Recovery key copied", variant: ToastVariant.success);
  }

  Future<void> _share() async {
    final box = context.findRenderObject() as RenderBox?;
    await SharePlus.instance.share(
      ShareParams(
        text: _phrase,
        subject: "Docket recovery key",
        sharePositionOrigin: box == null
            ? null
            : box.localToGlobal(Offset.zero) & box.size,
      ),
    );
  }

  Future<void> _save() async {
    if (!_confirmed || _isSaving) return;
    setState(() => _isSaving = true);
    String? error;
    UserResponse? updated;
    try {
      final backup = await _crypto.buildBackupKey(_phrase);
      updated = await _service.uploadKeyBackup(backup);
    } on ApiError catch (e) {
      error = e.errorMessage;
    } on Exception catch (e) {
      error = e.toString().replaceFirst("Exception: ", "");
    }
    if (!mounted) return;
    setState(() => _isSaving = false);
    if (error != null) {
      Toast.show(context, error, variant: ToastVariant.error);
      return;
    }
    Toast.show(context, "Recovery key saved", variant: ToastVariant.success);
    Navigator.of(context).pop(updated ?? widget.user);
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
              const Header(
                icon: Icons.key_outlined,
                title: "Save your recovery key",
                subtitle:
                    "This 24-word key is the only way to restore your vault if you lose access to this device. Write it down and keep it somewhere safe.",
              ),
              const SizedBox(height: 24),
              Container(
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
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (var i = 0; i < _words.length; i++)
                      _WordChip(index: i + 1, word: _words[i]),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _copy,
                      icon: const Icon(Icons.copy_all_outlined, size: 18),
                      label: const Text("Copy"),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Theme.of(context).primaryColor,
                        side: BorderSide(color: colors.outlineVariant),
                        minimumSize: const Size(0, 44),
                        shape: RoundedRectangleBorder(
                          borderRadius: .circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _share,
                      icon: const Icon(Icons.ios_share, size: 18),
                      label: const Text("Download"),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Theme.of(context).primaryColor,
                        side: BorderSide(color: colors.outlineVariant),
                        minimumSize: const Size(0, 44),
                        shape: RoundedRectangleBorder(
                          borderRadius: .circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const .all(14),
                decoration: BoxDecoration(
                  color: colors.errorContainer.withValues(alpha: 0.4),
                  borderRadius: .circular(12),
                ),
                child: Row(
                  crossAxisAlignment: .start,
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      size: 20,
                      color: colors.error,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Anyone with this key can open all your vaults. We can't show it again, so store it safely.",
                        style: textTheme.bodySmall?.copyWith(
                          color: colors.onErrorContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              CheckboxListTile(
                value: _confirmed,
                onChanged: (value) =>
                    setState(() => _confirmed = value ?? false),
                contentPadding: .zero,
                controlAffinity: .leading,
                activeColor: Theme.of(context).primaryColor,
                title: Text(
                  "I've saved my recovery key somewhere safe",
                  style: textTheme.bodyMedium?.copyWith(
                    color: colors.onSurface,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              CtaSection(
                onPressed: _confirmed && !_isSaving ? _save : null,
                isLoading: _isSaving,
                label: "Save recovery key",
                isEntry: true,
                helperText:
                    "Your recovery key is encrypted before it's stored, so no one else can read it — not even us.",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WordChip extends StatelessWidget {
  final int index;
  final String word;
  const _WordChip({required this.index, required this.word});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const .symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHigh,
        borderRadius: .circular(8),
      ),
      child: Row(
        mainAxisSize: .min,
        children: [
          Text(
            '$index',
            style: textTheme.labelSmall?.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            word,
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: .w600,
              color: colors.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
