
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/Counters/cartitemcounter.dart';
import 'package:store_app/Store/cart.dart';

class MyAppBar extends StatelessWidget with PreferredSizeWidget
{
  final PreferredSizeWidget bottom;
  MyAppBar({this.bottom});
  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(
        color: Colors.white
      ),
      flexibleSpace: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.pink, Colors.lightGreenAccent],
                begin: FractionalOffset(0.0, 0.0),
                end: FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp)),
      ),
      title: Text('e-shop',
          style: TextStyle(
              fontSize: 29, color: Colors.white, fontFamily: 'Signatra')),
      centerTitle: true,
      bottom: bottom,
      actions: [
        Stack(
          children: [
            IconButton(
                icon: Icon(
                  Icons.shopping_cart,
                  color: Colors.pink,
                ),
                onPressed: () {
                  Route route =
                  MaterialPageRoute(builder: (c) => CartPage());
                  Navigator.pushReplacement(context, route);
                }),
            Positioned(
              child: Stack(
                children: [
                  Icon(
                    Icons.brightness_1,
                    size: 20,
                    color: Colors.green,
                  ),
                  Positioned(
                    top: 3,
                    bottom: 4,
                    left: 3,
                    child: Consumer<CartItemCounter>(
                      builder: (context, counter, _) {
                        return Text(
                          counter.count.toString(),
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 15),
                        );
                      },
                    ),
                  )
                ],
              ),
            )
          ],
        )
      ],
    );

  }
  Size get preferredSize => bottom==null?Size(56,AppBar().preferredSize.height):Size(56, 80+AppBar().preferredSize.height);
}
