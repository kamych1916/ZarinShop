import 'dart:async';
import 'dart:convert';

import 'package:Zarin/blocs/product_bloc.dart';
import 'package:Zarin/utils/app_icons.dart';
import 'package:Zarin/blocs/app_bloc.dart';
import 'package:Zarin/models/address.dart';
import 'package:Zarin/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AddressTab extends StatefulWidget {
  final Function(Address, String) callback;

  const AddressTab(this.callback, {Key key}) : super(key: key);
  @override
  _AddressTabState createState() => _AddressTabState();
}

class _AddressTabState extends State<AddressTab> {
  String deliveryType = "Доставка домой";
  String whichBank = "Click";
  int currentAddress = -1;
  bool showAddresses = true;

  deliveryTypePickerCallback(String current) {
    if (current == "Самовывоз")
      setState(() {
        showAddresses = false;
        currentAddress = -1;
      });
    else
      setState(() => showAddresses = true);
    deliveryType = current;
  }

  whichBankPickerCallback(String current) {
    whichBank = current;
  }

  void pay() async {
    String responseBody =
        await productBloc.pay(deliveryType, whichBank, currentAddress);

    if (responseBody != null) {
      final Completer<WebViewController> _controller =
          Completer<WebViewController>();

      await pushNewScreen(
        context,
        screen: Scaffold(
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
                    color: Colors.black87,
                    fontFamily: "SegoeUIBold",
                    fontSize: 16),
              ),
              centerTitle: true,
              automaticallyImplyLeading: true,
            ),
          ),
          body: WebView(
            gestureNavigationEnabled: true,
            javascriptMode: JavascriptMode.unrestricted,
            initialUrl: json.decode(responseBody)["url"],
            onWebViewCreated: (WebViewController webViewController) {
              _controller.complete(webViewController);
            },
          ),
        ),
        withNavBar: false,
        pageTransitionAnimation: PageTransitionAnimation.fade,
      );

      await productBloc.getCartEntities();
      productBloc.getCartProducts();
      Navigator.of(context).pop(); //6262 9200 6488 5766 12/22
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: (deliveryType == "Самовывоз") || currentAddress >= 0
                  ? pay
                  : null,
              child: Container(
                alignment: Alignment.center,
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 10.0),
                decoration: BoxDecoration(
                    color: (deliveryType == "Самовывоз") || currentAddress >= 0
                        ? Styles.mainColor
                        : Colors.grey,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                // borderRadius: new BorderRadius.only(
                //   topLeft: const Radius.circular(10.0),
                //   topRight: const Radius.circular(10.0),
                // )),
                child: Text(
                  "Оплатить",
                  style:
                      TextStyle(fontFamily: 'SegoeUIBold', color: Colors.white),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
            ),
            Text(
              "Выберите способ и адрес доставки",
              style: TextStyle(fontFamily: "SegoeUISemiBold", fontSize: 16),
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
                    DeliveryTypePicker(deliveryTypePickerCallback),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5),
                    ),
                    WhichBankPicker(whichBankPickerCallback),
                    (showAddresses)
                        ? Padding(
                            padding: EdgeInsets.symmetric(vertical: 5),
                          )
                        : Container(),
                    (showAddresses)
                        ? StreamBuilder<List<Address>>(
                            stream: appBloc.addresses.stream,
                            builder: (context,
                                AsyncSnapshot<List<Address>> snapshot) {
                              return snapshot.hasData
                                  ? ListView.separated(
                                      physics: BouncingScrollPhysics(),
                                      separatorBuilder: (context, index) =>
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 5),
                                          ),
                                      shrinkWrap: true,
                                      itemCount:
                                          appBloc.addresses.value.length + 1,
                                      itemBuilder: (context, index) {
                                        return index ==
                                                appBloc.addresses.value.length
                                            ? !(appBloc.addresses.value.length <
                                                    3)
                                                ? Container()
                                                : GestureDetector(
                                                    onTap: () =>
                                                        showModalBottomSheet(
                                                            isScrollControlled:
                                                                true,
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius.vertical(
                                                                      top: Radius
                                                                          .circular(
                                                                              25.0)),
                                                            ),
                                                            context: context,
                                                            builder: (context) =>
                                                                AddAddressSheet()),
                                                    child: Container(
                                                      width: double.infinity,
                                                      decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10)),
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 10.0,
                                                              horizontal: 20.0),
                                                      child: Row(
                                                        children: [
                                                          Icon(
                                                            Icons.add_circle,
                                                            size: 26.0,
                                                            color: Styles
                                                                .mainColor,
                                                          ),
                                                          Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        10.0),
                                                          ),
                                                          Text(
                                                            "Добавить адрес",
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    "SegoeUIBold"),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                            : GestureDetector(
                                                onTap: () => setState(() =>
                                                    currentAddress = index),
                                                child: Container(
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 10.0,
                                                      horizontal: 20.0),
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.check,
                                                        color: index ==
                                                                currentAddress
                                                            ? Colors.green
                                                            : Colors.grey,
                                                        size: 22,
                                                      ),
                                                      Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    10.0),
                                                      ),
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              appBloc
                                                                  .addresses
                                                                  .value[index]
                                                                  .code,
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .clip,
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      "SegoeUI",
                                                                  fontSize: 12),
                                                            ),
                                                            Text(
                                                              appBloc
                                                                      .addresses
                                                                      .value[
                                                                          index]
                                                                      .state +
                                                                  " - " +
                                                                  appBloc
                                                                      .addresses
                                                                      .value[
                                                                          index]
                                                                      .city,
                                                              maxLines: 5,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      "SegoeUI",
                                                                  fontSize: 14),
                                                            ),
                                                            Text(
                                                              appBloc
                                                                      .addresses
                                                                      .value[
                                                                          index]
                                                                      .street +
                                                                  " " +
                                                                  appBloc
                                                                      .addresses
                                                                      .value[
                                                                          index]
                                                                      .houseNumber +
                                                                  " - " +
                                                                  appBloc
                                                                      .addresses
                                                                      .value[
                                                                          index]
                                                                      .apartmentNumber,
                                                              maxLines: 5,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      "SegoeUISemiBold",
                                                                  fontSize: 14),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {
                                                          appBloc.removeAddress(
                                                              appBloc.addresses
                                                                      .value[
                                                                  index]);
                                                          setState(() =>
                                                              currentAddress =
                                                                  -1);
                                                        },
                                                        behavior:
                                                            HitTestBehavior
                                                                .translucent,
                                                        child: Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: 20.0),
                                                          child: Icon(
                                                            Icons.close,
                                                            size: 18,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              );
                                      })
                                  : Container();
                            })
                        : Container(),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}

class AddAddressSheet extends StatefulWidget {
  @override
  _AddAddressSheetState createState() => _AddAddressSheetState();
}

class _AddAddressSheetState extends State<AddAddressSheet> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<String> data = ["", "", "", "", "", ""];

  Widget field(String hintText, int index,
      {TextInputType textInputType, bool hasFocus}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: SizedBox(
        height: 55,
        child: TextFormField(
            cursorColor: Colors.black54,
            keyboardType: textInputType ?? TextInputType.text,
            textAlign: TextAlign.center,
            onChanged: (value) => data[index] = value,
            autofocus: hasFocus ?? false,
            validator: (value) =>
                value != null && value.isNotEmpty ? null : "Заполните поле",
            style: TextStyle(
                decoration: TextDecoration.none,
                decorationColor: Colors.white.withOpacity(0)),
            decoration: InputDecoration(
                helperText: ' ',
                contentPadding: EdgeInsets.only(left: 15, right: 15, top: 5),
                filled: true,
                fillColor: Colors.white,
                hintMaxLines: 1,
                hintStyle: TextStyle(
                    color: Color.fromRGBO(134, 145, 173, 1), fontSize: 14.0),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(width: 0, style: BorderStyle.none)),
                hintText: hintText)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> fields = List.from([
      field("Область", 0,
          textInputType: TextInputType.streetAddress, hasFocus: true),
      field("Населенный пункт", 1, textInputType: TextInputType.streetAddress),
      field("Улица", 2, textInputType: TextInputType.streetAddress),
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(child: field("Номер дома", 3)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
          ),
          Expanded(child: field("Номер квартиры", 4)),
        ],
      ),
      field("Индекс", 5),
    ]);

    return Container(
      //padding: MediaQuery.of(context).viewInsets,
      padding: EdgeInsets.symmetric(horizontal: 20.0,),
      decoration: BoxDecoration(
          color: Styles.subBackgroundColor,
          borderRadius: BorderRadius.circular(25)),
      child: SingleChildScrollView(
              child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Container(
                margin: EdgeInsets.only(top: 10.0, bottom: 20.0),
                width: 25.0,
                height: 2.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.grey,
                ),
              ),
            ),
            Text(
              "Новый адрес доставки",
              style: TextStyle(fontFamily: "SegoeUIBold"),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: fields,
              ),
            ),
            GestureDetector(
              onTap: () {
                if (_formKey.currentState.validate()) {
                  Address address = Address(
                      data[0], data[1], data[2], data[3], data[4], data[5]);
                  appBloc.addAddress(address);
                  Navigator.of(context).pop();
                }
              },
              child: Container(
                alignment: Alignment.center,
                width: double.infinity,
                height: 40,
                decoration: BoxDecoration(
                    color: Styles.mainColor,
                    borderRadius: BorderRadius.circular(10)),
                child: Text(
                  "Готово",
                  style:
                      TextStyle(color: Colors.white, fontFamily: "SegoeUIBold"),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
            )
          ],
        ),
      ),
    );
  }
}

class DeliveryTypePicker extends StatefulWidget {
  final Function(String) callback;

  const DeliveryTypePicker(this.callback, {Key key}) : super(key: key);

  @override
  _DeliveryTypePickerState createState() => _DeliveryTypePickerState();
}

class _DeliveryTypePickerState extends State<DeliveryTypePicker> {
  String currentType = "Доставка домой";

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        String type = await showModalBottomSheet(
            isScrollControlled: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
            ),
            context: context,
            builder: (context) => DeliveryTypePickerSheet(
                  currentType: currentType,
                ));

        if (type != null && type != currentType)
          setState(() => currentType = type);

        widget.callback(currentType);
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        child: Row(
          children: [
            Icon(
              Icons.move_to_inbox,
              size: 26.0,
              color: Styles.mainColor,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Способ доставки",
                  style: TextStyle(fontFamily: "SegoeUIBold"),
                ),
                Text(
                  currentType,
                  style: TextStyle(fontFamily: "SegoeUISemiBold"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class WhichBankPicker extends StatefulWidget {
  final Function(String) callback;

  const WhichBankPicker(this.callback, {Key key}) : super(key: key);

  @override
  _WhichBankPickerState createState() => _WhichBankPickerState();
}

class _WhichBankPickerState extends State<WhichBankPicker> {
  String currentType = "Click";

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        String type = await showModalBottomSheet(
            isScrollControlled: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
            ),
            context: context,
            builder: (context) => WhichBankPickerSheet(
                  currentType: currentType,
                ));

        if (type != null && type != currentType)
          setState(() => currentType = type);

        widget.callback(currentType);
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        child: Row(
          children: [
            Icon(
              Icons.attach_money_rounded,
              size: 26.0,
              color: Styles.mainColor,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Способ оплаты",
                  style: TextStyle(fontFamily: "SegoeUIBold"),
                ),
                Text(
                  currentType,
                  style: TextStyle(fontFamily: "SegoeUISemiBold"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class WhichBankPickerSheet extends StatelessWidget {
  final String currentType;

  final List<String> deliveryTypes = [
    "Click",
    "Payme",
  ];

  WhichBankPickerSheet({Key key, this.currentType}) : super(key: key);

  Widget sortElement(String type, BuildContext context) => GestureDetector(
        onTap: () {
          Navigator.of(context).pop(type);
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 5.0),
          color: Styles.subBackgroundColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text(type)),
              type == currentType
                  ? Icon(
                      Icons.check,
                      size: 20.0,
                    )
                  : Container()
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      decoration: BoxDecoration(
          color: Styles.subBackgroundColor,
          borderRadius: BorderRadius.circular(25)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Container(
              margin: EdgeInsets.only(top: 10.0, bottom: 20.0),
              width: 25.0,
              height: 2.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.grey,
              ),
            ),
          ),
          Text(
            "Выберите способ оплаты",
            style: TextStyle(fontFamily: "SegoeUIBold"),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
          ),
          ListView.separated(
              separatorBuilder: (context, index) => Divider(),
              shrinkWrap: true,
              itemCount: deliveryTypes.length,
              itemBuilder: (context, index) =>
                  sortElement(deliveryTypes[index], context)),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
          ),
        ],
      ),
    );
  }
}

class DeliveryTypePickerSheet extends StatelessWidget {
  final String currentType;

  final List<String> deliveryTypes = [
    "Доставка домой",
    "Самовывоз",
  ];

  DeliveryTypePickerSheet({Key key, this.currentType}) : super(key: key);

  Widget sortElement(String type, BuildContext context) => GestureDetector(
        onTap: () {
          Navigator.of(context).pop(type);
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 5.0),
          color: Styles.subBackgroundColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text(type)),
              type == currentType
                  ? Icon(
                      Icons.check,
                      size: 20.0,
                    )
                  : Container()
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      //padding: MediaQuery.of(context).viewInsets,
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      decoration: BoxDecoration(
          color: Styles.subBackgroundColor,
          borderRadius: BorderRadius.circular(25)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Container(
              margin: EdgeInsets.only(top: 10.0, bottom: 20.0),
              width: 25.0,
              height: 2.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.grey,
              ),
            ),
          ),
          Text(
            "Выберите способ доставки",
            style: TextStyle(fontFamily: "SegoeUIBold"),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
          ),
          ListView.separated(
              separatorBuilder: (context, index) => Divider(),
              shrinkWrap: true,
              itemCount: deliveryTypes.length,
              itemBuilder: (context, index) =>
                  sortElement(deliveryTypes[index], context)),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
          ),
        ],
      ),
    );
  }
}
