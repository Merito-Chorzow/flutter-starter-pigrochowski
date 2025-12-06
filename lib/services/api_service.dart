import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/journal_entry.dart';

class ApiService {
  final String baseUrl;

  ApiService({this.baseUrl = 'https://jsonplaceholder.typicode.com'});

  Future<List<JournalEntry>> fetchEntries() async {
    final uri = Uri.parse('$baseUrl/posts?_limit=10');
    final res = await http.get(uri);

    if (res.statusCode != 200) {
      throw Exception('Błąd API (${res.statusCode})');
    }

    final List data = jsonDecode(res.body);
    return data.map((e) => JournalEntry.fromApi(e)).toList();
  }
}
