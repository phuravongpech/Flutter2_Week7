import 'package:flutter/material.dart';
import 'package:week_3_blabla_project/model/ride/ride_pref.dart';
import 'package:week_3_blabla_project/data/repository/ride_preferences_repository.dart';
import 'package:week_3_blabla_project/ui/providers/async_value.dart';

class RidesPreferencesProvider extends ChangeNotifier {
  RidePreference? _currentPreference;
  late AsyncValue<List<RidePreference>> pastPreferences;
  final RidePreferencesRepository repository;

  RidesPreferencesProvider({required this.repository}) {
    fetchPastPreferences();
    notifyListeners();
  }
  RidePreference? get currentPreference => _currentPreference;

  Future<void> fetchPastPreferences() async {
    // 1- Handle loading
    pastPreferences = AsyncValue.loading();
    notifyListeners();
    try {
      // 2 Fetch data
      List<RidePreference> pastPrefs = await repository.getPastPreferences();
      // 3 Handle success
      pastPreferences = AsyncValue.success(pastPrefs);
      // 4 Handle error
    } catch (error) {
      pastPreferences = AsyncValue.error(error);
    }
    notifyListeners();
  }

  void setCurrentPreferrence(RidePreference pref) {
// Your code
    if (pref != currentPreference) {
      _currentPreference = pref;
      _addPreference(pref);
      notifyListeners();
    }
  }

  Future<void> _addPreference(RidePreference preference) async {
    // 1- Set loading state
    pastPreferences = AsyncValue.loading();
    notifyListeners();

    try {
      // 2- Add artificial delay
      await Future.delayed(const Duration(seconds: 2));

      // 3- Get current preferences
      final currentPrefs = pastPreferences.data ?? [];

      // 4- Add new preference if not already present
      if (!currentPrefs.contains(preference)) {
        final newPrefs = [...currentPrefs, preference];
        pastPreferences = AsyncValue.success(newPrefs);
      }
    } catch (error) {
      // 5- Handle error state
      pastPreferences = AsyncValue.error(error);
    }
    notifyListeners();
  }

  // Add the preference to history only if it's not equal to any in the history

// History is returned from newest to oldest preference
  List<RidePreference> get preferencesHistory {
    return pastPreferences.data?.reversed.toList() ?? [];
  }
}
