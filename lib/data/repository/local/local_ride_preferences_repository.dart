import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:week_3_blabla_project/data/dto/ride_pref_dto.dart';
import 'package:week_3_blabla_project/data/repository/ride_preferences_repository.dart';
import 'package:week_3_blabla_project/model/ride/ride_pref.dart';

class LocalRidePreferencesRepository extends RidePreferencesRepository {
  static const String _preferencesKey = "ride_preferences";

  @override
  Future<void> addPreference(RidePreference preference) async {
    getPastPreferences();
    // Get SharedPreferences instance
    final prefs = await SharedPreferences.getInstance();
// Get the string list form the key
    final prefsList = prefs.getStringList(_preferencesKey) ?? [];
    //add
    prefsList.add(RidePreferenceDto.toJson(preference).toString());

    // Save the new list as a string list
    await prefs.setStringList(
      _preferencesKey,
      prefsList
          .map((pref) =>
              jsonEncode(RidePreferenceDto.toJson(pref as RidePreference)))
          .toList(),
    );
  }

  @override
  Future<List<RidePreference>> getPastPreferences() async {
    // Get SharedPreferences instance
    final prefs = await SharedPreferences.getInstance();
// Get the string list form the key
    final prefsList = prefs.getStringList(_preferencesKey) ?? [];
// Convert the string list to a list of RidePreferences – Using map()
    return prefsList
        .map((json) => RidePreferenceDto.fromJson(jsonDecode(json)))
        .toList();
  }
}
