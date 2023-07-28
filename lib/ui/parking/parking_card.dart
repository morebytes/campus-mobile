import 'package:campus_mobile_experimental/app_constants.dart';
import 'package:campus_mobile_experimental/core/hooks/parking_query.dart';
import 'package:campus_mobile_experimental/core/models/parking.dart';
import 'package:campus_mobile_experimental/core/providers/cards.dart';
import 'package:campus_mobile_experimental/ui/common/card_container.dart';
import 'package:campus_mobile_experimental/ui/common/dots_indicator.dart';
import 'package:campus_mobile_experimental/ui/parking/circular_parking_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import '../../core/providers/user.dart';

class ParkingCard extends HookWidget
{
  // instead of didChangeDependencies, useMemoized(userDataProvider), find example in availability card
  static const String cardId = 'parking';

  // ignore: must_call_super
  Widget build(BuildContext context) {
    final userDataProvider = useMemoized(() {
      debugPrint("Memoized UserDataProvider!");
      return Provider.of<UserDataProvider>(context);
    }, [context]);
    useListenable(userDataProvider);

    final parkingModels = useFetchParkingModels();
    final PageController _controller = usePageController();

    return CardContainer(
      titleText: CardTitleConstants.titleMap[cardId],
      isLoading: parkingModels.isFetching,
      reload: () => parkingModels.refetch(),
      errorText: parkingModels.isError ? "" : null,
      child: () => buildParkingCard(parkingModels.data!, userDataProvider, _controller),
      active: Provider.of<CardsDataProvider>(context).cardStates![cardId],
      hide: () => Provider.of<CardsDataProvider>(context, listen: false)
          .toggleCard(cardId),
      actionButtons: buildActionButtons(context),
    );
  }

  Widget buildParkingCard(List<ParkingModel> parkingModels, UserDataProvider udp, PageController pc) {
    try{
      List<Widget> selectedLotsViews = [];

      for (ParkingModel model in parkingModels) {
        if (udp.userProfileModel!.isParkingLotEnabled(model.locationName!)) {
          selectedLotsViews.add(CircularParkingIndicators(model: model));
        }
      }

      if (selectedLotsViews.isEmpty) {
        return (Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "No Lots to Display",
              style: TextStyle(fontSize: 24),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(
                "Add a Lot via 'Manage Lots'",
                style: TextStyle(fontSize: 14),
              ),
            ),
          ],
        ));
      }

      return Column(
        children: <Widget>[
          Expanded(
            child: PageView(
              controller: pc,
              children: selectedLotsViews,
            ),
          ),
          DotsIndicator(
            controller: pc,
            itemCount: selectedLotsViews.length,
            onPageSelected: (int index) {
              pc.animateToPage(index,
                  duration: Duration(seconds: 1), curve: Curves.decelerate);
            },
          ),
        ],
      );
    } catch (e) {
      debugPrint(e.toString());
      return Container(
        width: double.infinity,
        child: Center(
          child: Container(
            child: Text('An error occurred, please try again.'),
          ),
        ),
      );
    }
  }

  List<Widget> buildActionButtons(BuildContext context) {
    List<Widget> actionButtons = [];
    actionButtons.add(TextButton(
      style: TextButton.styleFrom(
        // primary: Theme.of(context).buttonColor,
        primary: Theme.of(context).backgroundColor,
      ),
      child: Text(
        'Manage Lots',
      ),
      onPressed: () {
        Navigator.pushNamed(context, RoutePaths.ManageParkingView);
      },
    ));
    actionButtons.add(TextButton(
      style: TextButton.styleFrom(
        // primary: Theme.of(context).buttonColor,
        primary: Theme.of(context).backgroundColor,
      ),
      child: Text(
        'Manage Spots',
      ),
      onPressed: () {
        Navigator.pushNamed(context, RoutePaths.SpotTypesView);
      },
    ));
    return actionButtons;
  }
}
