
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:violet_app/notifiers/dark_theme_provider.dart';
import 'package:violet_app/pages/update_profile.dart';
import 'package:violet_app/style/palette.dart';
import 'package:page_transition/page_transition.dart';
import 'package:violet_app/style/local.keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

import 'bottom_nav.dart';

class Orders extends StatefulWidget {

  Orders({Key key}) : super(key: key);

  @override
  _Orders createState() => _Orders();
}

class _Orders extends State<Orders> {

  double height, width;
  AlertDialog alert;
  final messageController = TextEditingController();
  bool isSearch = false;
  int selectOrder;
  bool clickOrder = false;


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
      // backgroundColor: Palette.blurColor,
      body: Stack(
          children: [
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
              top: (height/896) * 113,
              width: width,
              child:Center(
                child: Container(
                    height: (height/896) * 75,
                    child: Text(LocaleKeys.order_history,
                      style: TextStyle(
                        fontSize: 28,
                        color: Palette.pinkBox,
                      ),).tr()
                ),
              ),
            ),
            Positioned(
              top: (height/896) * 160,
              left: (width/414) * 25,
              right: (width/414) * 25,
              child:
              Container(
                padding: EdgeInsets.only(bottom: (height/896) * 225 ),
                height: height,
                width: width,
                child:  ListView.builder(
                    padding: EdgeInsets.zero,
                    scrollDirection: Axis.vertical,
                    itemCount:20,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                          child: listItem(index),
                          onTap:(){

                            setState(() {
                              clickOrder = true;
                              slideSheet();
                              selectOrder = index;
                            });

                          }
                      );
                    }
                ),
              ),
            ),
            Positioned(
              top: (height/896) * 695,
              left: (width/414) * 305,
              child: Container(
                child: Image.asset("assets/curve.png",
                    fit:  BoxFit. fill),
              ),
            ),

            // Positioned(
            //   top: (height/896) * 420,
            //   left: (width/414) * 0,
            //   width: width,
            //   child:
            //   clickOrder?
            //
            //  GestureDetector(
            //      child: Container(
            //       padding: EdgeInsets.only(top: (height/896)*25 ),
            //       height: height,
            //       width: width,
            //       decoration: BoxDecoration(
            //         borderRadius: BorderRadius.only(topLeft: Radius.circular(60), topRight: Radius.circular(60)),
            //         color:  Color(0xFFE9E2E3),
            //       ),
            //       child: ListView(
            //         children: [
            //           Column(
            //         children: [
            //           Text("FOUR SPA",
            //             style: TextStyle(
            //               color: Palette.darkPink,
            //               fontSize: 25,
            //               fontWeight: FontWeight.normal,
            //               fontFamily: "Audrey-Normal",
            //             ),),
            //           SizedBox(
            //             height: 35,
            //           ),
            //           Text("19 January. 1:12",
            //             style: TextStyle(
            //               color: Palette.darkPink,
            //               fontSize: 20,
            //               fontWeight: FontWeight.bold,
            //               fontFamily: "Audrey-Normal",
            //             ),),
            //           SizedBox(
            //             height: 15,
            //           ),
            //           Text("HAIR CUT",
            //             style: TextStyle(
            //               color: Palette.darkPink,
            //               fontSize: 20,
            //               fontWeight: FontWeight.bold,
            //               fontFamily: "Audrey-Normal",
            //             ),),
            //           SizedBox(
            //             height: 12,
            //           ),
            //           Text("100 SAR",
            //             style: TextStyle(
            //               color: Palette.darkPink,
            //               fontSize: 20,
            //               fontWeight: FontWeight.bold,
            //               fontFamily: "Audrey-Normal",
            //             ),),
            //           SizedBox(
            //             height: 12,
            //           ),
            //           Text("HAIR CUT",
            //             style: TextStyle(
            //               color: Palette.darkPink,
            //               fontSize: 20,
            //               fontWeight: FontWeight.bold,
            //               fontFamily: "Audrey-Normal",
            //             ),),
            //           SizedBox(
            //             height: 12,
            //           ),
            //           Text("500 SAR",
            //             style: TextStyle(
            //               color: Palette.darkPink,
            //               fontSize: 20,
            //               fontWeight: FontWeight.bold,
            //               fontFamily: "Audrey-Normal",
            //             ),),
            //           SizedBox(
            //             height: 15,
            //           ),
            //           Image.asset("assets/store.png")
            //         ],
            //       ),
            //         ]
            //   ),
            //
            // ),
            //    onTap: (){
            //        setState(() {
            //          slideSheet();
            //
            //          clickOrder = !clickOrder;
            //        });
            //    },
            //  ):
            //    Container(),
            // ),
          ]
      ),
    );
  }

  void slideSheet() {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return GestureDetector(
            child:
           Container(
            padding: EdgeInsets.only(top: (height/896)*25 ),
            height: height,
            width: width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(60), topRight: Radius.circular(60)),
              color:  Color(0xFFE9E2E3),
            ),
            child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  Column(
                    children: [
                      Text("FOUR SPA",
                        style: TextStyle(
                          color: Palette.darkPink,
                          fontSize: 25,
                          fontWeight: FontWeight.normal,
                          fontFamily: "Audrey-Normal",
                        ),),
                      SizedBox(
                        height: 35,
                      ),
                      Text("19 January. 1:12",
                        style: TextStyle(
                          color: Palette.darkPink,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Audrey-Normal",
                        ),),
                      SizedBox(
                        height: 15,
                      ),
                      Text("HAIR CUT",
                        style: TextStyle(
                          color: Palette.darkPink,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Audrey-Normal",
                        ),),
                      SizedBox(
                        height: 12,
                      ),
                      Text("100 SAR",
                        style: TextStyle(
                          color: Palette.darkPink,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Audrey-Normal",
                        ),),
                      SizedBox(
                        height: 12,
                      ),
                      Text("HAIR CUT",
                        style: TextStyle(
                          color: Palette.darkPink,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Audrey-Normal",
                        ),),
                      SizedBox(
                        height: 12,
                      ),
                      Text("500 SAR",
                        style: TextStyle(
                          color: Palette.darkPink,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Audrey-Normal",
                        ),),
                      SizedBox(
                        height: 15,
                      ),
                      Image.asset("assets/store.png")
                    ],
                  ),
                ]
            ),
           ),
            onTap: (){
            },
          );
        });
  }

  listItem(int index){
    return Container(
      height: (height/896) * 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(left: (width/414) * 25, right: (width/414) * 25),
            child: Text("7 May 2020",
              style: TextStyle(
                color: Palette.darkPink,
                fontSize: 15,
              ),),
          ),
          Container(
            height: (height/896) * 100,
            width: width,
            margin: EdgeInsets.only(top: (height/896) * 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color:  selectOrder == index ? Color.fromRGBO(168, 132, 153, 0.64) :Color.fromRGBO(233, 226, 227, 0.75),
            ),
            child: Row(
                children:[
                  Container(
                    padding: EdgeInsets.only(left:  (width/414) * 25,right: (width/414) * 25 ),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:[
                          Image.asset("assets/ipay.png"),
                          Text("FOUR\nSPA",
                            style: TextStyle(
                              fontSize: 12,
                              color: selectOrder == index ? Palette.whiteText :Palette.pinkBox,
                            ),)
                        ]
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: (height/896) * 10),
                    width: (width/414) * 200,
                    child: Center(
                        child:  RichText(
                          text: TextSpan(
                            text: 'Massage\n',
                            style: TextStyle(
                                fontSize: 14,
                                color:  selectOrder == index ? Palette.whiteText :Palette.pinkBox),
                            children: <TextSpan>[
                              TextSpan(text: '130 SAR',
                                style: TextStyle(
                                    fontSize: 17,
                                    color: selectOrder == index ? Palette.whiteText :Palette.pinkBox),),
                            ],
                          ),
                        )
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: (width/414) *10),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children:[
                          Container(
                            alignment: Alignment.center,
                            height: (height/896) * 30,
                            child:Text("#2133",
                              style: TextStyle(
                                fontSize: 13,
                                color:  selectOrder == index ? Palette.whiteText :Palette.pinkBox,
                              ),),
                          ),
                          GestureDetector(
                              child: Container(
                              alignment: Alignment.bottomCenter,
                              height: (height/896) * 60,
                              child: Icon(Icons.refresh,
                                color:  selectOrder == index ? Palette.whiteText :Palette.pinkBox,
                                size: 20,)
                          ),
                            onTap: (){
                              Navigator.push(
                                  context,
                                  PageTransition(
                                    type: PageTransitionType.fade,
                                    child:  BottomNav(index: 0, subIndex: 4),
                                  ));
                            },
                          ),
                        ]
                    ),
                  ),
                ]
            ),
          ),
        ],
      ),
    );
  }


}