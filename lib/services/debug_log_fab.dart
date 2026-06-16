import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'log_service.dart';

class DebugLogFab extends StatelessWidget {
  const DebugLogFab({super.key});

  @override
  Widget build(BuildContext context) {
    if (!kDebugMode) return const SizedBox.shrink();
    return FloatingActionButton.small(
      heroTag: 'debug_log_fab',
      backgroundColor: Colors.black87,
      onPressed: () => _showLogDialog(context),
      tooltip: 'Download session logs',
      child: const Icon(Icons.download, color: Colors.greenAccent, size: 20),
    );
  }

  void _showLogDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Row(
          children: [
            const Text('Session Logs', style: TextStyle(fontSize: 16)),
            const Spacer(),
            Text('${LogService.instance.entryCount} entries', style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
        content: SizedBox(
          width: 600,
          height: 400,
          child: SelectionArea(
            child: ListView.builder(
              itemCount: LogService.instance.entryCount,
              itemBuilder: (_, i) {
                final entry = LogService.instance.entries[i];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 1),
                  child: Text(
                    entry.format(),
                    style: TextStyle(fontSize: 10, fontFamily: 'monospace', color: _colorForLevel(entry.level)),
                  ),
                );
              },
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
          ElevatedButton.icon(
            onPressed: () {
              LogService.instance.downloadLogFile();
              Navigator.pop(context);
            },
            icon: const Icon(Icons.download, size: 16),
            label: const Text('Download .log'),
          ),
        ],
      ),
    );
  }

  Color _colorForLevel(LogLevel level) {
    return switch (level) {
      LogLevel.debug => Colors.grey,
      LogLevel.info => Colors.white70,
      LogLevel.warning => Colors.orange,
      LogLevel.error => Colors.red,
      LogLevel.fatal => Colors.redAccent,
    };
  }
}
