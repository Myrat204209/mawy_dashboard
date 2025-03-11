import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier(this._settingsBox) : super(ThemeMode.light) {
    final savedIndex = _settingsBox.get('themeModeIndex', defaultValue: 0);
    state = ThemeMode.values[savedIndex];
  }
  final Box _settingsBox;

  bool isDarkTheme() {
    return _settingsBox.get('themeModeIndex') == 1;
  }

  void toggleTheme() {
    state = (state == ThemeMode.light) ? ThemeMode.dark : ThemeMode.light;
    _settingsBox.put('themeModeIndex', state.index);
  }
}

final themeNotifierProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((
  ref,
) {
  // Use authCheckBoxProvider or another Hive box designated for settings.
  final settingsBox = Hive.box('test4box');
  return ThemeNotifier(settingsBox);
});
