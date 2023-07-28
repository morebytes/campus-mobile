import 'package:campus_mobile_experimental/core/models/spot_types.dart';
import 'package:campus_mobile_experimental/ui/common/HexColor.dart';
import 'package:campus_mobile_experimental/ui/common/container_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import '../../core/hooks/parking_query.dart';
import '../../core/models/parking.dart';
import '../../core/providers/user.dart';

class SpotTypesView extends HookWidget
{
  @override
  Widget build(BuildContext context) {
    final parkingSpots = useFetchSpotTypesModel();
    final userDataProvider = useMemoized(() {
      debugPrint("Memoized UserDataProvider!");
      return Provider.of<UserDataProvider>(context);
    }, [context]);
    useListenable(userDataProvider);

    if (parkingSpots.isLoading || parkingSpots.isFetching)
      return Center(
          child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.secondary
          )
      );

    return ContainerView(
      child: createListWidget(context, parkingSpots.data!, userDataProvider),
    );
  }

  Widget createListWidget(BuildContext context, List<Spot> parkingSpots, UserDataProvider userDataProvider) {
    return ListView(children: createList(context, parkingSpots, userDataProvider));
  }

  List<Widget> createList(BuildContext context, List<Spot> parkingSpots, UserDataProvider udp) {
    int selectedSpots = 0;
    List<Widget> list = [];
    for (Spot data in parkingSpots) {
      if (udp.userProfileModel!.isParkingSpotEnabled(data.spotKey!)) {
        selectedSpots++;
      }
      Color iconColor = HexColor(data.color!);
      Color textColor = HexColor(data.textColor!);

      list.add(ListTile(
        key: Key(data.name.toString()),
        leading: Container(
            width: 35,
            height: 35,
            decoration: new BoxDecoration(
              shape: BoxShape.circle,
              color: iconColor,
            ),
            child: Align(
                alignment: Alignment.center,
                child: data.text!.contains("&#x267f;")
                    ? Icon(Icons.accessible,
                        size: 25.0, color: colorFromHex(data.textColor!))
                    : Text(
                        data.spotKey!.contains("SR") ? "RS" : data.text!,
                        style: TextStyle(color: textColor),
                      )
            )
        ),
        title: Text(data.name!),
        trailing: Switch(
          value: udp.userProfileModel!.isParkingSpotEnabled(data.spotKey!),
          onChanged: (_) {
            // TODO: fix this logic!

            // only allow select if doesn't exceed maximum allowed
            if (udp.userProfileModel!.isParkingSpotEnabled(data.spotKey!)
                || (!udp.userProfileModel!.isParkingSpotEnabled(data.spotKey!) && selectedSpots < ParkingModel.MAX_SELECTED_SPOTS)) {
              selectedSpots = selectedSpots + (udp.userProfileModel!.isParkingSpotEnabled(data.spotKey!) ? -1 : 1);
              // sync with user data provider
              if (udp.userProfileModel!.isParkingSpotEnabled(data.spotKey!)) {
              //  disable the parking spot -> put spotKey into map
                udp.userProfileModel!.disabledParkingSpots!.add(data.spotKey!);
              } else {
                // enable the parking spot -> delete spotKey from map
                udp.userProfileModel!.disabledParkingSpots!.remove(data.spotKey!);
              }
              udp.postUserProfile(udp.userProfileModel);
            }
          },
          // activeColor: Theme.of(context).buttonColor,
          activeColor: Theme.of(context).backgroundColor,
        ),
      ));
    }
    return list;
  }

  static Color colorFromHex(String hexColor) {
    final hexCode = hexColor.replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor =
          'FF' + hexColor; // FF as the opacity value if you don't add it.
    }
    return Color(int.parse('FF$hexCode', radix: 16));
  }
}
