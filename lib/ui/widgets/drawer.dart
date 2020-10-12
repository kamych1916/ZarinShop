import 'package:Zarin/app_icons.dart';
import 'package:Zarin/blocs/user_bloc.dart';
import 'package:Zarin/ui/screen_login.dart';
import 'package:Zarin/ui/widgets/slider_menu.dart';
import 'package:Zarin/utils/fade_page_route.dart';
import 'package:Zarin/utils/styles.dart';
import 'package:flutter/material.dart';

class ZarinDrawer extends StatefulWidget {
  final GlobalKey<SliderMenuContainerState> sliderKey;

  const ZarinDrawer({Key key, this.sliderKey}) : super(key: key);

  @override
  _ZarinDrawerState createState() => _ZarinDrawerState();
}

class _ZarinDrawerState extends State<ZarinDrawer> {
  homeEvent() async {
    if (ModalRoute.of(context).settings.name == "/home")
      widget.sliderKey.currentState.closeDrawer();
    else {
      await widget.sliderKey.currentState.closeDrawer();
      Navigator.of(context).popUntil(ModalRoute.withName("/home"));
    }
  }

  personalEvent() async {
    if (userBloc.auth) {
    } else {
      await widget.sliderKey.currentState.closeDrawer();
      Navigator.of(context).push(FadePageRoute(
        builder: (context) => LoginScreen(),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> drawerContainers = new List.from([
      DrawerMenuContainer("Главная", AppIcons.home, homeEvent),
      DrawerMenuContainer("Личный кабинет", AppIcons.user, personalEvent),
      DrawerMenuContainer("Мои заказы", AppIcons.list, null),
    ]);

    return Container(
      width: MediaQuery.of(context).size.width - 50,
      child: Container(
        color: Styles.backgroundColor,
        padding:
            EdgeInsets.only(left: 20, right: 20.0, top: kToolbarHeight - 20.0),
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
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    "домашний текстиль",
                    style:
                        TextStyle(fontSize: 13.0, fontWeight: FontWeight.w500),
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
                        AppIcons.phone_handset,
                        size: 18,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5),
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
                        AppIcons.map_marker,
                        size: 18,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                      ),
                      Text(
                        "Город Ташкент\nулица Катта Дархон, дом 23",
                        overflow: TextOverflow.clip,
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
                                  fontSize: 12.0, fontWeight: FontWeight.w600),
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.copyright,
                                  size: 14,
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 2.5),
                                ),
                                Text(
                                  "2020",
                                  style: TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w600),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(left: 50.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Icon(
                                AppIcons.telegram_plane,
                                size: 30.0,
                              ),
                              Icon(
                                AppIcons.instagram,
                                size: 30.0,
                              ),
                              Icon(
                                AppIcons.facebook_f,
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
              size: 18,
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
