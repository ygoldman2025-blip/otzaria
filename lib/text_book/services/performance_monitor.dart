// filepath: lib/text_book/services/performance_monitor.dart
import 'dart:async';

/// Monitors and logs performance metrics for document loading
class PerformanceMonitor {
  static final PerformanceMonitor _instance = PerformanceMonitor._internal();
  
  final List<LoadMetric> _metrics = [];
  Timer? _cleanupTimer;

  factory PerformanceMonitor() => _instance;

  PerformanceMonitor._internal() {
    // Auto-cleanup old metrics every hour
    _cleanupTimer = Timer.periodic(const Duration(hours: 1), (_) => _cleanup());
  }

  /// Start measuring a load operation
  Stopwatch startMeasure(String operationName) {
    return Stopwatch()..start();
  }

  /// Record a completed measurement
  void recordMetric(
    String operationName,
    int durationMs, {
    bool success = true,
    String? details,
  }) {
    _metrics.add(LoadMetric(
      operationName: operationName,
      durationMs: durationMs,
      timestamp: DateTime.now(),
      success: success,
      details: details,
    ));

    if (_metrics.length > 1000) {
      _cleanup();
    }
  }

  /// Get average load time for operation
  double getAverageTime(String operationName) {
    final relevant = _metrics.where((m) => m.operationName == operationName).toList();
    if (relevant.isEmpty) return 0;
    
    final total = relevant.fold<int>(0, (sum, m) => sum + m.durationMs);
    return total / relevant.length;
  }

  /// Get slowest load time for operation
  int? getSlowestTime(String operationName) {
    final relevant = _metrics
        .where((m) => m.operationName == operationName)
        .map((m) => m.durationMs);
    return relevant.isEmpty ? null : relevant.reduce((a, b) => a > b ? a : b);
  }

  /// Get success rate for operation
  double getSuccessRate(String operationName) {
    final relevant = _metrics.where((m) => m.operationName == operationName).toList();
    if (relevant.isEmpty) return 0;
    
    final successful = relevant.where((m) => m.success).length;
    return (successful / relevant.length) * 100;
  }

  /// Get all metrics
  List<LoadMetric> getAllMetrics() => List.from(_metrics);

  /// Clear old metrics
  void _cleanup() {
    final cutoff = DateTime.now().subtract(const Duration(hours: 24));
    _metrics.retainWhere((m) => m.timestamp.isAfter(cutoff));
  }

  /// Clear all metrics
  void clearAll() {
    _metrics.clear();
  }

  /// Get summary report
  Map<String, dynamic> getSummaryReport() {
    if (_metrics.isEmpty) return {};

    final operations = <String, Map<String, dynamic>>{};
    
    for (final metric in _metrics) {
      final op = metric.operationName;
      if (!operations.containsKey(op)) {
        operations[op] = {
          'count': 0,
          'totalTime': 0,
          'minTime': 999999,
          'maxTime': 0,
          'successCount': 0,
        };
      }

      final data = operations[op]!;
      data['count'] = (data['count'] as int) + 1;
      data['totalTime'] = (data['totalTime'] as int) + metric.durationMs;
      data['minTime'] = (data['minTime'] as int) < metric.durationMs 
          ? (data['minTime'] as int) 
          : metric.durationMs;
      data['maxTime'] = (data['maxTime'] as int) > metric.durationMs 
          ? (data['maxTime'] as int) 
          : metric.durationMs;
      if (metric.success) {
        data['successCount'] = (data['successCount'] as int) + 1;
      }
    }

    // Calculate averages
    for (final data in operations.values) {
      final count = data['count'] as int;
      data['averageTime'] = (data['totalTime'] as int) ~/ count;
      data['successRate'] = ((data['successCount'] as int) / count * 100).toStringAsFixed(1);
    }

    return operations;
  }

  /// Print performance report
  void printReport() {
    final report = getSummaryReport();
    print('\n========== PERFORMANCE REPORT ==========');
    
    report.forEach((operation, data) {
      print('\n$operation:');
      print('  Count: ${data['count']}');
      print('  Average: ${data['averageTime']}ms');
      print('  Min: ${data['minTime']}ms');
      print('  Max: ${data['maxTime']}ms');
      print('  Success Rate: ${data['successRate']}%');
    });
    
    print('\n========================================\n');
  }

  void dispose() {
    _cleanupTimer?.cancel();
    _metrics.clear();
  }
}

class LoadMetric {
  final String operationName;
  final int durationMs;
  final DateTime timestamp;
  final bool success;
  final String? details;

  LoadMetric({
    required this.operationName,
    required this.durationMs,
    required this.timestamp,
    required this.success,
    this.details,
  });

  @override
  String toString() {
    return '$operationName: ${durationMs}ms (${success ? 'OK' : 'FAIL'})';
  }
}
