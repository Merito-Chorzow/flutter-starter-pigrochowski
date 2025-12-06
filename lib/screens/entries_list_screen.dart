import 'package:flutter/material.dart';
import '../models/journal_entry.dart';
import '../services/api_service.dart';
import 'add_entry_screen.dart';
import 'entry_details_screen.dart';

class EntriesListScreen extends StatefulWidget {
  const EntriesListScreen({super.key});

  @override
  State<EntriesListScreen> createState() => _EntriesListScreenState();
}

class _EntriesListScreenState extends State<EntriesListScreen> {
  final ApiService _api = ApiService();
  late Future<List<JournalEntry>> _future;

  // wpisy dodane przez Ciebie lokalnie
  final List<JournalEntry> _localEntries = [];

  @override
  void initState() {
    super.initState();
    _future = _api.fetchEntries();
  }

  Future<void> _refresh() async {
    setState(() {
      _future = _api.fetchEntries();
    });
  }

  Future<void> _openAdd() async {
    final result = await Navigator.push<JournalEntry>(
      context,
      MaterialPageRoute(builder: (_) => const AddEntryScreen()),
    );

    if (result != null) {
      setState(() {
        _localEntries.insert(0, result);
      });
    }
  }

  String _shortDate(DateTime d) {
    final dd = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    return '$dd.$mm';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Geo Journal'),
        actions: [
          IconButton(
            onPressed: _refresh,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAdd,
        icon: const Icon(Icons.add),
        label: const Text('Dodaj'),
      ),
      body: FutureBuilder<List<JournalEntry>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Nie udało się pobrać wpisów z API.',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 12),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: _refresh,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Spróbuj ponownie'),
                    ),
                  ],
                ),
              ),
            );
          }

          final apiEntries = snapshot.data ?? [];
          final allEntries = [..._localEntries, ...apiEntries];

          if (allEntries.isEmpty) {
            return const Center(child: Text('Brak wpisów do wyświetlenia.'));
          }

          return ListView.separated(
            itemCount: allEntries.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final e = allEntries[index];

              return ListTile(
                title: Text(e.title.isEmpty ? 'Bez tytułu' : e.title),
                subtitle: Text(
                  e.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Text(
                  _shortDate(e.date),
                  style: const TextStyle(fontSize: 12),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EntryDetailsScreen(entry: e),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
