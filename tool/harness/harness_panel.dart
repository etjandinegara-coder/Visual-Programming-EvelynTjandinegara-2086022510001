import 'package:flutter/material.dart';

import 'harness_data.dart';

class HarnessPanel extends StatelessWidget {
  const HarnessPanel({
    super.key,
    required this.device,
    required this.data,
    required this.landscape,
    required this.keyboard,
    required this.dark,
    required this.insets,
    required this.screen,
    required this.onDevice,
    required this.onData,
    required this.onLandscape,
    required this.onKeyboard,
    required this.onDark,
    required this.onInsets,
  });

  final HarnessDevice device;
  final HarnessData data;
  final bool landscape;
  final bool keyboard;
  final bool dark;
  final bool insets;
  final Size screen;

  final ValueChanged<HarnessDevice> onDevice;
  final ValueChanged<HarnessData> onData;
  final ValueChanged<bool> onLandscape;
  final ValueChanged<bool> onKeyboard;
  final ValueChanged<bool> onDark;
  final ValueChanged<bool> onInsets;

  @override
  Widget build(BuildContext context) {
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
          for (final d in HarnessDevice.values)
            ChoiceChip(
              label: Text(d.label),
              selected: device == d,
              onSelected: (_) => onDevice(d),
            ),
        ]),
        group('Orientation', [
          ChoiceChip(
            label: const Text('Portrait'),
            selected: !landscape,
            onSelected: (_) => onLandscape(false),
          ),
          ChoiceChip(
            label: const Text('Landscape'),
            selected: landscape,
            onSelected: (_) => onLandscape(true),
          ),
        ]),
        group('Data', [
          for (final d in HarnessData.values)
            ChoiceChip(
              label: Text(d.label),
              selected: data == d,
              onSelected: (_) => onData(d),
            ),
        ]),
        group('Conditions', [
          FilterChip(
            label: const Text('Keyboard open'),
            selected: keyboard,
            onSelected: onKeyboard,
          ),
          FilterChip(
            label: const Text('Dark mode'),
            selected: dark,
            onSelected: onDark,
          ),
          FilterChip(
            label: const Text('Notch + gesture bar'),
            selected: insets,
            onSelected: onInsets,
          ),
        ]),
        Text(
          'Screen: ${screen.width.toInt()} × ${screen.height.toInt()} dp',
          style: text.bodySmall,
        ),
      ],
    );
  }
}