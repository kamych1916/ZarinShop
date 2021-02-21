import 'package:Zarin/blocs/product_bloc.dart';
import 'package:Zarin/models/api_response.dart';
import 'package:Zarin/ui/widgets/progress_indicator.dart';
import 'package:Zarin/utils/styles.dart';
import 'package:Zarin/models/order.dart';
import 'package:flutter/material.dart';
import 'package:Zarin/ui/widgets/order_card.dart';

class OrdersScreen extends StatefulWidget {
  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  void initState() {
    productBloc.getUserOrders();
    super.initState();
  }

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
              "Мои заказы",
              overflow: TextOverflow.fade,
              style: TextStyle(
                  color: Colors.black87,
                  fontFamily: "SegoeUIBold",
                  fontSize: 18),
            ),
          ),
        ),
        body: StreamBuilder<ApiResponse<List<Order>>>(
            stream: productBloc.orders.stream,
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data.status == Status.LOADING)
                return Center(
                  child: AppCircularProgressIndicator(
                    color: Styles.mainColor,
                  ),
                );
              if (snapshot.data.status == Status.ERROR)
                return Center(
                  child: Text("Произошла ошибка"),
                );
              if (snapshot.data.status == Status.COMPLETED)
                return ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: snapshot.data.data.length,
                    itemBuilder: (context, index) =>
                        OrderCard(snapshot.data.data[index]));
              return Container();
            }));
  }
}
