import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:violet_app/model/place_model.dart';
import 'package:violet_app/network/shared.dart';
import 'package:violet_app/style/palette.dart';

import 'bottom_nav.dart';


class SelectLocation extends StatefulWidget {
  SelectLocation(
      {Key key,})
      : super(key: key);
  bool selected = false;

  @override
  _SelectLocation createState() => _SelectLocation();
}

class _SelectLocation extends State<SelectLocation> {
  // GoogleMapController mapController;
  // Location location = Location();

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
  var _markers;
  var data;
  var position;
  bool isLocationLoaded = false;
  final LatLng _center = const LatLng(24.774265, 46.738586);
  GoogleMapController _controller;
  String lanCode = 'en';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getShared();

  }


  @override
  void dispose() {
    _searchController.dispose();
    _controller.dispose();

  }

  getShared() async{
    lanCode = await SharedPreferencesHelper.getLanguage();
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;

    _controller.setMapStyle(mapStyle);

    _controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(latSearch, lngSearch), zoom: 15.0),
      ),
    );

    // if( latSearch != null) {
    //   _controller.animateCamera(
    //     CameraUpdate.newCameraPosition(
    //       CameraPosition(target: LatLng(latSearch, lngSearch), zoom: 15.0),
    //     ),
    //   );
    // }else {
    //   location.onLocationChanged.listen((l) {
    //     _controller.animateCamera(
    //       CameraUpdate.newCameraPosition(
    //         CameraPosition(target: LatLng(l.latitude, l.longitude),zoom: 15),
    //       ),
    //     );
    //   });
    //
    // }
  }

  void _onMapCreatedNew(GoogleMapController _cntlr)
  {
    _controller = _cntlr;
    _controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(24.774265, 46.738586), zoom: 15.0),
        )
    );
  }

  void getLocationResults(String input) async {
    if (input.isEmpty) {
      return;
    }
    String request =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&radius=1000&key=$kGoogleApiKey';// &types=(cities)

    var response = await Dio().get(request);

    final predictions = response.data['predictions'];
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
        _controller.animateCamera(CameraUpdate.newCameraPosition(
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

    return
      Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          width: width,
          height: height,
          child: Stack(
            children: <Widget>[
              latSearch != null ?  GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: _center,
                  zoom: 14.0,
                ),
                myLocationEnabled: false,
                myLocationButtonEnabled: false,
                tiltGesturesEnabled: true,
                compassEnabled: true,
          markers:  Set<Marker>.of(
              <Marker>[ Marker(
                  onTap: () {

                  },
                  draggable: true,
                  markerId: MarkerId('Marker'),
                  // position: LatLng(value.latitude, value.longitude),
                  onDragEnd: ((newPosition) {
                    print(newPosition.latitude);
                    print(newPosition.longitude);
                  })),
              ]
               ),
                scrollGesturesEnabled: false,
                zoomGesturesEnabled: false,
                onMapCreated:
                      _onMapCreated,
              )
                  :     GoogleMap(
                onMapCreated: _onMapCreatedNew,
                myLocationEnabled: false,
                initialCameraPosition: CameraPosition(
                  target: _center,
                  zoom: 11.0,
                ),
                markers:  Set<Marker>.of(
                    <Marker>[ Marker(
                        onTap: () {

                        },
                        draggable: true,
                        markerId: MarkerId('Marker'),
                        // position: LatLng(value.latitude, value.longitude),
                        onDragEnd: ((newPosition) {
                          print(newPosition.latitude);
                          print(newPosition.longitude);
                        })),
                    ]
                ),
              ),
              Container(
                height: height / 5.4,
                width: width,
                color: Palette.lightPink,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BottomNav(index: 0,subIndex: 5,)),
                  );
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
                          color: Palette.pinkBox,
                          shape: BoxShape.circle),
                      child: Center(
                        child: Icon(
                          Icons.close,
                          color: Palette.whiteText,
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
                      color: Colors.purple,
                      size: 40,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: height / 11,
                left: 20,
                child: Text(
                  "Enter City",
                  style: TextStyle(
                      color: Palette.pinkBox,
                      fontSize: 19,
                    fontFamily: lanCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',),
                )
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
                      gradient: new LinearGradient(
                        colors: [
                          const Color(0xFF3F2063),
                          const Color(0xFF6E2A73),
                        ],
                        begin: const FractionalOffset(0.0, 0.0),
                        end: const FractionalOffset(0.5, 1.0),
                      ),
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
                              color: Palette.whiteText, width: 0.5),
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
                                      widget.selected = true;
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
                                  cursorColor: Palette.darkPink,
                                  decoration: InputDecoration(
                                    hintText: newTitle != null
                                        ? newTitle
                                        : 'Please enter birth city..',
                                    hintStyle: TextStyle(
                                      color:Palette.pinkBox,
                                      fontSize: 18,
                                      fontFamily: lanCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
                                    ),
                                    border: InputBorder.none,
                                  ),
                                  style: TextStyle(
                                      color: Palette.pinkBox,
                                      fontSize: 18,
                                    fontFamily: lanCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',),
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
                child: widget.selected == true &&
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
                                        fontFamily: lanCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
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

                                  isSameLocation = false;
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
                        setState(() {
                          if (locationCode == "") {
                            getLocationName(_placesList[position].name);
                          }

                          if ((locationName == "" &&
                              locationName == "Fetching location..") ||
                              _searchController.text == "") {
                            showAlert(context, 'Oops!',
                                'Please select city.');
                          } else {
                            if (isLocationLoaded == true ) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => BottomNav(index: 0,subIndex: 5,)),
                              );
                            } else {
                              showAlert(context, 'Fetching location!',
                                  'Please wait..');
                            }
                          }
                        });
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
                              fontFamily: lanCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',),
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
                   fontSize: 20.0,
                    color: Palette.pinkBox,
                  fontFamily: lanCode == "en"? 'Audrey-Medium': 'ArbFONTS-026'),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Palette.pinkBox,
                  fontSize: 16.0,
                 fontFamily: lanCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
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
                    fontFamily: lanCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
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
                  fontFamily: lanCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
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
