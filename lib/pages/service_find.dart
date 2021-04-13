import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:violet_app/bloc/get_category_bloc.dart';
import 'package:violet_app/bloc/get_company_bloc.dart';
import 'package:violet_app/model/category.dart';
import 'package:violet_app/model/category_response.dart';
import 'package:violet_app/model/company.dart';
import 'package:violet_app/model/company_response.dart';
import 'package:violet_app/network/repository.dart';
import 'package:violet_app/network/shared.dart';
import 'package:violet_app/pages/home.dart';
import 'package:violet_app/style/local.keys.dart';
import 'package:violet_app/style/palette.dart';
import 'package:violet_app/utils/network_check.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:page_transition/page_transition.dart';
import 'package:http/http.dart' as http;
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:path_provider/path_provider.dart';

import 'bottom_nav.dart';
import 'info_service.dart';

class ServiceFindPage extends StatefulWidget {

  final String lngCode;
  ServiceFindPage({Key key, this.lngCode}) : super(key: key);

  @override
  _ServiceFindPageState createState() => _ServiceFindPageState();
}

class _ServiceFindPageState extends State<ServiceFindPage> {

  double height, width;
  AlertDialog alert;
  bool clickCategory = false;
  final messageController = TextEditingController();
  final searchController = TextEditingController();
  bool isSearch = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isApiCompleted = false;
  List<dynamic> companyList = new List<dynamic>();
  List<String> selectedCatList = new List<String>();
  List<Category> category =  new List<Category>();
  List<Company> company  =  new List<Company>();
  var dir;
  File file;
  String lngCode = "en";
  SharedPreferences prefs;
  int curTime, jsonTime, difference;
  int clickCategoryIndex ;
  bool isNoInternet = false;

  @override
  void initState() {
    super.initState();
    checkDataSet();
  }

  checkDataSet() async {

    lngCode = await SharedPreferencesHelper.getLanguage();
    bool networkResults = await NetworkCheck.checkNetwork();

    if (networkResults) {
      setState(() {
        isNoInternet =false;
      });
      companyListBloc..getCompany(lngCode, "company", []);
      categoryListBloc..getCategory(lngCode);
    }else{
      setState(() {
        isNoInternet =true;
      });
    }

  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    SystemChrome.setEnabledSystemUIOverlays([]);

    return  Scaffold(
        key: _scaffoldKey,
        body: Stack(
            children: [
              Container(
                height: height * 1.2,
                width: width,
                // color: Palette.whiteText,
              ),
              Positioned(
                top:0,
                width: width,
                height: height/2.5,
                child:Center(
                  child: Container(
                      width: width,
                      height: height/2.5,
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          image: new DecorationImage(
                            image: new AssetImage("assets/dot3.png"),
                            fit: BoxFit.fill,
                          )
                      )
                  ),
                ),
              ),
              Positioned(
                top: (height/449) * 6,
                width: width,
                child:Center(
                  child: Container(
                    width: (width/414) * 90,
                    height: (width/602) * 90,
                    child:
                    Image.asset('assets/artboard_white.png',

                      // fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: (height/602) * 44,
                left:  (width/414) * 16,
                right:  (width/414) * 16,
                child:GestureDetector(
                  child: Container(
                      alignment: context.locale.languageCode== "en" ? Alignment.centerLeft : Alignment.centerRight,
                      width: width,
                      child:
                        Icon(Icons.arrow_back_ios,
                          size:  (height/896) *25,
                          color: Palette.whiteText,
                        )
                  ),
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                  },
                ),
              ),
              isSearch ?  Container() : Positioned(
                top: (height/449) * 70,
                left: 15,
                child:Text(
                  LocaleKeys.welcome,
                  style: TextStyle(
                      letterSpacing: 1,
                      fontSize: (height/896) * 24,
                      color:  Palette.whiteText,
                      fontFamily: "Audrey-Medium"),
                ).tr(),
              ),
              Positioned(
                top: (height/449) * 69,
                left:  isSearch ? (width/208) * 60 :  (width/208) * 173,
                right:  (width/208) * 10 ,
                child: isSearch ? GestureDetector(
                  child: Container(
                    padding: EdgeInsets.only(left: 5, right: 5),
                    height: (height/448) * 20,
                    decoration: BoxDecoration(
                      color: Palette.greyBox,
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    child : Row(
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            // padding: EdgeInsets.only( right:(width/208) * 5),
                            width: (width/208) * 112,
                            child:
                            TextFormField(
                              controller : searchController,
                              cursorColor: Palette.pinkBox,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: tr(LocaleKeys.what_you_are_looking),
                                hintStyle: TextStyle(
                                  color: Palette.textGrey,
                                  fontSize: (height/896) * 21
                                )
                              ),
                              onChanged: (content) {
                                if(searchController.text.length > 3){

                                  searchCategory();

                                }else if(searchController.text.length == 0){
                                  selectedCatList.clear();
                                  setState(() {

                                  });
                                  companyListBloc..getCompany(lngCode, "company", [] );

                                }else{
                                  selectedCatList.clear();
                                  setState(() {

                                  });
                                }
                              },
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(5.0),
                            child:
                            Image.asset('assets/search.png',),
                          ),
                        ]
                      // child: Image.asset('assets/search.png',
                      // fit: BoxFit.fitHeight,
                    ),
                  ),
                  onTap: (){
                    setState(() {
                      isSearch = !isSearch;
                    });
                  },
                ): GestureDetector(
                  child: Container(
                    padding: EdgeInsets.all(5.0),
                    width: (width/208) * 25,
                    height: (height/448) * 20,
                    decoration: BoxDecoration(
                      color: Palette.greyBox,
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    child:
                    Image.asset('assets/search.png',),
                  ),
                  onTap: (){
                    setState(() {
                      isSearch = !isSearch;
                    });
                  },
                ),
              ),
              Positioned(
                top: (height/449) * 96,
                left: 15,
                child:Text(
                  LocaleKeys.find_service,
                  style: TextStyle(
                      letterSpacing: 1,
                      fontSize: (height/896) *30,
                      color:  Palette.whiteText,
                      fontFamily: "Audrey-Medium"),
                ).tr(),
              ),
              Positioned(
                  top: (height/449) * 120,
                  left:  0,
                  child: isNoInternet ?
                      Center(
                          child: Container(
                            width: width,
                            height:  (width/208) *50,
                            alignment: Alignment.center,
                            child: Text("",
                            style: TextStyle(
                              fontSize:   (height/896) * 18,
                                color:  Palette.whiteText,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Audrey-Normal"

                            ),).tr(),
                          )
                      ):
                       Container(
                      width: width,
                      height:  (width/208) *50,
                      child: StreamBuilder<CategoryResponse>(
                          stream: categoryListBloc.subject.stream,
                          builder: (context, AsyncSnapshot<CategoryResponse> snapshot) {
                            if (snapshot.hasData) {
                              if (snapshot.data.error != null &&
                                  snapshot.data.error.length > 0) {
                                return _buildErrorWidget(snapshot.data.error);
                              }
                              return _buildCategoryWidget(snapshot.data);
                            } else if (snapshot.hasError) {
                              return _buildErrorWidget(snapshot.error);
                            } else {
                              return _buildLoadingWidget();
                            }
                          })
                  ),
              ),
              Positioned(
                top: (height/449) * 185,
                width: width,
                child:Center(
                    child:  isNoInternet ?
                    Center(
                        child: Container(
                          width: width,
                          height:  (width/208) *50,
                          alignment: Alignment.center,
                          child: Text(LocaleKeys.no_internet,
                            style: TextStyle(
                                fontSize:   (height/896) * 18,
                                color:  Palette.pinkBox,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Audrey-Normal"

                            ),).tr(),
                        )
                    ):
                    StreamBuilder<CompanyResponse>(
                        stream: companyListBloc.subject.stream,
                        builder: (context, AsyncSnapshot<CompanyResponse> snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data.error != null &&
                                snapshot.data.error.length > 0) {
                              return _buildErrorWidget(snapshot.data.error);
                            }
                            return _buildCompanyWidget(snapshot.data);
                          } else if (snapshot.hasError) {
                            return _buildErrorWidget(snapshot.error);
                          } else {
                            return _buildLoadingWidget();
                          }
                        })

                ),
              ),
            ]
        )
    );
  }

  void searchCategory(){

    if(category.isNotEmpty){

      for(int i = 0; i< category.length; i++){
        if(category[i].name.toLowerCase().contains(searchController.text.toLowerCase())){
          selectedCatList.clear();
          selectedCatList.add(category[i].id.toString());

          companyListBloc
            ..getCompany(
                lngCode, "companies_by_category",
                selectedCatList);

          setState(() {

          });

          break;
        }else {
          selectedCatList.clear();
          // companyListBloc..getCompany(lngCode, "company", [] );

          for (int j = 0; j < company.length; j++) {


            if (company[j].name.toLowerCase().contains(
                searchController.text.toLowerCase())) {

              Company selectedCom = company[j];
              company.clear();
              company.add(selectedCom);

              setState(() {

              });

              break;
            }
          }
        }

        }
      } else{

    }

  }

  Widget _buildLoadingWidget() {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: (height/896) *25.0,
              width: 25.0,
              child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(Palette.pinkBox),
                strokeWidth: 4.0,
              ),
            )
          ],
        ));
  }

  Widget _buildErrorWidget(String error) {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Error occured: $error"),
          ],
        ));
  }

  Widget _buildCompanyWidget(CompanyResponse data) {

    company  =  data.company;

    if (company.length == 0) {
      return Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Column(
              children: <Widget>[
                Text(
                  "No More Companies",
                  style: TextStyle(color: Colors.black45),
                )
              ],
            )
          ],
        ),
      );
    }
    else
      return Container(
        width : width,
        height:(height/2),
        child: ListView.builder(
            padding: EdgeInsets.zero,
            scrollDirection: Axis.vertical,
            itemCount:company.length,
            itemBuilder: (BuildContext context, int index) {
              return
                GestureDetector(
                    child: Container(
                        width: width,
                        decoration: BoxDecoration(
                          color: Palette.lightPink,
                          borderRadius: BorderRadius.all(Radius.circular(18)),
                        ),
                        margin: EdgeInsets.only(right: (width/208) * 10, left: (width/208) * 10 , bottom: (width/208) * 8),
                        height:  (height/449) * 45,
                        child: Row(
                            children: [
                              Container(
                                width:  (width/208) * 57,
                                child: company[index].image != null ? ClipRRect(
                                  borderRadius: BorderRadius.circular(18.0),
                                  child: Image.network(Repository.iconUrl+company[index].image,
                                  fit: BoxFit.fill,
                                  errorBuilder: (BuildContext context, Object exception, StackTrace stackTrace) {
                                    print('service_find::_buildCompanyWidget: ImageNetwork error has occurred.');
                                    return ClipRRect(
                                        borderRadius: BorderRadius.circular(18.0),
                                    child:Image.asset("assets/background.png",
                                      fit: BoxFit.fill,)
                                    );
                                  },)
                                )
                                    :
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(18.0),
                                  child: new Image.asset("assets/background.png",
                                  fit: BoxFit.fill,),
                                ),
                              ),
                              Container(
                                  padding: EdgeInsets.only(left:  (width/208) * 5, top:  (height/449) * 5 , right: (height/449) * 5),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width:  (width/208) *120,
                                        child:Text("${company[index].name}",
                                          overflow: TextOverflow.clip,
                                          maxLines: 1,
                                          style: TextStyle(
                                              fontSize: (height/896) * 18,
                                              color:  Palette.pinkText,
                                              fontWeight: FontWeight.w900,
                                              fontFamily: "Audrey-Normal"

                                          ),),
                                      ),
                                      Container(
                                        child:Text("- Salon",
                                          overflow: TextOverflow.clip,
                                          style: TextStyle(
                                              fontSize: (height/896) *15,
                                              color:  Palette.pinkText,
                                              fontWeight: FontWeight.w600,
                                              fontFamily: "Audrey-Normal"
                                          ),),
                                      ),
                                      Container(
                                        child: Row(
                                          children: [
                                            Container(
                                              width: (width/208) *75,
                                              child:
                                              Text("${company[index].city.name}",
                                                maxLines: 1,
                                                overflow: TextOverflow.clip,
                                                style: TextStyle(
                                                    fontSize: (height/896) *17,
                                                    color:  Palette.pinkText,
                                                    fontWeight: FontWeight.w600,
                                                    fontFamily: "Audrey-Normal"
                                                ),
                                              ),
                                            ),
                                            Container(
                                              alignment: Alignment.centerLeft,
                                              // width: (width/208) * 12,
                                              child:
                                              Text("${company[index].rating} ",
                                                style: TextStyle(
                                                    fontSize: (height/896) *18,
                                                    color:  Palette.pinkText,
                                                    fontWeight: FontWeight.w600,
                                                    fontFamily: "Audrey-Normal"
                                                ),
                                              ),
                                            ),
                                            Container(
                                              alignment: Alignment.centerRight,
                                              child: RatingBar.builder(
                                                ignoreGestures: true,
                                                initialRating: double.parse((company[index].rating)),
                                                minRating: 1,
                                                direction: Axis.horizontal,
                                                allowHalfRating: true,
                                                itemCount: 5,
                                                itemSize: width / 35,
                                                unratedColor: Palette.greyText,
                                                itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                                                itemBuilder: (context, _) => Icon(
                                                  Icons.star,
                                                  color: Colors.yellow,
                                                ),
                                                onRatingUpdate: (rating) {
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                              )
                            ]
                        )
                    ),
                    onTap:() async{
                      await SharedPreferencesHelper.setCompanyId(
                          company[index].id);
                      Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.fade,
                            child:  BottomNav(index: 0, subIndex: 1),
                          ));
                    }
                );
            }
        ),
      );
  }

  Widget _buildCategoryWidget(CategoryResponse data) {
    category = data.category;
    if (category.length == 0) {
      return Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Column(
              children: <Widget>[
                Text(
                  "No More Categories",
                  style: TextStyle(color: Colors.white),
                )
              ],
            )
          ],
        ),
      );
    }
    else {
      return Container(
          width: width,
          height: (height / 2),
          child: ListView.builder(
              padding: EdgeInsets.zero,
              scrollDirection: Axis.horizontal,
              itemCount: category.length,
              itemBuilder: (BuildContext context, int index) {
                return

                    GestureDetector(
                      child: Container(
                        padding: EdgeInsets.only(
                            left: index == 0 ? (width / 208) * 1 : 0),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                    right: (width / 208) * 0),
                                width: (width / 208) * 28,
                                height: (width / 208) * 28,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: (selectedCatList.contains(category[index].id.toString())) ?  Palette.pinkText :  Palette.greyBox
                                ),
                                child: category[index].icon != null ?
                                Image.network(Repository.iconUrl+category[index].icon,
                                  errorBuilder: (BuildContext context, Object exception, StackTrace stackTrace) {
                                    print('service_find::_buildCategoryWidget: ImageNetwork error has occurred.');
                                  return Image.asset("assets/background.png",
                                      fit: BoxFit.fill,);
                                  },
                                  ):
                                Image.asset("assets/eyes.png"),
                              ),
                              Center(
                                child: Container(
                                  width: (width / 208) * 50,
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.only(left: 0, top: 5),
                                  child: Text("${category[index].name}",
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.clip,
                                    maxLines: 2,
                                    style: TextStyle(
                                      fontSize: (height/896) *15,
                                      color: Palette.whiteText,
                                    ),),
                                ),
                              ),
                            ]
                        ),
                      ),
                      onTap: () async {

                        clickCategoryIndex = index;
                        await SharedPreferencesHelper.setCompanyId(
                            category[index].id.toString());


                        if(selectedCatList.contains(category[index].id.toString())){
                          selectedCatList.remove(category[index].id.toString());

                          searchController.clear();

                        }else{
                          selectedCatList.add(category[index].id.toString());

                        }
                        if(selectedCatList.length == 0){
                          companyListBloc..getCompany(lngCode, "company", [] );

                        }else {
                          companyListBloc
                            ..getCompany(
                                lngCode, "companies_by_category",
                                selectedCatList);
                        }

                        // }
                        setState(() {
                          if(clickCategoryIndex == index) {
                            clickCategory = true;
                          }
                        });
                      }
                  );
              }
          )
      );
    }
  }




  showSnackbar(BuildContext context, String msg) {
    final snackBar = SnackBar(
      content: Text(msg),
      backgroundColor: Colors.red,
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

}
