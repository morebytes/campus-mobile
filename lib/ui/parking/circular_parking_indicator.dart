import 'package:campus_mobile_experimental/core/models/parking.dart';
import 'package:campus_mobile_experimental/core/models/spot_types.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

import '../../core/hooks/parking_query.dart';
import '../../core/providers/user.dart';

class CircularParkingIndicators extends HookWidget {
  const CircularParkingIndicators({
    Key? key,
    required this.model,
  }) : super(key: key);

  final ParkingModel model;

  @override
  Widget build(BuildContext context) {
    final userDataProvider = useMemoized(() {
      debugPrint("Memoized UserDataProvider!");
      return Provider.of<UserDataProvider>(context);
    }, [context]);
    useListenable(userDataProvider);

    final spotTypes = useFetchSpotTypesModel();

    if (spotTypes.isFetching)
      return Center(
          child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.secondary
          )
      );

    return Column(
      children: [
        buildLocationTitle(),
        buildLocationContext(),
        buildSpotsAvailableText(spotTypes.data!),
        buildHistoricInfo(),
        buildAllParkingAvailability(spotTypes.data!, userDataProvider),
      ],
    );
  }

  Widget buildAllParkingAvailability(List<Spot> spotTypes, UserDataProvider udp) {
    // Get 3 displayable parking spots
    List<Widget> displayableSpotWidgetsList = spotTypes
        .where((spot) => udp.userProfileModel!.isParkingSpotEnabled(spot.spotKey!))
        .take(3)
        .map((spot) =>
          buildParkingInfoOrShowCircularProgress(
              spot, model.availability![spot.spotKey!]))
        .toList();

    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: displayableSpotWidgetsList,
      ),
    );
  }

  Widget buildParkingInfoOrShowCircularProgress(Spot spot, Map<String, int>? locationData)
  {
    int open = 0, total = 0;
    double percent = 0.0;
    String displayText = "N/A";

    if (locationData != null) {
        open = locationData["Open"]!;
        total = locationData["Total"]!;

        if (total > 0)
          percent = open / total;

        displayText = (percent * 100).round().toString() + "%";
    }

    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Center(
                  child: SizedBox(
                    height: 75,
                    width: 75,
                    child: CircularPercentIndicator(
                      radius: 37,
                      animation: locationData != null,
                      animationDuration: 1000,
                      lineWidth: 7.5,
                      percent: percent,
                      center: Text(
                        displayText,
                        style: TextStyle(fontSize: 22),
                      ),
                      circularStrokeCap: CircularStrokeCap.round,
                      backgroundColor: colorFromHex('#EDECEC'),
                      progressColor: getColor(open / total),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child:
                CircleAvatar(
                  backgroundColor: colorFromHex(spot.color!),
                  child: spot.text!.contains("&#x267f;")
                    ? Icon(
                        Icons.accessible,
                        size: 25.0,
                        color: colorFromHex(spot.textColor!),
                      )
                      : Text(
                        spot.spotKey!.contains("SR") ? "RS" : spot.text!,
                        style: TextStyle(
                          color: colorFromHex(spot.textColor!),
                      ),
                  ),
              )
          )
        ],
      ),
    );
  }

  static Color colorFromHex(String hexColor) {
    final hexCode = hexColor.replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor =
          'FF' + hexColor; // FF as the opacity value if you don't add it.
    }
    return Color(int.parse('FF$hexCode', radix: 16));
  }

  static Color getColor(double value) {
    if (value > .75) {
      return Colors.green;
    }
    if (value > .25) {
      return Colors.yellow;
    }
    return Colors.red;
  }

  Widget buildLocationContext() {
    return Center(
      child: Text(model.locationContext ?? "",
          style: TextStyle(
            color: Colors.grey,
          )),
    );
  }

  Widget buildLocationTitle() {
    return Text(
      model.locationName ?? "",
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    );
  }

  Widget buildHistoricInfo() {
    if (model.locationProvider == "Historic") {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            color: Colors.black,
          ),
          Padding(
            padding: EdgeInsets.only(right: 1.0),
          ),
          Text(
            "No Live Data. Estimated availability shown.",
          )
        ],
      );
    } else {
      return Text("");
    }
  }

  /// Returns the total number of spots open at a given location
  /// does not filter based on spot type
  Map<String, num> getApproxNumOfOpenSpots() {
    int openSpots = 0;
    int totalSpots = 0;

    model.availability!.forEach((spot, availability) {
        openSpots += availability!['Open']!;
        totalSpots += availability['Total']!;
    });

    return {"Open": openSpots, "Total": totalSpots};
  }

  Widget buildSpotsAvailableText(List<Spot> spots) {
    return Center(
      child: Text("~" +
          getApproxNumOfOpenSpots()["Open"].toString() +
          " of " +
          getApproxNumOfOpenSpots()["Total"].toString() +
          " Spots Available"
      ),
    );
  }
}