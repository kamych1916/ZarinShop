import 'package:flutter/material.dart';
import 'package:Zarin/ui/widgets/slider_img.dart' as Zarin;

class ProductInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40),
        child: AppBar(
          backgroundColor: Colors.white,
          brightness: Brightness.light,
          elevation: 0,
          iconTheme: new IconThemeData(color: Colors.black87),
          leading: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Icon(Icons.arrow_back_ios),
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height / 1.7,
            child: Zarin.Slider(
              children: List.generate(
                  5,
                  (index) => Container(
                        decoration: BoxDecoration(
                          color: Colors.blue,
                        ),
                        child: Center(
                          child: Text(index.toString()),
                        ),
                      )),
            ),
          )
        ],
      ),
    );
  }
}
