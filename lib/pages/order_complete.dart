import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:page_transition/page_transition.dart';
import 'package:violet_app/network/repository.dart';
import 'package:violet_app/network/shared.dart';
import 'package:violet_app/pages/update_profile.dart';
import 'package:violet_app/style/palette.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:violet_app/style/local.keys.dart';
import 'package:violet_app/utils/network_check.dart';

import 'bottom_nav.dart';
import 'home.dart';

class OrderComplete extends StatefulWidget {

  OrderComplete({Key key}) : super(key: key);

  @override
  _OrderComplete createState() => _OrderComplete();
}

class _OrderComplete extends State<OrderComplete> {

  double height, width;
  AlertDialog alert;
  final messageController = TextEditingController();
  final feedController = TextEditingController();
  bool isInfo = false;
  final Dio _dio = Dio();
  String lngCode = "en";
  String token, reservationID;
  bool isSubmit = false;
  double rate =0.0;


  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async{
    lngCode = await SharedPreferencesHelper.getLanguage();
    token = await SharedPreferencesHelper.getToken();
    reservationID = await SharedPreferencesHelper.getReservationID();
  }

  @override
  void dispose() {
    super.dispose();
    messageController.dispose();
    feedController.dispose();
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
            // Container(
            //     height: height,
            //     width: width,
            //     decoration: BoxDecoration(
            //         shape: BoxShape.rectangle,
            //         image: new DecorationImage(
            //             image: new AssetImage("assets/curve_back.png"),
            //             fit:  BoxFit. fill
            //         )
            //     )
            // ),
            Positioned(
              top: (height/896) * 0,
              left: (width/414) * 0,
              child:  Container(
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
              top: (height/896) * 65,
              left: (width/414) * 16,
              child: GestureDetector(
                child: Center(
                  child: Container(
                    height: (height/896) * 15,
                    width: (width/414) * 10,
                    child: Image.asset("assets/back.png"),
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
              top: (height/896) * 142,
              left: (width/414) * 20,
              right: (width/414) * 20,
              child:
              Center(
                child: Container(
                  padding: EdgeInsets.only(top: (height/896) * 20, right: (height/896) * 10, left: (width/414) * 10),
                  height: (height/896) * 660,
                  width: width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: Color.fromRGBO(168, 132, 153, 0.2),
                  ),
                  child:  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(LocaleKeys.your_order_is_completed,
                        style: TextStyle(
                          fontSize: (height/896) *28,
                          fontFamily: lngCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
                          color: Palette.pinkBox,
                        ),).tr(),
                        Container(
                          margin: EdgeInsets.only(top: (height/896) * 20, right: (height/896) * 15, left: (width/414) * 15),
                          height: (height/896) * 230,
                          width: width,
                            decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            color: Colors.white,
                            ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: (height/896) * 40, right: (height/896) * 20, left: (width/414) * 20),
                          height: (height/896) * 230,
                          width: width,
                          child:RichText(
                            text: TextSpan(
                              text: 'Order number:\n',
                              style: TextStyle(
                                  fontSize: (height/896) *20,
                                  fontFamily: lngCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
                                  height: (height/896) * 1.5,
                                  color: Palette.textGrey),
                              children: <TextSpan>[
                                TextSpan(text: ' #2133\n',
                                  style: TextStyle(
                                      fontSize: (height/896) *17,
                                      height: (height/896) *1.2,
                                      fontFamily: lngCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
                                      color: Palette.pinkBox),),
                                TextSpan(text: 'Date and Time\n',
                                  style: TextStyle(
                                      fontSize: (height/896) *20,
                                      fontFamily: lngCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
                                      height: (height/896) *3,
                                      color: Palette.textGrey),),
                                TextSpan(text: ' 19 January, 1:12\n',
                                style: TextStyle(
                                    fontSize: (height/896) *17,
                                    height: (height/896) *1,
                                    fontFamily: lngCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
                                    color: Palette.pinkBox),
                              ),
                                TextSpan(text: 'Order\n',
                                  style: TextStyle(
                                      fontSize: (height/896) *20,
                                      height: (height/896) *3,
                                      fontFamily: lngCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
                                      color: Palette.textGrey),),
                                TextSpan(text: ' HAIR COLOR           100SAR\n',
                                  style: TextStyle(
                                      fontSize: (height/896) *17,
                                      fontFamily: lngCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
                                      height: (height/896) *1.3,
                                      color: Palette.pinkBox),
                                ),
                                TextSpan(text: ' HAIR CUT                500SAR\n',
                                  style: TextStyle(
                                      fontSize: (height/896) *17,
                                      fontFamily: lngCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
                                      height: (height/896) *1.3,
                                      color: Palette.pinkBox),
                                ),

                              ],
                            ),
                          )
                        ),
                      ],
                    )
                  )
                ),
              ),
            ),
            Positioned(
              top: (height/896) * 0,
              left: (width/414) * 0,
              child:  Container(
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
            ),
            Positioned(
              top: (height/896) * 510,
              left: (width/414) * 230,
              child:  Center(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Color.fromRGBO(247, 127, 151, 0.18),
                  ),
                  height: (height/896) * 108,
                  width: (height/896) * 108,
                  child: Center(
                    child:
                        Image.asset("assets/cart.png",
                        ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: (height/896) * 134,
              left: (width/414) * 378,
              child: GestureDetector(
                child: Container(
                  height: (height/896) * 20,
                  width: (height/896) * 20,
                  child: Center(
                    child:
                    Image.asset("assets/close.png",
                    ),
                  ),
                ),
                onTap: (){
                  showFeedback(context);
                },
              ),
            ),
          ]
      ),
    );
  }

  showFeedback(BuildContext context) {

    showDialog(
        context: context,
        barrierDismissible: true,
        barrierColor: Palette.blur,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(20.0)), //this right here
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(30),
                color: Palette.blurColor,
              ),
              // height: height/2.2,
              child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                     GestureDetector(
                       child:
                      Container(
                        alignment: Alignment.topRight,
                        margin: EdgeInsets.only( top: (height/896) *0,  ),
                        child: Icon(Icons.close,
                        color: Palette.pinkBox,
                        size:  (height/896) * 25,)
                      ),
                       onTap: (){
                         Navigator.pop(context);
                         // Navigator.push(
                         //     context,
                         //     PageTransition(
                         //       type: PageTransitionType.fade,
                         //       child:  BottomNav(index: 0, subIndex: 0),
                         //     ));
                       },
                     ),Container(
                        margin: EdgeInsets.only( top: (height/896) *1),
                        child: Image.asset("assets/pink_art.png"),
                      ),
                      Center(
                          child: Container(
                            margin: EdgeInsets.only( top: (height/896) *14, left: 15, right: 15),
                            child: Text(LocaleKeys.how_it_was,
                              maxLines: 1,
                              style: TextStyle(
                                decoration: TextDecoration.none,
                                fontFamily: lngCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
                                letterSpacing: 0.01,
                                fontSize: (height/896) *16,
                                color: Palette.pinkBox,
                              ),).tr(),
                          )
                      ),
                      Container(
                        margin: EdgeInsets.only( top: (height/896) *14),
                        child:  RatingBar.builder(
                          initialRating: rate,
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
                            rate = rating;
                            print(rating);
                          },
                        ),
                      ),
                      Center(
                          child: Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.only( left: (width/414) * 15, right:(width/414) * 15, top:  (height/896) *30),
                            child: Text(LocaleKeys.tell_us,
                              maxLines: 1,
                              style: TextStyle(
                                decoration: TextDecoration.none,
                                fontFamily: lngCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
                                letterSpacing: 0.01,
                                fontSize: (height/896) *18,
                                color: Palette.pinkBox,
                              ),).tr(),
                          )
                      ),
                      Center(
                          child: Container(
                              padding: EdgeInsets.only( left: (width/414) * 15, right: (width/414) * 15, top:  (height/896) *2),
                              width:width,
                              height:  (height/896) *110,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Palette.whiteText,
                              ),
                              margin: EdgeInsets.only( left:(width/414) * 15, right: (width/414) * 15, top:  (height/896) *30),
                              child: TextFormField(
                                controller: feedController,
                                maxLines: 3,
                                style: TextStyle(
                                    decoration: TextDecoration.none,
                                    fontFamily: lngCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
                                    fontSize: (height/896) *14,
                                    color: Palette.mainColor
                                ),
                                autofocus: false,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: LocaleKeys.write_your_message_here.tr(),
                                    hintStyle: TextStyle(
                                        decoration: TextDecoration.none,
                                        fontFamily: lngCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
                                        fontSize: (height/896) *14,
                                        color: Palette.greyText
                                    )
                                ),
                              )
                            // child: TextField()
                          )
                      ),
                      SizedBox(
                        height: (width/414) * 15,
                      ),
                      Center(
                        child :
                       GestureDetector(
                         child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(12)),
                              color: Palette.pinkBox,
                            ),
                          width:  (width/414) * 85,
                          height: (height/896) * 45,
                          child: Center(
                            child: isSubmit ?
                            CircularProgressIndicator(
                              valueColor: new AlwaysStoppedAnimation<Color>(Palette.whiteText),
                              strokeWidth: 4.0,
                            ):
                            Text(LocaleKeys.submit,
                            style: TextStyle(
                              fontSize: (height/896) *18,
                              fontWeight: FontWeight.w400,
                                fontFamily: lngCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
                              color: Palette.whiteText
                            ),
                          ),
                          ),
                        ),
                       onTap:(){
                           if(feedController.text == null){
                             showAlert(context, LocaleKeys.comment_req);
                           }else if(rate == 0.0){
                             showAlert(context, LocaleKeys.rating_req);
                           }else {
                             sendFeedBack();
                             setState(() {
                               isSubmit = true;
                             });
                           }
                       }
                       ),
                      ),

                    ],
                  )
              ),
            ),
          );
        });
  }

  Future<bool> sendFeedBack() async {
    bool networkResults = await NetworkCheck.checkNetwork();
    var params = {'customer_comment': "feedController.text.toString()",
                  'rating': "rate.toString()"};
      Options options = Options(headers: {"Accept-Language": lngCode,
      'Authorization' : "Bearer "+token});
    if (networkResults) {
      try {
        Response response = await _dio.post(
            Repository.feedBack + reservationID,
            data: params,
            options: options);
        print("response.statusCode ${response.statusCode}");
        if (response.statusCode == 200) {
          final item = response.data['data'];

          print("item $item");
          Navigator.pop(context);

        } else {
          Navigator.pop(context);
          showAlert(context, LocaleKeys.something_wrong);
        }
      } catch (e) {
        print("e $e");
        Navigator.pop(context);
        showAlert(context, LocaleKeys.something_wrong);
      }
      setState(() {
        isSubmit = false;
      });
      return true;
    }else{
      Navigator.pop(context);
      showAlert(context, LocaleKeys.no_internet);
      setState(() {
        isSubmit = false;
      });
    }
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
                                fontSize:  (height/896) *22,
                                fontFamily: lngCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
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
                                fontSize:  (height/896) *16,
                                fontFamily: lngCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
                                color: Palette.labelColor,
                              ),).tr(),
                          ),
                          onTap: () {
                            // setState(() {
                            //   loading = false;
                            // });
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


}
