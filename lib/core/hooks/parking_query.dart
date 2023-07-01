import 'dart:convert';

import 'package:campus_mobile_experimental/core/models/parking.dart';
import 'package:flutter/cupertino.dart';
import 'package:fquery/fquery.dart';

import '../../app_networking.dart';
import '../models/spot_types.dart';

UseQueryResult<List<ParkingModel>, dynamic> useFetchParkingModels()
{
  // TODO: implement the logic for refreshing access token as needed
  return useQuery(['parking'], () async {
    const String campusParkingServiceApiUrl = "https://api-qa.ucsd.edu:8243/campusparkingservice/v1.3";

    /// fetch data
    String _response = await NetworkHelper().authorizedFetch(
        campusParkingServiceApiUrl+ "/status", {
      "accept": "application/json",
      "Authorization": "Basic djJlNEpYa0NJUHZ5akFWT0VRXzRqZmZUdDkwYTp2emNBZGFzZWpmaWZiUDc2VUJjNDNNVDExclVh"
    });
    debugPrint("PARKINGMODEL QUERY HOOK: FETCHING DATA!");

    /// parse data
    final List<ParkingModel> data = parkingModelFromJson(_response);

    return data;
  });
}

UseQueryResult<List<Spot>, dynamic> useFetchSpotTypesModel()
{
  // TODO: implement the logic for refreshing access token as needed
  return useQuery(['spot'], () async {
    const String campusSpotTypeApiUrl = "https://mobile.ucsd.edu/replatform/v1/qa/integrations/parking/v1.2/spot_types.json";

    /// fetch data
    String _response = await NetworkHelper().authorizedFetch(
        campusSpotTypeApiUrl, {
      "accept": "application/json",
      "Authorization": "Basic djJlNEpYa0NJUHZ5akFWT0VRXzRqZmZUdDkwYTp2emNBZGFzZWpmaWZiUDc2VUJjNDNNVDExclVh"
    });
    debugPrint("SPOTTYPESMODEL QUERY HOOK: FETCHING DATA!");

    /// parse data
    final data = List<Spot>.from(json.decode(_response)["spots"].map((x) => Spot.fromJson(x)));
    return data;
  });
}
