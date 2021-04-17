import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:violet_app/network/repository.dart';
import 'package:violet_app/pages/payment.dart';
import 'package:violet_app/pages/profile.dart';
import 'package:violet_app/pages/select_time_date.dart';
import 'package:violet_app/pages/service_find.dart';
import 'package:violet_app/pages/setting.dart';
import 'package:violet_app/pages/update_profile.dart';
import 'package:violet_app/style/palette.dart';
import 'package:violet_app/style/local.keys.dart';
import 'package:easy_localization/easy_localization.dart';

import 'change_language.dart';
import 'change_password.dart';
import 'info_service.dart';
import 'location.dart';
import 'order_complete.dart';
import 'orders.dart';

class BottomNav extends StatefulWidget {
  int index;
  int subIndex;
  String lat = '';
  String lng = '';
  BottomNav({Key key, this.index,this.subIndex,
    this.lat,
    this.lng}) : super(key: key);

  @override
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {

  int _currentIndex = 0, subIndex , page;
  double height, width;
  String lanCode = "en";
  double zoom = 1;
  String _lat= "", _lng = "";

  List<Widget> _children = [];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.index;
    subIndex = widget.subIndex;
    _lat = widget.lat;
    _lng = widget.lng;
  

    _children = [
      ServiceFindPage(), //0
      Orders(),//1
      Profile(),//2
      InfoService(),//3
      Payment(),//4
      OrderComplete(),//5
      UpdateProfile(),
      Setting(),
      ChangeLang(),
      SelectTimeDate(),
      ChangePassword(),
      LocationPage(lat: _lat, lng: _lng),// 11
    ];

    // print("_currentIndex $_currentIndex, subIndex $subIndex ");
    if(_currentIndex == 0){
        if(subIndex == 1){
          page = 3;
        }else if(subIndex == 2){
          page = 4;
        } else if(subIndex == 3) {
          page = 5;
        }else if(subIndex == 4){
          page = 9;
        }else if(subIndex == 5){
          page = 11;
        }else{
            page = _currentIndex;
        }
    }
    else if(_currentIndex == 1 ){
      page = _currentIndex;
    }else if(_currentIndex == 2 ){
        if(subIndex ==1){
          page = 6;
        }else if(subIndex == 2) {
          page = 7;
        }else if(subIndex == 3){
          page = 8;
        }else if(subIndex == 4){
          page = 10;
        }else{
          page = _currentIndex;
        }
    }else{
       page = _currentIndex;
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

    lanCode = context.locale.languageCode;
    zoom = Repository.zoom;
    // if (lanCode == "ar") {
    //   zoom = 1.3;
    // } else {
    //   zoom = 1;
    // }

    return Scaffold(
      body: SizedBox.expand(
        child: _children[page],
      ),
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Palette.pinkBox,
        items:  <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Image(
              image:AssetImage('assets/white_art.png'),
              height: (height/896) * 30 ,
              width: (height/896) * 30 ,
            ),
            title: Text(LocaleKeys.violet ,
              style: TextStyle(
                fontFamily: lanCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
                color: Palette.whiteText,
                fontSize: (height/896) * 15 * zoom,
              ),
            ).tr()
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.menu,
              color: Colors.white,
              size: (height/896) * 25 ,
            ),
            title: Text(LocaleKeys.orders,
              style: TextStyle(
                fontFamily: lanCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
                color: Palette.whiteText,
                fontSize: (height/896) * 15 * zoom,
              ),
            ).tr()
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.account_circle,
              color: Colors.white,
              size: (height/896) * 25 ,
            ),
            title: Text(LocaleKeys.profile,
              style: TextStyle(
                fontFamily: lanCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
                color: Palette.whiteText,
                fontSize: (height/896) * 15 * zoom,
              ),
            ).tr()
          ),
        ],
        currentIndex: _currentIndex,
        unselectedFontSize:  (height/896) *18  * zoom,
        selectedFontSize: (height/896) * 18  * zoom,
          selectedItemColor: Palette.blurColor,
        onTap: (index){

         setState(() {
           _currentIndex = index;
           page = index;
         });
        },
      ),
    );
  }
}