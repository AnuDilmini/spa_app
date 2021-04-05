
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:violet_app/bloc/get_city_bloc.dart';
import 'package:violet_app/model/city_response.dart';
import 'package:violet_app/model/company.dart';
import 'package:violet_app/network/repository.dart';
import 'package:violet_app/network/shared.dart';
import 'package:violet_app/pages/profile.dart';
import 'package:violet_app/style/palette.dart';
import 'package:page_transition/page_transition.dart';
import 'package:violet_app/style/local.keys.dart';
import 'package:easy_localization/easy_localization.dart';


import 'bottom_nav.dart';

class UpdateProfile extends StatefulWidget {

  UpdateProfile({Key key}) : super(key: key);

  @override
  _UpdateState createState() => _UpdateState();
}

class _UpdateState extends State<UpdateProfile> {

  double height, width;
  AlertDialog alert;
  final messageController = TextEditingController();
  bool isSearch = false;
  String lngCode = "en";
  List<String> cityList = ["Dammam"];
  String _cityValue ;


  @override
  void initState() {
    super.initState();

    checkDataSet();
  }

  checkDataSet() async {
    lngCode = await SharedPreferencesHelper.getLanguage();
    cityListBloc..getCity(lngCode);
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
                    width: width,
                    alignment: context.locale.languageCode== "en" ? Alignment.centerLeft : Alignment.centerRight,
                    child:
                    Icon(Icons.arrow_back_ios,
                      color: Colors.white,
                      size: 25,)
                  ),
                ),
                onTap: (){
                  Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.fade,
                        child:  BottomNav(index: 2, subIndex: 0),
                      ));
                },
              ),
            ),
            Positioned(
              top: (height/896) * 96,
              width: width,
              child:Center(
                child: Container(
                  height: (height/896) * 75,
                  width: (height/896) * 75,
                  child: Image.asset("assets/profile_edit3.png",
                      fit:  BoxFit. fill),
                ),
              ),
            ),
            Positioned(
              top: (height/896) * 170,
              left: (width/414) * 228,
              child:Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: (height/896) * 4),
                  height: (height/896) * 15,
                  width: (height/896) * 15,
                  child: Image.asset("assets/pen.png",
                      fit:  BoxFit. fill),
                ),
               Text(LocaleKeys.edit_photo,
               style: TextStyle(
                 fontSize: 16,
                 color: Palette.pinkBox,
               ),).tr(),
              ]
              ),
            ),
            Positioned(
            top: (height/896) * 235,
            left: (width/414) * 70,
            right: (width/414) * 70,
             child:Center(
                 child: Container(
                   width: width,
                   child: Column(
                   children: [
                     Container(
                       child: StreamBuilder<CityResponse>(
                           stream: cityListBloc.subject.stream,
                           builder: (context, AsyncSnapshot<CityResponse> snapshot) {
                             if (snapshot.hasData) {
                               if (snapshot.data.error != null &&
                                   snapshot.data.error.length > 0) {
                                 return _buildErrorWidget(snapshot.data.error);
                               }
                               return _buildCityList(snapshot.data);
                             } else if (snapshot.hasError) {
                               return _buildErrorWidget(snapshot.error);
                             } else {
                               return _buildLoadingWidget();
                             }
                           }
                       )
                     ),
                     Container(
                       margin: EdgeInsets.only(bottom: (height/896) * 20),
                       padding: EdgeInsets.only(left: (width/414) * 15, right: (width/414) * 15),
                       height: (height/896) * 44,
                       decoration: BoxDecoration(
                         borderRadius: BorderRadius.all(Radius.circular(20)),
                         color: Palette.whiteText,
                       ),
                       child:Center(
                         child: TextFormField(
                             autofocus: false,
                           decoration: InputDecoration(
                               border: InputBorder.none,
                             hintText: LocaleKeys.name.tr(),
                             hintStyle: TextStyle(
                               fontSize: 15,
                               color: Palette.labelColor,
                             )
                           )
                       ),
                       ),
                     ),
                     // Container(
                     //   margin: EdgeInsets.only(bottom: (height/896) * 20),
                     //   padding: EdgeInsets.only(left: (width/414) * 15, right: (width/414) * 15),
                     //   height: (height/896) * 41,
                     //   decoration: BoxDecoration(
                     //     borderRadius: BorderRadius.all(Radius.circular(20)),
                     //     color: Palette.whiteText,
                     //   ),
                     //   child:Center(
                     //     child: TextFormField(
                     //         decoration: InputDecoration(
                     //             border: InputBorder.none,
                     //             hintText: LocaleKeys.password.tr(),
                     //             hintStyle: TextStyle(
                     //               fontSize: 15,
                     //               color: Palette.labelColor,
                     //             )
                     //         )
                     //     ),
                     //   ),
                     // ),
                     Container(
                       margin: EdgeInsets.only(bottom: (height/896) * 20),
                       padding: EdgeInsets.only(left: (width/414) * 15, right: (width/414) * 15),
                       height: (height/896) * 44,
                       decoration: BoxDecoration(
                         borderRadius: BorderRadius.all(Radius.circular(20)),
                         color: Palette.whiteText,
                       ),
                       child:Center(
                         child: TextFormField(
                             decoration: InputDecoration(
                                 hintText: LocaleKeys.e_mail.tr(),
                                 border: InputBorder.none,
                                 hintStyle: TextStyle(
                                   fontSize: 15,
                                   color: Palette.labelColor,
                                 )
                             )
                         ),
                       ),
                     ),
                     Container(
                       margin: EdgeInsets.only(bottom: (height/896) * 20),
                       padding: EdgeInsets.only(left: (width/414) * 15, right: (width/414) * 15),
                       height: (height/896) * 44,
                       decoration: BoxDecoration(
                         borderRadius: BorderRadius.all(Radius.circular(20)),
                         color: Palette.whiteText,
                       ),
                       child:Center(
                         child: TextFormField(
                             decoration: InputDecoration(
                                 hintText: LocaleKeys.phone.tr(),
                                 border: InputBorder.none,
                                 hintStyle: TextStyle(
                                   fontSize: 15,
                                   color: Palette.labelColor,
                                 )
                             )
                         ),
                       ),
                     ),

                     Container(
                       margin: EdgeInsets.only(bottom: (height/896) * 20),
                       padding: EdgeInsets.only(left: (width/414) * 15, right: (width/414) * 15),
                       height: (height/896) * 44,
                       decoration: BoxDecoration(
                         borderRadius: BorderRadius.all(Radius.circular(20)),
                         color: Palette.whiteText,
                       ),
                       child:
                            Center(
                          child:
                         Container(
                           alignment: Alignment.centerLeft,
                                 child:DropdownButtonHideUnderline(
                                   child: DropdownButton<String>(
                                     isExpanded: true,
                                     value: _cityValue,
                                     hint:  Text(LocaleKeys.city,
                                     style: TextStyle(
                                       fontSize: 15,
                                       color: Palette.labelColor,
                                     )).tr(),
                                     onChanged: (value) async {

                                       setState(() {
                                         _cityValue = value;
                                       });
                                     },
                                     items: cityList.map((String value) {
                                       return DropdownMenuItem<String>(
                                         value: value,
                                         child: Container(
                                           width:  (width/414) * 200,
                                           child: Text(
                                                _cityValue.toString(),
                                                 style: TextStyle(
                                                     color: Palette.pinkBox,
                                                     fontSize: 16.0),
                                               ),
                                         ),
                                       );
                                     }).toList(),
                                   ),
                                 )),
                       ),
                       ),
                     Container(
                       margin: EdgeInsets.only(bottom: (height/896) * 20),
                       padding: EdgeInsets.only(left: (width/414) * 15, right: (width/414) * 15),
                       height: (height/896) * 44,
                       decoration: BoxDecoration(
                         borderRadius: BorderRadius.all(Radius.circular(20)),
                         color: Palette.whiteText,
                       ),
                       child:Center(
                         child: TextFormField(
                             decoration: InputDecoration(
                                 hintText: LocaleKeys.district.tr(),
                                 border: InputBorder.none,
                                 hintStyle: TextStyle(
                                   fontSize: 15,
                                   color: Palette.labelColor,
                                 )
                             )
                         ),
                       ),
                     ),
                     Container(
                       margin: EdgeInsets.only(bottom: (height/896) * 20),
                       padding: EdgeInsets.only(left: (width/414) * 15, right: (width/414) * 15),
                       height: (height/896) * 44,
                       decoration: BoxDecoration(
                         borderRadius: BorderRadius.all(Radius.circular(20)),
                         color: Palette.whiteText,
                       ),
                       child:Center(
                         child: TextFormField(
                             decoration: InputDecoration(
                                 hintText: LocaleKeys.building_number.tr(),
                                 border: InputBorder.none,
                                 hintStyle: TextStyle(
                                   fontSize: 15,
                                   color: Palette.labelColor,
                                 )
                             )
                         ),
                       ),
                     ),
                   ],
                 ),
               ),
             )
            ),
            Positioned(
              top: (height/896) * 701,
              left: (width/414) * 55,
              right: (width/414) * 55,
              child:GestureDetector(
                child: Center(
                child: Container(
                  height: (height/896) * 50,
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

  getCityList(){
    return StreamBuilder<CityResponse>(
        stream: cityListBloc.subject.stream,
        builder: (context, AsyncSnapshot<CityResponse> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.error != null &&
                snapshot.data.error.length > 0) {
              return _buildErrorWidget(snapshot.data.error);
            }
            return _buildCityList(snapshot.data);
          } else if (snapshot.hasError) {
            return _buildErrorWidget(snapshot.error);
          } else {
            return _buildLoadingWidget();
          }
        }
    );
  }

  Widget _buildErrorWidget(String error) {
    cityList.clear();
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Error occured: $error"),
          ],
        ));

  }

  Widget _buildCityList(CityResponse data) {

    List<City> cities = data.city;
    cityList.clear();

    if(cities.isNotEmpty) {

      for (int i = 0 ; i < cities.length ; i++){
        print("name*********** ${cities[i].name}");
        cityList.add(cities[i].name);
      }
    }
    return Container();


  }



  Widget _buildLoadingWidget() {
    cityList.clear();

    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(Palette.pinkBox),
                strokeWidth: 1.0,
              ),
            )
          ],
        ));

  }


}