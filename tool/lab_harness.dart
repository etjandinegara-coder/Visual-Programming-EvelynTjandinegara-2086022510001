// lab_harness.dart = device harness untuk Drama Vault
//
// Dibuat dengan pola yang sama seperti harness di lab04_start.dart: sebuah
// "layar HP" digambar di dalam window, lalu ukuran layar, rotasi, keyboard,
// notch, dan data dikirim ke HomeScreen

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:composition_md/design/theme.dart';
import 'package:composition_md/screens/home_screen.dart';

void main() => runApp(const LabHarness());

/// Tepat 200 karakter. Untuk tes "Long text".
const String kLongTitle =
    'Crash Landing on You: The Extended Director Cut With Alternate Endings, '
    'Behind The Scenes Commentary, Deleted Scenes, Cast Interviews, Bloopers, '
    'Soundtrack Special, and Fan Voted Epilogue Episodes Pt2';

final List<Map<String, dynamic>> kLongTitleDramas = [
  {
    'title': kLongTitle,
    'status': 'Watching',
    'genre': 'Romance Comedy Fantasy Thriller Historical Melodrama',
    'rating': 9.9,
  },
  ...kDefaultDramas,
];

const List<String> _statuses = ['Watching', 'Finished', 'Backlog'];

/// Untuk tes "Long list".
final List<Map<String, dynamic>> kBigDramas = List.generate(
  500,
      (i) => {
    'title': 'Drama ${i + 1}',
    'status': _statuses[i % _statuses.length],
    'genre': 'Romance',
    'rating': 5.0 + (i % 50) / 10,
  },
);

// Harness
enum _Device {
  small('Small phone', Size(320, 568)),
  large('Large phone', Size(430, 932)),
  tablet('Tablet', Size(800, 1280));

  const _Device(this.label, this.size);

  final String label;
  final Size size;
}

enum _Data {
  normal('Normal'),
  longTitle('200-char title'),
  empty('Zero items'),
  big('500 items');

  const _Data(this.label);

  final String label;

  List<Map<String, dynamic>> get dramas => switch (this) {
    _Data.normal => kDefaultDramas,
    _Data.longTitle => kLongTitleDramas,
    _Data.empty => const <Map<String, dynamic>>[],
    _Data.big => kBigDramas,
  };
}

/// App yang diuji: sama dengan MyApp di main.dart, tapi data bisa diganti.
class _DramaApp extends StatelessWidget {
  const _DramaApp({super.key, required this.dramas, required this.themeMode});

  final List<Map<String, dynamic>> dramas;
  final ThemeMode themeMode;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Drama Vault',
      debugShowCheckedModeBanner: false,
      theme: dramaTheme,
      darkTheme: dramaDarkTheme,
      themeMode: themeMode,
      // Supaya bisa drag dengan mouse di Chrome / desktop.
      scrollBehavior: const MaterialScrollBehavior()
          .copyWith(dragDevices: PointerDeviceKind.values.toSet()),
      home: HomeScreen(dramas: dramas),
    );
  }
}

class LabHarness extends StatefulWidget {
  const LabHarness({super.key});

  @override
  State<LabHarness> createState() => _LabHarnessState();
}

class _LabHarnessState extends State<LabHarness> {
  _Device _device = _Device.small;
  _Data _data = _Data.normal;
  bool _landscape = false;
  bool _keyboard = false;
  bool _dark = false;
  bool _insets = false;

  Size get _screen => _landscape ? _device.size.flipped : _device.size;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Drama Vault · device harness',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF455A64),
      ),
      home: Builder(
        builder: (context) => Scaffold(
          body: SafeArea(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(width: 280, child: _panel(context)),
                const VerticalDivider(width: 1),
                Expanded(child: _stage(context)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _panel(BuildContext context) {
    final text = Theme.of(context).textTheme;

    Widget group(String title, List<Widget> chips) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: text.labelLarge),
            const SizedBox(height: 8),
            Wrap(spacing: 8, runSpacing: 8, children: chips),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Drama Vault · device harness', style: text.titleMedium),
        const SizedBox(height: 4),
        Text(
          'Coba semua kombinasi. Buka debug console: pesan '
              '"A RenderFlex overflowed by … pixels" menyebut widget, sumbu, '
              'dan jumlah pixel-nya.',
          style: text.bodySmall,
        ),
        const SizedBox(height: 20),
        group('Screen', [
          for (final d in _Device.values)
            ChoiceChip(
              label: Text(d.label),
              selected: _device == d,
              onSelected: (_) => setState(() => _device = d),
            ),
        ]),
        group('Orientation', [
          ChoiceChip(
            label: const Text('Portrait'),
            selected: !_landscape,
            onSelected: (_) => setState(() => _landscape = false),
          ),
          ChoiceChip(
            label: const Text('Landscape'),
            selected: _landscape,
            onSelected: (_) => setState(() => _landscape = true),
          ),
        ]),
        group('Data', [
          for (final d in _Data.values)
            ChoiceChip(
              label: Text(d.label),
              selected: _data == d,
              onSelected: (_) => setState(() => _data = d),
            ),
        ]),
        group('Conditions', [
          FilterChip(
            label: const Text('Keyboard open'),
            selected: _keyboard,
            onSelected: (v) => setState(() => _keyboard = v),
          ),
          FilterChip(
            label: const Text('Dark mode'),
            selected: _dark,
            onSelected: (v) => setState(() => _dark = v),
          ),
          FilterChip(
            label: const Text('Notch + gesture bar'),
            selected: _insets,
            onSelected: (v) => setState(() => _insets = v),
          ),
        ]),
        Text(
          'Screen: ${_screen.width.toInt()} × ${_screen.height.toInt()} dp',
          style: text.bodySmall,
        ),
      ],
    );
  }

  Widget _stage(BuildContext context) {
    final size = _screen;
    final keyboard = _keyboard ? (_landscape ? 180.0 : 260.0) : 0.0;
    final padding = !_insets
        ? EdgeInsets.zero
        : _landscape
        ? const EdgeInsets.only(left: 32, bottom: 20)
        : const EdgeInsets.only(top: 32, bottom: 20);
    // Saat keyboard terbuka, HP melaporkan padding bawah = 0.
    final safe = keyboard > 0 ? padding.copyWith(bottom: 0) : padding;
    final media = MediaQuery.of(context).copyWith(
      size: size,
      padding: safe,
      viewPadding: safe,
      viewInsets: EdgeInsets.only(bottom: keyboard),
    );

    return ColoredBox(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF1B1D1F),
                borderRadius: BorderRadius.circular(30),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: SizedBox.fromSize(
                  size: size,
                  child: MediaQuery(
                    data: media,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: _DramaApp(
                            // Ganti data -> state HomeScreen di-reset.
                            key: ValueKey(_data),
                            dramas: _data.dramas,
                            themeMode:
                            _dark ? ThemeMode.dark : ThemeMode.light,
                          ),
                        ),
                        if (padding.top > 0)
                          Positioned(
                            left: 0,
                            right: 0,
                            top: 0,
                            height: padding.top,
                            child: const IgnorePointer(child: _FakeStatusBar()),
                          ),
                        if (padding.left > 0)
                          Positioned(
                            left: 0,
                            top: 0,
                            bottom: 0,
                            width: padding.left,
                            child: const IgnorePointer(
                              child: ColoredBox(color: Color(0xFF000000)),
                            ),
                          ),
                        if (safe.bottom > 0)
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 0,
                            height: safe.bottom,
                            child:
                            const IgnorePointer(child: _FakeGestureBar()),
                          ),
                        if (keyboard > 0)
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 0,
                            height: keyboard,
                            child: const IgnorePointer(child: _FakeKeyboard()),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FakeStatusBar extends StatelessWidget {
  const _FakeStatusBar();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '9:41',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        Center(
          child: Container(
            width: 84,
            height: 22,
            decoration: BoxDecoration(
              color: const Color(0xFF000000),
              borderRadius: BorderRadius.circular(11),
            ),
          ),
        ),
      ],
    );
  }
}

class _FakeGestureBar extends StatelessWidget {
  const _FakeGestureBar();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 120,
        height: 5,
        decoration: BoxDecoration(
          color: const Color(0x99000000),
          borderRadius: BorderRadius.circular(3),
        ),
      ),
    );
  }
}

class _FakeKeyboard extends StatelessWidget {
  const _FakeKeyboard();

  static const List<String> _rows = ['qwertyuiop', 'asdfghjkl', 'zxcvbnm'];

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFF2B2F33),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Column(
          children: [
            for (final row in _rows)
              Expanded(
                child: Row(
                  children: [
                    for (final letter in row.split(''))
                      Expanded(child: _Key(letter)),
                  ],
                ),
              ),
            const Expanded(
              child: Row(
                children: [
                  Expanded(flex: 2, child: _Key('123')),
                  Expanded(flex: 6, child: _Key('spasi')),
                  Expanded(flex: 2, child: _Key('⏎')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Key extends StatelessWidget {
  const _Key(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: const Color(0xFF4A4F55),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(
          child: FittedBox(
            child: Padding(
              padding: const EdgeInsets.all(2),
              child: Text(
                label,
                style: const TextStyle(color: Color(0xCCFFFFFF), fontSize: 14),
              ),
            ),
          ),
        ),
      ),
    );
  }
}