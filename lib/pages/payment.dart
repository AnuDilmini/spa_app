
import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:violet_app/enums/connectivity_status.dart';
import 'package:violet_app/model/companyService.dart';
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


import 'bottom_nav.dart';

class Payment extends StatefulWidget {

  Payment({Key key}) : super(key: key);

  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {

  double height, width;
  AlertDialog alert;
  final otpController = TextEditingController();
  bool isCheckout = false;
  bool isSelect = false;
  bool isAgree = false;
  var connectionStatus;

  final commentController = TextEditingController();
  bool isCompleteApi = false;
  int selectedServiceCount = 0;

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  List<CompanyServices> selectedService = new List();



  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async{
    String serviceListJson = await SharedPreferencesHelper.getSelectedService();

    if (serviceListJson != "") {
      selectedService = CompanyServices.decode(serviceListJson);
      selectedServiceCount = selectedService.length;
    }
    setState(() {

    });

  }

  @override
  void dispose() {
    super.dispose();
    commentController.dispose();

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
              top: (height/602) * 40,
              left: (width/414) * 20,
              child:GestureDetector(
                 child: Center(
                   child: Container(
                       alignment: context.locale.languageCode== "en" ? Alignment.centerLeft : Alignment.centerRight,
                       child:
                       Icon(Icons.arrow_back_ios,
                         color: Palette.pinkBox,
                         size: 25,)
                   ),
                  // child: Container(
                  //   child: Icon(Icons.arrow_back_ios,
                  //   color: Palette.pinkBox,
                  //   size: 20,),
                  // ),
              ),
                onTap: (){

                  FocusScope.of(context).requestFocus(new FocusNode());
                  Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.fade,
                        child:  BottomNav(index: 0, subIndex: 1),
                      ));

                },
              ),
            ),
            Positioned(
              top: (height/896) * 104,
              left: (width/414) *20,
              right: (width/414) *20,
              child: Column(
                children: [
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Color.fromRGBO(247, 127, 151, 0.18),
                      ),
                      height: (height/896) * 110,
                      width: width,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:[
                            // Image.asset("assets/cart.png",
                            //   height: (height/896) * 45,
                            //   width: (width/414) * 27,),
                            Text("FOUR\n SPA",
                              style: TextStyle(
                                fontSize: 11,
                                color: Color.fromRGBO(247, 127, 151, 1),
                              ),),
                          ]
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  Center(
                    child: Container(
                        padding: EdgeInsets.only(left: (width/414) * 15, right: (width/414) * 15,top: (height/896) * 15 , bottom: (height/896) * 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Color.fromRGBO(231, 223, 225, 0.81),
                        ),
                        // height: (height/896) * 260,
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
                              height: (height/896) * 130,
                              child:ListView.builder(
                                  padding: EdgeInsets.zero,
                                  scrollDirection: Axis.vertical,
                                  itemCount: selectedServiceCount,
                                  itemBuilder: (BuildContext context, int index) {
                                    return GestureDetector(
                                        child: listItem(index),
                                        onTap:(){
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
                                            fontSize: 17,
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
                                            fontSize: 16,
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
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: Palette.pinkBox
                                        ),
                                      ).tr()
                                  ),
                                  Expanded(
                                      flex: 1,
                                      child:  Text(
                                        "${totalPriceSum()} SAR",
                                        style: TextStyle(
                                            fontSize: 17,
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
                                child:   Row(
                                  children: [
                                    Text(tr('* ( ${LocaleKeys.include_vat.tr()}'),
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: Palette.textGrey),
                                    ),
                                    Text("15.0 % )",
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: Palette.textGrey),
                                    ),
                                  ],
                                )
                            ),
                          ],
                        )
                    ),
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  GestureDetector(
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
                  SizedBox(
                    height: 7,
                  ),
                  Center(
                    child: Container(
                      padding: EdgeInsets.only(left: (width/414) * 15, right: (width/414) * 15,top: (height/896) * 8 ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color.fromRGBO(231, 223, 225, 0.81),
                      ),
                      height: (height/896) * 180,
                      width: width,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            LocaleKeys.payment,
                            style: TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.normal,
                                color: Palette.pinkBox
                            ),
                          ).tr(),
                          Container(
                            padding: EdgeInsets.only(top: (height/896) * 3 ),
                            height: (height/896) * 124,
                            child: ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.zero,
                                scrollDirection: Axis.vertical,
                                itemCount: 3,
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
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      GestureDetector(
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
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      GestureDetector(
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            LocaleKeys.i_agree,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
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
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
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
                ],
              ),

            ),
            // Positioned(
            //   top: (height/896) * 221,
            //   left: (width/414) *20,
            //   right: (width/414) *20,
            //   child:  Center(
            //     child: Container(
            //       padding: EdgeInsets.only(left: (width/414) * 15, right: (width/414) * 15,top: (height/896) * 15 , bottom: (height/896) * 15),
            //       decoration: BoxDecoration(
            //         borderRadius: BorderRadius.circular(20),
            //         color: Color.fromRGBO(231, 223, 225, 0.81),
            //       ),
            //       // height: (height/896) * 260,
            //       width: width,
            //       child:Column(
            //         children: [
            //           Container(
            //             padding: EdgeInsets.only(bottom: (height/896) * 5 ),
            //             decoration: BoxDecoration(
            //               border: Border(
            //                 bottom: BorderSide(width: 2, color: Palette.pinkBox ),
            //               ),
            //             ),
            //             height: (height/896) * 130,
            //             child:ListView.builder(
            //                 padding: EdgeInsets.zero,
            //                 scrollDirection: Axis.vertical,
            //                 itemCount: selectedServiceCount,
            //                 itemBuilder: (BuildContext context, int index) {
            //                   return GestureDetector(
            //                       child: listItem(index),
            //                       onTap:(){
            //                         showLoginDialog(context);
            //                       }
            //                   );
            //                 }
            //             ),
            //           ),
            //           Container(
            //             padding: EdgeInsets.only(left: (width/414) * 5, right: (width/414) * 5, top: (height/896) * 8),
            //             child: Row(
            //               children: [
            //                 Expanded(
            //                   flex: 3,
            //                 child: Text(
            //                   LocaleKeys.delivery_charge,
            //                   style: TextStyle(
            //                       fontSize: 17,
            //                       fontWeight: FontWeight.w500,
            //                       color: Palette.pinkBox
            //                   ),
            //                 ).tr()
            //                 ),
            //                 Expanded(
            //                     flex: 1,
            //                     child: Text(
            //                       "1150 SAR",
            //                       maxLines: 1,
            //                       style: TextStyle(
            //                           fontSize: 16,
            //                           fontWeight: FontWeight.w500,
            //                           color: Palette.pinkBox
            //                       ),
            //                     )
            //                 ),
            //               ],
            //             ),
            //           ),
            //           Container(
            //             alignment: Alignment.center,
            //             padding: EdgeInsets.only(left: (width/414) * 5, right: (width/414) * 5, top: (height/896) * 2),
            //             child: Row(
            //               children: [
            //                 Expanded(
            //                     flex: 3,
            //                     child: Text(
            //                       LocaleKeys.total,
            //                       style: TextStyle(
            //                           fontSize: 16,
            //                           fontWeight: FontWeight.w500,
            //                           color: Palette.pinkBox
            //                       ),
            //                     ).tr()
            //                 ),
            //                 Expanded(
            //                     flex: 1,
            //                     child:  Text(
            //                       "${totalPriceSum()} SAR",
            //                       style: TextStyle(
            //                           fontSize: 17,
            //                           fontWeight: FontWeight.w500,
            //                           color: Palette.pinkBox
            //                       ),
            //                     )
            //                 ),
            //               ],
            //             ),
            //           ),
            //           Container(
            //             alignment: Alignment.bottomLeft,
            //             padding: EdgeInsets.only(left: (width/414) * 5, right: (width/414) * 5, top: (height/896) * 5),
            //             child:   Row(
            //               children: [
            //                 Text(tr('* ( ${LocaleKeys.include_vat}'),
            //                 style: TextStyle(
            //                     fontSize: 12,
            //                     fontWeight: FontWeight.w500,
            //                     color: Palette.textGrey),
            //                 ),
            //                 Text("15.0 % )",
            //                   style: TextStyle(
            //                       fontSize: 12,
            //                       fontWeight: FontWeight.w500,
            //                       color: Palette.textGrey),
            //                 ),
            //               ],
            //             )
            //           ),
            //         ],
            //       )
            //     ),
            //   ),
            // ),
            // Positioned(
            //   top: (height/896) * 488,
            //   left: (width/414) *20,
            //   right: (width/414) *20,
            //   child:  GestureDetector(
            //   child: Center(
            //     child: Container(
            //       alignment: Alignment.center,
            //       decoration: BoxDecoration(
            //         borderRadius: BorderRadius.circular(15),
            //         color: Color.fromRGBO(231, 223, 225, 0.81),
            //       ),
            //       height: (height/896) * 65,
            //       width: width,
            //       child: Text(
            //         LocaleKeys.add_comment,
            //         style: TextStyle(
            //             fontSize: 22,
            //             fontWeight: FontWeight.w400,
            //             color: Palette.pinkBox
            //         ),
            //       ).tr(),
            //     ),
            //   ),
            //     onTap: (){
            //       showComment(context);
            //     },
            //   ),
            // ),
            // Positioned(
            //   top: (height/896) * 562,
            //   left: (width/414) *20,
            //   right: (width/414) *20,
            //   child:  Center(
            //     child: Container(
            //       padding: EdgeInsets.only(left: (width/414) * 15, right: (width/414) * 15,top: (height/896) * 10 ),
            //       decoration: BoxDecoration(
            //         borderRadius: BorderRadius.circular(20),
            //         color: Color.fromRGBO(231, 223, 225, 0.81),
            //       ),
            //       height: (height/896) * 163,
            //       width: width,
            //       child: Column(
            //         mainAxisSize: MainAxisSize.min,
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //          Text(
            //             LocaleKeys.payment,
            //             style: TextStyle(
            //                 fontSize: 21,
            //                 fontWeight: FontWeight.normal,
            //                 color: Palette.pinkBox
            //             ),
            //           ).tr(),
            //       Container(
            //         margin: EdgeInsets.only(top: (height/896) * 10 ),
            //         height: (height/896) * 110,
            //         child: ListView.builder(
            //             padding: EdgeInsets.zero,
            //               scrollDirection: Axis.vertical,
            //               itemCount: 2,
            //               itemBuilder: (BuildContext context, int index) {
            //                 return GestureDetector(
            //                     child: listPayment(index),
            //                     onTap:(){
            //
            //                     }
            //                 );
            //               }
            //           ),
            //       ),
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
            // Positioned(
            //   top: (height/896) * 790,
            //   left: (width/414) *20,
            //   right: (width/414) *20,
            //   child:  GestureDetector(
            //    child: Center(
            //     child: Container(
            //       alignment: Alignment.center,
            //       decoration: BoxDecoration(
            //         borderRadius: BorderRadius.circular(12),
            //         border: Border.all(color: Palette.pinkBox,
            //         width: 1),
            //         color: isAgree ? Palette.pinkBox: Colors.transparent,
            //       ),
            //       height: (height/896) * 50,
            //       width: width,
            //       child: Text(LocaleKeys.slied_to_checkout,
            //           style: TextStyle(
            //             fontSize: 19,
            //             color: isAgree ? Palette.whiteText : Palette.pinkBox,
            //           ),
            //         ).tr(),
            //     ),
            //    ),
            //     onTap: (){
            //
            //       Navigator.push(
            //           context,
            //           PageTransition(
            //             type: PageTransitionType.fade,
            //             child:  BottomNav(index: 0, subIndex:3),
            //           ));
            //     },
            //   ),
            // ),
            // Positioned(
            // top: (height/896) * 737,
            // left: (width/414) *32,
            // child: GestureDetector(
            //  child: Container(
            //   height: (height/896) * 25,
            //   width: (height/896) * 25,
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(8),
            //     border: Border.all(color: Palette.pinkBox,
            //         width: 6),
            //     color: isAgree ? Colors.transparent :  Palette.pinkBox,
            //   ),
            //   ),
            //   onTap: (){
            //    setState(() {
            //      isAgree = !isAgree;
            //    });
            //   },
            // )
            // ),
            // Positioned(
            //     top: (height/896) * 738,
            //     left: (width/414) * 65,
            //     right: (width/414) * 20,
            //     child: GestureDetector(
            //       child: Container(
            //         alignment: Alignment.centerLeft,
            //      child: Text(
            //        LocaleKeys.i_agree,
            //        style: TextStyle(
            //          fontSize: 16,
            //          letterSpacing: 2,
            //          color:  Palette.pinkBox,
            //        ),
            //      ).tr(),
            //       ),
            //       onTap: (){
            //         setState(() {
            //           isAgree = !isAgree;
            //         });
            //       },
            //     )
            // ),
    ]
      ),
        ),
    );
  }

  double totalPriceSum() {
    double total = 0.0;
    for(int i = 0; i < selectedService.length ; i++){
      total = total + double.parse(selectedService[i].price);
      print("total $total");
    }
    return total;
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
                width:(width/414) * 40,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    // color: Colors.black54,
                    shape: BoxShape.rectangle,
                ),
                child: selectedService[index].image != null ?
                Image.network(Repository.iconUrl+selectedService[index].image):
                Image.asset("assets/background.png")
            ),
          ),
          Positioned(
              top: (height/896) * 8,
              left: (width/414) * 55,
              right: (width/414) * 55,
              // width: (width/414) * 170,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                 children:[
                 Text(
                 '${selectedService[index].name}',
                  maxLines: 1,
                  style: TextStyle(
                      fontSize: 16,
                      color: Palette.pinkBox),
                 ),
                  Text(
                      '${selectedService[index].duration_min} min - ${selectedService[index].price} SAR',
                        style: TextStyle(
                        fontSize: 11,
                        color: Palette.labelColor),
                 ),
                ]
                ),
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
      // padding: EdgeInsets.only(bottom: (height/896) * 1),
      child: Stack(
        children: [
          Positioned(
            top: (height/896) * 0,
            left: (width/414) * 1,
            child: Container(
              alignment: Alignment.topLeft,
                height: (height/896) *55,
                width:(width/414) * 55,
                decoration: BoxDecoration(
                    // borderRadius: BorderRadius.circular(8),
                    shape: BoxShape.rectangle,
                    image: new DecorationImage(
                      image: index == 0 ? new AssetImage("assets/master.png") :
                      index == 1 ?  new AssetImage("assets/ipay.png")
                          : new AssetImage("assets/cash.png"),
                      ),
                    )
                )
            ),
          Positioned(
              top: (height/896) * 18,
              left: (width/414) * 75,
              width: (width/414) * 170,
              child:Text(
                index == 0 ?'**** **** 3256' :
                index ==1 ? "Apple Pay":
                "Cash",
                  style: TextStyle(
                      letterSpacing: 2,
                      fontSize: 16,
                      color: Palette.balckColor),
                ),
              ),
          Positioned(
            top: (height/896) * 15,
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
                                controller: commentController,
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






}