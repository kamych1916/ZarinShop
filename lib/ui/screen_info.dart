import 'package:Zarin/ui/screen_info_delivery.dart';
import 'package:Zarin/ui/screen_info_garant.dart';
import 'package:Zarin/utils/app_icons.dart';
import 'package:Zarin/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class InfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Styles.subBackgroundColor,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(40),
          child: AppBar(
            brightness: Brightness.light,
            backgroundColor: Styles.subBackgroundColor,
            iconTheme: new IconThemeData(color: Colors.black87),
            elevation: 0,
            centerTitle: true,
            leading: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              behavior: HitTestBehavior.translucent,
              child: Container(
                child: Icon(
                  Icons.arrow_back_ios,
                  size: 16,
                ),
              ),
            ),
            title: Text(
              "Приложение",
              overflow: TextOverflow.fade,
              style: TextStyle(
                  color: Colors.black87,
                  fontFamily: "SegoeUIBold",
                  fontSize: 18),
            ),
          ),
        ),
        body: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
              ),
              Row(
                children: [
                  Expanded(
                      child: Text(
                    "Язык приложения",
                    style: TextStyle(fontFamily: "SegoeUiSemiBold"),
                  )),
                  DropdownButton<String>(
                    isDense: true,
                    dropdownColor: Styles.backgroundColor,
                    elevation: 1,
                    icon: Icon(
                      Icons.arrow_forward_ios,
                      size: 10,
                    ),
                    underline: Container(),
                    onChanged: (value) {},
                    items: [
                      DropdownMenuItem(
                        child: Text(
                          "Русский",
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                      DropdownMenuItem(
                        child: Text(
                          "Узбекский",
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
              ),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => pushNewScreen(
                  context,
                  screen: GarantInfoScreen(),
                  withNavBar: true,
                  pageTransitionAnimation: PageTransitionAnimation.fade,
                ),
                child: Row(
                  children: [
                    Expanded(
                        child: Text(
                      "Гарантия качества",
                      style: TextStyle(fontFamily: "SegoeUiSemiBold"),
                    )),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 10,
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
              ),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => pushNewScreen(
                  context,
                  screen: DeliveryInfoScreen(),
                  withNavBar: true,
                  pageTransitionAnimation: PageTransitionAnimation.fade,
                ),
                child: Row(
                  children: [
                    Expanded(
                        child: Text(
                      "Доставка",
                      style: TextStyle(fontFamily: "SegoeUiSemiBold"),
                    )),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 10,
                    )
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Icon(
                            AppIcons.phone_handset,
                            size: 18,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                          ),
                          SelectableText(
                            "+998 (78) 150-00-02",
                            style: TextStyle(
                                fontSize: 11.0, fontFamily: "SegoeUISemiBold"),
                          )
                        ],
                      ),
                      Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                      Row(
                        children: [
                          Icon(
                            AppIcons.map_marker,
                            size: 18,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                          ),
                          SelectableText(
                            "Город Ташкент, улица Катта Дархон, дом 23",
                            style: TextStyle(
                                fontSize: 11.0, fontFamily: "SegoeUISemiBold"),
                          )
                        ],
                      ),
                      Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: 5.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Zarin Shop",
                                  style: TextStyle(
                                      fontSize: 12.0,
                                      fontFamily: "SegoeUISemiBold"),
                                ),
                                Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(top: 1.5),
                                      child: Icon(
                                        Icons.copyright,
                                        size: 16,
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 2.5),
                                    ),
                                    Text(
                                      "2020",
                                      style: TextStyle(
                                          fontSize: 12.0,
                                          fontFamily: "SegoeUISemiBold"),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ])));
  }
}
