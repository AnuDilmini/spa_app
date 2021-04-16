
import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_credit_card/credit_card_form.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:violet_app/enums/connectivity_status.dart';
import 'package:violet_app/model/companyService.dart';
import 'package:violet_app/network/repository.dart';
import 'package:violet_app/network/shared.dart';
import 'package:violet_app/style/palette.dart';
import 'package:violet_app/utils/network_check.dart';
import 'package:page_transition/page_transition.dart';
import 'package:violet_app/style/local.keys.dart';
import 'package:easy_localization/easy_localization.dart';
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
  final cardNoController = TextEditingController();
  final cardNameController = TextEditingController();
  final exDateController = TextEditingController();
  final cvvController = TextEditingController();
  bool isCompleteApi = false;
  bool loading = false;
  int selectedServiceCount = 0;

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  List<CompanyServices> selectedService = new List();
  List<dynamic> serviceList = new List();
  List<dynamic> detailsList = new List();
  double total = 0.0;
  int selectPayment ;
  String companyId, customerId, token;
  String lngCode = "en";
  String dateTime = "29-03-2021 12:00:00";
  final Dio _dio = Dio();
  bool isMaster = false, isModa = false, isVisa = false, isStc = false, isIpay = false, isCash = false;
  double zoom = 1;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async{
    String serviceListJson = await SharedPreferencesHelper.getSelectedService();
    companyId = await SharedPreferencesHelper.getCompanyId();
    customerId = await SharedPreferencesHelper.getCustomerID();
    lngCode = await SharedPreferencesHelper.getLanguage();
    token = await SharedPreferencesHelper.getToken();
    dateTime = await SharedPreferencesHelper.getDateTime();


    if(lngCode == "en"){
      zoom = 1;
    }else if(lngCode == "ar"){
      zoom = 1.5;
    }

    if (serviceListJson != "") {
      selectedService = CompanyServices.decode(serviceListJson);
      selectedServiceCount = selectedService.length;
      totalPriceSum();
    }

    setState(() {
    });

    }

    @override
    void dispose() {
      super.dispose();
      commentController.dispose();
      otpController.dispose();
      cardNoController.dispose();
      cardNameController.dispose();
      exDateController.dispose();
      cvvController.dispose();

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
                  height:  lngCode == "en"? height* 1.3 : height* 1.4,
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
                          alignment:  lngCode == "en"? Alignment.centerLeft : Alignment.centerRight,
                          child:
                          Icon(Icons.arrow_back_ios,
                            color: Palette.pinkBox,
                            size:  (height/896) * 25,)
                      ),
                      // child: Container(
                      //   child: Icon(Icons.arrow_back_ios,
                      //   color: Palette.pinkBox,
                      //   size: 20,),
                      // ),
                    ),
                    onTap: () {
                      print("anuuuuu");
                      // String serviceList = CompanyServices.encode(selectedService);
                      // await SharedPreferencesHelper.setSelectedService(serviceList);
                      FocusScope.of(context).requestFocus(new FocusNode());
                      Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.fade,
                            child:  BottomNav(index: 0, subIndex: 2),
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
                                    fontSize: (height/896) *11,
                                    fontFamily: lngCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
                                    color: Color.fromRGBO(247, 127, 151, 1),
                                  ),),
                              ]
                          ),
                        ),
                      ),
                      SizedBox(
                        height: (height/896) *7,
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
                                  child:selectedService.isNotEmpty ? ListView.builder(
                                      padding: EdgeInsets.zero,
                                      scrollDirection: Axis.vertical,
                                      itemCount: selectedService.length,
                                      itemBuilder: (BuildContext context, int index) {
                                        final item = selectedService[index].id;
                                        return Dismissible(
                                          direction: DismissDirection.startToEnd,
                                          key: Key(item),
                                          child: listItem(index),
                                          onDismissed: (direction) {
                                            total = total - double.parse(selectedService[index].price);
                                            selectedService.removeAt(index);

                                            setState(() {
                                            });
                                            // minusPriceSum(double.parse(selectedService[index].price));

                                            // Then show a snackbar.
                                            // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$item dismissed")));
                                          },
                                          background: Container(color: Palette.pinkBox),
                                        );
                                      }
                                  ):  Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Column(
                                          children: <Widget>[
                                            Text(
                                              "No Selected Services",
                                              style: TextStyle(color: Palette.pinkBox,
                                                fontFamily: lngCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
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
                                                fontFamily: lngCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
                                                fontSize: (height/896) *17  * zoom,
                                                fontWeight: FontWeight.w500,
                                                color: Palette.pinkBox
                                            ),
                                          ).tr()
                                      ),
                                      Expanded(
                                          flex: 1,
                                          child: Text(
                                            "1150  SAR",
                                            maxLines: 1,
                                            style: TextStyle(
                                                fontFamily: lngCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
                                                fontSize: (height/896) *16 ,
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
                                                fontFamily: lngCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
                                                fontSize: (height/896) *16* zoom,
                                                fontWeight: FontWeight.w500,
                                                color: Palette.pinkBox
                                            ),
                                          ).tr()
                                      ),
                                      Expanded(
                                          flex: 1,
                                          child:  Text(
                                            "$total SAR",
                                            style: TextStyle(
                                                fontFamily: lngCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
                                                fontSize: (height/896) *17,
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
                                        Text('* ( ${LocaleKeys.include_vat.tr()}',
                                          style: TextStyle(
                                              fontFamily: lngCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
                                              fontSize: (height/896) *12 * zoom,
                                              fontWeight: FontWeight.w500,
                                              color: Palette.textGrey),
                                        ),
                                        Text("15.0 % )",
                                          style: TextStyle(
                                              fontFamily: lngCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
                                              fontSize: (height/896) *12,
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
                        height: (height/896) * 7,
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
                                  fontFamily: lngCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
                                  fontSize: (height/896) *22 * zoom,
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
                        height: (height/896) *7,
                      ),
                      Center(
                        child: Container(
                          padding: EdgeInsets.only(left: (width/414) * 15, right: (width/414) * 15,top: (height/896) * 15, bottom: (height/896) * 25 ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Color.fromRGBO(231, 223, 225, 0.81),
                          ),
                          // height: (height/896) * 170,
                          width: width,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                LocaleKeys.payment,
                                style: TextStyle(
                                    fontFamily: lngCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
                                    fontSize: (height/896) *21 * zoom,
                                    fontWeight: FontWeight.normal,
                                    color: Palette.pinkBox
                                ),
                              ).tr(),
                              (isMaster  || isModa  || isVisa || isStc )?
                                  Container(
                                    child: Column(
                                        children:[
                                          CreditCardForm(
                                      formKey: formKey, // Required
                                      onCreditCardModelChange: (CreditCardModel data) {}, // Required
                                      themeColor: Palette.pinkBox,
                                      obscureCvv: true,
                                      obscureNumber: true,
                                      cardNumberDecoration: const InputDecoration(
                                        border: OutlineInputBorder(
                                          borderSide: const BorderSide(color: Palette.darkPink, width: 4.0),
                                        ),
                                        labelText: 'Card Number',
                                        labelStyle: TextStyle(
                                          color: Palette.pinkBox

                                        ),
                                        hintText: 'XXXX XXXX XXXX XXXX',
                                      ),
                                      cardHolderDecoration: const InputDecoration(
                                        border: OutlineInputBorder(
                                          borderSide: const BorderSide(color: Palette.darkPink, width: 4.0),
                                        ),
                                        labelText: 'CardHolder Name',
                                        labelStyle: TextStyle(
                                            color: Palette.pinkBox

                                        ),
                                      ),
                                      expiryDateDecoration: const InputDecoration(
                                        border: OutlineInputBorder(
                                          borderSide: const BorderSide(color: Palette.darkPink, width: 4.0),
                                        ),
                                        labelText: 'Expired Date',
                                        labelStyle: TextStyle(
                                            color: Palette.pinkBox

                                        ),
                                        hintText: 'XX/XX',
                                      ),
                                      cvvCodeDecoration: const InputDecoration(
                                        border: OutlineInputBorder(
                                          borderSide: const BorderSide(color: Palette.darkPink, width: 4.0),
                                        ),
                                        labelText: "CVV",
                                        labelStyle: TextStyle(
                                            color: Palette.pinkBox

                                        ),
                                        hintText: 'XXX',
                                      ),

                                    ),
                                    Container(
                                      margin: EdgeInsets.only( left: (width/414) *95, right: (width/414) * 95),
                                      padding: EdgeInsets.only( top: (height/896) * 10, bottom: (height/896) * 10),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      shape: BoxShape.rectangle,
                                      color: Palette.pinkBox
                                      ),
                                      child: Text(LocaleKeys.pay_now,
                                      style: TextStyle(
                                      fontFamily: lngCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
                                      fontSize: (height/896) *15* zoom,
                                      fontWeight: FontWeight.normal,
                                      color: Palette.whiteText
                                      ),
                                      ).tr(),
                                    )

                                   ]
                                   )
                                  ):
                              // Container(
                              //     margin: EdgeInsets.only(left: (width/414) * 15, right: (width/414) * 15, top: (height/896) * 10),
                              //     child:
                              //   Column(
                              //     crossAxisAlignment: CrossAxisAlignment.start,
                              //    children: [
                              //     Text(LocaleKeys.card_number,
                              //       style: TextStyle(
                              //           fontFamily: lngCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
                              //           fontSize: (height/896) *14 * zoom,
                              //           fontWeight: FontWeight.normal,
                              //           color: Palette.pinkBox
                              //       ),
                              //     ).tr(),
                              //    SizedBox(
                              //      height: (height/896) *7,
                              //    ),
                              //    Container(
                              //       padding: EdgeInsets.only(left: (width/414) * 10, right: (width/414) * 10),
                              //       decoration: BoxDecoration(
                              //       borderRadius: BorderRadius.circular(15),
                              //       shape: BoxShape.rectangle,
                              //       color: Palette.greyWhite
                              //       ),
                              //      child: TextField(
                              //      controller: cardNoController,
                              //       decoration: InputDecoration(
                              //         hintText: tr(LocaleKeys.enter_card_no).tr(),
                              //         hintStyle: TextStyle(
                              //           fontFamily: lngCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
                              //         color: Palette.labelColor,
                              //         fontSize: (height/896) *14* zoom,
                              //         ),
                              //         border: InputBorder.none,
                              //       ),
                              //         style: TextStyle(
                              //             fontFamily: lngCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
                              //         color: Palette.pinkBox,
                              //         fontSize: (height/896) *14* zoom,
                              //         ),
                              //       ),
                              //        ),
                              //      SizedBox(
                              //        height: (height/896) *7,
                              //      ),
                              //      Text(LocaleKeys.card_name,
                              //        style: TextStyle(
                              //            fontFamily: lngCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
                              //            fontSize: (height/896) *14* zoom,
                              //            fontWeight: FontWeight.normal,
                              //            color: Palette.pinkBox
                              //        ),
                              //      ).tr(),
                              //      SizedBox(
                              //        height: (height/896) *7,
                              //      ),
                              //      Container(
                              //        padding: EdgeInsets.only(left: (width/414) * 10, right: (width/414) * 10),
                              //        decoration: BoxDecoration(
                              //            borderRadius: BorderRadius.circular(15),
                              //            shape: BoxShape.rectangle,
                              //            color: Palette.greyWhite
                              //        ),
                              //        child: TextField(
                              //          controller: cardNameController,
                              //          decoration: InputDecoration(
                              //            hintText: tr(LocaleKeys.enter_card_name).tr(),
                              //            hintStyle: TextStyle(
                              //              color: Palette.labelColor,
                              //              fontSize: (height/896) *14 * zoom,
                              //              fontFamily: lngCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
                              //            ),
                              //            border: InputBorder.none,
                              //          ),
                              //          style: TextStyle(
                              //              color: Palette.pinkBox,
                              //              fontSize: 14,
                              //            fontFamily: lngCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',),
                              //        ),
                              //      ),
                              //      SizedBox(
                              //        height: (height/896) *7,
                              //      ),
                              //      Row(
                              //        mainAxisAlignment: MainAxisAlignment.center,
                              //        children: [
                              //          Expanded(
                              //            flex: 1,
                              //            child:
                              //          Column(
                              //            crossAxisAlignment: CrossAxisAlignment.start,
                              //            children: [
                              //              Text(LocaleKeys.ex_date,
                              //                style: TextStyle(
                              //                    fontSize: (height/896) *14* zoom,
                              //                    fontWeight: FontWeight.normal,
                              //                    color: Palette.pinkBox,
                              //                  fontFamily: lngCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
                              //                ),
                              //              ).tr(),
                              //
                              //              Container(
                              //                padding: EdgeInsets.only(left: (width/414) * 10, right: (width/414) * 10),
                              //                decoration: BoxDecoration(
                              //                    borderRadius: BorderRadius.circular(15),
                              //                    shape: BoxShape.rectangle,
                              //                    color: Palette.greyWhite
                              //                ),
                              //                child: TextField(
                              //                  controller: exDateController,
                              //                  decoration: InputDecoration(
                              //                    border: InputBorder.none,
                              //                  ),
                              //                  style: TextStyle(
                              //                      color: Palette.pinkBox,
                              //                      fontSize:  (height/896) *14* zoom,
                              //                    fontFamily: lngCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',),
                              //                ),
                              //              ),
                              //            ],
                              //          ),
                              //          ),
                              //          SizedBox(
                              //            width: (width/414) * 10,
                              //          ),
                              //          Expanded(
                              //            flex: 1,
                              //            child:
                              //            Column(
                              //              crossAxisAlignment: CrossAxisAlignment.start,
                              //              children: [
                              //                Text(LocaleKeys.cvv,
                              //                  style: TextStyle(
                              //                      fontFamily: lngCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
                              //                      fontSize: (height/896) *14* zoom,
                              //                      fontWeight: FontWeight.normal,
                              //                      color: Palette.pinkBox
                              //                  ),
                              //                ).tr(),
                              //                Container(
                              //                  padding: EdgeInsets.only(left: (width/414) * 10, right: (width/414) * 10),
                              //                  decoration: BoxDecoration(
                              //                      borderRadius: BorderRadius.circular(15),
                              //                      shape: BoxShape.rectangle,
                              //                      color: Palette.greyWhite
                              //                  ),
                              //                  child: TextField(
                              //                    controller: cvvController,
                              //                    decoration: InputDecoration(
                              //                      border: InputBorder.none,
                              //                    ),
                              //                    style: TextStyle(
                              //                        color: Palette.pinkBox,
                              //                        fontSize:  (height/896) *14* zoom,
                              //                      fontFamily: lngCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',),
                              //                  ),
                              //                ),
                              //              ],
                              //            ),
                              //          ),
                              //        ],
                              //      ),
                              //      SizedBox(
                              //        height: (height/896) *10,
                              //      ),
                              //      Container(
                              //        margin: EdgeInsets.only( left: (width/414) *95, right: (width/414) * 95),
                              //        padding: EdgeInsets.only( top: (height/896) * 10, bottom: (height/896) * 10),
                              //        alignment: Alignment.center,
                              //        decoration: BoxDecoration(
                              //            borderRadius: BorderRadius.circular(10),
                              //            shape: BoxShape.rectangle,
                              //            color: Palette.pinkBox
                              //        ),
                              //        child: Text(LocaleKeys.pay_now,
                              //          style: TextStyle(
                              //              fontFamily: lngCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
                              //              fontSize: (height/896) *15* zoom,
                              //              fontWeight: FontWeight.normal,
                              //              color: Palette.whiteText
                              //          ),
                              //        ).tr(),
                              //      )
                              //
                              //    ]
                              //   )
                              // ):
                              Container(
                                padding: EdgeInsets.only(top: (height/896) *20),
                                alignment: Alignment.center,
                                child: Center(
                                    child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                      children:[
                                        GestureDetector(
                                          onTap: (){
                                            setState(() {
                                              isMaster = true;
                                            });
                                          },
                                            child: Container(
                                        alignment: Alignment.topLeft,
                                        height: (height/896) *37,
                                        width:(width/414) * 55,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8),
                                            shape: BoxShape.rectangle,
                                            color: Palette.greyWhite
                                        ),
                                        child: Center(
                                            child: Image.asset("assets/master.png")
                                        )
                                     ),
                                        ),
                                        SizedBox(
                                          width: (width/414) * 15,
                                        ),
                                        GestureDetector(
                                            onTap: (){
                                              setState(() {
                                                isModa = true;
                                              });
                                            },
                                            child:Container(
                                      alignment: Alignment.topLeft,
                                      height: (height/896) *37,
                                      width:(width/414) * 55,
                                      decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      shape: BoxShape.rectangle,
                                      color: Palette.greyWhite
                                      ),
                                      child: Center(
                                      child: Image.asset("assets/mada.png")
                                      )
                                    ),
                                        ),
                                        SizedBox(
                                          width: (width/414) * 15,
                                        ),
                                        GestureDetector(
                                            onTap: (){
                                              setState(() {
                                                isVisa = true;
                                              });
                                            },
                                            child:
                                    Container(
                                      alignment: Alignment.topLeft,
                                      height: (height/896) *37,
                                      width:(width/414) * 55,
                                      decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      shape: BoxShape.rectangle,
                                      color: Palette.greyWhite
                                     ),
                                    child: Center(
                                      child: Image.asset("assets/visa.png")
                                      )
                                     ),
                                        ),
                                        SizedBox(
                                          width: (width/414) * 15,
                                        ),
                                    ]
                                      ),
                                    SizedBox(
                                      height: (height/896) * 12,
                                    ),
                                    Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                      children:[
                                        GestureDetector(
                                            onTap: (){
                                              setState(() {
                                                isIpay = true;
                                              });
                                            },
                                            child: Container(
                                          alignment: Alignment.topLeft,
                                          height: (height/896) *37,
                                          width:(width/414) * 55,
                                          decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          shape: BoxShape.rectangle,
                                          color: Palette.greyWhite
                                          ),
                                          child: Center(
                                            child:
                                            Image.asset("assets/ipay.png")
                                          )
                                        ),
                                        ),
                                        SizedBox(
                                          width: (width/414) * 15,
                                        ),
                                        GestureDetector(
                                            onTap: (){
                                              setState(() {
                                                isStc = true;
                                              });
                                            },
                                            child:Container(
                                          alignment: Alignment.topLeft,
                                          height: (height/896) *37,
                                          width:(width/414) * 55,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8),
                                            shape: BoxShape.rectangle,
                                            color: Palette.greyWhite
                                          ),
                                          child: Center(
                                            child:
                                            Image.asset("assets/stc.png")
                                          )
                                        ),
                                        ),
                                        SizedBox(
                                          width: (width/414) * 15,
                                        ),
                                        GestureDetector(
                                          onTap: (){
                                            setState(() {
                                              isCash = true;
                                              isIpay = false; isVisa = false; isMaster =false; isStc =false;
                                            });
                                          },
                                          child: Container(
                                              alignment: Alignment.topLeft,
                                              height: (height/896) *37,
                                              width:(width/414) * 55,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(8),
                                                  shape: BoxShape.rectangle,
                                                  color: isCash ? Palette.darkPink : Palette.greyWhite
                                              ),
                                              child: Center(
                                                  child:
                                                  Image.asset("assets/cash.png")
                                              )
                                          ),
                                        ),
                                      ]
                                    ),
                                  ],
                                ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: (height/896) *10,
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
                            width: (height/896) *5,
                          ),
                          GestureDetector(
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                LocaleKeys.i_agree,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: lngCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
                                  fontSize:  (height/896) *16 * zoom,
                                  letterSpacing: 1,
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
                        height: (height/896) *10,
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
                            child: loading ?  CircularProgressIndicator(
                              strokeWidth:  (height/896) * 2,
                              valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                            ) :Text(LocaleKeys.slied_to_checkout,
                              style: TextStyle(
                                fontFamily: lngCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
                                fontSize:  (height/896) *18* zoom,
                                color: isAgree ? Palette.whiteText : Palette.pinkBox,
                              ),
                            ).tr(),
                          ),
                        ),
                        onTap: (){
                          if(isAgree) {
                            setState(() {
                              loading = true;
                            });
                            getServiceList();
                          }else{
                            showSnackbar(context, "Please hit agree option", Colors.red);
                          }

                        },
                      ),
                    ],
                  ),

                ),

              ]
          ),
        ),
      );
    }


  getServiceList(){
    if(selectedService.isNotEmpty) {
      for (int i = 0; i < selectedService.length; i++) {
        Map<String, dynamic> services = {
          "service_id": selectedService[i].id,
          "employee_id": ""
        };
        detailsList.add(services);
      }
      newReservation();
    }else{
      showAlert(context, "Your order list empty");
    }

  }

  double totalPriceSum() {

    if(selectedService.isNotEmpty) {
      for (int i = 0; i < selectedService.length; i++) {
        total = total + double.parse(selectedService[i].price);

      }
    }
    return total;
  }

  Future<bool> newReservation() async {

    if(commentController.text == null){
      commentController.text = "NO COMMENT";
    }
    print("token $token companyId -$companyId customerId -$customerId");

    bool networkResults = await NetworkCheck.checkNetwork();
    var params = {"start_time":dateTime, "customer_comment":commentController.text, "customer_id":customerId, "type_reservation": "HOME_RESERVATION",  "company_id":companyId ,
      "details": detailsList
    };

    Options options = Options(headers: {"Accept-Language": lngCode,
      "Authorization": "Bearer " +token});
    if (networkResults) {
      try {
        Response response = await _dio.post(
            Repository.newReservation, data: params,
            options: options);

        if (response.statusCode == 200) {
          final item = response.data['data'];
          print("response data ${response.data}");

          String resID = item['id'];
          print("response id $resID");
          await SharedPreferencesHelper.setReservationID(resID);
          showSnackbar(context, "New Reservation added", Colors.blue);

          Future.delayed(const Duration(seconds: 1), () =>
              Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.fade,
                    child:  BottomNav(index: 0, subIndex:3),
                  )));

        } else {
          showAlert(context,"Something went wrong!");
        }
      } catch (e) {
        print("e $e");
        showAlert(context, "Something went wrong!");
      }
      return true;
    }else{
      showAlert(context, "No Internet!");
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
                                fontFamily: lngCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
                                fontSize:  (height/896) *22,
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
                                fontFamily: lngCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
                                fontSize:  (height/896) *16,
                                color: Palette.labelColor,
                              ),).tr(),
                          ),
                          onTap: () {
                            setState(() {
                              loading = false;
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
                Image.network(Repository.iconUrl+selectedService[index].image,
                  errorBuilder: (BuildContext context, Object exception, StackTrace stackTrace) {
                    print('payment::listItem: ImageNetwork error has occurred.');
                  return Image.asset("assets/background.png",
                      fit: BoxFit.fill,);
                  },):
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
                      fontFamily: lngCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
                      fontSize:  (height/896) *16,
                      color: Palette.pinkBox),
                 ),
                  Text(
                      '${selectedService[index].duration_min} min - ${selectedService[index].price} SAR',
                        style: TextStyle(
                            fontFamily: lngCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
                        fontSize:  (height/896) *11,
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
                      size:  (height/896) *17,)
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

  // listPayment(int index){
  //   return Container(
  //     height: (height/896) * 40,
  //     width: width,
  //     // padding: EdgeInsets.only(bottom: (height/896) * 1),
  //     child: Stack(
  //       children: [
  //         Positioned(
  //           top: (height/896) * 5,
  //           left: (width/414) * 1,
  //           child: Container(
  //             // padding: EdgeInsets.all(1.0),
  //             alignment: Alignment.topLeft,
  //               height: (height/896) *37,
  //               width:(width/414) * 55,
  //               decoration: BoxDecoration(
  //                   borderRadius: BorderRadius.circular(15),
  //                   shape: BoxShape.rectangle,
  //                   color: Palette.greyWhite
  //                   // image: new DecorationImage(
  //                   //   image: index == 0 ? new AssetImage("assets/master.png") :
  //                   //   index == 1 ?  new AssetImage("assets/ipay.png")
  //                   //       : new AssetImage("assets/cash.png"),
  //                   //   ),
  //                   ),
  //               child: Center(
  //                   child: index == 0 ?Image.asset("assets/master.png") :
  //               index == 1 ? Image.asset("assets/ipay.png") :
  //               Image.asset("assets/cash.png")
  //               )
  //               )
  //           ),
  //         Positioned(
  //             top: (height/896) * 18,
  //             left: (width/414) * 75,
  //             width: (width/414) * 170,
  //             child:Text(
  //               index == 0 ?'**** **** 3256' :
  //               index ==1 ? "Apple Pay":
  //               "Cash",
  //                 style: TextStyle(
  //                     fontFamily: lngCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
  //                     letterSpacing: 2,
  //                     fontSize:  (height/896) *16,
  //                     color: Palette.balckColor),
  //               ),
  //             ),
  //         Positioned(
  //           top: (height/896) * 15,
  //           left: (width/414) *  310,
  //           child: GestureDetector(
  //             child: Container(
  //               alignment: Alignment.center,
  //               decoration: BoxDecoration(
  //                 borderRadius: BorderRadius.circular(6),
  //                 color: selectPayment == index ? Palette.pinkBox : Color.fromRGBO(168, 132, 153, 0.20),
  //               ),
  //               height: (height/896) * 25,
  //               width: (height/896) * 30,
  //               child: Center(
  //                   child: Icon(Icons.check,
  //                     color: Palette.boxWhite,
  //                     size:  (height/896) *20,)
  //               ),
  //             ),
  //             onTap: (){
  //                selectPayment = index;
  //                 if(index == selectPayment)
  //                   setState(() {
  //                   isSelect = !isSelect;
  //                 });
  //             },
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  // }

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
              child: Padding(
                  padding: const EdgeInsets.all(0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
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
                              size:  (height/896) *20,)
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
                                fontFamily: lngCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
                                decoration: TextDecoration.none,
                                letterSpacing: 0.01,
                                fontSize:  (height/896) *23,
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
                                    fontFamily: lngCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
                                    decoration: TextDecoration.none,
                                    fontSize:  (height/896) *18* zoom,
                                    color: Palette.mainColor
                                ),
                                autofocus: false,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "${LocaleKeys.write_your_message_here}..".tr(),
                                    hintStyle: TextStyle(
                                        fontFamily: lngCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
                                        decoration: TextDecoration.none,
                                        fontSize:  (height/896) * 15 * zoom,
                                        fontWeight: FontWeight.normal,
                                        color: Palette.greyText
                                    )
                                ),
                              )
                            // child: TextField()
                          )
                      ),
                      GestureDetector(
                        child: Container(
                          margin:  EdgeInsets.only(top:  (height/896) * 15, bottom: (height/896) * 15),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Palette.pinkBox,
                          ),
                          height: (height/896) * 45,
                          width: (width/414) * 156,
                          child: Center(
                            child: Text(LocaleKeys.submit,
                              style: TextStyle(
                                fontFamily: lngCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
                                fontWeight: FontWeight.normal,
                                color: Palette.whiteText,
                                fontSize:  (height/896) *16* zoom,
                              ),).tr(),
                          ),
                        ),
                        onTap: (){
                          FocusScope.of(context).requestFocus(new FocusNode());
                          Navigator.pop(context);
                        },
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
      content: Text(msg,
        style: TextStyle(
            fontFamily: lngCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
            color: Colors.white,
            fontSize: (height/896) * 18* zoom,
        ),),
      backgroundColor: color,
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }
}