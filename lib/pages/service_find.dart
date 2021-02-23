
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/style/palette.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ServiceFindPage extends StatefulWidget {

  ServiceFindPage({Key key}) : super(key: key);

  @override
  _ServiceFindPageState createState() => _ServiceFindPageState();
}

class _ServiceFindPageState extends State<ServiceFindPage> {

  double height, width;
  AlertDialog alert;
  final messageController = TextEditingController();


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

    return  Scaffold(
        body: Stack(
            children: [
              Container(
                  height: height * 1.2,
                  width: width,
                 color: Palette.whiteText,
              ),
              Positioned(
                top:0,
                width: width,
                height: height/2.5,
                child:Center(
                  child: Container(
                      width: width,
                      height: height/2.5,
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        image: new DecorationImage(
                          image: new AssetImage("assets/dot_background.png"),
                          fit: BoxFit.fill,
                        )
                    )
                  ),
                ),
              ),
              Positioned(
                top: (height/449) * 10,
                width: width,
                child:Center(
                  child: Container(
                    width: (width/208) * 30,
                    height: (width/208) * 30,
                    child:
                    Image.asset('assets/artboard.png',
                    ),
                  ),
                ),
              ),
              Positioned(
                top: (height/449) * 70,
                left: 15,
                  child:Text(
                    'Welcome  Abeer!',
                    style: TextStyle(
                        letterSpacing: 1,
                        fontSize: 24,
                        color:  Palette.whiteText,
                        fontFamily: "Audrey-Medium"),
                  ),
              ),
              Positioned(
                top: (height/449) * 66,
                left: 15 + (width/208) * 150,
                child: Container(
                    width: (width/208) * 35,
                    height: (height/448) * 25,
                    decoration: BoxDecoration(
                      color: Palette.greyBox,
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                  child: Icon(Icons.search,
                  size: 35,
                  color: Palette.pinkBox,),
                ),
              ),
              Positioned(
                top: (height/449) * 100,
                left: 15,
                child:Text(
                  'Find service',
                  style: TextStyle(
                      letterSpacing: 1,
                      fontSize: 30,
                      color:  Palette.whiteText,
                      fontFamily: "Audrey-Medium"),
                ),
              ),
              Positioned(
                top: (height/449) * 120,
                left:  (width/208) * 8,
                right:  (width/208) * 8,
                child: Center(
                      child: Row(
                      children: <Widget>[
                        Expanded(
                            flex: 1,
                            child: Column(
                                children:[
                                  Container(
                                    margin: EdgeInsets.only(right: (width/208) * 3 ),
                                    width: (width/208) *30,
                                    height:  (width/208) * 30,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Palette.greyBox
                                    ),
                                    child: Icon(Icons.menu,
                                      size: 25,
                                      color: Palette.pinkBox,
                                    )
                                  ),
                                  Center(
                                    child: Container(
                                      margin: EdgeInsets.only(top: 5),
                                      child: Text("All",
                                      style: TextStyle(
                                        color: Palette.whiteText,
                                        fontSize: 15,
                                      ),),
                                    ),
                                  ),
                                ]
                            ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                              children:[
                                Container(
                                  margin: EdgeInsets.only(right: (width/208) * 3 ),
                                  width: (width/208) *30,
                                  height:  (width/208) * 30,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Palette.greyBox
                                  ),
                                    child: Icon(Icons.menu,
                                      size: 25,
                                      color: Palette.pinkBox,
                                    )
                                ),
                                Center(
                                  child: Container(
                                    margin: EdgeInsets.only(top: 5),
                                    child: Text("Makeup",
                                      style: TextStyle(
                                        color: Palette.whiteText,
                                        fontSize: 15,
                                      ),),
                                  ),
                                ),
                              ]
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                              children:[
                                Container(
                                  margin: EdgeInsets.only(right: (width/208) * 3 ),
                                  width: (width/208) *30,
                                  height:  (width/208) * 30,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Palette.greyBox
                                  ),
                                    child: Icon(Icons.menu,
                                      size: 25,
                                      color: Palette.pinkBox,
                                    )
                                ),
                                Center(
                                  child: Container(
                                    margin: EdgeInsets.only(top: 5),
                                    child: Text("Nails",
                                      style: TextStyle(
                                        color: Palette.whiteText,
                                        fontSize: 15,
                                      ),),
                                  ),
                                ),
                              ]
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                              children:[
                                Container(
                                  margin: EdgeInsets.only(right: (width/208) * 3 ),
                                  width: (width/208) *30,
                                  height:  (width/208) * 30,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Palette.greyBox
                                  ),
                                    child: Icon(Icons.menu,
                                      size: 25,
                                      color: Palette.pinkBox,
                                    )
                                ),
                                Center(
                                  child: Container(
                                    margin: EdgeInsets.only(top: 5),
                                    child: Text("Haircut",
                                      style: TextStyle(
                                        color: Palette.whiteText,
                                        fontSize: 15,
                                      ),),
                                  ),
                                ),
                              ]
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                              children:[
                                Container(
                                  margin: EdgeInsets.only(right: (width/208) * 3 ),
                                  width: (width/208) *30,
                                  height:  (width/208) * 30,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Palette.greyBox
                                  ),
                                    child: Icon(Icons.menu,
                                      size: 25,
                                      color: Palette.pinkBox,
                                    )
                                ),
                                Center(
                                  child: Container(
                                    margin: EdgeInsets.only(top: 5),
                                    child: Text("HairDry",
                                      style: TextStyle(
                                        color: Palette.whiteText,
                                        fontSize: 15,
                                      ),),
                                  ),
                                ),
                              ]
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                              children:[
                                Container(
                                  margin: EdgeInsets.only(right: (width/208) * 3 ),
                                  width: (width/208) *30,
                                  height:  (width/208) * 30,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Palette.greyBox
                                  ),
                                    child: Icon(Icons.menu,
                                      size: 25,
                                      color: Palette.pinkBox,
                                    )
                                ),
                                Center(
                                  child: Container(
                                    margin: EdgeInsets.only(top: 5),
                                    child: Text("Others",
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Palette.whiteText,
                                      ),),
                                  ),
                                ),
                              ]
                          ),
                        ),
                       ]
                    ),
                ),
              ),
              Positioned(
                top: (height/449) * 185,
                width: width,
                child:Center(
                  child:Container(
                    width : width,
                    height: height * 1.2 ,
                     child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: 10,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                              child: listItem(index),
                            onTap:(){
                              showAlertDialog(context,"Anu", "Des");
                            }
                          );
                        }
                     ),
                  )
                ),
              ),
            ]
          )
    );
  }

  listItem(int index){
    return Container(
        width: width,
        decoration: BoxDecoration(
          color: Palette.lightPink,
          borderRadius: BorderRadius.all(Radius.circular(18)),
        ),
        margin: EdgeInsets.only(right: (width/208) * 10, left: (width/208) * 10 , bottom: (width/208) * 8),
        height:  (height/449) * 45,
      child: Row(
        children: [
          Container(
            width:  (width/208) * 47,
            decoration: BoxDecoration(
              color: Palette.pinkBox,
              borderRadius: BorderRadius.all(Radius.circular(18)),
            image: new DecorationImage(
            image: new AssetImage("assets/background.png"),
            fit: BoxFit.fill,
            )
           ),
          ),
          Container(
            padding: EdgeInsets.only(left:  (width/208) * 10, top:  (height/449) * 5 ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                child:Text("The Salon",
                style: TextStyle(
                    fontSize: 18,
                    color:  Palette.pinkText,
                    fontWeight: FontWeight.w900,
                    fontFamily: "Audrey-Normal"
                ),),
                  ),
                Container(
                  child:Text("- Salon",
                  style: TextStyle(
                      fontSize: 15,
                      color:  Palette.pinkText,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Audrey-Normal"
                  ),),
                  ),
                Container(
                  child: Row(
                    children: [
                      Container(
                        width: (width/208) * 40,
                        child:
                          Text("Riyadh",
                          style: TextStyle(
                          fontSize: 18,
                          color:  Palette.pinkText,
                          fontWeight: FontWeight.w600,
                          fontFamily: "Audrey-Normal"
                          ),
                          ),
                      ),
                      Container(
                        width: (width/208) * 12,
                        child:
                        Text("5",
                          style: TextStyle(
                              fontSize: 18,
                              color:  Palette.pinkText,
                              fontWeight: FontWeight.w600,
                              fontFamily: "Audrey-Normal"
                          ),
                        ),
                    ),
                       Container(
                          child:  RatingBar.builder(
                            initialRating: 3,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemSize: width / 25,
                            unratedColor: Palette.starColor,
                            itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.yellow,
                            ),
                            onRatingUpdate: (rating) {
                              print(rating);
                            },
                          ),
                        ),
                    ],


          ),
                ),
        ],
    )
      )
    ]
      )


    );

  }

  showAlertDialog(BuildContext context, String title, String description) {
    // set up the buttons

    Widget continueButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        setState(() {
          Navigator.pop(context);
          Navigator.pop(context);
        });
      },
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
         return Center(
          child:  Container(
            margin: EdgeInsets.only(left: 25, right: 25,top:height/7),
            height: height/2.5,
            width: width,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(30),
              color: Palette.blurColor,
            ),
            child: Column(
              children: [
                Container(
                  width: (width/208) * 40,
                  height: (width/208) * 40,
                  child: Image.asset("assets/artboard_pink.png"),
                ),
                Center(
                  child: Container(
                   margin: EdgeInsets.only( left: 15, right: 15),
                    child: Text("How it was your reservation with violate!",
                      maxLines: 1,
                      style: TextStyle(
                        decoration: TextDecoration.none,
                        letterSpacing: 0.01,
                        fontSize: 16,
                        color: Palette.pinkBox,
                    ),),
                  )
                ),
                Container(
                  margin: EdgeInsets.only( top: 15),
                  child:  RatingBar.builder(
                    initialRating: 3,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemSize: width / 20,
                    unratedColor: Palette.starColor,
                    itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.yellow,
                    ),
                    onRatingUpdate: (rating) {
                      print(rating);
                    },
                  ),
                ),
                Center(
                    child: Container(
                      margin: EdgeInsets.only( left: 15, right: 15, top: (width/208) * 10),
                      child: Text("Tell us how we can improve violate?",
                        maxLines: 1,
                        style: TextStyle(
                          decoration: TextDecoration.none,
                          letterSpacing: 0.01,
                          fontSize: 18,
                          color: Palette.pinkBox,
                        ),),
                    )
                ),
                Center(
                    child: Container(
                      width:width,
                      height: (width/208) * 44,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Palette.whiteText,
                      ),
                      margin: EdgeInsets.only( left: 15, right: 15, top: (width/208) * 8),
                      // child: TextField()
                    )
                ),
              ],
             ),
        )
        );
      },
    );
  }
}