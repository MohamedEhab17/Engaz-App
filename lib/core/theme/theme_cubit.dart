import 'package:engaz_app/core/theme/theme_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/services/preferences_service.dart';

class ThemeCubit extends Cubit<ThemeModel> {
  final PreferencesService _prefs;

  ThemeCubit(this._prefs) : super(ThemeModel(isDark: false)) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final isDark = await _prefs.getTheme();
    emit(ThemeModel(isDark: isDark));
  }

  Future<void> toggleTheme() async {
    final newTheme = !state.isDark;
    await _prefs.saveTheme(newTheme);
    emit(ThemeModel(isDark: newTheme));
  }
}
