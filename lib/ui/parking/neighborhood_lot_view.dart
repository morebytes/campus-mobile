import 'package:campus_mobile_experimental/ui/common/container_view.dart';
import 'package:campus_mobile_experimental/ui/parking/parking_lot_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

import '../../core/hooks/parking_query.dart';
import '../../core/providers/user.dart';

class NeighborhoodLotsView extends HookWidget with ParkingLotsList
{
  final List<String> args;
  const NeighborhoodLotsView(this.args);

  @override
  Widget build(BuildContext context) {
    final parking = useFetchParkingModels();
    final userDataProvider = useMemoized(() {
      debugPrint("Memoized UserDataProvider!");
      return Provider.of<UserDataProvider>(context);
    }, [context]);
    useListenable(userDataProvider);

    return parking.isFetching? Center(
        child: CircularProgressIndicator(
            color: Theme.of(context).colorScheme.secondary)) :
    ContainerView(
      child: buildParkingLotsList(context, parking.data!, userDataProvider, args)
      //child: lotsList(context, args, parking, userDataProvider),
    );
  }
}

