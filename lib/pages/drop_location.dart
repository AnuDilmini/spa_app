import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:violet_app/model/place_model.dart';
import 'package:violet_app/style/palette.dart';


class SelectLocation extends StatefulWidget {
  SelectLocation(
      {Key key,
        })
      : super(key: key);


  @override
  _SelectLocation createState() => _SelectLocation();
}

class _SelectLocation extends State<SelectLocation> {
  GoogleMapController mapController;

  final String mapStyle =
      "[\r\n  {\r\n    \"elementType\": \"geometry\",\r\n    \"stylers\": [\r\n      {\r\n        \"color\": \"#f5f5f5\"\r\n      }\r\n    ]\r\n  },\r\n  {\r\n    \"elementType\": \"labels.icon\",\r\n    \"stylers\": [\r\n      {\r\n        \"visibility\": \"off\"\r\n      }\r\n    ]\r\n  },\r\n  {\r\n    \"elementType\": \"labels.text.fill\",\r\n    \"stylers\": [\r\n      {\r\n        \"color\": \"#616161\"\r\n      }\r\n    ]\r\n  },\r\n  {\r\n    \"elementType\": \"labels.text.stroke\",\r\n    \"stylers\": [\r\n      {\r\n        \"color\": \"#f5f5f5\"\r\n      }\r\n    ]\r\n  },\r\n  {\r\n    \"featureType\": \"administrative.land_parcel\",\r\n    \"elementType\": \"labels.text.fill\",\r\n    \"stylers\": [\r\n      {\r\n        \"color\": \"#bdbdbd\"\r\n      }\r\n    ]\r\n  },\r\n  {\r\n    \"featureType\": \"poi\",\r\n    \"elementType\": \"geometry\",\r\n    \"stylers\": [\r\n      {\r\n        \"color\": \"#eeeeee\"\r\n      }\r\n    ]\r\n  },\r\n  {\r\n    \"featureType\": \"poi\",\r\n    \"elementType\": \"labels.text.fill\",\r\n    \"stylers\": [\r\n      {\r\n        \"color\": \"#757575\"\r\n      }\r\n    ]\r\n  },\r\n  {\r\n    \"featureType\": \"poi.park\",\r\n    \"elementType\": \"geometry\",\r\n    \"stylers\": [\r\n      {\r\n        \"color\": \"#e5e5e5\"\r\n      }\r\n    ]\r\n  },\r\n  {\r\n    \"featureType\": \"poi.park\",\r\n    \"elementType\": \"labels.text.fill\",\r\n    \"stylers\": [\r\n      {\r\n        \"color\": \"#9e9e9e\"\r\n      }\r\n    ]\r\n  },\r\n  {\r\n    \"featureType\": \"road\",\r\n    \"elementType\": \"geometry\",\r\n    \"stylers\": [\r\n      {\r\n        \"color\": \"#ffffff\"\r\n      }\r\n    ]\r\n  },\r\n  {\r\n    \"featureType\": \"road.arterial\",\r\n    \"elementType\": \"labels.text.fill\",\r\n    \"stylers\": [\r\n      {\r\n        \"color\": \"#757575\"\r\n      }\r\n    ]\r\n  },\r\n  {\r\n    \"featureType\": \"road.highway\",\r\n    \"elementType\": \"geometry\",\r\n    \"stylers\": [\r\n      {\r\n        \"color\": \"#dadada\"\r\n      }\r\n    ]\r\n  },\r\n  {\r\n    \"featureType\": \"road.highway\",\r\n    \"elementType\": \"labels.text.fill\",\r\n    \"stylers\": [\r\n      {\r\n        \"color\": \"#616161\"\r\n      }\r\n    ]\r\n  },\r\n  {\r\n    \"featureType\": \"road.local\",\r\n    \"elementType\": \"labels.text.fill\",\r\n    \"stylers\": [\r\n      {\r\n        \"color\": \"#9e9e9e\"\r\n      }\r\n    ]\r\n  },\r\n  {\r\n    \"featureType\": \"transit.line\",\r\n    \"elementType\": \"geometry\",\r\n    \"stylers\": [\r\n      {\r\n        \"color\": \"#e5e5e5\"\r\n      }\r\n    ]\r\n  },\r\n  {\r\n    \"featureType\": \"transit.station\",\r\n    \"elementType\": \"geometry\",\r\n    \"stylers\": [\r\n      {\r\n        \"color\": \"#eeeeee\"\r\n      }\r\n    ]\r\n  },\r\n  {\r\n    \"featureType\": \"water\",\r\n    \"elementType\": \"geometry\",\r\n    \"stylers\": [\r\n      {\r\n        \"color\": \"#c9c9c9\"\r\n      }\r\n    ]\r\n  },\r\n  {\r\n    \"featureType\": \"water\",\r\n    \"elementType\": \"labels.text.fill\",\r\n    \"stylers\": [\r\n      {\r\n        \"color\": \"#9e9e9e\"\r\n      }\r\n    ]\r\n  }\r\n]";

  double latNew;
  double lngNew;
  double latFirst;
  double lngFirst;
  double latSearch;
  double lngSearch;
  String name;
  bool isToggled = false;
  String locationName = "";
  String profileLocation = "";
  String profileLocationNew = "";
  String locationCode = "";
  FocusNode nodeOne = FocusNode();
  Timer _throttle;
  String _heading;
  TextEditingController _searchController = new TextEditingController();
  List<Place> _placesList;


  int selectedPosition;
  bool isSameLocation = false;
  Place placeDetails;
  var newTitle;
  static String kGoogleApiKey = 'AIzaSyBrc_EnMrVTtH0ShPx62V9lpdul7vVwMe8';
  // static String kGoogleApiKey = 'AIzaSyABAX6oCiA6r3tgkbP44BNYFuhBKTJQUtM';
  var _markers;
  var data;
  var position;
  bool isLocationLoaded = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;

    mapController.setMapStyle(mapStyle);

    // if (widget.lat != null) {
    //   var latitude = double.parse(widget.lat);
    //   var longitude = double.parse(widget.lng);
    //   mapController.animateCamera(
    //     CameraUpdate.newCameraPosition(
    //       CameraPosition(target: LatLng(latitude, longitude), zoom: 14.0),
    //     ),
    //   );
    // } else {
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(latSearch, lngSearch), zoom: 14.0),
        ),
      );
    // }
  }

  void getLocationResults(String input) async {
    print("input *****$input");
    if (input.isEmpty) {
      print("empry***************");
      return;
    }
    String request =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&radius=1000&key=$kGoogleApiKey&types=(cities)';

    var response = await Dio().get(request);

    final predictions = response.data['predictions'];
    print("input **predictions***$predictions");
    List<Place> _displayResults = [];

    for (var i = 0; i < predictions.length; i++) {
      name = predictions[i]['description'];
      String placeId = predictions[i]['place_id'];
      _displayResults.add(Place(name, placeId, latSearch, lngSearch));
    }

    setState(() {
      _heading = "Results";
      if (_placesList != null) {
        _placesList.clear();
      }
      _placesList = _displayResults;
    });
  }

  _onSearchChanged() {
    if (_throttle?.isActive ?? false) _throttle.cancel();

    _throttle = Timer(const Duration(milliseconds: 1000), () {
      getLocationResults(_searchController.text);
    });
  }

  Future<void> getLocationName(String names) async {

    final query = names;
    var addresses = await Geocoder.local.findAddressesFromQuery(query);

    var first = addresses.first;
    latSearch = first.coordinates.latitude;
    lngSearch = first.coordinates.longitude;
    setState(() {
      Timer(const Duration(milliseconds: 1200), () {
        mapController.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(target: LatLng(latSearch, lngSearch), zoom: 14.0)));
      });
      _placesList.clear();

      locationName =
      "${first.addressLine.toString().replaceAll('Unknown, ', '')}";
      locationCode = first.countryCode;
      profileLocation = "${first.locality}, ${first.countryName}";

      if (first.locality == null) {
        if (first.adminArea != null) {
          profileLocation = " ${first.adminArea},  ${first.countryCode}";
        } else {
          profileLocation = "${first.countryName}";
        }
      } else {
        profileLocation =
        "${first.locality}, ${first.adminArea}, ${first.countryCode}";
      }
      isLocationLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(

        backgroundColor: Colors.white,
        body: Container(
          width: width,
          height: height,
          child: Stack(
            children: <Widget>[
              latSearch != null
                  ? GoogleMap(
                initialCameraPosition: CameraPosition(
                    target:LatLng(0, 0),
                    zoom: 14.0),
                myLocationEnabled: false,
                myLocationButtonEnabled: false,
                tiltGesturesEnabled: true,
                compassEnabled: true,
                markers: _markers,
                scrollGesturesEnabled: false,
                zoomGesturesEnabled: false,
                onMapCreated: _onMapCreated,
              )
                  : Container(
                width: width,
                height: height,

              ),
              Container(
                height: height / 5.4,
                width: width,
                color: Palette.textField,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      margin: const EdgeInsets.only(top: 20),
                      width: 40,
                      height: 40,
                      alignment: Alignment.centerRight,
                      decoration: BoxDecoration(
                          color:  Palette.darkPink,
                          shape: BoxShape.circle),
                      child: Center(
                        child: Icon(
                          Icons.close,
                          color:  Palette.whiteText,
                          size: height / 35,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                child: Center(
                  child: Container(
                    child: SpinKitRipple(
                      color: Palette.darkPink,
                      size: 40,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: height / 11,
                left: 20,
                child:  Text(
                  "Enter location",
                  style: TextStyle(
                      color: Palette.pinkBox,
                      fontSize: 19,
                      fontFamily: 'Rubik-Medium'),
                ),
              ),
              Center(
                child: Container(
                  height: 15,
                  width: 15,
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Color(0xFF3F2063),
                            blurRadius: 5.0,
                            spreadRadius: 0.01),
                      ],

                      color: Palette.pinkBox,
                      shape: BoxShape.circle),
                ),
              ),
              Positioned(
                top: height / 7,
                width: width,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: SizedBox(
                      width: width / 1.05,
                      height: height / 12,
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey[300],
                                blurRadius: 5.0,
                                spreadRadius: 0.5),
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          border: Border.all(
                              color:Palette.whiteText, width: 0.5),
                        ),
                        child: Row(
                          children: <Widget>[
                            Flexible(
                              flex: 15,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 15.0),
                                child: TextField(
                                  onChanged: (String text) {
                                    if (_searchController.text.isNotEmpty &&
                                        _searchController.text.length >= 3) {
                                      _onSearchChanged();
                                    } else {}
                                    setState(() {
                                      // widget.selected = true;
                                    });
                                  },
                                  onTap: () {
                                    _searchController.clear();
                                    profileLocation = "";
                                    newTitle = null;
                                    if (_placesList != null) {
                                      _placesList.clear();
                                    }
                                  },
                                  controller: _searchController,
                                  focusNode: nodeOne,
                                  cursorColor: Palette.pinkBox,
                                  decoration: InputDecoration(
                                    hintText: newTitle != null
                                        ? newTitle
                                        : 'Please enter city..',
                                    hintStyle: TextStyle(
                                      color: Palette.pinkBox,
                                      fontSize: 18,
                                      fontFamily: 'Barlow-Regular',
                                    ),
                                    border: InputBorder.none,
                                  ),
                                  style: TextStyle(
                                      color: Palette.pinkBox,
                                      fontSize: 18,
                                      fontFamily: 'Barlow-Regular'),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: height / 4.8,
                left: 10,
                right: 10,
                child:
                    (_placesList != null &&
                        _searchController.text.isNotEmpty &&
                        _searchController.text.length >= 3)
                    ? Container(
                  height: height,
                  width: width,
                  child: ListView.builder(
                      padding: EdgeInsets.all(10),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: _placesList.length,
                      itemBuilder: (context, position) {
                        return Column(
                          children: <Widget>[
                            GestureDetector(
                              child: Container(
                                height: 60,
                                width: width,
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey[300],
                                        blurRadius: 5.0,
                                        spreadRadius: 0.5),
                                  ],
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(10.0)),
                                  border: Border.all(
                                      color: Palette.whiteText,
                                      width: 0.5),
                                ),
                                child: Padding(
                                  padding:
                                  const EdgeInsets.only(left: 15),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      _placesList[position].name,
                                      maxLines: 3,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontFamily: "Barlow-Regular",
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              onTap: () {
                                locationName = "Fetching location..";
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());

                                setState(() {
                                  isLocationLoaded = false;
                                });

                                selectedPosition = position;

                                setState(() {
                                  _searchController.clear();
                                  _searchController.text =
                                      _placesList[position].name;
                                  getLocationName(_placesList[position].name);

                                });
                              },
                            ),
                            SizedBox(
                              height: 5,
                            )
                          ],
                        );
                      }),
                )
                    : Container(),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40.0, bottom: 60),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    width: (width * 2.3) * 0.260,
                    height: (height * 0.12) * 0.65,
                    child: GestureDetector(
                      onTap: () {
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Palette.pinkBox,
                            borderRadius:
                            BorderRadius.all(Radius.circular(50.0))),
                        child: Center(
                          child: Text(
                            "Save",
                            style: TextStyle(
                                color: Palette.whiteText,
                                fontSize: 19,
                                fontFamily: 'Rubik-Medium'),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
    );
  }

  showAlert(BuildContext context, String title, String description) {
    Dialog errorDialog = Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0)), //this right here
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 25.0),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: "MerriweatherSans-Regular",
                    fontSize: 20.0,
                    color: Palette.pinkBox),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Palette.pinkBox,
                  fontFamily: "MerriweatherSans-Regular",
                  fontSize: 16.0,
                ),
              ),
            ),
            FlatButton(
              color: Palette.pinkBox,
              textColor: Palette.whiteText,
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop('dialog');
              },
            ),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => errorDialog);
  }

  showAlertError(BuildContext context, String title, String description) {
    Dialog errorDialog = Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0)), //this right here
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 25.0),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: "MerriweatherSans-Regular",
                    fontSize: 20.0,
                    color: Palette.pinkBox),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Palette.pinkBox,
                  fontFamily: "MerriweatherSans-Regular",
                  fontSize: 16.0,
                ),
              ),
            ),
            FlatButton(
              color: Palette.pinkBox,
              textColor:Palette.whiteText,
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop('dialog');
                _searchController.clear();
                profileLocation = "";
                if (_placesList != null) {
                  _placesList.clear();
                }
              },
            ),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => errorDialog);
  }
}
