import 'dart:convert';

import 'package:docket/features/crypto/crypto_service.dart';
import 'package:docket/features/family/family_provider.dart';
import 'package:docket/features/family/family_service.dart';
import 'package:docket/features/http/api_response.dart';
import 'package:docket/features/onboarding/widgets/family_name_input.dart';
import 'package:docket/shared/cta_section.dart';
import 'package:docket/shared/docket_back_button.dart';
import 'package:docket/shared/header.dart';
import 'package:docket/shared/toast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sodium/sodium.dart';

class CreateFamilyScreen extends StatefulWidget {
  const CreateFamilyScreen({super.key});

  @override
  State<CreateFamilyScreen> createState() => _CreateFamilyScreenState();
}

class _CreateFamilyScreenState extends State<CreateFamilyScreen> {
  final TextEditingController _nameController = TextEditingController();
  final FamilyService _service = FamilyService();
  bool _isCreating = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  bool get _isValid => _nameController.text.trim().isNotEmpty;

  Future<void> _create() async {
    if (!_isValid || _isCreating) return;
    setState(() => _isCreating = true);
    final crypto = context.read<CryptoService>();
    SecureKey? familyKey;
    try {
      final publicKey = await crypto.createUserKeys();
      familyKey = crypto.generateFamilyKey();
      final family = await _service.createFamily(
        _nameController.text.trim(),
        crypto.wrapFamilyKey(familyKey, base64Decode(publicKey)),
      );
      await crypto.saveFamilyKeyLocally(
        family.id,
        familyKey,
        family.keyVersion,
      );
      if (!mounted) return;
      context.read<FamilyProvider>().addFamily(family);
      Navigator.of(context).maybePop();
    } on ApiError catch (e) {
      if (!mounted) return;
      Toast.show(context, e.errorMessage, variant: ToastVariant.error);
    } finally {
      familyKey?.dispose();
      if (mounted) setState(() => _isCreating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final canPop = ModalRoute.of(context)?.canPop ?? false;
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: .stretch,
          children: [
            if (canPop) ...[
              const Padding(
                padding: .fromLTRB(16, 8, 16, 0),
                child: Align(alignment: .centerLeft, child: DocketBackButton()),
              ),
            ],
            Expanded(
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
                        const Header(
                          icon: Icons.create_new_folder_outlined,
                          title: "Create a family vault",
                          subtitle:
                              "Give your new vault a name. You can invite family members once it's created.",
                        ),
                        const SizedBox(height: 24),
                        FamilyNameInput(
                          controller: _nameController,
                          onChanged: () => setState(() {}),
                        ),
                        const SizedBox(height: 32),
                        CtaSection(
                          onPressed: _isValid ? _create : null,
                          isLoading: _isCreating,
                          label: "Create vault",
                          isEntry: false,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
