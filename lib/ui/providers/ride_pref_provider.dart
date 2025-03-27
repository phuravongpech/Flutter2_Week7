import 'package:flutter/material.dart';
import 'package:week_3_blabla_project/model/ride/ride_pref.dart';
import 'package:week_3_blabla_project/repository/ride_preferences_repository.dart';

class RidesPreferencesProvider extends ChangeNotifier {
  RidePreference? _currentPreference;
  List<RidePreference> _pastPreferences = [];
  final RidePreferencesRepository repository;
  RidesPreferencesProvider({required this.repository}) {
    // For now past preferences are fetched only 1 time
    _pastPreferences = repository.getPastPreferences();
    notifyListeners();
  }
  RidePreference? get currentPreference => _currentPreference;
  void setCurrentPreferrence(RidePreference pref) {
// Your code
    if (pref != currentPreference) {
      _currentPreference = pref;
      _addPreference(pref);
      notifyListeners();
    }
  }

  void _addPreference(RidePreference preference) {
    // Add the preference to history only if it's not equal to any in the history
    if (!_pastPreferences.contains(preference)) {
      _pastPreferences.add(preference);
      notifyListeners();
    }
  }

// History is returned from newest to oldest preference
  List<RidePreference> get preferencesHistory =>
      _pastPreferences.reversed.toList();
}
