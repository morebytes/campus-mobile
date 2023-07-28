// To parse this JSON data, do
//
//     final userProfileModel = userProfileModelFromJson(jsonString);

import 'dart:convert';

import 'package:hive/hive.dart';

part 'user_profile.g.dart';

UserProfileModel userProfileModelFromJson(String str) =>
    UserProfileModel.fromJson(json.decode(str));

String userProfileModelToJson(UserProfileModel data) =>
    json.encode(data.toJson());

@HiveType(typeId: 2)
class UserProfileModel extends HiveObject {
  Classifications? classifications;
  int? latestTimeStamp;
  String? pid;
  String? ucsdaffiliation;
  String? username;

  @HiveField(0)
  List<String>? disabledLots;
  @HiveField(1)
  List<String?>? disabledOccuspaceLocations;
  @HiveField(2)
  List<String?>? subscribedTopics;
  @HiveField(8)
  List<String?>? disabledParkingSpots;
  @HiveField(9)
  List<String?>? disabledParkingLots;
  @HiveField(5)
  List<int?>? disabledStops;
  @HiveField(6)
  List<String>? surveyCompletion;
  @HiveField(7)
  List<String?>? disabledVentilationLocations;

  UserProfileModel(
      {this.classifications,
      this.latestTimeStamp,
      this.pid,
      this.disabledLots,
      this.disabledOccuspaceLocations,
      this.subscribedTopics,
      this.ucsdaffiliation,
      this.username,
      this.disabledParkingSpots,
      this.disabledParkingLots,
      this.disabledStops,
      this.surveyCompletion,
      this.disabledVentilationLocations});

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      UserProfileModel(
        classifications: json["classifications"] == null
            ? null
            : Classifications.fromJson(json["classifications"]),
        latestTimeStamp:
            json["latestTimeStamp"] == null ? null : json["latestTimeStamp"],
        pid: json["pid"] == null ? null : json["pid"],
        disabledLots: json["selectedLots"] == null
            ? []
            : List<String>.from(json["selectedLots"].map((x) => x)),
        disabledOccuspaceLocations: json["selectedOccuspaceLocations"] == null
            ? []
            : List<String>.from(
                json["selectedOccuspaceLocations"].map((x) => x)),
        subscribedTopics: json["subscribedTopics"] == null
            ? []
            : List<String>.from(json["subscribedTopics"].map((x) => x)),
        ucsdaffiliation:
            json["ucsdaffiliation"] == null ? null : json["ucsdaffiliation"],
        username: json["username"] == null ? null : json["username"],
        disabledParkingLots: json["selectedParkingLots"] == null
            ? []
            : List<String>.from(
            json["selectedParkingLots"].map((x) => x)),
        disabledParkingSpots: json["selectedParkingSpots"] == null
            ? []
            : List<String>.from(
            json["selectedParkingSpots"].map((x) => x)),
        disabledStops: json["selectedStops"] == null
            ? []
            : List<int>.from(json["selectedStops"].map((x) => x)),
        surveyCompletion: json["surveyCompletion"] == null
            ? []
            : List<String>.from(json["surveyCompletion"].map((x) => x)),
        disabledVentilationLocations:
            json['selectedVentilationLocations'] == null
                ? []
                : List<String>.from(
                    json["selectedVentilationLocations"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "classifications":
            classifications == null ? null : classifications!.toJson(),
        "latestTimeStamp": latestTimeStamp == null ? null : latestTimeStamp,
        "pid": pid == null ? null : pid,
        "selectedLots": disabledLots == null
            ? null
            : List<dynamic>.from(disabledLots!.map((x) => x)),
        "selectedOccuspaceLocations": disabledOccuspaceLocations == null
            ? null
            : List<dynamic>.from(disabledOccuspaceLocations!.map((x) => x)),
        "subscribedTopics": subscribedTopics == null
            ? null
            : List<dynamic>.from(subscribedTopics!.map((x) => x)),
        "ucsdaffiliation": ucsdaffiliation == null ? null : ucsdaffiliation,
        "username": username == null ? null : username,
        "selectedParkingLots": disabledParkingLots == null
            ? null
            : disabledParkingLots,
        "selectedParkingSpots": disabledParkingSpots == null
            ? null
            : disabledParkingSpots,
        "selectedStops": disabledStops == null
            ? null
            : List<dynamic>.from(disabledStops!.map((x) => x)),
        "surveyCompletion": surveyCompletion == null
            ? null
            : List<dynamic>.from(surveyCompletion!.map((x) => x)),
        "selectedVentilationLocations": disabledVentilationLocations == null
            ? null
            : List<dynamic>.from(disabledVentilationLocations!.map((x) => x)),
      };

  // DATA OPERATION FUNCTIONS
  bool isOccuspaceLocationDisabled(String name) => disabledOccuspaceLocations?.contains(name) ?? false;
  bool isParkingLotDisabled(String name) => disabledParkingLots?.contains(name) ?? false;
  bool isParkingLotEnabled(String name) => !isParkingLotDisabled(name);
  bool isParkingSpotDisabled(String name) => disabledParkingSpots?.contains(name) ?? false;
  bool isParkingSpotEnabled(String name) => !isParkingSpotDisabled(name);
}

class Classifications {
  bool? student;
  bool? staff;

  Classifications({
    this.student,
    this.staff,
  });

  factory Classifications.fromJson(Map<String, dynamic> json) =>
      Classifications(
        student: json["student"] == null ? null : json["student"],
        staff: json["staff"] == null ? null : json["staff"],
      );

  Map<String, dynamic> toJson() => {
        "student": student == null ? null : student,
        "staff": staff == null ? null : staff,
      };
}
