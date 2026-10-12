import 'package:docket/features/documents/document_item.dart';
import 'package:docket/features/documents/documents_provider.dart';
import 'package:docket/features/http/api_response.dart';
import 'package:docket/shared/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class DocumentViewerScreen extends StatefulWidget {
  final DocumentItem document;
  final Uint8List? bytes;
  const DocumentViewerScreen({super.key, required this.document, this.bytes});

  @override
  State<DocumentViewerScreen> createState() => _DocumentViewerScreenState();
}

class _DocumentViewerScreenState extends State<DocumentViewerScreen> {
  static const _imageTypes = {"png", "jpg", "jpeg", "gif", "webp"};

  Uint8List? _bytes;
  bool _isLoading = false;
  bool _isSharing = false;
  String? _error;

  bool get _isImage =>
      _imageTypes.contains(widget.document.fileType.toLowerCase());

  @override
  void initState() {
    super.initState();
    _bytes = widget.bytes;
    if (_bytes == null && _isImage) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _load());
    }
  }

  Future<void> _load() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final bytes = await context
          .read<DocumentsProvider>()
          .service
          .getDecryptedDocument(context, widget.document.record);
      if (!mounted) return;
      setState(() => _bytes = bytes);
    } on ApiError catch (e) {
      if (!mounted) return;
      setState(() => _error = e.errorMessage);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _share() async {
    if (_isSharing) return;
    setState(() => _isSharing = true);
    try {
      await context.read<DocumentsProvider>().service.shareDecrypted(
        context,
        widget.document.record,
      );
    } on ApiError catch (e) {
      if (!mounted) return;
      Toast.show(context, e.errorMessage, variant: ToastVariant.error);
    } finally {
      if (mounted) setState(() => _isSharing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        elevation: 0,
        title: Text(
          widget.document.title,
          maxLines: 1,
          overflow: .ellipsis,
          style: textTheme.labelLarge?.copyWith(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: _isSharing ? null : _share,
            tooltip: 'Share',
            icon: _isSharing
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.ios_share),
          ),
        ],
      ),
      body: SafeArea(child: _body()),
    );
  }

  Widget _body() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }
    if (_error != null) {
      return _ViewerMessage(
        icon: Icons.error_outline,
        title: "Couldn't open this file",
        message: _error!,
      );
    }
    final bytes = _bytes;
    if (bytes != null) {
      return InteractiveViewer(
        minScale: 0.5,
        maxScale: 5,
        child: Center(child: Image.memory(bytes, fit: BoxFit.contain)),
      );
    }
    return _ViewerMessage(
      icon: widget.document.icon,
      title: "Preview not supported",
      message:
          "This file type can't be opened in the app. Use Share to open it elsewhere.",
      onShare: _isSharing ? null : _share,
      isSharing: _isSharing,
    );
  }
}

class _ViewerMessage extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final VoidCallback? onShare;
  final bool isSharing;
  const _ViewerMessage({
    required this.icon,
    required this.title,
    required this.message,
    this.onShare,
    this.isSharing = false,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Center(
      child: Padding(
        padding: const .all(32),
        child: Column(
          mainAxisSize: .min,
          children: [
            Icon(icon, size: 56, color: Colors.white70),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: .center,
              style: textTheme.titleMedium?.copyWith(color: Colors.white),
            ),
            const SizedBox(height: 6),
            Text(
              message,
              textAlign: .center,
              style: textTheme.bodyMedium?.copyWith(color: Colors.white60),
            ),
            if (onShare != null) ...[
              const SizedBox(height: 20),
              SizedBox(
                height: 44,
                child: FilledButton.icon(
                  onPressed: onShare,
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: .circular(8)),
                  ),
                  icon: isSharing
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.ios_share, size: 18),
                  label: const Text("Share"),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
