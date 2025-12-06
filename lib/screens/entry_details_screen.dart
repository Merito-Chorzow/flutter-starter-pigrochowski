import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/journal_entry.dart';

class EntryDetailsScreen extends StatelessWidget {
  final JournalEntry entry;

  const EntryDetailsScreen({
    super.key,
    required this.entry,
  });

  String _formatDate(DateTime d) {
    final dd = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    final yy = d.year.toString();
    final hh = d.hour.toString().padLeft(2, '0');
    final min = d.minute.toString().padLeft(2, '0');
    return '$dd.$mm.$yy $hh:$min';
  }

  @override
  Widget build(BuildContext context) {
    final hasLocation = entry.lat != null && entry.lng != null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Szczegóły wpisu'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text(
              entry.title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 6),
            Text(
              _formatDate(entry.date),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),

            if (entry.description.isNotEmpty)
              Text(
                entry.description,
                style: Theme.of(context).textTheme.bodyLarge,
              )
            else
              const Text('Brak opisu.'),

            const SizedBox(height: 24),
            const Divider(),

            const SizedBox(height: 8),
            Text(
              'Lokalizacja',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),

            if (hasLocation)
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '${entry.lat!.toStringAsFixed(5)}, ${entry.lng!.toStringAsFixed(5)}',
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: () {
                      final text =
                          '${entry.lat!.toStringAsFixed(5)}, ${entry.lng!.toStringAsFixed(5)}';
                      Clipboard.setData(ClipboardData(text: text));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Skopiowano lokalizację.')),
                      );
                    },
                    icon: const Icon(Icons.copy),
                    label: const Text('Kopiuj'),
                  ),
                ],
              )
            else
              const Text('Brak zapisanej lokalizacji.'),
          ],
        ),
      ),
    );
  }
}
