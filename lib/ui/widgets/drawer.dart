import 'package:Zarin/blocs/user_bloc.dart';
import 'package:Zarin/ui/screen_login.dart';
import 'package:Zarin/utils/fade_page_route.dart';
import 'package:Zarin/utils/styles.dart';
import 'package:flutter/material.dart';

class ZarinDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    homeEvent() => ModalRoute.of(context).settings.name == "/home"
        ? Navigator.of(context).pop()
        : Navigator.of(context).popUntil(ModalRoute.withName("/home"));

    personalEvent() => userBloc.auth
        ? null
        : Navigator.of(context).push(FadePageRoute(
            builder: (context) => LoginScreen(),
          ));

    final List<Widget> drawerContainers = new List.from([
      DrawerMenuContainer("Главная", Icons.home, homeEvent),
      DrawerMenuContainer(
          "Личный кабинет", Icons.supervised_user_circle, personalEvent),
      DrawerMenuContainer("Мои заказы", Icons.list, null),
    ]);

    return Container(
      width: MediaQuery.of(context).size.width - 50,
      child: Drawer(
        elevation: 0,
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.only(
              left: 20, right: 20.0, top: kToolbarHeight - 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(left: 20.0, bottom: 20.0, top: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Zarin Shop",
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      "домашний текстиль",
                      style: TextStyle(
                          fontSize: 13.0, fontWeight: FontWeight.w500),
                    )
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: drawerContainers,
                ),
                decoration: BoxDecoration(
                    color: Styles.mainColor,
                    borderRadius: BorderRadius.circular(25)),
              ),
              Expanded(
                child: Container(),
              ),
              Container(
                padding: EdgeInsets.only(bottom: 20.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.phone,
                          size: 18,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 2.5),
                        ),
                        Text(
                          "+998 (78) 150-00-02",
                          style: TextStyle(
                              fontSize: 11.0, fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                    Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 18,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 2.5),
                        ),
                        Text(
                          "Город Ташкент, улица Катта Дархон, дом 23",
                          style: TextStyle(
                              fontSize: 11.0, fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                    Padding(padding: EdgeInsets.symmetric(vertical: 7)),
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
                                    fontSize: 11.0,
                                    fontWeight: FontWeight.w600),
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.copyright,
                                    size: 10,
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 2.5),
                                  ),
                                  Text(
                                    "2020",
                                    style: TextStyle(
                                        fontSize: 11.0,
                                        fontWeight: FontWeight.w600),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(left: 100.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Icon(
                                  Icons.chat,
                                  size: 30.0,
                                ),
                                Icon(
                                  Icons.camera,
                                  size: 30.0,
                                ),
                                Icon(
                                  Icons.fast_forward,
                                  size: 30.0,
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class DrawerMenuContainer extends StatelessWidget {
  final String title;
  final IconData icon;
  final Function event;
  DrawerMenuContainer(this.title, this.icon, this.event);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: event,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.grey[600],
            ),
            Padding(
                padding: EdgeInsets.symmetric(
              horizontal: 10.0,
            )),
            Text(title),
          ],
        ),
      ),
    );
  }
}
