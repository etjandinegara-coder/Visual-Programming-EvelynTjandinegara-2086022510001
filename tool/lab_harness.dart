// lab_harness.dart = device harness untuk Drama Vault
//
//   flutter run -t tool/lab_harness.dart -d chrome
//
// Sebuah "layar HP" digambar di dalam window, lalu ukuran layar, rotasi,
// keyboard, notch, dan data dikirim ke HomeScreen.

import 'package:flutter/material.dart';

import 'harness/harness_data.dart';
import 'harness/harness_panel.dart';
import 'harness/harness_stage.dart';

void main() => runApp(const LabHarness());

class LabHarness extends StatefulWidget {
  const LabHarness({super.key});

  @override
  State<LabHarness> createState() => _LabHarnessState();
}

class _LabHarnessState extends State<LabHarness> {
  HarnessDevice _device = HarnessDevice.small;
  HarnessData _data = HarnessData.normal;
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
      home: Scaffold(
        body: SafeArea(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: 280,
                child: HarnessPanel(
                  device: _device,
                  data: _data,
                  landscape: _landscape,
                  keyboard: _keyboard,
                  dark: _dark,
                  insets: _insets,
                  screen: _screen,
                  onDevice: (v) => setState(() => _device = v),
                  onData: (v) => setState(() => _data = v),
                  onLandscape: (v) => setState(() => _landscape = v),
                  onKeyboard: (v) => setState(() => _keyboard = v),
                  onDark: (v) => setState(() => _dark = v),
                  onInsets: (v) => setState(() => _insets = v),
                ),
              ),
              const VerticalDivider(width: 1),
              Expanded(
                child: HarnessStage(
                  size: _screen,
                  landscape: _landscape,
                  keyboardOpen: _keyboard,
                  insets: _insets,
                  dark: _dark,
                  data: _data,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}