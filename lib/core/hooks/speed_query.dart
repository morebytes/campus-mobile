import 'package:campus_mobile_experimental/core/models/speed_test.dart';
import 'package:flutter/cupertino.dart';
import 'package:fquery/fquery.dart';
import '../../app_networking.dart';
import 'package:wifi_connection/WifiInfo.dart';

UseQueryResult<SpeedTestModel, dynamic> useFetchSpeedTestModel(String accessToken)
{

  return useQuery(['speed_test'], () async {
    // fetch data
    // TODO: go ahead and fetch the data from the endpoint (see speed test service file)
    // TODO: convert data from JSON map to Model class instance

    // String? _downloadResponse = await NetworkHelper().authorizedFetch(
    //     "https://api-qa.ucsd.edu:8243/wifi_test/v1.0.0/url_generator/download_url",
    //     header); <-Found in Service File
    final Map<String, String> header = {
      "accept": "application/json",
    };
    String? _downloadResponse = await NetworkHelper().authorizedFetch(
        "https://api-qa.ucsd.edu:8243/wifi_test/v1.0.0/url_generator/download_url",
        header);
    String? _uploadResponse = await NetworkHelper().authorizedFetch(
        "https://api-qa.ucsd.edu:8243/wifi_test/v1.0.0/url_generator/upload_url?name=temp.html",
        header);
    WifiInfo? response = await NetworkHelper().authorizedFetch(
        'https://api-qa.ucsd.edu:8243/wifi_test/v1.0.0/url_generator/download_url', {
      "Authorization": 'Bearer $accessToken' // TODO recheck if this is correct token ///could possibly be : 'Bearer ${_userDataProvider.authenticationModel?.accessToken}'
    });

    debugPrint("SpeedTestModel QUERY HOOK: FETCHING DATA!");

    /// parse data
   ///final data = speedTestModelFromJson(response); ///TODO: find positional argument
    final data = speedTestModelFromJson(response, _downloadResponse!, _uploadResponse!, data != null);

  });
}