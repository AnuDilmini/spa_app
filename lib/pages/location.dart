

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:violet_app/pages/update_profile.dart';
import 'package:violet_app/style/local.keys.dart';
import 'package:violet_app/style/palette.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:location/location.dart';

import 'drop_location.dart';
import 'home.dart';

class LocationPage extends StatefulWidget {

  LocationPage({Key key}) : super(key: key);

  @override
  _LocationState createState() => _LocationState();
}

class _LocationState extends State<LocationPage> {

  Location location = Location();

  double height, width;
  AlertDialog alert;
  final messageController = TextEditingController();
  bool isSearch = false;
  LocationData _locationData;
  GoogleMapController _controller;

  final LatLng _center = const LatLng(24.774265, 46.738586);

  void _onMapCreated(GoogleMapController _cntlr)
  {
    _controller = _cntlr;
    location.onLocationChanged.listen((l) {
      _controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(l.latitude, l.longitude),zoom: 15),
        ),
      );
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
      //             print('Tapped');
      //           },
      //           draggable: true,
      //           markerId: MarkerId('Marker'),
      //           // position: LatLng(value.latitude, value.longitude),
      //           onDragEnd: ((newPosition) {
      //             print(newPosition.latitude);
      //             print(newPosition.longitude);
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
                          print('Tapped');
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
                      size: 25,)
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
                              padding: EdgeInsets.only(left:(width/414) * 10),
                              child: Icon(Icons.location_on_outlined,
                              color: Palette.pinkBox,
                              size: 25,)
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                      Container(
                                        padding:  EdgeInsets.only(left:(width/414) * 15),
                                        width:(width/414) * 170,
                                      child:
                                        Text(LocaleKeys.delivered_to,
                                        style: TextStyle(
                                          color: Palette.pinkBox,
                                          fontSize: 15,
                                          fontWeight: FontWeight.normal
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
                                             fontSize: 15,
                                               fontWeight: FontWeight.normal
                                           ),).tr(),
                                         Icon(Icons.arrow_forward_ios,
                                           color: Palette.pinkBox,
                                           size: 15,)
                                     ]
                                     ),
                                   ),
                                      onTap: (){
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => SelectLocation()),
                                        );

                                      },
                                    ),
                                  ],
                                ),
                                Container(
                                  padding:  EdgeInsets.only(top:(height/896) * 10,
                                      left:(width/414) * 15),
                                  child:  Text(LocaleKeys.choose_a_drop_off_location,
                                    style: TextStyle(
                                      color: Palette.pinkBox,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
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
                            fontSize: 20,
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