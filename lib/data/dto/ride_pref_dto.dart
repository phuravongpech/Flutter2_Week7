import '../../model/ride/ride_pref.dart';
import 'location_dto.dart';

class RidePreferenceDto {
  // To JSON method
  static Map<String, dynamic> toJson(RidePreference model) {
    return {
      'departure': model.departure,
      'departureDate': model.departureDate.toIso8601String(),
      'arrival': model.arrival,
      'requestedSeats': model.requestedSeats,
    };
  }

  // From JSON method
  static RidePreference fromJson(Map<String, dynamic> json) {
    return RidePreference(
      departure: LocationDto.fromJson(json['departure']),
      departureDate: DateTime.parse(json['departureDate']),
      arrival: LocationDto.fromJson(json['arrival']),
      requestedSeats: json['requestedSeats'],
    );
  }
}
