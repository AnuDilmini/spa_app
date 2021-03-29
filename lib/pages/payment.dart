
import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:violet_app/enums/connectivity_status.dart';
import 'package:violet_app/network/repository.dart';
import 'package:violet_app/network/shared.dart';
import 'package:violet_app/pages/update_profile.dart';
import 'package:violet_app/style/palette.dart';
import 'package:violet_app/utils/network_check.dart';
import 'package:violet_app/utils/validator.dart';
import 'package:page_transition/page_transition.dart';
import 'package:violet_app/style/local.keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import 'bottom_nav.dart';

class Payment extends StatefulWidget {

  Payment({Key key}) : super(key: key);

  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {

  double height, width;
  AlertDialog alert;
  final messageController = TextEditingController();
  final otpController = TextEditingController();
  bool isCheckout = false;
  bool isSelect = false;
  bool isAgree = false;
  var connectionStatus;
  String pin ;
  bool pinCorrect = false;
  final mobileController = TextEditingController();
  final mobileRegController = TextEditingController();
  bool isCompleteApi = false;

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();

  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      border: Border.all(color: Palette.textField),
      borderRadius: BorderRadius.circular(12.0),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    mobileController.dispose();
    mobileRegController.dispose();
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
    connectionStatus = Provider.of<ConnectivityStatus>(context);

    return Scaffold(
       key: _scaffoldKey,
        body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: height* 1.0,
            ),
            Positioned(
              top: (height/896) * 42,
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
              left: (width/414) * 20,
              child:GestureDetector(
                 child: Center(
                  child: Container(

                    child: Icon(Icons.arrow_back_ios,
                    color: Palette.pinkBox,
                    size: 20,),
                  ),
              ),
                onTap: (){

                  FocusScope.of(context).requestFocus(new FocusNode());
                  Navigator.pop(context);

                },
              ),
            ),
            Positioned(
              top: (height/896) * 102,
              left: (width/414) *20,
              right: (width/414) *20,
              child:  Center(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Color.fromRGBO(247, 127, 151, 0.18),
                  ),
                  height: (height/896) * 113,
                  width: width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                      children:[
                        Image.asset("assets/cart.png",
                          height: (height/896) * 45,
                          width: (width/414) * 27,),
                        Text("FOUR\n SPA",
                          style: TextStyle(
                            fontSize: 11,
                            color: Color.fromRGBO(247, 127, 151, 1),
                          ),),
                      ]
                  ),
                ),
              ),
            ),
            Positioned(
              top: (height/896) * 221,
              left: (width/414) *20,
              right: (width/414) *20,
              child:  Center(
                child: Container(
                  padding: EdgeInsets.only(left: (width/414) * 15, right: (width/414) * 15,top: (height/896) * 12 ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color.fromRGBO(231, 223, 225, 0.81),
                  ),
                  height: (height/896) * 260,
                  width: width,
                  child:Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(bottom: (height/896) * 5 ),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(width: 2, color: Palette.pinkBox ),
                          ),
                        ),
                        height: (height/896) * 125,
                        child:ListView.builder(
                            padding: EdgeInsets.zero,
                            scrollDirection: Axis.vertical,
                            itemCount:20,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                  child: listItem(index),
                                  onTap:(){

                                    showLoginDialog(context);

                                  }
                              );
                            }
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: (width/414) * 5, right: (width/414) * 5, top: (height/896) * 8),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                            child: Text(
                              LocaleKeys.delivery_charge,
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Palette.pinkBox
                              ),
                            ).tr()
                            ),
                            Expanded(
                                flex: 1,
                                child: Text(
                                  "1150 SAR",
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Palette.pinkBox
                                  ),
                                )
                            ),
                          ],
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(left: (width/414) * 5, right: (width/414) * 5, top: (height/896) * 2),
                        child: Row(
                          children: [
                            Expanded(
                                flex: 3,
                                child: Text(
                                  LocaleKeys.total,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Palette.pinkBox
                                  ),
                                ).tr()
                            ),
                            Expanded(
                                flex: 1,
                                child:  Text(
                                  "1800 SAR",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Palette.pinkBox
                                  ),
                                )
                            ),
                          ],
                        ),
                      ),
                      Container(
                        alignment: Alignment.bottomLeft,
                        padding: EdgeInsets.only(left: (width/414) * 5, right: (width/414) * 5, top: (height/896) * 5),
                        child:   RichText(
                          text: TextSpan(
                            text: '* (Include',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Palette.textGrey),
                            children: <TextSpan>[
                              TextSpan(text: ' VAT',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Palette.textGrey),),
                              TextSpan(text: ' 15.0 %)',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Palette.textGrey),),
                            ],
                          ),
                        )
                      ),
                    ],
                  )
                ),
              ),
            ),
            Positioned(
              top: (height/896) * 488,
              left: (width/414) *20,
              right: (width/414) *20,
              child:  GestureDetector(
              child: Center(
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Color.fromRGBO(231, 223, 225, 0.81),
                  ),
                  height: (height/896) * 65,
                  width: width,
                  child: Text(
                    LocaleKeys.add_comment,
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w400,
                        color: Palette.pinkBox
                    ),
                  ).tr(),
                ),
              ),
                onTap: (){
                  showComment(context);
                },
              ),
            ),
            Positioned(
              top: (height/896) * 562,
              left: (width/414) *20,
              right: (width/414) *20,
              child:  Center(
                child: Container(
                  padding: EdgeInsets.only(left: (width/414) * 15, right: (width/414) * 15,top: (height/896) * 2 ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color.fromRGBO(231, 223, 225, 0.81),
                  ),
                  height: (height/896) * 173,
                  width: width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                     Text(
                        LocaleKeys.payment,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                            color: Palette.pinkBox
                        ),
                      ).tr(),
                  Container(
                    margin: EdgeInsets.only(top: (height/896) * 5 ),
                    height: (height/896) * 130,
                    child: ListView.builder(
                        padding: EdgeInsets.zero,
                          scrollDirection: Axis.vertical,
                          itemCount:3,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                                child: listPayment(index),
                                onTap:(){

                                }
                            );
                          }
                      ),
                  ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: (height/896) * 790,
              left: (width/414) *20,
              right: (width/414) *20,
              child:  GestureDetector(
               child: Center(
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Palette.pinkBox,
                    width: 1),
                    color: isAgree ? Palette.pinkBox: Colors.transparent,
                  ),
                  height: (height/896) * 50,
                  width: width,
                  child: Text(LocaleKeys.slied_to_checkout,
                      style: TextStyle(
                        fontSize: 19,
                        color: isAgree ? Palette.whiteText : Palette.pinkBox,
                      ),
                    ).tr(),
                ),
               ),
                onTap: (){

                  Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.fade,
                        child:  BottomNav(index: 0, subIndex:3),
                      ));
                },
              ),
            ),
            Positioned(
            top: (height/896) * 737,
            left: (width/414) *32,
            child: GestureDetector(
             child: Container(
              height: (height/896) * 25,
              width: (height/896) * 25,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Palette.pinkBox,
                    width: 6),
                color: isAgree ? Colors.transparent :  Palette.pinkBox,
              ),
              ),
              onTap: (){
               setState(() {
                 isAgree = !isAgree;
               });
              },
            )
            ),
            Positioned(
                top: (height/896) * 738,
                left: (width/414) * 65,
                right: (width/414) * 20,
                child: GestureDetector(
                  child: Container(
                    alignment: Alignment.centerLeft,
                 child: Text(
                   LocaleKeys.i_agree,
                   style: TextStyle(
                     fontSize: 16,
                     letterSpacing: 2,
                     color:  Palette.pinkBox,
                   ),
                 ).tr(),
                  ),
                  onTap: (){
                    setState(() {
                      isAgree = !isAgree;
                    });
                  },
                )
            ),
    ]
      ),
        ),
    );
  }

  listItem(int index){
    return Container(
      height: (height/896) * 57,
      width: width,
      // margin: EdgeInsets.only(bottom: (height/896) * 1),
      child: Stack(
        children: [
          Positioned(
            top: (height/896) * 4,
            left: (width/414) * 1,
            child: Container(
                height: (height/896) * 49,
                width:(width/414) * 60,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.black54,
                    shape: BoxShape.rectangle,
                    image: new DecorationImage(
                      image: new AssetImage("assets/ipay.png"),
                    )
                )
            ),
          ),
          Positioned(
              top: (height/896) * 8,
              left: (width/414) * 75,
              width: (width/414) * 170,
              child: RichText(
                text: TextSpan(
                  text: 'Eyelashes fullset\n',
                  style: TextStyle(
                      fontSize: 18,
                      color: Palette.pinkBox),
                  children: <TextSpan>[
                    TextSpan(text: '120 min - 1026 SR',
                      style: TextStyle(
                          fontSize: 12,
                          color: Palette.labelColor),),
                  ],
                ),
              )
          ),
          Positioned(
            top: (height/896) * 18,
            left: (width/414) *  310,
            child: GestureDetector(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Palette.pinkBox,
                ),
                height: (height/896) * 26,
                width: (height/896) * 26,
                child: Center(
                    child: Icon(Icons.close,
                      color: Palette.boxWhite,
                      size: 17,)
                ),
              ),
              onTap: (){

              },
            ),
          )
        ],
      ),
    );
  }

  listPayment(int index){
    return Container(
      height: (height/896) * 40,
      width: width,
      padding: EdgeInsets.only(bottom: (height/896) * 1),
      child: Stack(
        children: [
          Positioned(
            top: (height/896) * 4,
            left: (width/414) * 1,
            child: Container(
                height: (height/896) * 26,
                width:(width/414) * 45,
                decoration: BoxDecoration(
                    color: Palette.whiteText,
                    borderRadius: BorderRadius.circular(8),
                    shape: BoxShape.rectangle,
                    image: new DecorationImage(
                      image: index == 0 ? new AssetImage("assets/master.png") :
                      (index == 1 ?new AssetImage("assets/ipay.png"): new AssetImage("assets/cash.png")
                      ),
                    )
                )
            ),
          ),
          Positioned(
              top: (height/896) * 8,
              left: (width/414) * 75,
              width: (width/414) * 170,
              child:Text(
                   'Eyelashes fullset\n',
                  style: TextStyle(
                      fontSize: 16,
                      color: Palette.balckColor),
                ),
              ),
          Positioned(
            top: (height/896) * 12,
            left: (width/414) *  310,
            child: GestureDetector(
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: isSelect ? Palette.pinkBox : Color.fromRGBO(168, 132, 153, 0.50),
                ),
                height: (height/896) * 25,
                width: (height/896) * 30,
                child: Center(
                    child: Icon(Icons.check,
                      color: Palette.boxWhite,
                      size: 20,)
                ),
              ),
              onTap: (){
                setState(() {
                  isSelect = !isSelect;
                });

              },
            ),
          )
        ],
      ),
    );
  }

  showComment(BuildContext context) {

    showDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Color.fromRGBO(201, 200, 200, 0.49),
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(12)), //this right here
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(12),
                color: Color.fromRGBO(247, 243, 240, 1),
              ),
              height: (height/896) * 310,
              child: Padding(
                  padding: const EdgeInsets.all(0),
                  child: Column(
                    children: [
                      GestureDetector(
                  child: Container(
                        alignment: Alignment.topRight,
                        margin: EdgeInsets.only( left: (width/414) *325),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Palette.pinkBox,
                        ),
                        width: width,
                        height: (height/896) * 25,
                        child: Center(
                            child: Icon(Icons.close,
                              color: Palette.boxWhite,
                              size: 20,)
                        ),
                      ),
                        onTap: (){
                          FocusScope.of(context).requestFocus(new FocusNode());
                          Navigator.pop(context);
                        },
                      ),
                      Center(
                          child: Container(
                            margin: EdgeInsets.only( top: (height/896) *4, left: 15, right: 15),
                            child: Text(LocaleKeys.add_comment,
                              style: TextStyle(
                                decoration: TextDecoration.none,
                                letterSpacing: 0.01,
                                fontSize: 23,
                                color: Palette.pinkBox,
                              ),).tr(),
                          )
                      ),

                      Center(
                          child: Container(
                              padding: EdgeInsets.only( left: (width/414) * 10, right: (width/414) * 20, top:  (height/896) * 20),
                              width:width,
                              height:  (height/896) *191,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Palette.whiteText,
                              ),
                              margin: EdgeInsets.only( left: (width/414) * 20, right:(width/414) * 20, top:  (height/896) *15),
                              child: TextFormField(
                                maxLines: 3,
                                style: TextStyle(
                                    decoration: TextDecoration.none,
                                    fontSize: 18,
                                    color: Palette.mainColor
                                ),
                                autofocus: false,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "${LocaleKeys.write_your_message_here}..".tr(),
                                    hintStyle: TextStyle(
                                        decoration: TextDecoration.none,
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal,
                                        color: Palette.greyText
                                    )
                                ),
                              )
                            // child: TextField()
                          )
                      ),
                    ],
                  )
              ),
            ),
          );
        });
  }

  showRegisterDialog(BuildContext context) {

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
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(25),
                color: Palette.whiteText,
              ),
              // height: (height/896) * 456,
              width: (width/414) * 347,
              child: Padding(
                  padding: const EdgeInsets.all(0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                          child: Container(
                            margin: EdgeInsets.only( top: (height/896) *25),
                            child: Text(LocaleKeys.register_to_violet,
                              style: TextStyle(
                                 fontSize: 26,
                                color: Palette.pinkBox,
                              ),).tr(),
                          )
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only( top: (height/896) *15, left: (width/414) * 18),
                        child: Text(LocaleKeys.we_just_need,
                          style: TextStyle(
                            fontSize: 18,
                            color: Palette.labelColor,
                          ),).tr(),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only( top: (height/896) *15, left: (width/414) * 18),
                        child: Text(LocaleKeys.phone_number,
                          style: TextStyle(
                            fontSize: 20,
                            color: Palette.pinkBox,
                          ),).tr(),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(12),
                          color: Palette.textField,
                        ),
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(top: (height/896) *5),
                        padding: EdgeInsets.only(left: (width/414) * 20,),
                        height: (height/896) * 57,
                        width: (width/414) * 312,
                          child: Center(
          child: TextFormField(
                            controller: mobileRegController,
                            keyboardType: TextInputType.phone,
                            maxLines: 3,
                            style: TextStyle(
                                decoration: TextDecoration.none,
                                fontSize: 18,
                                color: Palette.mainColor
                            ),
                            autofocus: false,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: LocaleKeys.phone_number.tr() ,
                                hintStyle: TextStyle(
                                    decoration: TextDecoration.none,
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal,
                                    color: Palette.pinkBox
                                )
                            ),
                          ),
                          ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(12),
                          color: Palette.textField,
                        ),
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(top: (height/896) *5),
                        height: (height/896) * 57,
                        width: (width/414) * 312,
                        child: TextFormField(
                          textAlign : TextAlign.center,
                          maxLines: 3,
                          style: TextStyle(
                              fontSize: 15,
                              color: Palette.mainColor
                          ),
                          autofocus: false,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                              hintText: LocaleKeys.your_name.tr(),
                              hintStyle: TextStyle(
                                fontSize: 15,
                                color: Color.fromRGBO(149, 152, 154, 0.38),
                              ),
                          ),
                        )
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only( top: (height/896) * 20, left: (width/414) * 18),
                        child: Text(LocaleKeys.a_digit,
                          style: TextStyle(
                            fontSize: 17,
                            color: Palette.labelColor,
                          ),).tr(),
                      ),
                      GestureDetector(
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(12),
                          color: Color.fromRGBO(112, 112, 112, 1),
                        ),
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(top: (height/896) *6),
                        height: (height/896) * 44,
                        width: (width/414) * 156,
                        child: Text(LocaleKeys.register,
                          style: TextStyle(
                            fontSize: 18,
                            color: Palette.whiteText,
                          ),).tr(),
                      ),
                        onTap: (){
                          FocusScope.of(context).requestFocus(new FocusNode());
                          validateMobile(mobileRegController.text, "register");
                        },
                      ),
                      Container(
                        alignment: Alignment.center,
                        width: width,
                        padding: EdgeInsets.only(top: (height/896) *10, left: (width/414) * 18, right: (width/414) * 18),
                         child:Center (
                          child: Row(
                          children: [
                            Expanded(
                              flex:1,
                            child: GestureDetector(
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    right: BorderSide(width: 1, color: Palette.pinkBox ),
                                  ),
                                ),
                               child: Text("${LocaleKeys.new_register_now}",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: Palette.labelColor,
                              ),).tr()
                              ),
                              onTap: (){
                                FocusScope.of(context).requestFocus(new FocusNode());
                                showLoginDialog(context);
                              }
                            ),
                            ),
                           Expanded(
                             flex:1,
                             child:
                             Container(
                               decoration: BoxDecoration(
                                 border: Border(
                                   left: BorderSide(width: 1, color: Palette.pinkBox ),
                                 ),
                               ),
                               child: Text(LocaleKeys.forget_password,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                              fontSize: 14,
                              color: Palette.labelColor,
                            ),).tr(),
                           ),
                           ),
                          ],
                        ),
                       ),
                      ),
                     GestureDetector(
                      child: Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only( top: (height/896) * 20,bottom: (height/896) * 20),
                        child: Icon(Icons.close,
                        color: Palette.pinkBox,
                        size: 20,)
                      ),
                       onTap: () {
                         FocusScope.of(context).requestFocus(new FocusNode());
                         Navigator.pop(context);
                       }
                     ),
                    ],
                  )
              ),
            ),
          );
        });
  }

  showOTPRegister(BuildContext context, String mobile, String otpReg) {

    showDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Color.fromRGBO(112, 112, 112, 0.67),
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(25)), //this right here
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(25),
                color: Palette.whiteText,
              ),
              // height: (height/896) * 456,
              width: (width/414) * 347,
              child: Padding(
                  padding: const EdgeInsets.all(0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                          child: Container(
                            margin: EdgeInsets.only( top: (height/896) *25),
                            child: Text(LocaleKeys.register_to_violet,
                              style: TextStyle(
                                fontSize: 26,
                                color: Palette.pinkBox,
                              ),).tr(),
                          )
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only( top: (height/896) * 50, left: (width/414) * 18),
                        child: Text(LocaleKeys.enter_the,
                          style: TextStyle(
                            fontSize: 16,
                            color: Palette.labelColor,
                          ),).tr(),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only( top: (height/896) *30, left: (width/414) * 18),
                        child: Text("$mobile",
                          style: TextStyle(
                            fontSize: 16,
                            color: Palette.pinkBox,
                          ),),
                      ),
                      Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(top: (height/896) *15, left:  (width/414) *35, right: (width/414) *35),
                        width: width,
                        child:  Container(
                          width: width,
                          height: (height/896) * 76,
                          child: Center(
                            child: Container(
                              child: PinPut(
                                eachFieldHeight:(height/896) * 76,
                                eachFieldWidth:(width/414) * 50,
                                fieldsCount: 4,
                                textStyle: TextStyle(
                                  fontSize: 24,
                                  color: Palette.pinkBox,
                                  fontWeight: FontWeight.normal,
                                ),
                                // onSubmit: (String pin) => _showSnackBar(pin, context),
                                onSubmit: (String str){
                                  // setState((){
                                    if(str == otpReg){
                                      print("correct *****");
                                      pinCorrect = true;
                                      pin = str;
                                      verifyOtp(context, mobile, str);
                                    }else{
                                      // _pinPutController.clear();
                                    }
                                  // });
                                },
                                focusNode: _pinPutFocusNode,
                                controller: _pinPutController,
                                submittedFieldDecoration: _pinPutDecoration.copyWith(
                                  color: Palette.textField,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Palette.textField,
                                  ),
                                ),
                                selectedFieldDecoration: _pinPutDecoration.copyWith(
                                  color:  Palette.textField,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Palette.textField,
                                  ),
                                ),
                                followingFieldDecoration: _pinPutDecoration.copyWith(
                                  color:  Palette.textField,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Palette.textField,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                       child: Container(
                        alignment: Alignment.centerLeft,
                        width: width,
                        padding: EdgeInsets.only( top: (height/896) * 25, bottom: (height/896) *40,left: (width/414) * 18),
                        child: Text(LocaleKeys.resend_otp,
                          style: TextStyle(
                            fontSize: 20,
                            color: Palette.pinkBox,
                          ),).tr(),
                         ),
                        onTap: (){
                          FocusScope.of(context).requestFocus(new FocusNode());
                          Navigator.pop(context);
                          showLoginDialog(context);
                        },
                      ),
                    ],
                  )
              ),
            ),
          );
        });
  }

  showLoginDialog(BuildContext context) {

    showDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Color.fromRGBO(112, 112, 112, 0.67),
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(25)), //this right here
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(25),
                color: Palette.whiteText,
              ),
              // height: (height/896) * 550,
              width: (width/414) * 347,
              child: Padding(
                  padding: const EdgeInsets.all(0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                          child: Container(
                            margin: EdgeInsets.only( top: (height/896) *25),
                            child: Text(LocaleKeys.login_to_violet,
                              style: TextStyle(
                                fontSize: 26,
                                color: Palette.pinkBox,
                              ),).tr(),
                          )
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only( top: (height/896) *15, left: (width/414) * 18),
                        child: Text(LocaleKeys.we_just_need,
                          style: TextStyle(
                            fontSize: 18,
                            color: Palette.labelColor,
                          ),).tr(),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only( top: (height/896) *15, left: (width/414) * 18),
                        child: Text(LocaleKeys.phone_number,
                          style: TextStyle(
                            fontSize: 20,
                            color: Palette.pinkBox,
                          ),).tr(),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(12),
                          color: Palette.textField,
                        ),
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(top: (height/896) *10),
                        padding: EdgeInsets.only( left:10),
                        height: (height/896) * 57,
                        width: (width/414) * 312,
                        child: TextFormField(
                          controller: mobileController,
                          keyboardType: TextInputType.phone,
                          maxLines: 3,
                          style: TextStyle(
                              decoration: TextDecoration.none,
                              fontSize: 18,
                              color: Palette.mainColor
                          ),
                          autofocus: false,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: LocaleKeys.phone_number.tr() ,
                              hintStyle: TextStyle(
                                  decoration: TextDecoration.none,
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal,
                                  color: Palette.pinkBox
                              )
                          ),
                        )
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only( top: (height/896) * 10, left: (width/414) * 18),
                        child: Text(LocaleKeys.a_digit,
                          style: TextStyle(
                            fontSize: 17,
                            color: Palette.labelColor,
                          ),).tr(),
                      ),
                    GestureDetector(
                       child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(12),
                          color: Color.fromRGBO(112, 112, 112, 1),
                        ),
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(top: (height/896) *40,  bottom: (height/896) *40),
                        height: (height/896) * 44,
                        width: (width/414) * 156,
                        child: Text(LocaleKeys.login,
                          style: TextStyle(
                            fontSize: 18,
                            color: Palette.whiteText,
                          ),).tr(),
                      ),
                      onTap: (){

                        validateMobile(mobileController.text, "login");

                      },
                    ),
                      Container(
                        alignment: Alignment.center,
                        width: width,
                        padding: EdgeInsets.only(top: (height/896) *3, left: (width/414) * 18, right: (width/414) * 18),
                        child:Center (
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                flex:1,
                                child: GestureDetector(
                                  child: Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                      right: BorderSide(width: 1, color: Palette.pinkBox ),
                                    ),
                                  ),
                                  child: Text(LocaleKeys.new_register_now,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Palette.labelColor,
                                    ),).tr(),),
                                  onTap: (){
                                    FocusScope.of(context).requestFocus(new FocusNode());
                                    Navigator.pop(context);
                                    showRegisterDialog(context);
                                  },
                                ),
                              ),
                              Expanded(
                                flex:1,
                                child:
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                      left: BorderSide(width: 1, color: Palette.pinkBox ),
                                    ),
                                  ),
                                  child: Text(LocaleKeys.forget_password,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Palette.labelColor,
                                    ),).tr(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                          child: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.only( top: (height/896) * 20, bottom: (height/896) * 20),
                          child: Icon(Icons.close,
                            color: Palette.pinkBox,
                            size: 24,)
                      ),
                        onTap: (){
                          FocusScope.of(context).requestFocus(new FocusNode());
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  )
              ),
            ),
          );
        });
  }

  validateMobile(String value, String type) {
    String pattern = r'(^[0-9]*$)';
    RegExp regExp = new RegExp(pattern);

    if(value.isEmpty){
      showSnackbar(context, "Mobile number is Required ", Colors.red);
    }else{
      if(type == "login"){
        _login();
      }else{
        register(context);
      }

    }
  }

  showOTPLogin(BuildContext context, String mobile, String otpLogin) {

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
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(25),
                color: Palette.whiteText,
              ),
              // height: (height/896) * 456,
              width: (width/414) * 347,
              child: Padding(
                  padding: const EdgeInsets.all(0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                          child: Container(
                            margin: EdgeInsets.only( top: (height/896) *25),
                            child: Text(LocaleKeys.login_to_violet,
                              style: TextStyle(
                                fontSize: 26,
                                color: Palette.pinkBox,
                              ),).tr(),
                          )
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only( top: (height/896) * 50, left: (width/414) * 18),
                        child: Text(LocaleKeys.enter_the,
                          style: TextStyle(
                            fontSize: 16,
                            color: Palette.labelColor,
                          ),).tr(),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only( top: (height/896) *30, left: (width/414) * 18),
                        child: Text("$mobile",
                          style: TextStyle(
                            fontSize: 16,
                            color: Palette.pinkBox,
                          ),),
                      ),
                      Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(top: (height/896) *15, left:  (width/414) *25, right: (width/414) *25),
                          width: width,
                          child:  Container(
                                  width: width,
                            height: (height/896) * 76,
                                  child: Center(
                                    child: Container(
                                      child: PinPut(
                                        eachFieldHeight:(height/896) * 76,
                                        eachFieldWidth:(width/414) * 50,
                                        fieldsCount: 4,
                                        textStyle: TextStyle(
                                          fontSize: 24,
                                          color: Palette.pinkBox,
                                          fontWeight: FontWeight.normal,
                                        ),
                                        // onSubmit: (String pin) => _showSnackBar(pin, context),
                                        onSubmit: (String str){
                                          if(str == otpLogin){
                                            verifyOtp(context, mobile, str);
                                          }
                                          // setState((){
                                          //
                                          //   pinCorrect = true;
                                          //   pin = str;
                                          // });
                                        },
                                        focusNode: _pinPutFocusNode,
                                        controller: _pinPutController,
                                        submittedFieldDecoration: _pinPutDecoration.copyWith(
                                          color: Palette.textField,
                                          borderRadius: BorderRadius.circular(20),
                                          border: Border.all(
                                            color: Palette.textField,
                                          ),
                                        ),
                                        selectedFieldDecoration: _pinPutDecoration.copyWith(
                                          color:  Palette.textField,
                                          borderRadius: BorderRadius.circular(20),
                                          border: Border.all(
                                            color: Palette.textField,
                                          ),
                                        ),
                                        followingFieldDecoration: _pinPutDecoration.copyWith(
                                          color:  Palette.textField,
                                          borderRadius: BorderRadius.circular(20),
                                          border: Border.all(
                                            color: Palette.textField,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                      ),
                      GestureDetector(
                        child: Container(
                          alignment: Alignment.centerLeft,
                          width: width,
                          padding: EdgeInsets.only( top: (height/896) * 25, bottom: (height/896) *40,left: (width/414) * 18),
                          child: Text(LocaleKeys.resend_otp,
                            style: TextStyle(
                              fontSize: 20,
                              color: Palette.pinkBox,
                            ),).tr(),
                        ),
                        onTap: (){

                        },
                      ),

                    ],
                  )
              ),
            ),
          );
        });
  }

  Future<String> _login() async {

    var response;
    print("_register ");
    bool networkResults = await NetworkCheck.checkNetwork();
    print("_register  networkResults  $networkResults");
    if (networkResults ) {
      try {
        response = await http.post(
            Uri.parse(Repository.login),
            headers: {"Accept": "application/json"},
            body: {
              "mobile": mobileController.text
            }
        );

        int responseCode = response.statusCode;
        print("responseCode $responseCode");
        if (responseCode == 201) {
          var parsedJson = json.decode(response.body);
          String mobile = parsedJson['user']['mobile'];
          int otp = parsedJson['user']['otp_password'];
          print("otp $otp");
          mobileController.clear();
          Navigator.pop(context);
          showOTPLogin(context, mobile, otp.toString());

        } else if (responseCode == 425) {
          Navigator.pop(context);
          showAlert(context, " Error !");
        } else {
          Navigator.pop(context);
          showAlert(context, " Error !");
        }
        return "Success";
      } catch (Exception) {
        setState(() {
        });

      }
    }else{
      showAlert(context, "No internet Available!");


    }
  }

  Future<String> register(BuildContext context) async {
    String url = Repository.registerNewCustomer;
    var response;

    print("mobileRegController.text ${mobileRegController.text}");
    bool networkResults = await NetworkCheck.checkNetwork();

    if (networkResults) {
      try {
        response = await http.post(
            Uri.parse(url),
            body: {
              "mobile": mobileRegController.text
            }
        );

        int responseCode = response.statusCode;
        // print("responseCode regirtuyr $responseCode");
        if (responseCode == 200) {
          var convertData = json.decode(response.body);
          // print("convertData $convertData");
          var mobile = convertData['data']['user']['mobile'];
          var otpReg = convertData['data']['user']['otp_password'];
          var userId = convertData['data']['user_id'];
          // print("otp $otpReg");
          await SharedPreferencesHelper.setCustomerID(userId);
          mobileRegController.clear();
          Navigator.pop(context);
          showOTPRegister(context, mobile, otpReg );

        } else if (responseCode == 422) {
          showAlert(context, "The mobile has already been taken.");
        } else {
          showAlert(context, "Server error ! ");
        }
        } catch (Exception) {
        showAlert(context, " Error !");
      }
    } else {
      showAlert(context, "No Internet ! ");

    }
    return "success";
  }

  Future<String> verifyOtp(BuildContext context, String mobileNo, String otp) async {
    String url = Repository.verifyOtpGetToken;
    var response;

    print("otp api  ${otp}");
    bool networkResults = await NetworkCheck.checkNetwork();

    if (networkResults) {
      try {
        response = await http.post(
            Uri.parse(url),
            body: {
              "mobile": mobileNo,
              "otp": otp
            }
        );

        int responseCode = response.statusCode;
        print("responseCode verify  $responseCode");
        if (responseCode == 201) {
          var convertData = json.decode(response.body);
          print("convertData $convertData");
          var token = convertData['token'];
          String userId = convertData['data']['id'];
          print("token *** $token");
          _pinPutController.clear();
          FocusScope.of(context).requestFocus(new FocusNode());
          Navigator.pop(context);
          await SharedPreferencesHelper.setToken(token);
          await SharedPreferencesHelper.setCustomerID(userId);

          showSnackbar(context, "Success",Colors.blue);
          // setState(() {
          //
          // });
        } else if (responseCode == 425) {
          Navigator.pop(context);
          showAlert(context, "Number already exist !");
        } else {
          Navigator.pop(context);
          showAlert(context, "Server error ! ");
        }
      } catch (Exception) {
        Navigator.pop(context);
        showAlert(context, " Error !");
      }
    } else {
      Navigator.pop(context);
      showAlert(context, "No Internet !! ");


    }
    return "success";
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
                                fontSize: 22,
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
                            fontSize: 16,
                            color: Palette.labelColor,
                          ),).tr(),
                      ),
                        onTap: () {
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

  showSnackbar(BuildContext context, String msg, Color color) {
    final snackBar = SnackBar(
      content: Text(msg),
      backgroundColor: color,
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }


}