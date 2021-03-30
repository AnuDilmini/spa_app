import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:violet_app/pages/update_profile.dart';
import 'package:violet_app/style/local.keys.dart';
import 'package:violet_app/style/palette.dart';
import 'package:page_transition/page_transition.dart';
import 'package:easy_localization/easy_localization.dart';

import 'bottom_nav.dart';
import 'home.dart';

class SelectTimeDate extends StatefulWidget {

  SelectTimeDate({Key key}) : super(key: key);

  @override
  _SelectTimeDate createState() => _SelectTimeDate();
}

class _SelectTimeDate extends State<SelectTimeDate> {

  double height, width;
  AlertDialog alert;
  final messageController = TextEditingController();
  bool isInfo = false;
  int currentPageIndex = 0;
  int month = 4;
  List<String> months = ["January", "February", "March", "April",
  "May", "June", "July", "August", "September", "October", "November", "December"];


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
              top: (height/896) * 695,
              left: (width/414) * 315,
              child: Container(
                child: Image.asset("assets/curve.png",
                    fit:  BoxFit. fill),
              ),
            ),
            Positioned(
              top: (height/602) * 40,
              left:  (width/414) * 16 ,
              child:GestureDetector(
                child: Center(
                  child: Container(
                    width: (width/414) * 16,
                    height: (width/414) * 16,
                    child:
                    Image.asset('assets/back.png',
                      // fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
                onTap: (){
                  Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.fade,
                        child:  BottomNav(index: 0, subIndex: 0),
                      ));
                },
              ),
            ),
            Positioned(
              top: (height/896) * 114,
              left: (width/414) * 12,
              child: GestureDetector(
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Palette.lightPink,
                    ),
                    height: (height/896) * 37,
                    width: (width/414) * 50,
                    child: Image.asset("assets/cart.png"),
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
            Positioned(
              top: (height/896) * 185,
              left: (width/414) * 50,
              right: (width/414) * 30,
              child: Column(
                children: [
                  Container(
                   alignment: Alignment.topLeft,
                   height: (height/896) * 37,
                   width: width,
                   child: Text(LocaleKeys.our_specialist,
                  style: TextStyle(
                    fontFamily: "Audrey-Medium",
                    color: Palette.darkPink,
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                  ),).tr()
                 ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    alignment: Alignment.center,
                    width : width,
                    height: (height/896) * 37,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 5,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            width: 100,
                            padding: EdgeInsets.only(right: 10),
                              child: Text("Amli ",
                              style: TextStyle(
                                color: Palette.darkPink,
                                fontSize: 23,
                                // fontFamily: "Audrey-Normal",
                                fontWeight: FontWeight.w400,
                              ),
                              ),
                            );
                        }
                    ),
                  ),
             ]
              )
            ),
            Positioned(
                top: (height/896) * 310,
                left: (width/414) * 50,
                right: (width/414) * 30,
                child: Container(
                    alignment: Alignment.topLeft,
                    height: (height/896) * 37,
                    width: width,
                    child: Text(LocaleKeys.available_date,
                      style: TextStyle(
                        fontFamily: "Audrey-Medium",
                        color: Palette.darkPink,
                        fontSize: 25,
                        fontWeight: FontWeight.w500,
                      ),).tr()
                ),
            ),
            Positioned(
              top: (height/896) * 339,
              left: (width/414) * 30,
              right: (width/414) * 30,
              child: Container(
                  alignment: Alignment.topLeft,
                  height: (height/896) * 37,
                  width: width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                        child: Icon(Icons.arrow_back_ios,
                          color: Palette.pinkBox,
                          size: 15,),
                          onTap: (){
                            if(month> 0){
                              setState(() {
                                month = month -1;
                                currentPageIndex = currentPageIndex-1;
                              });

                            }
                          },
                        ),
                        SizedBox(
                          width: 10,
                        ),
                      Container(
                        alignment: Alignment.center,
                        width: width/5,
                          child: Text("${months[month]}",
                    style: TextStyle(
                      fontFamily: "Audrey-Medium",
                      color: Palette.darkPink,
                      fontSize: 18,
                      fontWeight: FontWeight.w300,
                    ),),
                      ),
                        SizedBox(
                          width: 10,
                        ),
                      GestureDetector(
                        child:  Icon(Icons.arrow_forward_ios,
                          color: Palette.pinkBox,
                          size: 15,),
                      onTap: (){
                          if(month< 11){
                            setState(() {
                              month = month +1;
                              currentPageIndex = currentPageIndex+1;
                            });
                          }
                      },
                   ),
                ]
                ),
              ),
            ),
            Positioned(
              top: (height/896) * 390,
              left: (width/414) * 30,
              right: (width/414) * 30,
              child:  Container(
                height: (height/896) * 375,
              child: PageView.builder(
                 onPageChanged: (value) {
                  setState(() {
                  currentPageIndex = value;
                  month = currentPageIndex;
                  });
                  },
                pageSnapping: true,
                allowImplicitScrolling: true,
                scrollDirection: Axis.horizontal,
                itemCount: 12,
                // ignore: missing_return
                itemBuilder: (BuildContext context, int index) {
                 return monthItem(index);
                }),
             ),
            ),
            Positioned(
              top: (height/896) * 550,
              left: (width/414) * 50,
              right: (width/414) * 30,
              child: Container(
                  alignment: Alignment.topLeft,
                  height: (height/896) * 37,
                  width: width,
                  child: Text(LocaleKeys.available_time,
                    style: TextStyle(
                      fontFamily: "Audrey-Medium",
                      color: Palette.darkPink,
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                    ),).tr()
              ),
            ),
            Positioned(
              top: (height/896) * 590,
              left: (width/414) * 50,
              right: (width/414) * 30,
              child:
              Container(
                height: (height/896) * 140,
                child: ListView(
                 scrollDirection: Axis.vertical,
                  children: [
                    Wrap(
                         spacing: 20,
                         crossAxisAlignment :WrapCrossAlignment.center,
                         alignment: WrapAlignment.center,
                         direction : Axis.horizontal,
                         children: [
                            Container(
                              width: (width/414) * 50,
                              height:(width/414) * 50,
                              decoration: BoxDecoration(
                                color: Palette.greyBox,
                                shape: BoxShape.circle,
                              ),
                              // child: Text("${months[month]}"),
                            ),
                            Container(
                              width: (width/414) * 50,
                              height:(width/414) * 50,
                              decoration: BoxDecoration(
                                color: Palette.greyBox,
                                shape: BoxShape.circle,
                              ),
                              // child: Text("1"),
                            ),
                            Container(
                              width: (width/414) * 50,
                              height:(width/414) * 50,
                              decoration: BoxDecoration(
                                color: Palette.greyBox,
                                shape: BoxShape.circle,

                              ),
                              // child: Text("1"),
                            ),
                            Container(
                              width: (width/414) * 50,
                              height:(width/414) * 50,
                              decoration: BoxDecoration(
                                color: Palette.greyBox,
                                shape: BoxShape.circle,
                              ),
                              // child: Text("1"),
                            ),
                            Container(
                              width: (width/414) * 50,
                              height:(width/414) * 50,
                              decoration: BoxDecoration(
                                color: Palette.greyBox,
                                shape: BoxShape.circle,
                              ),
                              // child: Text("1"),
                            ),
                            Container(
                              width: (width/414) * 50,
                              height:(width/414) * 50,
                              decoration: BoxDecoration(
                                color: Palette.greyBox,
                                shape: BoxShape.circle,
                              ),
                              // child: Text("1"),
                            ),
                            Container(
                              width: (width/414) * 50,
                              height:(width/414) * 50,
                              decoration: BoxDecoration(
                                color: Palette.greyBox,
                                shape: BoxShape.circle,
                              ),
                              // child: Text("1"),
                            ),
                            Container(
                              width: (width/414) * 50,
                              height:(width/414) * 50,
                              decoration: BoxDecoration(
                                color: Palette.greyBox,
                                shape: BoxShape.circle,
                              ),
                              // child: Text("1"),
                            ),
                            Container(
                      width: (width/414) * 50,
                      height:(width/414) * 50,
                      decoration: BoxDecoration(
                        color: Palette.greyBox,
                        shape: BoxShape.circle,
                      ),
                      // child: Text("1"),
                    ),
                    ]
                   ),
                  ],
                ),
              )
            ),
      Positioned(
          top: (height/896) * 740,

          left: (width/414) * 135,
          right: (width/414) *135,
          child: GestureDetector(
              child: Container(

            alignment: Alignment.center,
            width: (width/414) * 135,
            height: (height/896) * 47,
            decoration: BoxDecoration(
              color: Palette.pinkBox,
              borderRadius: BorderRadius.all(Radius.circular(30)),
            ),
         child: Text(
           LocaleKeys.confirm,
           style: TextStyle(
             fontSize: 26,
             color: Palette.whiteText
           ),
         )
          ),
            onTap: (){
              Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.fade,
                    child:  BottomNav(index: 0, subIndex:2),
                  ));
            },
          ),
      ),
          ]
      ),
    );
  }

  monthItem(int index){
    return Container(
      height: (height/896) * 200,
      width: width,
      child:
          Wrap(
        spacing: 20,
        crossAxisAlignment :WrapCrossAlignment.center,
        alignment: WrapAlignment.center,
        direction : Axis.horizontal,
        children: [

          Container(
            width: (width/414) * 50,
            height:(width/414) * 50,
            decoration: BoxDecoration(
              color: Palette.greyBox,
              shape: BoxShape.circle,
            ),
            // child: Text("${months[month]}"),
          ),
          Container(
            width: (width/414) * 50,
            height:(width/414) * 50,
            decoration: BoxDecoration(
              color: Palette.greyBox,
              shape: BoxShape.circle,
            ),
            // child: Text("1"),
          ),
          Container(
            width: (width/414) * 50,
            height:(width/414) * 50,
            decoration: BoxDecoration(
              color: Palette.greyBox,
              shape: BoxShape.circle,

            ),
            // child: Text("1"),
          ),
          Container(
            width: (width/414) * 50,
            height:(width/414) * 50,
            decoration: BoxDecoration(
              color: Palette.greyBox,
              shape: BoxShape.circle,
            ),
            // child: Text("1"),
          ),
          Container(
            width: (width/414) * 50,
            height:(width/414) * 50,
            decoration: BoxDecoration(
              color: Palette.greyBox,
              shape: BoxShape.circle,
            ),
            // child: Text("1"),
          ),
          Container(
            width: (width/414) * 50,
            height:(width/414) * 50,
            decoration: BoxDecoration(
              color: Palette.greyBox,
              shape: BoxShape.circle,
            ),
            // child: Text("1"),
          ),
          Container(
            width: (width/414) * 50,
            height:(width/414) * 50,
            decoration: BoxDecoration(
              color: Palette.greyBox,
              shape: BoxShape.circle,
            ),
            // child: Text("1"),
          ),
          Container(
            width: (width/414) * 50,
            height:(width/414) * 50,
            decoration: BoxDecoration(
              color: Palette.greyBox,
              shape: BoxShape.circle,
            ),
            // child: Text("1"),
          ),
          Container(
            width: (width/414) * 50,
            height:(width/414) * 50,
            decoration: BoxDecoration(
              color: Palette.greyBox,
              shape: BoxShape.circle,
            ),
            // child: Text("1"),
          ),
        ],
      ),

    );

  }

}
