import 'dart:ui' show ImageFilter;

import 'package:docket/core/theme/vault_theme.dart';
import 'package:flutter/material.dart';

class StyleGuideScreen extends StatelessWidget {
  const StyleGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: VaultTheme.build(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Style Guide", style: VaultTheme.textTheme.headlineSmall),
          backgroundColor: VaultTheme.canvas,
          actions: [
            Container(
              margin: const .only(right: 20),
              padding: const .symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: VaultTheme.surfaceMuted,
                borderRadius: .circular(999),
              ),
              child: Text(
                "PHASE 0",
                style: VaultTheme.overline.copyWith(color: VaultTheme.inkMuted),
              ),
            ),
          ],
        ),
        body: ListView(
          padding: const .fromLTRB(20, 8, 20, 64),
          children: const [
            _Intro(),
            SizedBox(height: VaultTheme.sectionGap),
            _ColorSection(),
            SizedBox(height: VaultTheme.sectionGap),
            _TypeSection(),
            SizedBox(height: VaultTheme.sectionGap),
            _ElevationSection(),
            SizedBox(height: VaultTheme.sectionGap),
            _ButtonsSection(),
            SizedBox(height: VaultTheme.sectionGap),
            _InputsSection(),
            SizedBox(height: VaultTheme.sectionGap),
            _ComponentsSection(),
            SizedBox(height: VaultTheme.sectionGap),
            _ToastSection(),
            SizedBox(height: VaultTheme.sectionGap),
            _NavSection(),
            SizedBox(height: VaultTheme.sectionGap),
            _MockupsSection(),
          ],
        ),
      ),
    );
  }
}

class _Intro extends StatelessWidget {
  const _Intro();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        Text("DOCKET", style: VaultTheme.overline),
        const SizedBox(height: 8),
        Text("The Vault", style: VaultTheme.textTheme.displayLarge),
        const SizedBox(height: 12),
        SizedBox(
          width: 260,
          child: Text(
            "A clean, warm canvas with one deep-emerald ink, frosted glass surfaces, and depth over borders. Space over density.",
            style: VaultTheme.textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        Row(
          children: [
            Container(width: 16, height: 2, color: VaultTheme.primary),
            const SizedBox(width: 8),
            Text(title.toUpperCase(), style: VaultTheme.overline),
          ],
        ),
        const SizedBox(height: 14),
        ...children,
      ],
    );
  }
}

class _Panel extends StatelessWidget {
  const _Panel({required this.child, this.padding = const .all(20)});

  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: VaultTheme.surface,
        borderRadius: .circular(VaultTheme.radiusLg),
        boxShadow: VaultTheme.e1,
      ),
      child: child,
    );
  }
}

class _ColorSection extends StatelessWidget {
  const _ColorSection();

  static const _swatches = <(String, String, Color, Color)>[
    ("Primary", "0B3B2E", VaultTheme.primary, VaultTheme.onPrimary),
    ("Bright", "1B7A52", VaultTheme.primaryBright, VaultTheme.onPrimary),
    ("Canvas", "F5F4F1", VaultTheme.canvas, VaultTheme.ink),
    ("Surface", "FFFFFF", VaultTheme.surface, VaultTheme.ink),
    ("Muted", "EDEBE6", VaultTheme.surfaceMuted, VaultTheme.ink),
    ("Hairline", "E4E1DA", VaultTheme.hairline, VaultTheme.ink),
    ("Ink", "10231C", VaultTheme.ink, VaultTheme.canvas),
    ("Ink Muted", "5C6660", VaultTheme.inkMuted, VaultTheme.canvas),
    ("Error", "B3261E", VaultTheme.error, VaultTheme.onPrimary),
  ];

  @override
  Widget build(BuildContext context) {
    return _Section(
      title: "Color",
      children: [
        _Panel(
          child: Wrap(
            spacing: 12,
            runSpacing: 16,
            children: [
              for (final (name, hex, color, fg) in _swatches)
                _Swatch(name: name, hex: hex, color: color, onColor: fg),
            ],
          ),
        ),
      ],
    );
  }
}

class _Swatch extends StatelessWidget {
  const _Swatch({
    required this.name,
    required this.hex,
    required this.color,
    required this.onColor,
  });

  final String name;
  final String hex;
  final Color color;
  final Color onColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 96,
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Container(
            height: 56,
            decoration: BoxDecoration(
              color: color,
              borderRadius: .circular(VaultTheme.radiusSm),
              border: .all(color: VaultTheme.ink.withValues(alpha: 0.06)),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            name,
            style: VaultTheme.textTheme.labelMedium,
            maxLines: 1,
            overflow: .ellipsis,
          ),
          Text(
            "#$hex",
            style: VaultTheme.textTheme.bodySmall,
            maxLines: 1,
            overflow: .ellipsis,
          ),
        ],
      ),
    );
  }
}

class _TypeSection extends StatelessWidget {
  const _TypeSection();

  @override
  Widget build(BuildContext context) {
    final text = VaultTheme.textTheme;
    return _Section(
      title: "Typography — Roboto",
      children: [
        _Panel(
          child: Column(
            crossAxisAlignment: .start,
            children: [
              const _Specimen(
                label: "Display / 40 Roboto",
                text: "Family Vault",
              ),
              const SizedBox(height: 20),
              const _Specimen(
                label: "Headline Large / 30",
                text: "Welcome home",
              ),
              const SizedBox(height: 20),
              const _Specimen(
                label: "Headline Medium / 24",
                text: "Recent Documents",
              ),
              const SizedBox(height: 20),
              const _Specimen(
                label: "Title / 16 SemiBold",
                text: "Birth Certificate",
              ),
              const SizedBox(height: 20),
              _Specimen(
                label: "Body / 14",
                text:
                    "Your documents are protected with zero-knowledge encryption.",
                style: text.bodyMedium,
              ),
              const SizedBox(height: 20),
              const _Specimen(
                label: "Overline / 11 +1.6",
                text: "VERIFIED OWNER",
                overline: true,
              ),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: .baseline,
                textBaseline: .alphabetic,
                children: [
                  Text("42", style: VaultTheme.stat),
                  const SizedBox(width: 8),
                  Text("documents", style: text.bodySmall),
                ],
              ),
              const SizedBox(height: 4),
              Text("Stat numerals — Roboto", style: text.bodySmall),
            ],
          ),
        ),
      ],
    );
  }
}

class _Specimen extends StatelessWidget {
  const _Specimen({
    required this.label,
    required this.text,
    this.style,
    this.overline = false,
  });

  final String label;
  final String text;
  final TextStyle? style;
  final bool overline;

  @override
  Widget build(BuildContext context) {
    final textTheme = VaultTheme.textTheme;
    return Column(
      crossAxisAlignment: .start,
      children: [
        Text(label.toUpperCase(), style: textTheme.labelSmall),
        const SizedBox(height: 6),
        Text(
          overline ? text.toUpperCase() : text,
          style:
              style ??
              (overline ? VaultTheme.overline : textTheme.headlineSmall),
        ),
      ],
    );
  }
}

class _ElevationSection extends StatelessWidget {
  const _ElevationSection();

  @override
  Widget build(BuildContext context) {
    Widget tile(String label, List<BoxShadow> shadows, Border? border) {
      return Container(
        height: 80,
        alignment: .center,
        decoration: BoxDecoration(
          color: VaultTheme.surface,
          borderRadius: .circular(VaultTheme.radiusLg),
          boxShadow: shadows,
          border: border,
        ),
        child: Text(label, style: VaultTheme.textTheme.labelMedium),
      );
    }

    Widget radiusBox(double radius) {
      return Expanded(
        child: Column(
          children: [
            Container(
              height: 56,
              decoration: BoxDecoration(
                color: VaultTheme.surfaceMuted,
                borderRadius: .circular(radius),
                border: .all(color: VaultTheme.hairline),
              ),
            ),
            const SizedBox(height: 6),
            Text("${radius.toInt()}px", style: VaultTheme.textTheme.bodySmall),
          ],
        ),
      );
    }

    return _Section(
      title: "Radius & Elevation",
      children: [
        Row(
          children: [
            Expanded(
              child: tile("Flat", const [], .all(color: VaultTheme.hairline)),
            ),
            const SizedBox(width: 12),
            Expanded(child: tile("e1 · card", VaultTheme.e1, null)),
            const SizedBox(width: 12),
            Expanded(child: tile("e2 · float", VaultTheme.e2, null)),
          ],
        ),
        const SizedBox(height: 16),
        _Panel(
          child: Row(
            children: [
              radiusBox(VaultTheme.radiusSm),
              const SizedBox(width: 12),
              radiusBox(VaultTheme.radiusMd),
              const SizedBox(width: 12),
              radiusBox(VaultTheme.radiusLg),
              const SizedBox(width: 12),
              radiusBox(VaultTheme.radiusXl),
            ],
          ),
        ),
      ],
    );
  }
}

class _ButtonsSection extends StatelessWidget {
  const _ButtonsSection();

  @override
  Widget build(BuildContext context) {
    return _Section(
      title: "Buttons",
      children: [
        _Panel(
          child: Column(
            children: [
              const _PrimaryButton(
                label: "Unlock Vault",
                icon: Icons.lock_open_rounded,
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: .infinity,
                child: FilledButton(
                  onPressed: () {},
                  child: const Text("Add Document"),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: .infinity,
                child: OutlinedButton(
                  onPressed: () {},
                  child: const Text("Invite Member"),
                ),
              ),
              const SizedBox(height: 12),
              const SizedBox(
                width: .infinity,
                child: FilledButton(onPressed: null, child: Text("Continue")),
              ),
              const SizedBox(height: 12),
              const _LoadingButton(),
            ],
          ),
        ),
      ],
    );
  }
}

class _PrimaryButton extends StatefulWidget {
  const _PrimaryButton({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  State<_PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<_PrimaryButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: () {},
      child: AnimatedScale(
        scale: _pressed ? 0.98 : 1,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: Container(
          height: 54,
          decoration: BoxDecoration(
            color: VaultTheme.primary,
            borderRadius: .circular(VaultTheme.radiusMd),
            boxShadow: VaultTheme.e1,
          ),
          child: Row(
            mainAxisAlignment: .center,
            children: [
              Icon(widget.icon, size: 20, color: VaultTheme.onPrimary),
              const SizedBox(width: 10),
              Text(
                widget.label,
                style: VaultTheme.textTheme.labelLarge?.copyWith(
                  color: VaultTheme.onPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoadingButton extends StatefulWidget {
  const _LoadingButton();

  @override
  State<_LoadingButton> createState() => _LoadingButtonState();
}

class _LoadingButtonState extends State<_LoadingButton> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: .infinity,
      child: FilledButton(
        onPressed: _loading
            ? null
            : () {
                setState(() => _loading = true);
                Future.delayed(const Duration(seconds: 2), () {
                  if (mounted) setState(() => _loading = false);
                });
              },
        child: _loading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: VaultTheme.inkMuted,
                ),
              )
            : const Text("Uploading…"),
      ),
    );
  }
}

class _InputsSection extends StatelessWidget {
  const _InputsSection();

  @override
  Widget build(BuildContext context) {
    return _Section(
      title: "Inputs — default · focused · error",
      children: [
        _Panel(
          child: Column(
            crossAxisAlignment: .start,
            children: [
              const _Field(label: "Email Address", hint: "you@example.com"),
              const SizedBox(height: 20),
              const _Field(
                label: "Password",
                hint: "Enter your password",
                focused: true,
              ),
              const SizedBox(height: 20),
              const _Field(
                label: "Full Legal Name",
                hint: "Your full legal name",
                error: "This field is required",
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required this.label,
    required this.hint,
    this.focused = false,
    this.error,
  });

  final String label;
  final String hint;
  final bool focused;
  final String? error;

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder border(Color color, [double width = 1.5]) =>
        OutlineInputBorder(
          borderRadius: .circular(VaultTheme.radiusMd),
          borderSide: BorderSide(color: color, width: width),
        );

    final decoration = InputDecoration(
      filled: true,
      fillColor: VaultTheme.surfaceMuted,
      hintText: hint,
      errorText: error,
      contentPadding: const .symmetric(horizontal: 16, vertical: 16),
      border: border(Colors.transparent, 0),
      enabledBorder: border(Colors.transparent, 0),
      focusedBorder: border(VaultTheme.primary),
      errorBorder: border(VaultTheme.error),
      focusedErrorBorder: border(VaultTheme.error),
      hintStyle: VaultTheme.textTheme.bodyMedium?.copyWith(
        color: VaultTheme.inkMuted.withValues(alpha: 0.6),
      ),
      errorStyle: VaultTheme.textTheme.bodySmall?.copyWith(
        color: VaultTheme.error,
      ),
    );

    return Column(
      crossAxisAlignment: .start,
      children: [
        Text(label.toUpperCase(), style: VaultTheme.textTheme.labelSmall),
        const SizedBox(height: 6),
        InputDecorator(
          isEmpty: true,
          isFocused: focused,
          decoration: decoration,
        ),
      ],
    );
  }
}

class _ComponentsSection extends StatelessWidget {
  const _ComponentsSection();

  @override
  Widget build(BuildContext context) {
    return _Section(
      title: "Chips · Badges · Avatars · Tiles",
      children: [
        _Panel(
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: const [
                  Chip(label: Text("All")),
                  Chip(
                    label: Text("Certificates"),
                    backgroundColor: VaultTheme.primary,
                    labelStyle: TextStyle(color: VaultTheme.onPrimary),
                    side: BorderSide.none,
                  ),
                  Chip(label: Text("Health")),
                  Chip(label: Text("Deeds")),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const _Badge(
                    label: "Secured",
                    icon: Icons.verified_user_rounded,
                  ),
                  const SizedBox(width: 8),
                  _Badge(
                    label: "Owner",
                    icon: Icons.shield_rounded,
                    color: VaultTheme.surfaceMuted,
                    fg: VaultTheme.inkMuted,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const _VaultAvatar(initials: "YA", size: 44),
                  const SizedBox(width: 8),
                  const _VaultAvatar(initials: "KD", size: 44, soft: true),
                  const SizedBox(width: 8),
                  const _VaultAvatar(initials: "MA", size: 44),
                  const Spacer(),
                  const _IconTile(icon: Icons.folder_rounded),
                  const SizedBox(width: 8),
                  const _IconTile(icon: Icons.lock_rounded, primary: false),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({
    required this.label,
    required this.icon,
    this.color = VaultTheme.primarySoft,
    this.fg = VaultTheme.primary,
  });

  final String label;
  final IconData icon;
  final Color color;
  final Color fg;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const .symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(color: color, borderRadius: .circular(999)),
      child: Row(
        mainAxisSize: .min,
        children: [
          Icon(icon, size: 14, color: fg),
          const SizedBox(width: 6),
          Text(
            label,
            style: VaultTheme.textTheme.labelMedium?.copyWith(color: fg),
          ),
        ],
      ),
    );
  }
}

class _VaultAvatar extends StatelessWidget {
  const _VaultAvatar({
    required this.initials,
    required this.size,
    this.soft = false,
  });

  final String initials;
  final double size;
  final bool soft;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: .center,
      decoration: BoxDecoration(
        color: soft ? VaultTheme.primarySoft : VaultTheme.primary,
        shape: .circle,
        border: .all(color: VaultTheme.surface, width: 2),
        boxShadow: VaultTheme.e1,
      ),
      child: Text(
        initials,
        style: VaultTheme.textTheme.labelMedium?.copyWith(
          color: soft ? VaultTheme.primary : VaultTheme.onPrimary,
        ),
      ),
    );
  }
}

class _IconTile extends StatelessWidget {
  const _IconTile({required this.icon, this.primary = true});

  final IconData icon;
  final bool primary;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      alignment: .center,
      decoration: BoxDecoration(
        color: primary ? VaultTheme.primary : VaultTheme.surfaceMuted,
        borderRadius: .circular(14),
        boxShadow: primary ? VaultTheme.e1 : null,
      ),
      child: Icon(
        icon,
        size: 20,
        color: primary ? VaultTheme.onPrimary : VaultTheme.primary,
      ),
    );
  }
}

class _ToastSection extends StatelessWidget {
  const _ToastSection();

  @override
  Widget build(BuildContext context) {
    return _Section(
      title: "Toast — animated, glassy",
      children: [
        const _ToastPreview(
          message: "Document uploaded securely",
          icon: Icons.check_circle_outline,
          color: VaultTheme.primaryBright,
        ),
        const SizedBox(height: 12),
        const _ToastPreview(
          message: "Invitation sent to the family",
          icon: Icons.info_outline,
          color: VaultTheme.inkMuted,
        ),
        const SizedBox(height: 12),
        const _ToastPreview(
          message: "Could not decrypt the file",
          icon: Icons.error_outline,
          color: VaultTheme.error,
        ),
      ],
    );
  }
}

class _ToastPreview extends StatelessWidget {
  const _ToastPreview({
    required this.message,
    required this.icon,
    required this.color,
  });

  final String message;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const .symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: VaultTheme.surface,
        borderRadius: .circular(VaultTheme.radiusMd),
        border: .all(color: VaultTheme.hairline),
        boxShadow: VaultTheme.e2,
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Text(message, style: VaultTheme.textTheme.labelMedium),
          ),
        ],
      ),
    );
  }
}

class _NavSection extends StatelessWidget {
  const _NavSection();

  @override
  Widget build(BuildContext context) {
    Widget dot(double size, Color color, [double opacity = 0.16]) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color.withValues(alpha: opacity),
          shape: .circle,
        ),
      );
    }

    return _Section(
      title: "Navigation — floating glass bar",
      children: [
        ClipRRect(
          borderRadius: .circular(VaultTheme.radiusLg),
          child: Container(
            height: 180,
            color: VaultTheme.primary,
            child: Stack(
              children: [
                Positioned(
                  top: -30,
                  left: -20,
                  child: dot(130, VaultTheme.primaryBright, 0.55),
                ),
                Positioned(
                  top: 30,
                  right: -30,
                  child: dot(150, VaultTheme.surface, 0.12),
                ),
                Positioned(
                  bottom: -20,
                  left: 90,
                  child: dot(90, VaultTheme.onPrimary, 0.10),
                ),
                const Positioned(
                  left: 0,
                  right: 0,
                  bottom: 16,
                  child: Center(child: _GlassNav(width: 320)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _GlassNav extends StatelessWidget {
  const _GlassNav({required this.width});

  final double width;

  @override
  Widget build(BuildContext context) {
    const items = [
      (Icons.home_rounded, "Home", true),
      (Icons.folder_rounded, "Documents", false),
      (Icons.settings_rounded, "Settings", false),
    ];
    return Container(
      width: width,
      height: 64,
      padding: const .symmetric(horizontal: 8),
      child: ClipRRect(
        borderRadius: .circular(999),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            decoration: BoxDecoration(
              color: VaultTheme.surface.withValues(alpha: 0.72),
              borderRadius: .circular(999),
              border: .all(color: VaultTheme.surface.withValues(alpha: 0.6)),
              boxShadow: VaultTheme.e2,
            ),
            child: Row(
              mainAxisAlignment: .spaceEvenly,
              children: [
                for (final (icon, label, selected) in items)
                  _NavItem(icon: icon, label: label, selected: selected),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
  });

  final IconData icon;
  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const .symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: selected ? VaultTheme.primary : Colors.transparent,
        borderRadius: .circular(999),
      ),
      child: Row(
        mainAxisSize: .min,
        children: [
          Icon(
            icon,
            size: 20,
            color: selected ? VaultTheme.onPrimary : VaultTheme.inkMuted,
          ),
          if (selected) ...[
            const SizedBox(width: 8),
            Text(
              label,
              style: VaultTheme.textTheme.labelMedium?.copyWith(
                color: VaultTheme.onPrimary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _MockupsSection extends StatelessWidget {
  const _MockupsSection();

  @override
  Widget build(BuildContext context) {
    return _Section(
      title: "Composed Previews",
      children: [
        const _VaultCardMock(),
        const SizedBox(height: 16),
        const _Panel(
          padding: .all(8),
          child: Column(
            children: [
              _DocRowMock(
                icon: Icons.description_rounded,
                title: "Birth Certificate",
                subtitle: "PDF · 1.2 MB · Amara",
              ),
              Divider(height: 1, color: VaultTheme.hairline),
              _DocRowMock(
                icon: Icons.health_and_safety_rounded,
                title: "Immunization Record",
                subtitle: "PDF · 840 KB · Kwame",
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const _LoginMock(),
      ],
    );
  }
}

class _VaultCardMock extends StatelessWidget {
  const _VaultCardMock();

  @override
  Widget build(BuildContext context) {
    return _Panel(
      padding: const .all(22),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Row(
            children: [
              const _IconTile(icon: Icons.roofing_rounded),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      "The Adeyemi Family",
                      style: VaultTheme.textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "Household Archival System",
                      style: VaultTheme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          const Divider(),
          const SizedBox(height: 18),
          Row(
            children: [
              _Stat(value: "42", label: "Documents"),
              _Stat(value: "5", label: "Members"),
              _Stat(value: "100%", label: "Encrypted"),
            ],
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Text(value, style: VaultTheme.stat),
          const SizedBox(height: 4),
          Text(label.toUpperCase(), style: VaultTheme.textTheme.labelSmall),
        ],
      ),
    );
  }
}

class _DocRowMock extends StatelessWidget {
  const _DocRowMock({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const .symmetric(horizontal: 12, vertical: 12),
      child: Row(
        children: [
          _IconTile(icon: icon, primary: false),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Text(title, style: VaultTheme.textTheme.titleMedium),
                const SizedBox(height: 2),
                Text(subtitle, style: VaultTheme.textTheme.bodySmall),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: VaultTheme.inkMuted,
            size: 20,
          ),
        ],
      ),
    );
  }
}

class _LoginMock extends StatelessWidget {
  const _LoginMock();

  @override
  Widget build(BuildContext context) {
    return _Panel(
      padding: const .all(22),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Text("Welcome back", style: VaultTheme.textTheme.headlineMedium),
          const SizedBox(height: 6),
          Text(
            "Sign in to reach your family vault.",
            style: VaultTheme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 22),
          const _Field(label: "Email Address", hint: "you@example.com"),
          const SizedBox(height: 16),
          const _Field(label: "Password", hint: "Enter your password"),
          const SizedBox(height: 10),
          Align(
            alignment: .centerRight,
            child: Text(
              "Forgot password?",
              style: VaultTheme.textTheme.labelMedium?.copyWith(
                color: VaultTheme.primary,
              ),
            ),
          ),
          const SizedBox(height: 16),
          const _PrimaryButton(
            label: "Sign In",
            icon: Icons.arrow_forward_rounded,
          ),
        ],
      ),
    );
  }
}
