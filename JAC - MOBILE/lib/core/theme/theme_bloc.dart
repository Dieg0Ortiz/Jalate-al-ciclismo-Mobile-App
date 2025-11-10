import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_event.dart';
part 'theme_state.dart';

@injectable
class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc(this._prefs) : super(const ThemeState(ThemeMode.light)) {
    on<ThemeChanged>(_onThemeChanged);
    on<ThemeLoaded>(_onThemeLoaded);
    
    // Cargar tema guardado al iniciar
    add(const ThemeLoaded());
  }

  final SharedPreferences _prefs;
  static const String _themeKey = 'theme_mode';

  Future<void> _onThemeChanged(
    ThemeChanged event,
    Emitter<ThemeState> emit,
  ) async {
    await _prefs.setString(_themeKey, event.themeMode.toString());
    emit(ThemeState(event.themeMode));
  }

  Future<void> _onThemeLoaded(
    ThemeLoaded event,
    Emitter<ThemeState> emit,
  ) async {
    final themeString = _prefs.getString(_themeKey);
    if (themeString != null) {
      ThemeMode themeMode;
      if (themeString == 'ThemeMode.dark') {
        themeMode = ThemeMode.dark;
      } else if (themeString == 'ThemeMode.system') {
        themeMode = ThemeMode.system;
      } else {
        themeMode = ThemeMode.light;
      }
      emit(ThemeState(themeMode));
    }
  }
}

