import 'package:docket/features/documents/screens/add_file_screen.dart';
import 'package:docket/features/documents/document_category.dart';
import 'package:docket/features/documents/screens/document_details_screen.dart';
import 'package:docket/features/documents/widgets/document_filter_chips.dart';
import 'package:docket/features/documents/document_item.dart';
import 'package:docket/features/documents/widgets/documents_header.dart';
import 'package:docket/shared/bottom_nav.dart';
import 'package:docket/shared/document_card.dart';
import 'package:flutter/material.dart';

class DocumentsScreen extends StatefulWidget {
  const DocumentsScreen({super.key});

  @override
  State<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen> {
  DocumentCategory _category = DocumentCategory.all;

  final List<DocumentItem> _documents = [
    DocumentItem(
      icon: Icons.article_outlined,
      title: "Birth Certificate",
      subtitle: "Added 2 days ago",
      category: DocumentCategory.certificates,
      owner: "Eleanor Vance",
      fileName: "Eleanor_Vance_Birth_Certificate.pdf",
      addedOn: "24 September 2026",
      modifiedOn: "24 September 2026",
      fingerprint: "9F42-A1C7",
      fileSize: "1.2 MB",
      tags: ["Vital record", "Certified copy"],
    ),
    DocumentItem(
      icon: Icons.article_outlined,
      title: "Noah's Birth Certificate",
      subtitle: "Added 6 days ago",
      category: DocumentCategory.certificates,
      owner: "Eleanor Vance",
      fileName: "Noah_Vance_Birth_Certificate.pdf",
      addedOn: "20 September 2026",
      modifiedOn: "20 September 2026",
      fingerprint: "3B7D-90E4",
      tags: ["Vital record"],
    ),
    DocumentItem(
      icon: Icons.article_outlined,
      title: "Marriage Certificate",
      subtitle: "Added 3 weeks ago",
      category: DocumentCategory.certificates,
      owner: "Eleanor Vance",
      fileName: "Vance_Hartley_Marriage_Certificate.pdf",
      addedOn: "5 September 2026",
      modifiedOn: "5 September 2026",
      fingerprint: "C18A-55F2",
      fileSize: "2.4 MB",
      pageCount: 4,
      tags: ["Certified copy"],
    ),
    DocumentItem(
      icon: Icons.home_work_outlined,
      title: "Property Deed",
      subtitle: "Added 1 week ago",
      category: DocumentCategory.property,
      owner: "James Vance",
      fileName: "Vance_Home_Deed.pdf",
      addedOn: "19 September 2026",
      modifiedOn: "19 September 2026",
      fingerprint: "7D22-4E90",
      fileSize: "3.1 MB",
      pageCount: 6,
      tags: ["Property", "Original"],
    ),
    DocumentItem(
      icon: Icons.home_work_outlined,
      title: "Property Tax Record",
      subtitle: "Added 2 months ago",
      category: DocumentCategory.property,
      owner: "James Vance",
      fileName: "Vance_Home_Property_Tax_2026.pdf",
      addedOn: "1 August 2026",
      modifiedOn: "1 August 2026",
      fingerprint: "E0B6-13C7",
      tags: ["Property"],
    ),
    DocumentItem(
      icon: Icons.description_outlined,
      title: "Will & Testament",
      subtitle: "Added 2 months ago",
      category: DocumentCategory.property,
      owner: "Eleanor Vance",
      fileName: "Vance_Family_Will.pdf",
      addedOn: "1 August 2026",
      modifiedOn: "14 August 2026",
      fingerprint: "5A9F-2E84",
      fileSize: "0.8 MB",
      pageCount: 8,
      addedBy: "Eleanor Vance",
      visibility: "Eleanor Vance + Executor",
      tags: ["Legal", "Executed"],
    ),
    DocumentItem(
      icon: Icons.health_and_safety_outlined,
      title: "Health Record",
      subtitle: "Added 2 weeks ago",
      category: DocumentCategory.health,
      owner: "Eleanor Vance",
      fileName: "Eleanor_Vance_Health_Records.pdf",
      addedOn: "12 September 2026",
      modifiedOn: "18 September 2026",
      fingerprint: "2F6D-8B31",
      tags: ["Medical"],
    ),
    DocumentItem(
      icon: Icons.health_and_safety_outlined,
      title: "Prescription History",
      subtitle: "Added 1 month ago",
      category: DocumentCategory.health,
      owner: "Eleanor Vance",
      fileName: "Vance_Prescription_History.pdf",
      addedOn: "26 August 2026",
      modifiedOn: "26 August 2026",
      fingerprint: "8C43-1D97",
      tags: ["Medical"],
    ),
    DocumentItem(
      icon: Icons.badge_outlined,
      title: "Passport",
      subtitle: "Added 4 months ago",
      category: DocumentCategory.identity,
      owner: "Eleanor Vance",
      fileName: "Eleanor_Vance_Passport.jpg",
      addedOn: "26 May 2026",
      modifiedOn: "26 May 2026",
      fingerprint: "4E17-B6D2",
      fileType: "JPG",
      fileSize: "3.8 MB",
      pageCount: 1,
      visibility: "Eleanor Vance only",
      tags: ["Identity"],
    ),
    DocumentItem(
      icon: Icons.credit_card_outlined,
      title: "Driver's License",
      subtitle: "Added 4 months ago",
      category: DocumentCategory.identity,
      owner: "Eleanor Vance",
      fileName: "Eleanor_Vance_Drivers_Licence.pdf",
      addedOn: "26 May 2026",
      modifiedOn: "26 May 2026",
      fingerprint: "A05D-77C3",
      fileSize: "0.6 MB",
      pageCount: 1,
      visibility: "Eleanor Vance only",
      tags: ["Identity"],
    ),
    DocumentItem(
      icon: Icons.shield_outlined,
      title: "Insurance Policy",
      subtitle: "Added 5 months ago",
      category: DocumentCategory.identity,
      owner: "Eleanor Vance",
      fileName: "Vance_Family_Insurance_Policy.pdf",
      addedOn: "26 April 2026",
      modifiedOn: "26 April 2026",
      fingerprint: "6B39-4E15",
      fileSize: "1.9 MB",
      pageCount: 5,
      tags: ["Insurance"],
    ),
    DocumentItem(
      icon: Icons.verified_user_outlined,
      title: "Executor Letter",
      subtitle: "Added 2 months ago",
      category: DocumentCategory.identity,
      owner: "Eleanor Vance",
      fileName: "Executor_Appointment_Letter.pdf",
      addedOn: "1 August 2026",
      modifiedOn: "1 August 2026",
      fingerprint: "1F84-C6A2",
      fileSize: "0.4 MB",
      pageCount: 1,
      addedBy: "James Vance",
      visibility: "Eleanor Vance + Executor",
      tags: ["Legal"],
    ),
  ];

  List<DocumentItem> get _visibleDocuments => _category == DocumentCategory.all
      ? _documents
      : _documents.where((document) => document.category == _category).toList();

  void _openDetails(DocumentItem document) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => DocumentDetailsScreen(document: document),
      ),
    );
  }

  Future<void> _addDocument() async {
    final created = await Navigator.of(context).push<DocumentItem>(
      MaterialPageRoute(builder: (_) => const AddFileScreen()),
    );
    if (created == null) return;
    setState(() {
      _documents.insert(0, created);
      _category = DocumentCategory.all;
    });
  }

  @override
  Widget build(BuildContext context) {
    final documents = _visibleDocuments;
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: .stretch,
          children: [
            Padding(
              padding: const .fromLTRB(16, 16, 16, 0),
              child: DocumentsHeader(
                documentCount: _documents.length,
                onAdd: _addDocument,
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const .symmetric(horizontal: 16),
              child: DocumentFilterChips(
                selected: _category,
                onChanged: (value) => setState(() => _category = value),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                padding: const .fromLTRB(16, 0, 16, 16),
                itemCount: documents.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final document = documents[index];
                  return DocumentCard(
                    icon: document.icon,
                    title: document.title,
                    subtitle: document.subtitle,
                    onTap: () => _openDetails(document),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNav(currentIndex: 1),
    );
  }
}
