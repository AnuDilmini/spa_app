
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:violet_app/network/shared.dart';
import 'package:violet_app/style/palette.dart';
import 'package:page_transition/page_transition.dart';
import 'package:violet_app/style/local.keys.dart';
import 'package:easy_localization/easy_localization.dart';

import 'bottom_nav.dart';

class ChangeLang extends StatefulWidget {

  ChangeLang({Key key}) : super(key: key);

  @override
  _ChangeLang createState() => _ChangeLang();
}

class _ChangeLang extends State<ChangeLang> {

  double height, width;
  AlertDialog alert;
  final messageController = TextEditingController();
  bool isSearch = false;
  int selectedRadio;
  String lanCode;
  double zoom = 1;

  @override
  void initState()  {
    super.initState();

    getLang();
  }

  getLang() async{
    lanCode = await SharedPreferencesHelper.getLanguage();

    if (lanCode == "en") {
      setState(() {
        selectedRadio = 1;
        zoom = 1;
      });
    } else if(lanCode == "ar") {
      setState(() {
        selectedRadio = 2;
        zoom = 1.5;
      });
    } else {
      setState(() {
        selectedRadio = 1;
        zoom = 1;
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
    messageController.dispose();
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
                right:  (width/414) * 16 ,
                child:GestureDetector(
                  child: Container(
                      alignment: lanCode == "en" ? Alignment.centerLeft : Alignment.centerRight,
                      child:
                      Icon(Icons.arrow_back_ios,
                      color: Colors.white,
                      size: (height/896) * 25,)
                  ),
                  onTap: (){

                    FocusScope.of(context).requestFocus(new FocusNode());
                    Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.fade,
                          child: BottomNav(index: 2, subIndex: 2),
                        ));
                  },
                ),
              ),
              Positioned(
                top: (height/602) * 210,
                left:  (width/414) * 16 ,
                right:  (width/414) *20 ,
                child: Center(
                    child: Container(
                        width: width,
                      child:
                      Text(LocaleKeys.change_language,
                        style: TextStyle(
                          fontFamily: lanCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
                          fontSize: (height/896) * 20 * zoom,
                          color: Palette.pinkBox,
                        ),).tr()
                    ),
                  ),
              ),
              Positioned(
                top: (height/602) * 235,
                left:  (width/414) * 16 ,
                right:  (width/414) * 16 ,
                child: Center(
                    child: Container(
                      height: (height/602) * 180,
                      width: width,
                      child:
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          RadioListTile(
                            value: 1,
                            groupValue: selectedRadio,
                            title: Text(LocaleKeys.english,
                              style: TextStyle(
                                fontFamily: lanCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
                              fontSize: (height/896) * 18 * zoom,
                              color: Palette.pinkBox,
                            ),).tr(),
                            activeColor: Palette.pinkBox,
                            onChanged: (val) async{

                              setSelectedRadio(val);

                              context.locale = Locale('en', 'US');

                              await  SharedPreferencesHelper.setLanguage("en");
                            },
                          ),

                          RadioListTile(
                          value: 2,
                            title: Text(LocaleKeys.arabic,
                              style: TextStyle(
                                fontFamily: lanCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
                                fontSize: (height/896) * 18 * zoom,
                                color: Palette.pinkBox,
                              ),).tr(),
                          groupValue: selectedRadio,
                          activeColor: Palette.pinkBox,
                          onChanged: (val) async {
                            setSelectedRadio(val);
                            context.locale = Locale('ar', '');

                            await  SharedPreferencesHelper.setLanguage("ar");

                          },
                        ),

                        ],
                      )
                    ),
                  ),
              ),

              Positioned(
                top: (height/896) * 600,
                left: (width/414) * 55,
                right: (width/414) * 55,
                child:GestureDetector(
                  child: Center(
                    child: Container(
                      height: (height/896) * 45 * zoom,
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
                              fontFamily: lanCode == "en"? 'Audrey-Medium': 'ArbFONTS-026',
                              fontSize: (height/896) * 20 * zoom,
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