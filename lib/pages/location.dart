

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:violet_app/style/local.keys.dart';
import 'package:violet_app/style/palette.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:location/location.dart';

import 'drop_location.dart';
import 'home.dart';

class LocationPage extends StatefulWidget {
  String lat = '';
  String lng = '';
  LocationPage({Key key,
    this.lat,
    this.lng
  }) : super(key: key);

  @override
  _LocationState createState() => _LocationState();
}

class _LocationState extends State<LocationPage> {

  Location location = Location();
  final String mapStyle =
      "[\r\n  {\r\n    \"elementType\": \"geometry\",\r\n    \"stylers\": [\r\n      {\r\n        \"color\": \"#f5f5f5\"\r\n      }\r\n    ]\r\n  },\r\n  {\r\n    \"elementType\": \"labels.icon\",\r\n    \"stylers\": [\r\n      {\r\n        \"visibility\": \"off\"\r\n      }\r\n    ]\r\n  },\r\n  {\r\n    \"elementType\": \"labels.text.fill\",\r\n    \"stylers\": [\r\n      {\r\n        \"color\": \"#616161\"\r\n      }\r\n    ]\r\n  },\r\n  {\r\n    \"elementType\": \"labels.text.stroke\",\r\n    \"stylers\": [\r\n      {\r\n        \"color\": \"#f5f5f5\"\r\n      }\r\n    ]\r\n  },\r\n  {\r\n    \"featureType\": \"administrative.land_parcel\",\r\n    \"elementType\": \"labels.text.fill\",\r\n    \"stylers\": [\r\n      {\r\n        \"color\": \"#bdbdbd\"\r\n      }\r\n    ]\r\n  },\r\n  {\r\n    \"featureType\": \"poi\",\r\n    \"elementType\": \"geometry\",\r\n    \"stylers\": [\r\n      {\r\n        \"color\": \"#eeeeee\"\r\n      }\r\n    ]\r\n  },\r\n  {\r\n    \"featureType\": \"poi\",\r\n    \"elementType\": \"labels.text.fill\",\r\n    \"stylers\": [\r\n      {\r\n        \"color\": \"#757575\"\r\n      }\r\n    ]\r\n  },\r\n  {\r\n    \"featureType\": \"poi.park\",\r\n    \"elementType\": \"geometry\",\r\n    \"stylers\": [\r\n      {\r\n        \"color\": \"#e5e5e5\"\r\n      }\r\n    ]\r\n  },\r\n  {\r\n    \"featureType\": \"poi.park\",\r\n    \"elementType\": \"labels.text.fill\",\r\n    \"stylers\": [\r\n      {\r\n        \"color\": \"#9e9e9e\"\r\n      }\r\n    ]\r\n  },\r\n  {\r\n    \"featureType\": \"road\",\r\n    \"elementType\": \"geometry\",\r\n    \"stylers\": [\r\n      {\r\n        \"color\": \"#ffffff\"\r\n      }\r\n    ]\r\n  },\r\n  {\r\n    \"featureType\": \"road.arterial\",\r\n    \"elementType\": \"labels.text.fill\",\r\n    \"stylers\": [\r\n      {\r\n        \"color\": \"#757575\"\r\n      }\r\n    ]\r\n  },\r\n  {\r\n    \"featureType\": \"road.highway\",\r\n    \"elementType\": \"geometry\",\r\n    \"stylers\": [\r\n      {\r\n        \"color\": \"#dadada\"\r\n      }\r\n    ]\r\n  },\r\n  {\r\n    \"featureType\": \"road.highway\",\r\n    \"elementType\": \"labels.text.fill\",\r\n    \"stylers\": [\r\n      {\r\n        \"color\": \"#616161\"\r\n      }\r\n    ]\r\n  },\r\n  {\r\n    \"featureType\": \"road.local\",\r\n    \"elementType\": \"labels.text.fill\",\r\n    \"stylers\": [\r\n      {\r\n        \"color\": \"#9e9e9e\"\r\n      }\r\n    ]\r\n  },\r\n  {\r\n    \"featureType\": \"transit.line\",\r\n    \"elementType\": \"geometry\",\r\n    \"stylers\": [\r\n      {\r\n        \"color\": \"#e5e5e5\"\r\n      }\r\n    ]\r\n  },\r\n  {\r\n    \"featureType\": \"transit.station\",\r\n    \"elementType\": \"geometry\",\r\n    \"stylers\": [\r\n      {\r\n        \"color\": \"#eeeeee\"\r\n      }\r\n    ]\r\n  },\r\n  {\r\n    \"featureType\": \"water\",\r\n    \"elementType\": \"geometry\",\r\n    \"stylers\": [\r\n      {\r\n        \"color\": \"#c9c9c9\"\r\n      }\r\n    ]\r\n  },\r\n  {\r\n    \"featureType\": \"water\",\r\n    \"elementType\": \"labels.text.fill\",\r\n    \"stylers\": [\r\n      {\r\n        \"color\": \"#9e9e9e\"\r\n      }\r\n    ]\r\n  }\r\n]";

  double height, width;
  AlertDialog alert;
  final messageController = TextEditingController();
  bool isSearch = false;
  LocationData _locationData;
  GoogleMapController _controller;
  String lanCode = "en";
  double zoom = 1;
  String lat = "", lng = "";
  var place;
  var coordinates, addresses, first;

  final LatLng _center = const LatLng(0, 0);

  void _onMapCreated(GoogleMapController _cntlr) async {
    _controller = _cntlr;

    _controller.setMapStyle(mapStyle);

    print("(widget.lat ${widget.lat}");
    if (widget.lat != null) {
      print("yes*************** yes");
      var latitude = double.parse(widget.lat);
      var longitude = double.parse(widget.lng);
      _controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(latitude, longitude), zoom: 14.0),
        ),
      );
      getLocation(double.parse(widget.lat),double.parse(widget.lng));
    } else {
    print("yes*************** no");
    location.onLocationChanged.listen((l) {
      _controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(l.latitude, l.longitude), zoom: 15),

        ),
      );
      getLocation(l.latitude, l.longitude);
    });
    }
  }

  getLocation (double latNew, double lngNew) async{
     lat = latNew.toString();
     lng = lngNew.toString();
     coordinates = new Coordinates(latNew, lngNew);
     addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
     first = addresses.first.addressLine;
     setState(() {

     });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery
        .of(context)
        .size
        .width;
    height = MediaQuery
        .of(context)
        .size
        .height;

    lanCode = context.locale.languageCode;
    if (lanCode == "ar") {
      zoom = 1.4;
    } else {
      zoom = 1;
    }

    SystemChrome.setEnabledSystemUIOverlays([]);

    return Scaffold(

      // body:     GoogleMap(
      //   onMapCreated: _onMapCreated,
      //   myLocationEnabled: true,
      //   initialCameraPosition: CameraPosition(
      //     target: _center,
      //     zoom: 11.0,
      //   ),
      //   markers:  Set<Marker>.of(
      //       <Marker>[ Marker(
      //           onTap: () {
      //           },
      //           draggable: true,
      //           markerId: MarkerId('Marker'),
      //           // position: LatLng(value.latitude, value.longitude),
      //           onDragEnd: ((newPosition) {

      //           })),
      //       ]
      //   ),
      // ),


      body: Stack(
          children: [
            Positioned(
              top: (height/896) *235,
              child: Center(
                child: Container(
                  height: (height/896) *312,
                  width: width,
                  child:
                  GoogleMap(
                    onMapCreated: _onMapCreated,
                    myLocationEnabled: true,
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
                ),
              ),
            ),
            Container(
                height: height,
                width: width,
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    image: new DecorationImage(
                        image: new AssetImage("assets/curve_back.png"),
                        fit:  BoxFit. fill
                    )
                )
            ),

            Positioned(
              top: (height/896) * 695,
              left: (width/414) * 305,
              child: Container(
                child: Image.asset("assets/curve.png",
                    fit:  BoxFit. fill),
              ),
            ),
            Positioned(
              top: (height/896) * 2,
              width: width,
              child:Center(
                child: Container(
                  height: (height/896) * 61,
                  child: Image.asset("assets/pink_art.png",
                  ),
                ),
              ),
            ),
            Positioned(
              top: (height/602) * 45,
              left:  (width/414) * 16 ,
              right:  (width/414) * 16 ,
              child:GestureDetector(
                child: Container(
                    alignment: context.locale.languageCode== "en" ? Alignment.centerLeft : Alignment.centerRight,
                    child:
                    Icon(Icons.arrow_back_ios,
                      color: Colors.white,
                      size: (height/896) *25,)
                ),
                onTap: (){

                  FocusScope.of(context).requestFocus(new FocusNode());
                  Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.fade,
                        child: HomePage(),
                      ));
                },
              ),
            ),

            Positioned(
              top: (height/896) * 565,
              left: (width/414) * 17,
              right: (width/414) * 17,
              child: Center(
                  child: Container(
                    height: (height/896) * 128,
                    width: width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                      color: Palette.moreLightPink,
                    ),
                    child:
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(left:(width/414) * 15, right:(width/414) * 15 ),
                        height: (height/896) * 80,
                        width: width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          color: Palette.boxWhite,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.only(left:(width/414) * 10, right:(width/414) * 10),
                              child: Icon(Icons.location_on_outlined,
                              color: Palette.pinkBox,
                              size: (height/896) *25,)
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                      Container(
                                        width:(width/414) * 170,
                                      child:
                                        Text(LocaleKeys.delivered_to,
                                        style: TextStyle(
                                          color: Palette.pinkBox,
                                          fontSize: (height/896) * 16 * zoom,
                                          fontWeight: FontWeight.normal,
                                          fontFamily: lanCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
                                        ),).tr(),
                                        ),
                                    GestureDetector(
                                      child:
                                    Container(
                                      alignment: Alignment.centerRight,
                                    // width:(width/414) * 175,
                                    child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                       children: [
                                         Text(LocaleKeys.pick_the_location,
                                           style: TextStyle(
                                             color: Palette.pinkBox,
                                               fontFamily: lanCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
                                             fontSize: (height/896) * 16 * zoom,
                                               fontWeight: FontWeight.normal
                                           ),).tr(),
                                         Container(
                                           padding: EdgeInsets.only(top: lanCode == "en"? 0 : (height/896) * 12),
                                             child: Icon(Icons.arrow_forward_ios,
                                           color: Palette.pinkBox,
                                           size: (height/896) * 15,)
                                         ),
                                     ]
                                     ),
                                   ),
                                      onTap: (){
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => SelectLocation(lat:lat, lng:lng, title: first)),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                Container(
                                  padding:  EdgeInsets.only(top: lanCode == "en"?  (height/896) * 10 : 0,
                                      ),
                                  child:  Text( first != null ? first : LocaleKeys.choose_a_drop_off_location,
                                    style: TextStyle(
                                      color: Palette.pinkBox,
                                      fontFamily: lanCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
                                      fontWeight: FontWeight.bold,
                                      fontSize: (height/896) * 10 *  zoom ,
                                    ),).tr(),
                                )

                              ],
                            )
                          ],
                        )

                      ),
                    ),
                  ),
                ),

            ),
            Positioned(
              top: (height/896) * 730,
              left: (width/414) * 114,
              right: (width/414) * 114,
              child: GestureDetector(
                child: Center(
                  child: Container(
                    height: (height/896) * 50,
                    width: width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      color: Palette.pinkBox,
                    ),
                    child:
                   Center(
                        child: Text(LocaleKeys.confirm,
                          style: TextStyle(
                            fontSize: 20 * zoom,
                            fontFamily: lanCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
                            color: Palette.whiteText,
                          ),).tr(),
                      ),
                    ),
                ),
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                },
              ),
            ),
          ]
      ),
    );
  }


}