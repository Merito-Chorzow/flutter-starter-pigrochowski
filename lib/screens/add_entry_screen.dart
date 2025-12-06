import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../models/journal_entry.dart';

class AddEntryScreen extends StatefulWidget {
  const AddEntryScreen({super.key});

  @override
  State<AddEntryScreen> createState() => _AddEntryScreenState();
}

class _AddEntryScreenState extends State<AddEntryScreen> {
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();

  double? _lat;
  double? _lng;
  bool _locLoading = false;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _getLocation() async {
    setState(() => _locLoading = true);

    try {
      final enabled = await Geolocator.isLocationServiceEnabled();
      if (!enabled) {
        _showSnack('Usługi lokalizacji są wyłączone.');
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        _showSnack('Brak zgody na lokalizację.');
        return;
      }

      if (permission == LocationPermission.deniedForever) {
        _showSnack('Lokalizacja zablokowana na stałe w ustawieniach.');
        return;
      }

      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
      );

      setState(() {
        _lat = pos.latitude;
        _lng = pos.longitude;
      });

      _showSnack('Lokalizacja pobrana.');
    } catch (e) {
      _showSnack('Nie udało się pobrać lokalizacji.');
    } finally {
      setState(() => _locLoading = false);
    }
  }

  void _save() {
    final title = _titleCtrl.text.trim();
    final desc = _descCtrl.text.trim();

    if (title.isEmpty && desc.isEmpty) {
      _showSnack('Uzupełnij tytuł lub opis.');
      return;
    }

    final entry = JournalEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title.isEmpty ? 'Bez tytułu' : title,
      description: desc,
      date: DateTime.now(),
      lat: _lat,
      lng: _lng,
    );

    Navigator.pop(context, entry);
  }

  void _showSnack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dodaj wpis'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _titleCtrl,
            decoration: const InputDecoration(
              labelText: 'Tytuł',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _descCtrl,
            maxLines: 5,
            decoration: const InputDecoration(
              labelText: 'Opis',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _locLoading ? null : _getLocation,
                  icon: _locLoading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.my_location),
                  label: const Text('Pobierz lokalizację'),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),
          if (_lat != null && _lng != null)
            Text(
              'Aktualna lokalizacja: ${_lat!.toStringAsFixed(5)}, ${_lng!.toStringAsFixed(5)}',
              style: const TextStyle(fontSize: 12),
            ),

          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: _save,
            icon: const Icon(Icons.save),
            label: const Text('Zapisz wpis'),
          ),
        ],
      ),
    );
  }
}
