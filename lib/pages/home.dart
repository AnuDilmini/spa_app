
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/style/palette.dart';

class HomePage extends StatefulWidget {

  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  double height, width;


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

    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;


    SystemChrome.setEnabledSystemUIOverlays([]);
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //     statusBarColor: Colors.transparent, // transparent status bar
    //     statusBarIconBrightness: Brightness.dark));

    return Scaffold(
      body: Stack(
        children: [
        Container(
          height: height,
          width: width,
        decoration: BoxDecoration(
        shape: BoxShape.rectangle,
         image: new DecorationImage(
          image: new AssetImage("assets/background.png"),
          fit: BoxFit.fill,
          )
        )
        ),
          Positioned(
          top: (height/449) * 20,
          width: width,
          child:Center(
            child: Container(
            width: (width/208) * 45,
            height: (width/208) * 45,
            child:
            Image.asset('assets/artboard.png',
            ),
          ),
          ),
        ),
          Positioned(
            top: (height/449) * 80,
            width: width,
            child:Center(
              child: Column(
                children:[
                Text(
                  'VIOLET',
                  style: TextStyle(
                    letterSpacing: 1,
                      fontSize: 40,
                      color:  Palette.whiteText,
                      fontFamily: "Audrey-Medium"),
                ),
              Text( 'بنفسج',
                style: TextStyle(
                    height: 0.4,
                    letterSpacing: 1,
                    fontSize: 40,
                    color: Palette.whiteText,
                    fontFamily: "Ah-moharram-bold"
                )),
              ]
              ),
            ),

          ),
          Positioned(
            top: (height/449) * 150,
            width: width,
              child:  Center(
                child: Text(
                 'CHOOSE YOUR SELECTION',
                  style: TextStyle(
                      fontSize: 25,
                      color: Palette.whiteText,
                      fontFamily: "Audrey-Medium"
                  )),
              ),
          ),
          Positioned(
            top: (height/449) * 193,
            width: width,
            child: GestureDetector(
              child: Center(
                child:  Container(
              width: (width/208) *75,
              height:  (width/208) * 75,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                color: Palette.pinkBox,
              ),
                  child: Column(
                    children: [
                      Container(
                          margin: EdgeInsets.only(top: (width/208) * 10,bottom: (width/208) * 5 ),
                      height: (width/208) * 40,
                     width: (width/208) * 40,
                     child:
                       Image.asset('assets/reservation.png',)
                      ),
                      Text(
                          'Reservation',
                          style: TextStyle(
                              fontSize: 26,
                              // letterSpacing: 0.01,
                              color: Palette.whiteText,
                              fontFamily: "Audrey-Medium"
                          )),
                    ],
                  )
            )
            ),
              onTap: (){

              },
            ),
          ),
          Positioned(
            top: (height/449) *305,
            width: width,
            child: GestureDetector(
              child: Center(
                  child:  Container(
                      width: (width/208) *75,
                      height:  (width/208) * 75,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Palette.pinkBox,
                      ),
                      child: Column(
                        children: [
                          Container(
                              margin: EdgeInsets.only(top: (width/208) * 10,bottom: (width/208) * 5 ),
                              height: (width/208) * 40,
                              width: (width/208) * 40,
                              child:
                              Image.asset('assets/wd.png',)
                          ),
                        Container(
                          padding: EdgeInsets.only(left:5,right: 5 ),
                          child: Text(
                              'Home Service',
                              maxLines: 1,
                              style: TextStyle(
                                  fontSize: 26,
                                  // letterSpacing: 0.01,
                                  color: Palette.whiteText,
                                  fontFamily: "Audrey-Medium"
                              )),
                          ),
                        ],
                      )
                  )
              ),
              onTap: (){

              },
            ),
          ),
       ]
      )
    );
  }
}