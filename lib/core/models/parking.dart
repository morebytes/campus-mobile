// To parse this JSON data, do
//
//     final parkingModel = parkingModelFromJson(jsonString);

import 'dart:convert';

List<ParkingModel> parkingModelFromJson(String str) => List<ParkingModel>.from(
    json.decode(str//, reviver: (k, v) {
    //   if ((k == "Open" || k == "Total") && v is String) {
    //     return v == "" ? 0 : int.parse(v);
    //   }
    //   return v;}
    ).map((x) => ParkingModel.fromJson(x)));

String parkingModelToJson(List<ParkingModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ParkingModel {
  String? neighborhood;
  bool? isStructure;
  String? locationId;
  String? locationName;
  String? locationContext;
  String? locationProvider;
  // NOTE: check if null makes a difference here
  Map<String, Map<String, int>?>? availability;
  DateTime? lastUpdated;
  String? availabilityType;
  static const MAX_SELECTED_LOTS = 10;
  static const MAX_SELECTED_SPOTS = 3;

  ParkingModel({
    this.neighborhood,
    this.isStructure,
    this.locationId,
    this.locationName,
    this.locationContext,
    this.locationProvider,
    this.availability,
    this.lastUpdated,
    this.availabilityType,
  });

  factory ParkingModel.fromJson(Map<String, dynamic> json) {
   // print(json);
    return ParkingModel(
      neighborhood: json["neighborhood"] == null ? null : json["neighborhood"],
      isStructure: json["isStructure"] == null ? null : json["isStructure"],
      locationId: json["LocationId"] == null ? null : json["LocationId"],
      locationName: json["LocationName"] == null ? null : json["LocationName"],
      locationContext:
          json["LocationContext"] == null ? null : json["LocationContext"],
      locationProvider:
          json["LocationProvider"] == null ? null : json["LocationProvider"],
      // TODO: automatically convert every String representation of integers to an actual int
      availability: json["Availability"] == null
          ? null
          : Map<String, Map<String, int>>.from(
              json["Availability"]
              .map((k, v) =>
                  MapEntry(k, Map<String, int>.from(v.map((k, v) {
                        if (v == "" || v == null)
                          return MapEntry(k, 0);
                        else if (v is String)
                          return MapEntry(k, int.parse(v));
                        else
                          return MapEntry(k, v);
                      }))
                  )
              )),
      lastUpdated: json["lastUpdated"] == null
          ? null
          : DateTime.parse(json["LastUpdated"]),
      availabilityType:
          json["AvailabilityType"] == null ? null : json["AvailabilityType"],
    );
  }

  Map<String, dynamic> toJson() => {
        "Neighborhood": neighborhood == null ? null : neighborhood,
        "isStructure": isStructure == null ? null : isStructure,
        "LocationId": locationId == null ? null : locationId,
        "LocationName": locationName == null ? null : locationName,
        "LocationContext": locationContext == null ? null : locationContext,
        "LocationProvider": locationProvider == null ? null : locationProvider,
        "Availability": availability == null ? null : availability,
        "LastUpdated":
            lastUpdated == null ? null : lastUpdated!.toIso8601String(),
        "AvailabilityType": availabilityType == null ? null : availabilityType
      };
}
