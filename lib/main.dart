import 'package:flutter/material.dart';
import 'screens/entries_list_screen.dart';

void main() {
  runApp(const GeoJournalApp());
}

class GeoJournalApp extends StatelessWidget {
  const GeoJournalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Geo Journal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      ),
      home: const EntriesListScreen(),
    );
  }
}
