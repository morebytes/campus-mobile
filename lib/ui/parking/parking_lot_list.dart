import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/material.dart';

import '../../core/models/parking.dart';
import '../../core/providers/user.dart';

mixin ParkingLotsList
{
  // builds the listview that will be put into a ContainerView
  Widget buildParkingLotsList(
      BuildContext context,
      List<ParkingModel> parkingModels,
      UserDataProvider udp,
      [List<String>? lots] // optional, you can provide the lots to be displayed
  )
{
    final showedScaffold = useState(false);

    if (lots == null) {
      lots = parkingModels
          .where((model) => !model.isStructure!)
          .map((model) => model.locationName!)
          .toList();
    }

    // creates a list that will hold the list of building names
    List<Widget> list = [];
    list.add(ListTile(
      title: Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
        child: Text(
          "Parking Lots:",
          style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontSize: 20,
              fontWeight: FontWeight.bold),
        ),
      ),
    ));

    int selectedLots = 0;
    parkingModels.forEach((parkingModel) {
      if (udp.userProfileModel!.isParkingLotEnabled(parkingModel.locationName!)) {
        selectedLots++;
      }
    });

    // loops through and adds buttons for the user to click on
    for (var i = 0; i < lots.length; i++) {
      bool lotViewState = udp.userProfileModel!.isParkingLotEnabled(lots[i]);
      list.add(
        ListTile(
          title: Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
            child: Text(
              lots[i],
              style: TextStyle(
                  color: Theme.of(context)
                      .colorScheme
                      .secondary, // lotViewState ? ColorPrimary : Colors.black,
                  fontSize: 20),
            ),
          ),
          trailing:
          Icon(lotViewState ? Icons.cancel_rounded : Icons.add_rounded),
          onTap: () {
            // Note: used to be a hard-coded 10
            if (selectedLots == ParkingModel.MAX_SELECTED_LOTS && !lotViewState && !showedScaffold.value) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                    'You have reached the maximum number of lots (10) that can be selected. You need to deselect some lots before you can add any more.'),
                duration: Duration(seconds: 5),
              ));
              showedScaffold.value = !showedScaffold.value;
            } else {
              selectedLots += lotViewState ? -1 : 1;
              if (!udp.userProfileModel!.disabledParkingLots!.remove(lots![i]))
                udp.userProfileModel!.disabledParkingLots!.add(lots[i]);
              udp.postUserProfile(udp.userProfileModel);
            }
          },
        ),
      );
    }

    // adds SizedBox to have a grey underline for the last item in the list
    list.add(SizedBox());

    return ListView(
      physics: BouncingScrollPhysics(),
      shrinkWrap: true,
      children: ListTile.divideTiles(tiles: list, context: context).toList(),
    );
  }
}