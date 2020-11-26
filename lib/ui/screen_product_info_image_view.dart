import 'package:Zarin/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ProductInfoImageView extends StatelessWidget {
  final String heroTag;
  final String image;

  const ProductInfoImageView(this.heroTag, this.image, {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      child: Stack(
        children: [
          PhotoView(
            backgroundDecoration:
                BoxDecoration(color: Styles.subBackgroundColor),
            heroAttributes: PhotoViewHeroAttributes(
              tag: heroTag,
              flightShuttleBuilder: (flightContext, animation, flightDirection,
                      fromHeroContext, toHeroContext) =>
                  Container(
                child: Image(
                  image: NetworkImage(image),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            imageProvider: NetworkImage(image),
            minScale: 0.5,
            maxScale: 1.0,
          ),
          Container(
            height: 55,
            child: AppBar(
              brightness: Brightness.light,
              iconTheme: new IconThemeData(color: Colors.black87),
              elevation: 0,
              backgroundColor: Colors.transparent,
              leading: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                behavior: HitTestBehavior.translucent,
                child: Container(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 5,
                        height: 5,
                        decoration: BoxDecoration(
                            color: Colors.transparent,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black54,
                                  spreadRadius: 1,
                                  blurRadius: 10)
                            ]),
                      ),
                      Icon(
                        Icons.arrow_back_ios,
                        size: 16,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
