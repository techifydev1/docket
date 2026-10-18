import 'package:docket/core/theme/vault_theme.dart';
import 'package:docket/features/crypto/crypto_service.dart';
import 'package:docket/features/http/api_response.dart';
import 'package:docket/features/onboarding/widgets/code_card.dart';
import 'package:docket/features/recovery/recovery_service.dart';
import 'package:docket/shared/cta_section.dart';
import 'package:docket/shared/docket_card.dart';
import 'package:docket/shared/header.dart';
import 'package:docket/shared/link_button.dart';
import 'package:docket/shared/toast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecoveryScreen extends StatefulWidget {
  const RecoveryScreen({super.key});

  @override
  State<RecoveryScreen> createState() => _RecoveryScreenState();
}

class _RecoveryScreenState extends State<RecoveryScreen> {
  final RecoveryService _service = RecoveryService();
  final TextEditingController _phraseController = TextEditingController();
  late final CryptoService _crypto;
  bool _isValidPhrase = false;
  bool _isSending = false;
  bool _isRestoring = false;
  bool _codeSent = false;
  String _code = '';
  int _codeResets = 0;

  @override
  void initState() {
    super.initState();
    _crypto = context.read<CryptoService>();
  }

  @override
  void dispose() {
    _phraseController.dispose();
    super.dispose();
  }

  String get _normalized => _phraseController.text
      .trim()
      .toLowerCase()
      .split(RegExp(r'\s+'))
      .join(' ');

  void _onPhraseChanged() {
    final valid = _crypto.isValidRecoveryPhrase(_normalized);
    if (valid != _isValidPhrase) setState(() => _isValidPhrase = valid);
  }

  Future<void> _sendCode() async {
    if (!_isValidPhrase || _isSending) return;
    setState(() => _isSending = true);
    try {
      await _service.requestRecoveryCode();
    } on ApiError catch (e) {
      if (!mounted) return;
      setState(() => _isSending = false);
      Toast.show(context, e.errorMessage, variant: ToastVariant.error);
      return;
    }
    if (!mounted) return;
    setState(() {
      _isSending = false;
      _codeSent = true;
      _code = '';
      _codeResets++;
    });
    Toast.show(
      context,
      "We sent a recovery code to your email",
      variant: ToastVariant.success,
    );
  }

  Future<void> _restore() async {
    if (_code.length != 6 || _isRestoring) return;
    setState(() => _isRestoring = true);
    try {
      final backup = await _service.confirmRecovery(_code);
      await _crypto.restoreKeyFromBackup(_normalized, backup);
    } on ApiError catch (e) {
      if (!mounted) return;
      setState(() => _isRestoring = false);
      Toast.show(context, e.errorMessage, variant: ToastVariant.error);
      return;
    } on Exception catch (e) {
      if (!mounted) return;
      setState(() => _isRestoring = false);
      Toast.show(
        context,
        e.toString().replaceFirst("Exception: ", ""),
        variant: ToastVariant.error,
      );
      return;
    }
    if (!mounted) return;
    setState(() => _isRestoring = false);
    Toast.show(context, "Vault restored", variant: ToastVariant.success);
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = VaultTheme.textTheme;
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
                  Header(
                    icon: _codeSent
                        ? Icons.mail_outline
                        : Icons.lock_open_outlined,
                    title: _codeSent
                        ? "Verify your email"
                        : "Recover your vault",
                    subtitle: _codeSent
                        ? "Enter the 6-digit code we sent to your email to confirm it's you."
                        : "We couldn't find your keys on this device. Enter your 24-word recovery key to restore access to your family vaults.",
                  ),
                  const SizedBox(height: 24),
                  if (!_codeSent) ...[
                    DocketCard(
                      child: Column(
                        crossAxisAlignment: .start,
                        children: [
                          Text("Recovery key", style: textTheme.labelMedium),
                          const SizedBox(height: 4),
                          TextField(
                            controller: _phraseController,
                            maxLines: 4,
                            minLines: 3,
                            keyboardType: TextInputType.multiline,
                            textCapitalization: .none,
                            autocorrect: false,
                            enableSuggestions: false,
                            onChanged: (_) => _onPhraseChanged(),
                            style: textTheme.bodyMedium,
                            decoration: const InputDecoration(
                              hintText:
                                  "Enter your 24 words separated by spaces",
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    CtaSection(
                      onPressed: _isValidPhrase && !_isSending
                          ? _sendCode
                          : null,
                      isLoading: _isSending,
                      label: "Send recovery code",
                      isEntry: true,
                      helperText:
                          "We'll email a one-time code to confirm it's really you.",
                    ),
                  ] else ...[
                    CodeCard(
                      onChanged: (pin) => setState(() => _code = pin),
                      onResend: _sendCode,
                      isSending: _isSending,
                      resetKey: _codeResets,
                    ),
                    const SizedBox(height: 16),
                    CtaSection(
                      onPressed: _code.length == 6 && !_isRestoring
                          ? _restore
                          : null,
                      isLoading: _isRestoring,
                      label: "Restore vault",
                      isEntry: true,
                      helperText:
                          "Your recovery key is only used on this device and is never sent to our servers.",
                    ),
                    const SizedBox(height: 12),
                    Center(
                      child: LinkButton(
                        label: "Use a different recovery key",
                        onPressed: _isRestoring
                            ? null
                            : () => setState(() => _codeSent = false),
                      ),
                    ),
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
