
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:violet_app/network/repository.dart';
import 'package:violet_app/network/shared.dart';
import 'package:violet_app/style/palette.dart';
import 'package:page_transition/page_transition.dart';
import 'package:violet_app/style/local.keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:violet_app/utils/network_check.dart';

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
  bool isLoading = true;
  int selectOrder;
  bool clickOrder = false;
  String lngCode = "en";
  String customerId;
  String token;
  List responseList;
  final Dio _dio = Dio();

  @override
  void initState() {
    super.initState();
    checkDataSet();
  }

  checkDataSet() async {
    lngCode = await SharedPreferencesHelper.getLanguage();
    token = await SharedPreferencesHelper.getToken();
    customerId = await SharedPreferencesHelper.getCustomerID();

    if(customerId != null) {
      getOrders();
    }else{
      setState(() {
        isLoading = false;
      });
    }
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
                        fontSize: (height/896) *28,
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
                child: isLoading ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: (height/896) *25.0,
                          width: (height/896) *25.0,
                          child: CircularProgressIndicator(
                            valueColor: new AlwaysStoppedAnimation<Color>(Palette.pinkBox),
                            strokeWidth: 4.0,
                          ),
                        )
                      ],
                    )):
                ( responseList== null || responseList.length == 0?
                Container(
                  alignment: Alignment.center,
                  height: height,
                  width: width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                       child: Image.asset("assets/empty_box.png",
                         height: (height/896) * 300,
                       ),
                      ),
                      Text(LocaleKeys.there_no_reservation,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Palette.pinkBox,
                        height: 2,
                        fontSize: (height/896) *16,
                      ),).tr(),
                      Text(LocaleKeys.enjoying_your_Time,
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Palette.darkPink,
                          height: 2,
                          fontSize: (height/896) *14,
                        ),).tr(),
                      GestureDetector(
                        onTap: (){
                          Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.fade,
                                child:  BottomNav(index: 0, subIndex: 0),
                              ));
                        },
                        child: Container(
                        margin:  EdgeInsets.only(top:  (height/896) * 15),
                        alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Palette.pinkBox,
                          ),
                        height: (height/896) * 45,
                        width: (width/414) * 156,
                        child: Center(
                          child: Text(LocaleKeys.reserve_now,
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Palette.whiteText,
                            fontSize: (height/896) *16,
                          ),).tr(),
                        ),
                      ),
                      ),

                    ],
                  )
                ):
                ListView.builder(
                    padding: EdgeInsets.zero,
                    scrollDirection: Axis.vertical,
                    itemCount: responseList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                          child: listItem(index),
                          onTap:(){
                            setState(() {
                              clickOrder = true;
                              slideSheet(index);
                              selectOrder = index;
                            });
                          }
                      );
                    }
                )
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
          ]
      ),
    );
  }

  void slideSheet(int index) {
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
                          fontSize: (height/896) *25,
                          fontWeight: FontWeight.normal,
                          fontFamily: "Audrey-Normal",
                        ),),
                      SizedBox(
                        height: (height/896) *35,
                      ),
                      Text(timeFormatter(responseList[index]['start_time']),
                        style: TextStyle(
                          color: Palette.darkPink,
                          fontSize: (height/896) *20,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Audrey-Normal",
                        ),),
                      SizedBox(
                        height: (height/896) *15,
                      ),
                      Text("HAIR CUT",
                        style: TextStyle(
                          color: Palette.darkPink,
                          fontSize: (height/896) *20,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Audrey-Normal",
                        ),),
                      SizedBox(
                        height: (height/896) * 12,
                      ),
                      Text("100 SAR",
                        style: TextStyle(
                          color: Palette.darkPink,
                          fontSize:(height/896) * 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Audrey-Normal",
                        ),),
                      SizedBox(
                        height: (height/896) *12,
                      ),
                      Text("HAIR CUT",
                        style: TextStyle(
                          color: Palette.darkPink,
                          fontSize: (height/896) *20,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Audrey-Normal",
                        ),),
                      SizedBox(
                        height: (height/896) *12,
                      ),
                      Text("500 SAR",
                        style: TextStyle(
                          color: Palette.darkPink,
                          fontSize: (height/896) *20,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Audrey-Normal",
                        ),),
                      SizedBox(
                        height: (height/896) *15,
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

  Future<bool> getOrders() async {
    Options options = Options(headers: {"Accept-Language": lngCode});
    bool networkResults = await NetworkCheck.checkNetwork();
    String url = Repository.reservationByCustomerId+customerId;
    if (networkResults) {
      try {
        Response response = await _dio.get(url,
            options: options);
        if (response.statusCode == 200) {
          final item = response.data['data'];
          responseList = item;

          setState(() {
            isLoading = false;
          });

        } else {
          responseList = [];
          showAlert(context, "Something went wrong!");
        }
      } catch (e) {
        responseList = [];
        showAlert(context, "Something went wrong!");
      }
    }else{
      responseList = [];
      showAlert(context, "No Internet!");

    }
    setState(() {
      isLoading = false;
    });
  }


  showAlert(BuildContext context, String msg) {

    showDialog(
        context: context,
        barrierDismissible: true,
        barrierColor: Color.fromRGBO(112, 112, 112, 0.67),
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(25)), //this right here
            child: Container(

              // alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(12),
                color: Palette.whiteText,
              ),
              width: (width/414) * 347,
              child: Padding(
                  padding: const EdgeInsets.all(0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                          child: Container(
                            margin: EdgeInsets.only( top: (height/896) *25,left: (width/414) * 18, right:  (width/414) * 18),
                            child: Text(msg,
                              style: TextStyle(
                                fontSize: (height/896) *22,
                                color: Palette.pinkBox,
                              ),).tr(),
                          )
                      ),
                      GestureDetector(
                          child: Container(
                            alignment: Alignment.centerRight,
                            margin: EdgeInsets.only( top: (height/896) * 50, bottom: (height/896) * 35,left: (width/414) * 18,  right:  (width/414) * 40),
                            child: Text(LocaleKeys.ok,
                              style: TextStyle(
                                fontSize: (height/896) *16,
                                color: Palette.labelColor,
                              ),).tr(),
                          ),
                          onTap: () {
                            setState(() {
                              isLoading = false;
                            });
                            Navigator.pop(context);
                          }
                      )
                    ],
                  )
              ),
            ),
          );
        });
  }

  timeFormatter(String date) {

    var inputFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
    var inputDate = inputFormat.parse(date);

    String formattedDate = DateFormat('d MMM yyyy').format(inputDate);

      return formattedDate;

    }


  listItem(int index){
    return Container(
      height: (height/896) * 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(left: (width/414) * 25, right: (width/414) * 25),
            child: Text(timeFormatter(responseList[index]['start_time']),
              style: TextStyle(
                color: Palette.darkPink,
                fontSize: (height/896) *15,
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
                          Image.asset("assets/background.png",
                          height:  (height/896) * 30,
                          width:(width/414) * 30,),
                          Text("FOUR\nSPA",
                            style: TextStyle(
                              fontSize: (height/896) *12,
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
                            text: responseList[index]['customer_comment'] != null ? "${responseList[index]['customer_comment']}\n":"",
                            style: TextStyle(
                                fontSize: (height/896) *14,
                                color:  selectOrder == index ? Palette.whiteText :Palette.pinkBox),
                            children: <TextSpan>[
                              TextSpan(text: responseList[index]['net_total'] +' SR',
                                style: TextStyle(
                                    fontSize: (height/896) *17,
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
                                fontSize: (height/896) * 13,
                                color:  selectOrder == index ? Palette.whiteText :Palette.pinkBox,
                              ),),
                          ),
                          GestureDetector(
                              child: Container(
                              alignment: Alignment.bottomCenter,
                              height: (height/896) * 60,
                              child: Icon(Icons.refresh,
                                color:  selectOrder == index ? Palette.whiteText :Palette.pinkBox,
                                size: (height/896) *20,)
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