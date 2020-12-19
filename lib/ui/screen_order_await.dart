import 'dart:convert';

import 'package:Zarin/blocs/app_bloc.dart';
import 'package:Zarin/ui/widgets/progress_indicator.dart';
import 'package:Zarin/utils/styles.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http/io_client.dart';

class OrderAwaitScreen extends StatefulWidget {
  final int merchantTransId;

  const OrderAwaitScreen(this.merchantTransId, {Key key}) : super(key: key);
  @override
  _OrderAwaitScreenState createState() => _OrderAwaitScreenState();
}

class _OrderAwaitScreenState extends State<OrderAwaitScreen> {
  int state = 0;

  checkPay() async {
    await Future.delayed(Duration(seconds: 5));

    DateTime now = DateTime.now();
    String date = now.year.toString() +
        "-" +
        now.month.toString() +
        "-" +
        now.day.toString();
    String timestamp = (now.millisecondsSinceEpoch / 1000).round().toString();

    var digestBytes = utf8.encode(timestamp + "wtqRom5FNn");
    var digest = sha1.convert(digestBytes);
    String auth = AppBloc.merchantUserId.toString() +
        ":" +
        digest.toString() +
        ":" +
        timestamp;

    String checkUrl =
        "https://api.click.uz/v2/merchant/payment/status_by_mti/${AppBloc.serviceId}/${widget.merchantTransId}/$date";

    print(checkUrl);
    print(auth);

    IOClient client = new IOClient();
    Response response = await client.get(checkUrl, headers: {"Auth": auth});

    print(response.body);

    Map<String, dynamic> result = json.decode(response.body);

    if (result["error_code"] < 0) {
      setState(() => state = 2);
    } else
      setState(() => state = 1);

    showDialog(
        context: context,
        builder: (_) => AlertDialog(
            content: Text(checkUrl + "\n\n" + auth + "\n\n" + response.body)));
  }

  @override
  void initState() {
    checkPay();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget body;

    switch (state) {
      case 0:
        body = AppCircularProgressIndicator(
          color: Styles.mainColor,
          size: 25,
          strokeWidth: 3,
        );
        break;
      case 1:
        body = Text("Оплата успешна");
        break;
      case 2:
        body = Text("Ошибка при оплате");
        break;
    }

    return Scaffold(
      backgroundColor: Styles.subBackgroundColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40),
        child: AppBar(
          brightness: Brightness.light,
          backgroundColor: Styles.subBackgroundColor,
          iconTheme: new IconThemeData(color: Colors.black87),
          elevation: 0,
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
            "Проверка оплаты",
            style: TextStyle(
                color: Colors.black87, fontFamily: "SegoeUIBold", fontSize: 16),
          ),
          centerTitle: true,
        ),
      ),
      body: Center(child: body),
    );
  }
}
