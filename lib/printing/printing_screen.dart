import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:otzaria/models/books.dart';
import 'package:otzaria/models/links.dart';
import 'package:pdf/pdf.dart';

class PrintingScreen extends StatefulWidget {
  final Future<String> data;
  final Future<Uint8List> Function(PdfPageFormat format)? createPdfOverride;
  final String bookId;
  final List<Link> links;
  final List<String> activeCommentators;
  final bool removeNikud;
  final bool removeTaamim;
  final int startLine;
  final List<TocEntry> tableOfContents;
  const PrintingScreen({
    super.key,
    required this.data,
    this.createPdfOverride,
    required this.bookId,
    this.links = const [],
    this.activeCommentators = const [],
    this.startLine = 0,
    this.removeNikud = false,
    this.removeTaamim = false,
    this.tableOfContents = const [],
  });
  @override
  State<PrintingScreen> createState() => _PrintingScreenState();
}

class _PrintingScreenState extends State<PrintingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('הדפסה'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              FluentIcons.print_24_regular,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'הדפסה זמנית מושבתת',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'תכונת ההדפסה תחזור בקרוב',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}