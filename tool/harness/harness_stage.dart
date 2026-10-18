import 'package:flutter/material.dart';

import 'drama_test_app.dart';
import 'fake_device.dart';
import 'harness_data.dart';

class HarnessStage extends StatelessWidget {
  const HarnessStage({
    super.key,
    required this.size,
    required this.landscape,
    required this.keyboardOpen,
    required this.insets,
    required this.dark,
    required this.data,
  });

  final Size size;
  final bool landscape;
  final bool keyboardOpen;
  final bool insets;
  final bool dark;
  final HarnessData data;

  @override
  Widget build(BuildContext context) {
    final keyboard = keyboardOpen ? (landscape ? 180.0 : 260.0) : 0.0;
    final padding = !insets
        ? EdgeInsets.zero
        : landscape
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
                          child: DramaTestApp(
                            // Ganti data -> state HomeScreen di-reset.
                            key: ValueKey(data),
                            dramas: data.dramas,
                            themeMode: dark ? ThemeMode.dark : ThemeMode.light,
                          ),
                        ),
                        if (padding.top > 0)
                          Positioned(
                            left: 0,
                            right: 0,
                            top: 0,
                            height: padding.top,
                            child: const IgnorePointer(child: FakeStatusBar()),
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
                            child: const IgnorePointer(child: FakeGestureBar()),
                          ),
                        if (keyboard > 0)
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 0,
                            height: keyboard,
                            child: const IgnorePointer(child: FakeKeyboard()),
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