import 'package:flutter/material.dart';
import 'package:composition_md/models/drama.dart';

class DramaFormScreen extends StatefulWidget {
  const DramaFormScreen({super.key, this.drama});

  /// null = mode tambah, tidak null = mode edit.
  final Drama? drama;

  @override
  State<DramaFormScreen> createState() => _DramaFormScreenState();
}

class _DramaFormScreenState extends State<DramaFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late final _title = TextEditingController(text: widget.drama?.title);
  late final _genre = TextEditingController(text: widget.drama?.genre);
  late final _total = TextEditingController(
      text: widget.drama?.totalEpisodes.toString());
  late final _watched = TextEditingController(
      text: widget.drama?.watchedEpisodes.toString() ?? '0');
  late final _minutes = TextEditingController(
      text: widget.drama?.minutesPerEpisode.toString() ?? '60');
  late final _tropes =
  TextEditingController(text: widget.drama?.tropes.join(', '));
  late final _ratings = TextEditingController(
      text: widget.drama?.seasonRatings.map((r) => r.toString()).join(', '));
  late WatchStatus _status = widget.drama?.status ?? WatchStatus.backlog;

  @override
  void dispose() {
    for (final c in [_title, _genre, _total, _watched, _minutes, _tropes, _ratings]) {
      c.dispose();
    }
    super.dispose();
  }

  List<String> _splitList(String? value) => (value ?? '')
      .split(',')
      .map((s) => s.trim())
      .where((s) => s.isNotEmpty)
      .toList();

  String? _checkRequired(String? v) =>
      (v == null || v.trim().isEmpty) ? 'Required' : null;

  String? _checkPositive(String? v) {
    final n = int.tryParse(v?.trim() ?? '');
    return (n == null || n < 1) ? 'Enter a number of 1 or more' : null;
  }

  String? _checkWatched(String? v) {
    final n = int.tryParse(v?.trim() ?? '');
    final total = int.tryParse(_total.text.trim());
    if (n == null || n < 0) return 'Enter 0 or more';
    if (total != null && n > total) return 'Cannot exceed total episodes';
    return null;
  }

  String? _checkRatings(String? v) {
    for (final part in _splitList(v)) {
      final n = double.tryParse(part);
      if (n == null || n < 0 || n > 10) return 'Use numbers 0-10, e.g. 9.4, 8.7';
    }
    return null;
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final drama = Drama(
      id: widget.drama?.id ?? DateTime.now().microsecondsSinceEpoch.toString(),
      title: _title.text.trim(),
      genre: _genre.text.trim(),
      status: _status,
      totalEpisodes: int.parse(_total.text.trim()),
      watchedEpisodes: int.parse(_watched.text.trim()),
      minutesPerEpisode: int.parse(_minutes.text.trim()),
      tropes: _splitList(_tropes.text),
      seasonRatings: _splitList(_ratings.text).map(double.parse).toList(),
    );
    Navigator.of(context).pop(drama);
  }

  Widget _field({
    required String label,
    required TextEditingController controller,
    String? Function(String?)? validator,
    String? helper,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        validator: validator,
        keyboardType: keyboardType,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(labelText: label, helperText: helper),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.drama != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit Drama' : 'Add Drama')),
      body: SafeArea(
        top: false,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _field(label: 'Title', controller: _title, validator: _checkRequired),
                _field(label: 'Genre', controller: _genre, validator: _checkRequired),
                Text('Status', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final s in WatchStatus.values)
                      ChoiceChip(
                        label: Text(s.label),
                        showCheckmark: false,
                        selected: _status == s,
                        onSelected: (_) => setState(() => _status = s),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                _field(
                  label: 'Total episodes',
                  controller: _total,
                  validator: _checkPositive,
                  keyboardType: TextInputType.number,
                ),
                _field(
                  label: 'Watched episodes',
                  controller: _watched,
                  validator: _checkWatched,
                  keyboardType: TextInputType.number,
                ),
                _field(
                  label: 'Minutes per episode',
                  controller: _minutes,
                  validator: _checkPositive,
                  keyboardType: TextInputType.number,
                ),
                _field(
                  label: 'Tropes (optional)',
                  controller: _tropes,
                  helper: 'Separate with commas',
                ),
                _field(
                  label: 'Season ratings (optional)',
                  controller: _ratings,
                  validator: _checkRatings,
                  helper: 'One per season, e.g. 9.4, 8.7',
                ),
                FilledButton(
                  onPressed: _save,
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                  ),
                  child: Text(isEdit ? 'Save changes' : 'Add drama'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}