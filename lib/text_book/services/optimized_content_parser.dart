// filepath: lib/text_book/services/optimized_content_parser.dart
import 'dart:async';

/// High-performance content parsing with minimal allocations
class OptimizedContentParser {
  /// Parse content lines efficiently without creating unnecessary strings
  static List<String> parseContentLines(String content) {
    // Pre-allocate expected size
    final lines = <String>[];
    
    int start = 0;
    for (int i = 0; i < content.length; i++) {
      if (content[i] == '\n') {
        // Extract line without creating intermediate string
        final line = content.substring(start, i).trim();
        if (line.isNotEmpty) {
          lines.add(line);
        }
        start = i + 1;
      }
    }
    
    // Don't forget last line
    if (start < content.length) {
      final line = content.substring(start).trim();
      if (line.isNotEmpty) {
        lines.add(line);
      }
    }
    
    return lines;
  }

  /// Extract headings efficiently
  static List<HeadingInfo> extractHeadings(List<String> lines) {
    final headings = <HeadingInfo>[];
    
    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];
      final level = _getHeadingLevel(line);
      if (level > 0) {
        headings.add(HeadingInfo(
          text: line.replaceAll(RegExp(r'^#+\s*'), '').trim(),
          lineIndex: i,
          level: level,
        ));
      }
    }
    
    return headings;
  }

  /// Fast heading level detection
  static int _getHeadingLevel(String line) {
    if (!line.startsWith('#')) return 0;
    
    int level = 0;
    for (int i = 0; i < line.length && line[i] == '#'; i++) {
      level++;
    }
    return level;
  }

  /// Index content for faster lookups
  static Map<String, List<int>> createSearchIndex(List<String> lines) {
    final index = <String, List<int>>{};
    
    for (int i = 0; i < lines.length; i++) {
      final words = lines[i].split(RegExp(r'\s+'));
      for (final word in words) {
        if (word.length > 2) { // Skip short words
          final key = word.toLowerCase();
          index.putIfAbsent(key, () => []).add(i);
        }
      }
    }
    
    return index;
  }

  /// Find line range for quick navigation
  static LineRange? findLineRange(
    List<String> lines,
    String searchTerm, {
    bool caseSensitive = false,
  }) {
    final term = caseSensitive ? searchTerm : searchTerm.toLowerCase();
    int? startLine;
    int? endLine;

    for (int i = 0; i < lines.length; i++) {
      final line = caseSensitive ? lines[i] : lines[i].toLowerCase();
      if (line.contains(term)) {
        startLine ??= i;
        endLine = i;
      }
    }

    if (startLine != null && endLine != null) {
      return LineRange(start: startLine, end: endLine);
    }
    return null;
  }

  /// Batch process lines asynchronously
  static Future<List<T>> processBatch<T>(
    List<String> lines,
    T Function(String) processor, {
    int batchSize = 1000,
  }) async {
    final results = <T>[];
    
    for (int i = 0; i < lines.length; i += batchSize) {
      final batch = lines.sublist(
        i,
        (i + batchSize < lines.length) ? i + batchSize : lines.length,
      );

      for (final line in batch) {
        results.add(processor(line));
      }

      // Yield to event loop periodically
      if (i + batchSize < lines.length) {
        await Future.delayed(Duration.zero);
      }
    }

    return results;
  }
}

class HeadingInfo {
  final String text;
  final int lineIndex;
  final int level;

  HeadingInfo({
    required this.text,
    required this.lineIndex,
    required this.level,
  });
}

class LineRange {
  final int start;
  final int end;

  LineRange({required this.start, required this.end});

  int get length => end - start + 1;
}
