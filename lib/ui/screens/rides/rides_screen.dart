import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week_3_blabla_project/ui/providers/ride_pref_provider.dart';
import '../../../model/ride/ride_filter.dart';
import 'widgets/ride_pref_bar.dart';

import '../../../model/ride/ride.dart';
import '../../../model/ride/ride_pref.dart';
import '../../../service/rides_service.dart';
import '../../theme/theme.dart';
import '../../../utils/animations_util.dart';
import 'widgets/ride_pref_modal.dart';
import 'widgets/rides_tile.dart';

///
///  The Ride Selection screen allow user to select a ride, once ride preferences have been defined.
///  The screen also allow user to re-define the ride preferences and to activate some filters.
///
class RidesScreen extends StatelessWidget {
  RidesScreen({super.key});

  final RideFilter currentFilter = RideFilter();

  List<Ride> getMatchingRides(BuildContext context, RideFilter filter) {
    final pref = context.read<RidesPreferencesProvider>().currentPreference;
    return RidesService.instance.getRidesFor(pref!, filter);
  }

  void _onBackPressed(BuildContext context) {
    // 1 - Back to the previous view
    Navigator.of(context).pop();
  }

  void _onPreferencePressed(BuildContext context) async {
    final currentPref =
        context.read<RidesPreferencesProvider>().currentPreference;
    final RidePreference? newPreference =
        await Navigator.of(context).push<RidePreference>(
      AnimationUtils.createTopToBottomRoute(
        RidePrefModal(initialPreference: currentPref),
      ),
    );

    if (newPreference != null) {
      // Update the current preference using Provider
      context
          .read<RidesPreferencesProvider>()
          .setCurrentPreferrence(newPreference);
    }
  }

  void _onFilterPressed(BuildContext context) {
    // Add filter logic here
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RidesPreferencesProvider>();

    final currentPref = provider.currentPreference;

    // Handle null preference case
    if (currentPref == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "No ride preferences selected",
                style: BlaTextStyles.heading,
              ),
              SizedBox(height: BlaSpacings.m),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text("Go back"),
              ),
            ],
          ),
        ),
      );
    }

    final filter = RideFilter();
    final matchingRides = getMatchingRides(context, filter);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
          left: BlaSpacings.m,
          right: BlaSpacings.m,
          top: BlaSpacings.s,
        ),
        child: Column(
          children: [
            // Top search Search bar
            RidePrefBar(
              ridePreference: currentPref,
              onBackPressed: () => _onBackPressed(context),
              onPreferencePressed: () => _onPreferencePressed(context),
              onFilterPressed: () => _onFilterPressed(context),
            ),

            Expanded(
              child: ListView.builder(
                itemCount: matchingRides.length,
                itemBuilder: (ctx, index) =>
                    RideTile(ride: matchingRides[index], onPressed: () {}),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
