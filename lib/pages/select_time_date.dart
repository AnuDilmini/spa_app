import 'dart:convert';

import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:provider/provider.dart';
import 'package:violet_app/bloc/reservation_date_time_bloc.dart';
import 'package:violet_app/model/companyService.dart';
import 'package:violet_app/model/reservationDateTime_response.dart';
import 'package:violet_app/network/repository.dart';
import 'package:violet_app/network/shared.dart';
import 'package:violet_app/style/local.keys.dart';
import 'package:violet_app/style/palette.dart';
import 'package:page_transition/page_transition.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:violet_app/utils/network_check.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

import 'bottom_nav.dart';
import 'home.dart';

class SelectTimeDate extends StatefulWidget {

  SelectTimeDate({Key key}) : super(key: key);

  @override
  _SelectTimeDate createState() => _SelectTimeDate();
}

class _SelectTimeDate extends State<SelectTimeDate> {

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  double height, width;
  AlertDialog alert;
  final mobileController = TextEditingController();
  final mobileRegController = TextEditingController();
  final TextEditingController _pinPutController = TextEditingController();
  List<dynamic> bookedList = new List<dynamic>();
  List<CompanyServices> selectedService = new List();
  final FocusNode _pinPutFocusNode = FocusNode();
  bool isInfo = false;
  bool isClickConfirm = true;
  bool isLoading = false;
  int currentPageIndex = 0;
  int weekPageIndex = 0;
  int selectedServiceCount = 0;
  int month = 4;
  String pin ;
  bool pinCorrect = false;
  bool selectTime = false;
  int selectedTime, selectedRealTime;
  DateTime _selectedDate;
  String lngCode = "en";
  double zoom = 1;
  String companyId;
  String customerId;
  String token;
  DateTime now = DateTime.now();
  List<String> months = ["January", "February", "March", "April",
  "May", "June", "July", "August", "September", "October", "November", "December"];
  final Dio _dio = Dio();
  List<String> time = ["1", "2", "3", "4",
    "5", "6", "7", "8", "9", "10", "11", "12",
    "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23",
    "24"];

  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      border: Border.all(color: Palette.textField),
      borderRadius: BorderRadius.circular(12.0),
    );
  }

  @override
  void initState() {
    super.initState();
    checkDataSet();
    zoom = Repository.zoom;

  }

  checkDataSet() async {
    lngCode = await SharedPreferencesHelper.getLanguage();
    // if (lngCode == "ar") {
    //   zoom = 1.2;
    // } else {
    //   zoom = 1;
    // }
    companyId = await SharedPreferencesHelper.getCompanyId();
    token = await SharedPreferencesHelper.getToken();
    customerId = await SharedPreferencesHelper.getCustomerID();

    String serviceListJson = await SharedPreferencesHelper.getSelectedService();
    postReservationDateTime();
    if (serviceListJson != "") {
      selectedService = CompanyServices.decode(serviceListJson);
      selectedServiceCount = selectedService.length;
    }
    _selectedDate = now;

    setState(() {
    });

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
      key: _scaffoldKey,
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
                  height: (height/896) * 55,
                  child: Image.asset("assets/pink_art.png",
                  ),
                ),
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
              top: (height/602) * 45,
              left:  (width/414) * 16 ,
              right:  (width/414) * 16 ,
              child:GestureDetector(
                child: Container(
                    alignment: context.locale.languageCode== "en" ? Alignment.centerLeft : Alignment.centerRight,
                    child:
                    Icon(Icons.arrow_back_ios,
                      color: Colors.white,
                      size: (height/896) *25,)
                ),
                onTap: (){
                  FocusScope.of(context).requestFocus(new FocusNode());
                  Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.fade,
                        child: BottomNav(index: 0, subIndex: 1),
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
                    padding: EdgeInsets.all(2.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Palette.lightPink,
                    ),
                    height: (height/896) * 37,
                    width: (width/414) * 50,
                    child: Icon(Icons.shopping_cart_outlined,
                        color: Palette.pinkBox,
                      size: (height/896) * 25,
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
            Positioned(
              top: (height/896) * 109,
              left: (width/414) * 50,
              child: selectedService.isEmpty ? Container() : Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Palette.pinkBox,
                  ),
                  height: (width/414) * 20,
                  width: (width/414) * 20,
                  child: Text("${selectedService.length}",
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: lngCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
                      fontSize: (height/896) * 12
                    ),
                  )
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
                    fontFamily: lngCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
                    color: Palette.darkPink,
                    fontSize: (height/896) *25,
                    fontWeight: FontWeight.w500,
                  ),).tr()
                 ),
                  SizedBox(
                    height: (height/896) *15,
                  ),
                  Container(
                    alignment: Alignment.center,
                    width : width,
                    height: (height/896) * 37,
                    child: ListView.builder(
                        padding: EdgeInsets.zero,
                        scrollDirection: Axis.horizontal,
                        itemCount: 5,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            width: 100,
                            padding: EdgeInsets.only(right: 10),
                              child: Text("Amli ",
                              style: TextStyle(
                                color: Palette.darkPink,
                                fontSize: (height/896) *23,
                                fontFamily: lngCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
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
                        fontFamily: lngCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
                        color: Palette.darkPink,
                        fontSize: (height/896) *25,
                        fontWeight: FontWeight.w500,
                      ),).tr()
                ),
            ),
            // Positioned(
            //   top: (height/896) * 339,
            //   left: (width/414) * 30,
            //   right: (width/414) * 30,
            //   child: Container(
            //       alignment: Alignment.topLeft,
            //       height: (height/896) * 37,
            //       width: width,
            //       child: Row(
            //         mainAxisAlignment: MainAxisAlignment.center,
            //           children: [
            //             GestureDetector(
            //             child: Icon(Icons.arrow_back_ios,
            //               color: Palette.pinkBox,
            //               size: 15,),
            //               onTap: (){
            //                 if(month> 0){
            //                   setState(() {
            //                     month = month -1;
            //                     currentPageIndex = currentPageIndex-1;
            //                   });
            //
            //                 }
            //               },
            //             ),
            //             SizedBox(
            //               width: 10,
            //             ),
            //           Container(
            //             alignment: Alignment.center,
            //             width: width/5,
            //               child: Text("${months[month]}",
            //         style: TextStyle(
            //           fontFamily: "Audrey-Medium",
            //           color: Palette.darkPink,
            //           fontSize: 18,
            //           fontWeight: FontWeight.w300,
            //         ),),
            //           ),
            //             SizedBox(
            //               width: 10,
            //             ),
            //           GestureDetector(
            //             child:  Icon(Icons.arrow_forward_ios,
            //               color: Palette.pinkBox,
            //               size: 15,),
            //           onTap: (){
            //               if(month< 11){
            //                 setState(() {
            //                   month = month +1;
            //                   currentPageIndex = currentPageIndex+1;
            //                 });
            //               }
            //           },
            //        ),
            //     ]
            //     ),
            //   ),
            // ),
            Positioned(
              top: (height/896) * 355,
              left: (width/414) * 30,
              right: (width/414) * 30,
              child:  Container(
                alignment: Alignment.topCenter,
                  child: CalendarTimeline(
                    initialDate: (_selectedDate == null)?now:_selectedDate,
                    firstDate: DateTime(now.year -1, 1, 15),
                    lastDate: now.add(Duration(days: 365)),
                    onDateSelected: (date) {
                      _selectedDate = date;
                    },
                    leftMargin: 0,
                    monthColor:  Palette.pinkBox,
                    dayColor: Palette.darkPink,
                    activeDayColor: Colors.white,
                    activeBackgroundDayColor: Palette.pinkBox,
                    dotsColor:  Palette.pinkBox,
                    //selectableDayPredicate: (date) => date.day != 23,
                    locale: "en"//context.locale.languageCode,
                  )
              ),
            ),
            Positioned(
              top: (height/896) * 522,
              left: (width/414) * 50,
              right: (width/414) * 30,
              child:   Container(
                  alignment: Alignment.topLeft,
                  height: (height/896) * 37,
                  width: width,
                  child: Text(LocaleKeys.available_time,
                    style: TextStyle(
                      fontFamily: lngCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
                      color: Palette.darkPink,
                      fontSize: (height/896) * 25 ,
                      fontWeight: FontWeight.w500,
                    ),).tr()
              ),
            ),
            // Positioned(
            //   top: (height/896) * 575,
            //   left: (width/414) * 50,
            //   right: (width/414) * 30,
            //   child: SfCalendar(
            //     view: CalendarView.week,
            //     timeSlotViewSettings: TimeSlotViewSettings(
            //       timeIntervalHeight: 100,
            //     ),
            //   ),
            // ),

              Positioned(
              top: (height/896) * 570,
              left: (width/414) * 30,
              right: (width/414) * 30,
              child: Container(
                height:(width/414) * 65,
                width: width,
                  child: ListView.builder(
                  padding: EdgeInsets.zero,
                  scrollDirection: Axis.horizontal,
                  itemCount: 24,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                        child: Container(
                          margin: EdgeInsets.only(right: (width/414) * 2),
                          width: (width/414) * 55,
                          height:(width/414) * 40,
                          decoration: BoxDecoration(
                            color: index == selectedTime ?  Palette.pinkBox :Colors.transparent,
                            borderRadius: index == selectedTime ? BorderRadius.all(Radius.circular(12)): BorderRadius.all(Radius.circular(0))
                          ),
                          child:Center(
                           child: Text(time[index],
                           style: TextStyle(
                             color: index == selectedTime ? Colors.white : Palette.darkPink,
                             fontSize: index == selectedTime ? (height/896) *26 : (height/896) *24,
                             fontWeight:  index == selectedTime ? FontWeight.bold : FontWeight.w500
                           ),),
                         ),
                        ),
                        onTap:(){

                            selectedTime = index;
                          setState(() {
                          });
                        }
                    );
                  }
              ),
              ),
            ),
            Positioned(
              top: (height/896) * 720,
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
             child: isLoading ? CircularProgressIndicator(
               valueColor: new AlwaysStoppedAnimation<Color>(Palette.whiteText),
               strokeWidth: 1.0,
             ): Text(
               LocaleKeys.confirm,
               style: TextStyle(
                 fontSize: (height/896) *26,
                 color: Palette.whiteText
               ),
             ).tr()
          ),
            onTap: () async{

              if(selectedTime == null){
                showSnackbar(context, "Please select time", Colors.red);
              }else {
                setState(() {
                  isLoading = true;
                });
                timeFormatter();
              }
            },
          ),
           ),
      ]
     ),
    );
  }

  timeFormatter() async{

    if (customerId != null) {
      String dateFormat = DateFormat('dd-MM-yyyy').format(_selectedDate);
      selectedRealTime = selectedTime +1;
      String dateTime = "$dateFormat $selectedRealTime:00:00";

      var inputFormat = DateFormat('dd-MM-yyyy HH:mm:ss');
      var inputDate = inputFormat.parse(dateTime);

      String formattedDate = DateFormat('dd-MM-yyyy hh:mm:ss').format(inputDate);
      await SharedPreferencesHelper.setDateTime(formattedDate);
      Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.fade,
            child: BottomNav(index: 0, subIndex: 2),
          ));
    } else {
      setState(() {
        isLoading = false;
      });
      showLoginDialog(context);
    }

  }

  @override
  void dispose() {
    super.dispose();
    mobileController.dispose();
    mobileRegController.dispose();
  }

  Future<bool> postReservationDateTime() async {
    ReservationDateTimeResponse result;
    bool networkResults = await NetworkCheck.checkNetwork();
    var params = {'company_id': "1829954f-2ebf-4754-83a5-e1e140e0526e"};
    Options options = Options(headers: {"Accept-Language": lngCode});
    if (networkResults) {
      try {
        Response response = await _dio.post(
            Repository.reservationsDateTime, data: params,
            options: options);
        if (response.statusCode == 200) {
          final item = response.data['data'];

          if(item.isNotEmpty){
            bookedList = item;
          }


        } else {
          showAlert(context,LocaleKeys.something_wrong);
        }
      } catch (e) {
        showAlert(context, LocaleKeys.something_wrong);
      }
      return true;
    }else{
      showAlert(context, LocaleKeys.no_internet);
    }
  }

  weekItem(int index){
    return Container(
      height: (height/896) * 200,
      width: width,
      child:
       Column(
         crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(right: (width/414) * 10 ),
                width: (width/414) * 50,
                height:(width/414) * 50,
                decoration: BoxDecoration(
                  color: Palette.greyBox,
                  shape: BoxShape.circle,
                ),
                // child: Text("${months[month]}"),
              ),
              Container(
                margin: EdgeInsets.only(right: (width/414) * 10 ),
                width: (width/414) * 50,
                height:(width/414) * 50,
                decoration: BoxDecoration(
                  color: Palette.greyBox,
                  shape: BoxShape.circle,
                ),
                // child: Text("1"),
              ),
              Container(
                margin: EdgeInsets.only(right: (width/414) * 10 ),
                width: (width/414) * 50,
                height:(width/414) * 50,
                decoration: BoxDecoration(
                  color: Palette.greyBox,
                  shape: BoxShape.circle,

                ),
                // child: Text("1"),
              ),
              Container(
                margin: EdgeInsets.only(right: (width/414) * 10 ),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(right: (width/414) * 10 ),
                  width: (width/414) * 50,
                  height:(width/414) * 50,
                  decoration: BoxDecoration(
                    color: Palette.greyBox,
                    shape: BoxShape.circle,
                  ),
                  // child: Text("${months[month]}"),
                ),
                Container(
                  margin: EdgeInsets.only(right: (width/414) * 10 ),
                  width: (width/414) * 50,
                  height:(width/414) * 50,
                  decoration: BoxDecoration(
                    color: Palette.greyBox,
                    shape: BoxShape.circle,
                  ),
                  // child: Text("1"),
                ),
                Container(
                  margin: EdgeInsets.only(right: (width/414) * 10 ),
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
        ],
      ),
    );
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
                                fontSize: (height/896) *26 * zoom,
                                fontFamily: lngCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
                                color: Palette.pinkBox,
                              ),).tr(),
                          )
                      ),
                      Container(
                        width: width,
                        // alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only( top: (height/896) *15, left: (width/414) * 18,  right: (width/414) * 18),
                        child: Text(LocaleKeys.we_just_need,
                          style: TextStyle(
                            fontSize: (height/896) *18 * zoom,
                            fontFamily: lngCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
                            color: Palette.labelColor,
                          ),).tr(),
                      ),
                      Container(
                        width: width,
                        // alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only( top: (height/896) *15, left: (width/414) * 18, right: (width/414) * 18),
                        child: Text(LocaleKeys.phone_number,
                          style: TextStyle(
                            fontFamily: lngCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
                            fontSize: (height/896) * 20 * zoom,
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
                        padding: EdgeInsets.only(left: (width/414) * 20, right: (width/414) * 20),
                        height: (height/896) * 57,
                        width: (width/414) * 312,
                        child: Center(
                          child: TextFormField(
                            controller: mobileRegController,
                            keyboardType: TextInputType.phone,
                            maxLines: 3,
                            style: TextStyle(
                                decoration: TextDecoration.none,
                                fontFamily: lngCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
                                fontSize: (height/896) *18 * zoom,
                                color: Palette.mainColor
                            ),
                            autofocus: false,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: LocaleKeys.enter_your_number.tr() ,
                                hintStyle: TextStyle(
                                    fontFamily: lngCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
                                    decoration: TextDecoration.none,
                                    fontSize: (height/896) *15 * zoom,
                                    fontWeight: FontWeight.normal,
                                  color: Color.fromRGBO(149, 152, 154, 0.38),
                                )
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(12),
                            color: Palette.textField,
                          ),
                          margin: EdgeInsets.only(top: (height/896) *5),
                          padding: EdgeInsets.only(left: (width/414) * 20,  right: (width/414) * 20),
                          height: (height/896) * 57,
                          width: (width/414) * 312,
                            alignment: Alignment.center,
                          child: TextFormField(
                            maxLines: 3,
                            style: TextStyle(
                                fontFamily: lngCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
                                fontSize: (height/896) *15 * zoom,
                                color: Palette.mainColor
                            ),
                            autofocus: false,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: LocaleKeys.your_name.tr(),
                              hintStyle: TextStyle(
                                fontFamily: lngCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
                                fontSize: (height/896) *15 * zoom,
                                color: Color.fromRGBO(149, 152, 154, 0.38),
                              ),
                            ),
                          )
                      ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only( top: (height/896) * 20, left: (width/414) * 18, right: (width/414) * 18),
                        child: Text(LocaleKeys.a_digit,
                          style: TextStyle(
                            fontFamily: lngCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
                            fontSize: (height/896) *17 * zoom,
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
                              fontFamily: lngCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
                              fontSize: (height/896) *18 * zoom,
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
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                               GestureDetector(
                                    child: Container(
                                        decoration: BoxDecoration(

                                        ),
                                        child: Text("${LocaleKeys.or_you_can_login}",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: lngCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
                                            fontSize: (height/896) * 14 * zoom,
                                            color: Palette.pinkBox,
                                          ),).tr()
                                    ),
                                    onTap: (){
                                      FocusScope.of(context).requestFocus(new FocusNode());
                                      Navigator.pop(context);
                                      showLoginDialog(context);
                                    }
                                ),
                                SizedBox(width: (width/414) * 10),
                                GestureDetector(
                                 child: Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(width: 1, color: Palette.pinkBox ),
                                    ),
                                  ),
                                  child: Text(LocaleKeys.login,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: lngCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
                                      fontSize: (height/896) *14 * zoom,
                                      fontWeight: FontWeight.bold,
                                      color: Palette.pinkBox,
                                    ),).tr(),
                                ),
                                    onTap: (){
                                      FocusScope.of(context).requestFocus(new FocusNode());
                                      Navigator.pop(context);
                                      showLoginDialog(context);
                                    }
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
                                size: (height/896) *20,)
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
                                fontFamily: lngCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
                                fontSize:  (height/896) *26* zoom,
                                color: Palette.pinkBox,
                              ),).tr(),
                          )
                      ),
                      Container(
                        margin: EdgeInsets.only( top: (height/896) * 50, left: (width/414) * 18, right: (width/414) * 18),
                        width: width,
                        child: Text(LocaleKeys.enter_the,
                          style: TextStyle(
                            fontFamily: lngCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
                            fontSize: (height/896) *16 * zoom,
                            color: Palette.labelColor,
                          ),).tr(),
                      ),
                      Container(
                        width: width,
                        padding: EdgeInsets.only( top: (height/896) *30, left: (width/414) * 18, right: (width/414) * 18),
                        child: Text("$mobile",
                          style: TextStyle(
                            fontFamily: lngCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
                            fontSize: (height/896) *16 * zoom,
                            color: Palette.pinkBox,
                          ),),
                      ),
                      Container(
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
                                  fontFamily: lngCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
                                  fontSize: (height/896) *24 * zoom,
                                  color: Palette.pinkBox,
                                  fontWeight: FontWeight.normal,
                                ),
                                // onSubmit: (String pin) => _showSnackBar(pin, context),
                                onSubmit: (String str){
                                  // setState((){
                                  if(str == otpReg){
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
                          width: width,
                          padding: EdgeInsets.only( top: (height/896) * 25, bottom: (height/896) *40,left: (width/414) * 18, right: (width/414) * 18),
                          child: Text(LocaleKeys.resend_otp,
                            style: TextStyle(
                              fontFamily: lngCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
                              fontSize: (height/896) *20 * zoom,
                              color: Palette.pinkBox,
                            ),).tr(),
                        ),
                        onTap: (){
                          FocusScope.of(context).requestFocus(new FocusNode());
                          Navigator.pop(context);
                          showLoginDialog(context);
                        },
                      ),
                      Container(
                        width: width,
                        padding: EdgeInsets.only( top: (height/896) * 25, bottom: (height/896) *40,left: (width/414) * 18, right: (width/414) * 18),
                        child: Text("OTP $otpReg",
                          style: TextStyle(
                            fontFamily: lngCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
                            fontSize: (height/896) *20 * zoom,
                            color: Palette.pinkBox,
                          ),),
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
                                fontFamily: lngCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
                                fontSize: (height/896) *25 * zoom,
                                color: Palette.pinkBox,
                              ),).tr(),
                          )
                      ),
                      Container(
                        width: width,
                        margin: EdgeInsets.only( top: (height/896) *15, left: (width/414) * 18,  right: (width/414) * 18),
                        child: Text(LocaleKeys.we_just_need,
                          style: TextStyle(
                            fontFamily: lngCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
                            fontSize: (height/896) *18 * zoom,
                            color: Palette.labelColor,
                          ),).tr(),
                      ),
                      Container(
                        width: width,
                        margin: EdgeInsets.only( top: (height/896) *15, left: (width/414) * 18, right: (width/414) * 18),
                        child: Text(LocaleKeys.phone_number,
                          style: TextStyle(
                            fontSize: (height/896) *20 * zoom,
                            color: Palette.pinkBox,
                            fontFamily: lngCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
                          ),).tr(),
                      ),
                      Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(12),
                            color: Palette.textField,
                          ),
                          alignment: Alignment.centerLeft,
                          // margin: EdgeInsets.only(top: (height/896) *10),
                          padding: EdgeInsets.only( left:(width/414) *10,right:(width/414) * 10),
                          height: (height/896) * 57,
                          width: (width/414) * 312,
                          child: Center(
                          child: TextFormField(
                            controller: mobileController,
                            keyboardType: TextInputType.phone,
                            maxLines: 3,
                            style: TextStyle(
                                fontFamily: lngCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
                                decoration: TextDecoration.none,
                                fontSize: (height/896) *18 * zoom,
                                color: Palette.mainColor
                            ),
                            autofocus: false,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: LocaleKeys.enter_your_number.tr() ,
                                hintStyle: TextStyle(
                                  fontFamily: lngCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
                                    decoration: TextDecoration.none,
                                    fontSize: (height/896) *15 * zoom,
                                    fontWeight: FontWeight.normal,
                                  color: Color.fromRGBO(149, 152, 154, 0.38),
                                )
                            ),
                          )
                          ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only( top: (height/896) *20, left: (width/414) * 18, right: (width/414) * 18 ),
                        child: Text(LocaleKeys.a_digit,
                          style: TextStyle(
                            fontSize: (height/896) *14 * zoom,
                            color: Palette.labelColor,
                            fontFamily: lngCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
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
                              fontFamily: lngCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
                              fontSize: (height/896) *18 * zoom,
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
                                      // border: Border(
                                      //   right: BorderSide(width: 1, color: Palette.pinkBox ),
                                      // ),
                                    ),
                                    child: Text(LocaleKeys.new_register_now,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: lngCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
                                        fontSize: (height/896) *14 * zoom,
                                        color: Palette.labelColor,
                                      ),).tr(),),
                                  onTap: (){
                                    FocusScope.of(context).requestFocus(new FocusNode());
                                    Navigator.pop(context);
                                    showRegisterDialog(context);
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 2,
                                height:  (height/896) * 24,
                                child: Container(
                                    color: Palette.pinkBox
                              ),
                              ),
                              Expanded(
                                flex:1,
                                child:
                                Container(
                                  decoration: BoxDecoration(
                                    // border: Border(
                                    //   left: BorderSide(width: 1, color: Palette.pinkBox ),
                                    // ),
                                  ),
                                  child: Text(LocaleKeys.forget_password,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: lngCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
                                      fontSize: (height/896) *14 * zoom,
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
                              size: (height/896) *24,)
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
                                fontFamily: lngCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
                                fontSize: (height/896) *26 * zoom,
                                color: Palette.pinkBox,
                              ),).tr(),
                          )
                      ),
                      Container(
                        width: width,
                        margin: EdgeInsets.only( top: (height/896) * 50, left: (width/414) * 18, right: (width/414) * 18),
                        child: Text(LocaleKeys.enter_the,
                          style: TextStyle(
                            fontFamily: lngCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
                            fontSize: (height/896) *16 * zoom,
                            color: Palette.labelColor,
                          ),).tr(),
                      ),
                      Container(
                        width: width,
                        padding: EdgeInsets.only( top: (height/896) *30, left: (width/414) * 18, right: (width/414) * 18),
                        child: Text("$mobile",
                          style: TextStyle(
                            fontFamily: lngCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
                            fontSize: (height/896) *16 * zoom,
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
                                  fontFamily: lngCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
                                  fontSize: (height/896) *24 * zoom,
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
                          width: width,
                          padding: EdgeInsets.only( top: (height/896) * 25, bottom: (height/896) *40,left: (width/414) * 18, right: (width/414) * 18),
                          child: Text(LocaleKeys.resend_otp,
                            style: TextStyle(
                              fontFamily: lngCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
                              fontSize: (height/896) *20 * zoom,
                              color: Palette.pinkBox,
                            ),).tr(),
                        ),
                        onTap: (){

                        },
                      ),

                      Container(
                        width: width,
                        padding: EdgeInsets.only( top: (height/896) * 25, bottom: (height/896) *40,left: (width/414) * 18, right: (width/414) * 18),
                        child: Text("$otpLogin",
                          style: TextStyle(
                            fontFamily: lngCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
                            fontSize: (height/896) *20 * zoom,
                            color: Palette.pinkBox,
                          ),).tr(),
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
    bool networkResults = await NetworkCheck.checkNetwork();
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
        if (responseCode == 201) {
          var parsedJson = json.decode(response.body);
          String mobile = parsedJson['user']['mobile'];
          int otp = parsedJson['user']['otp_password'];
          mobileController.clear();
          Navigator.pop(context);
          showOTPLogin(context, mobile, otp.toString());

        } else if (responseCode == 425) {
          Navigator.pop(context);
          showAlert(context, LocaleKeys.something_wrong);
        } else {
          Navigator.pop(context);
          showAlert(context, LocaleKeys.something_wrong);
        }
        return "Success";
      } catch (Exception) {
        setState(() {
        });
      }
    }else{
      showAlert(context, LocaleKeys.no_internet);
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
                                fontFamily: lngCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
                                fontSize: (height/896) *16,
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

  Future<String> register(BuildContext context) async {
    String url = Repository.registerNewCustomer;
    var response;

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
        if (responseCode == 200) {
          var convertData = json.decode(response.body);
          var mobile = convertData['data']['user']['mobile'];
          var otpReg = convertData['data']['user']['otp_password'];
          var userId = convertData['data']['user_id'];
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
        showAlert(context, LocaleKeys.something_wrong);
      }
    } else {
      showAlert(context, LocaleKeys.no_internet);

    }
    return "success";
  }

  Future<String> verifyOtp(BuildContext context, String mobileNo, String otp) async {
    String url = Repository.verifyOtpGetToken;
    var response;

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
        if (responseCode == 201) {
          var convertData = json.decode(response.body);

          token = convertData['token'];
          String userId = convertData['user']['id'];

          _pinPutController.clear();

          await SharedPreferencesHelper.setToken(token);
          await SharedPreferencesHelper.setCustomerID(userId);

          FocusScope.of(context).requestFocus(new FocusNode());
          Navigator.pop(context);

          showSnackbar(context, "Success", Palette.lightPink);

          Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.fade,
                child:  BottomNav(index: 0, subIndex:2),
              ));

        } else if (responseCode == 425) {
          Navigator.pop(context);
          showAlert(context, "Number already exist !");
        } else {
          Navigator.pop(context);
          showAlert(context, "Server error ! ");
        }
      } catch (Exception) {
        Navigator.pop(context);
        showAlert(context, LocaleKeys.something_wrong);
      }
    } else {
      Navigator.pop(context);
      showAlert(context,LocaleKeys.no_internet);


    }
    return "success";
  }

  showSnackbar(BuildContext context, String msg, Color color) {
    final snackBar = SnackBar(
      content: Text(msg,
      style: TextStyle(
        color: Colors.white,
          fontFamily: lngCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
        fontSize: (height/896) *18
      ),),
      backgroundColor: color,
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

}
