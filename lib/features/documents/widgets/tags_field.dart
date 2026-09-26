import 'package:docket/shared/pill_chip.dart';
import 'package:docket/shared/text_field.dart';
import 'package:flutter/material.dart';

class TagsField extends StatefulWidget {
  final List<String> tags;
  final ValueChanged<List<String>> onChanged;
  const TagsField({super.key, required this.tags, required this.onChanged});

  @override
  State<TagsField> createState() => _TagsFieldState();
}

class _TagsFieldState extends State<TagsField> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _commit() {
    final incoming = _controller.text
        .split(",")
        .map((tag) => tag.trim())
        .where((tag) => tag.isNotEmpty)
        .toList();
    if (incoming.isEmpty) return;
    final next = [...widget.tags];
    for (final tag in incoming) {
      final isDuplicate = next.any(
        (existing) => existing.toLowerCase() == tag.toLowerCase(),
      );
      if (!isDuplicate) next.add(tag);
    }
    _controller.clear();
    widget.onChanged(next);
  }

  void _remove(String tag) {
    widget.onChanged([
      for (final existing in widget.tags)
        if (existing != tag) existing,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        DocketTextField(
          label: "Tags",
          placeholder: "Type a tag, then press add",
          controller: _controller,
          onSubmitted: _commit,
          suffixIcon: IconButton(
            onPressed: _commit,
            tooltip: 'Add tag',
            icon: const Icon(Icons.add),
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        if (widget.tags.isNotEmpty) ...[
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final tag in widget.tags)
                PillChip(
                  icon: Icons.sell_outlined,
                  label: tag,
                  onDeleted: () => _remove(tag),
                ),
            ],
          ),
        ],
      ],
    );
  }
}
