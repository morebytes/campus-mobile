import 'dart:collection';
import 'package:campus_mobile_experimental/core/models/parking.dart';
import 'package:flutter/material.dart';
import 'package:campus_mobile_experimental/ui/common/container_view.dart';
import 'package:campus_mobile_experimental/app_constants.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fquery/fquery.dart';
import '../../core/hooks/parking_query.dart';

class NeighborhoodsView extends HookWidget {
  // List<bool> selected = List.filled(5, false);

  @override
  Widget build(BuildContext context) {
    final parking = useFetchParkingModels();
    return  parking.isFetching? Center(
        child: CircularProgressIndicator(
            color: Theme.of(context).colorScheme.secondary)) :
    ContainerView(
      child: neighborhoodsList(context, parking),
    );
  }

  // builds the listview that will be put into ContainerView
  Widget neighborhoodsList(BuildContext context, UseQueryResult parking) {
    SplayTreeMap<String, List<String>> neighborhoods = SplayTreeMap<String, List<String>>();
    parking.data.forEach((ParkingModel pm) {
      if (!neighborhoods.containsKey(pm.neighborhood)) {
        neighborhoods[pm.neighborhood!] = <String>[];
      }
      neighborhoods[pm.neighborhood!]!.add(pm.locationName!);
    });
    // creates a list that will hold the list of building names
    List<Widget> list = [];
    list.add(ListTile(
      title: Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
        child: Text(
          "Neighborhoods:",
          style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontSize: 20,
              fontWeight: FontWeight.bold),
        ),
      ),
    ));

    // loops through and adds buttons for the user to click on
    neighborhoods.forEach((key, value) {
      if (key != "") {
        list.add(ListTile(
          title: Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
            child: Text(
              key,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary, fontSize: 20),
            ),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: Theme.of(context).colorScheme.secondary,
          ),
          onTap: () {
            Navigator.pushNamed(context, RoutePaths.NeighborhoodsLotsView,
                arguments: value);
            // arguments: {'building': 'Atkinson Hall'},
          },
        ));
      }
    });

    // adds SizedBox to have a grey underline for the last item in the list
    list.add(SizedBox());

    return ListView(
      physics: BouncingScrollPhysics(),
      shrinkWrap: true,
      children: ListTile.divideTiles(tiles: list, context: context).toList(),
    );
  }
}
