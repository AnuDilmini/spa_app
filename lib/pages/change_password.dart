
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/network/shared.dart';
import 'package:flutter_app/pages/profile.dart';
import 'package:flutter_app/style/palette.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter_app/style/local.keys.dart';
import 'package:easy_localization/easy_localization.dart';


import 'bottom_nav.dart';

class ChangePassword extends StatefulWidget {

  ChangePassword({Key key}) : super(key: key);

  @override
  _ChangePassword createState() => _ChangePassword();
}

class _ChangePassword extends State<ChangePassword> {

  double height, width;
  AlertDialog alert;
  final messageController = TextEditingController();
  bool isSearch = false;
  int selectedRadio ;
  String lanCode;


  @override
  void initState()  {
    super.initState();

    getLang();
  }

  getLang() async{
    lanCode = await SharedPreferencesHelper.getLanguage();
    print("lanCode ***$lanCode");
    if(lanCode == "en"){
      setState(() {
        selectedRadio = 1;
      });
    }else if(lanCode == "ar"){
      setState(() {
        selectedRadio = 2;
      });
    }else{
      setState(() {
        selectedRadio = 1;
      });
    }
  }


  setSelectedRadio(int val) {
    setState(() {
      selectedRadio = val;
    });
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
      // backgroundColor: Color(0xFFF5F2EF),
      body: SingleChildScrollView(
        child : Stack(
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
                left: (width/414) * 305,
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
                top: (height/602) * 45,
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
                          child:  BottomNav(index: 2, subIndex: 2),
                        ));
                  },
                ),
              ),
              Positioned(
                top: (height/602) * 210,
                left:  (width/414) * 40,
                child: Center(
                  child: Container(
                      child:
                      Text(LocaleKeys.change_language,
                        style: TextStyle(
                          fontSize: 18,
                          color: Palette.pinkBox,
                        ),).tr()
                  ),
                ),
              ),
              Positioned(
                top: (height/602) * 235,
                left:  (width/414) * 35,
                right:  (width/414) * 80,
                child: Center(
                  child: Container(
                    padding: EdgeInsets.only(left: (width/414) * 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                        color:  Palette.whiteText
                      ),
                      height: (height/602) * 30,
                      width: width,
                      child:
                      TextFormField(
                        maxLines: 1,
                        style: TextStyle(
                            decoration: TextDecoration.none,
                            fontSize: 16,
                            color: Palette.mainColor
                        ),
                        autofocus: false,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: LocaleKeys.enter_pass.tr(),
                            hintStyle: TextStyle(
                                decoration: TextDecoration.none,
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                color: Palette.greyText
                            )
                        ),
                      )
                  ),
                ),
              ),

              Positioned(
                top: (height/602) * 280,
                left:  (width/414) * 40,
                child: Center(
                  child: Container(
                      child:
                      Text(LocaleKeys.renter_pass,
                        style: TextStyle(
                          fontSize: 18,
                          color: Palette.pinkBox,
                        ),).tr()
                  ),
                ),
              ),
              Positioned(
                top: (height/602) * 305,
                left:  (width/414) * 35,
                right:  (width/414) * 80,
                child: Center(
                  child: Container(
                      padding: EdgeInsets.only(left: (width/414) * 15),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                          color:  Palette.whiteText
                      ),
                      height: (height/602) * 30,
                      width: width,
                      child:
                      TextFormField(
                        maxLines: 1,
                        style: TextStyle(
                            decoration: TextDecoration.none,
                            fontSize: 16,
                            color: Palette.mainColor
                        ),
                        autofocus: false,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: LocaleKeys.renter_your.tr(),
                            hintStyle: TextStyle(
                                decoration: TextDecoration.none,
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                color: Palette.greyText
                            )
                        ),
                      )
                  ),
                ),
              ),

              Positioned(
                top: (height/896) * 701,
                left: (width/414) * 55,
                right: (width/414) * 55,
                child:GestureDetector(
                  child: Center(
                    child: Container(
                      height: (height/896) * 45,
                      width: width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      child: Card(
                        color: Palette.pinkBox,
                        shadowColor: Palette.balckColor,
                        elevation: 4,
                        child:
                        Center(
                          child: Text(LocaleKeys.update,
                            style: TextStyle(
                              fontSize: 20,
                              color: Palette.whiteText,
                            ),).tr(),
                        ),
                      ),
                    ),
                  ),
                  onTap: (){
                    FocusScope.of(context).requestFocus(new FocusNode());
                  },
                ),
              ),
            ]
        ),
      ),
    );
  }
}