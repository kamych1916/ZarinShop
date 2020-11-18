import 'dart:async';

import 'package:Zarin/utils/app_icons.dart';
import 'package:Zarin/models/address.dart';
import 'package:Zarin/models/credit_card.dart';
import 'package:Zarin/ui/widgets/tab_address.dart';
import 'package:Zarin/ui/widgets/tab_payment.dart';
import 'package:Zarin/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:rxdart/rxdart.dart';

class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  BehaviorSubject<int> currentIndex;
  PageController pageViewController;
  StreamSubscription streamSubscription;

  Address address;
  CreditCard creditCard;
  String deliveryType;

  @override
  void initState() {
    currentIndex = BehaviorSubject()..sink.add(0);
    pageViewController = PageController(initialPage: 0);
    streamSubscription = currentIndex.listen((value) {
      pageViewController.animateToPage(value,
          duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
    });
    super.initState();
  }

  @override
  void dispose() {
    currentIndex.close();
    streamSubscription.cancel();
    super.dispose();
  }

  creditCardCallback(CreditCard creditCard) {
    currentIndex.sink.add(2);
    print(creditCard);
    this.creditCard = creditCard;
    setState(() {});
  }

  addressCallback(Address address, String deliveryType) {
    currentIndex.sink.add(1);
    print(address);
    print(deliveryType);
    this.address = address;
    this.deliveryType = deliveryType;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> tabs = [
      AddressTab(addressCallback),
      PaymentTab(creditCardCallback),
      creditCard == null
          ? Container()
          : Column(
              children: [
                Expanded(
                  child: Container(
                    margin:
                        EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Проверьте данные еще раз",
                          style: TextStyle(
                              fontFamily: "SegoeUISemiBold", fontSize: 16),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.0),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Styles.mainColor,
                              borderRadius: BorderRadius.circular(20)),
                          padding: EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10)),
                                padding: EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 20.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      AppIcons.map_marker,
                                      size: 22,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            address.code,
                                            maxLines: 1,
                                            overflow: TextOverflow.clip,
                                            style: TextStyle(
                                                fontFamily: "SegoeUI",
                                                fontSize: 12),
                                          ),
                                          Text(
                                            address.city,
                                            maxLines: 5,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontFamily: "SegoeUI",
                                                fontSize: 14),
                                          ),
                                          Text(
                                            address.street +
                                                " " +
                                                address.houseNumber +
                                                " - " +
                                                address.apartmentNumber,
                                            maxLines: 5,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontFamily: "SegoeUISemiBold",
                                                fontSize: 14),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 10.0),
                              ),
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10)),
                                padding: EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 20.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      AppIcons.credit_card,
                                      size: 22,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                    ),
                                    Expanded(
                                      child: Text(
                                        "**** **** **** " +
                                            creditCard.cardNumber.substring(14),
                                        style: TextStyle(
                                            fontFamily: "SegoeUI",
                                            fontSize: 14),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Container(),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  decoration: BoxDecoration(
                      color: Styles.mainColor,
                      borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(10.0),
                        topRight: const Radius.circular(10.0),
                      )),
                  child: Text(
                    "Оплатить",
                    style: TextStyle(
                        fontFamily: 'SegoeUIBold', color: Colors.white),
                  ),
                )
              ],
            )
    ];

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40),
        child: AppBar(
          brightness: Brightness.light,
          backgroundColor: Styles.subBackgroundColor,
          iconTheme: new IconThemeData(color: Colors.black87),
          elevation: 0,
          title: Text(
            "Оформить заказ",
            style: TextStyle(
                color: Colors.black87, fontFamily: "SegoeUIBold", fontSize: 16),
          ),
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
        ),
      ),
      backgroundColor: Styles.subBackgroundColor,
      body: Container(
        margin: EdgeInsets.only(top: 10.0),
        child: Column(
          children: [
            StreamBuilder<int>(
                stream: currentIndex.stream,
                builder: (context, AsyncSnapshot<int> snapshot) {
                  return Container(
                    margin:
                        EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
                    child: GNav(
                        gap: MediaQuery.of(context).size.width / 12,
                        activeColor: Colors.white,
                        iconSize: 20,
                        duration: Duration(milliseconds: 500),
                        tabBackgroundColor: Styles.mainColor,
                        padding: EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 20.0),
                        tabs: [
                          GButton(
                            icon: AppIcons.map,
                            text: 'Доставка',
                          ),
                          GButton(
                            icon: AppIcons.credit_card,
                            text: 'Оплата',
                          ),
                          GButton(
                            icon: AppIcons.location,
                            text: 'Подтверждение',
                            gap: 10,
                          ),
                        ],
                        selectedIndex:
                            snapshot.hasData ? currentIndex.value : 0,
                        onTabChange: (index) {
                          if (index < currentIndex.value)
                            currentIndex.sink.add(index);
                        }),
                  );
                }),
            Expanded(
              child: PageView(
                physics: BouncingScrollPhysics(),

                ///TODO: убрать
                children: tabs,
                controller: pageViewController,
              ),
            )
          ],
        ),
      ),
    );
  }
}
