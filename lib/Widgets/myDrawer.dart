

import 'package:flutter/material.dart';
import 'package:store_app/Address/addAddress.dart';
import 'package:store_app/Authentication/authenication.dart';
import 'package:store_app/Config/config.dart';
import 'package:store_app/Orders/myOrders.dart';
import 'package:store_app/Store/Search.dart';
import 'package:store_app/Store/cart.dart';
import 'package:store_app/Store/storehome.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
          children: [
            Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Colors.pink,Colors.lightGreenAccent],
                      begin: FractionalOffset(0.0,0.0),
                      end: FractionalOffset(1.0,0.0),
                      stops: [0.0,1.0],
                      tileMode:TileMode.clamp
                  )
              ),
              child: Column(
                children: [
                  Material(
                    borderRadius: BorderRadius.circular(80),
                    elevation: 8,
                    child: Container(
                      height: 160,
                      width: 160,
                      child: CircleAvatar(
                backgroundImage: NetworkImage(
                  EcommerceApp.sharedPreferences.getString(EcommerceApp.userAvatarUrl)
                ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  Text(EcommerceApp.sharedPreferences.getString(EcommerceApp.userName,),style: TextStyle(
                    fontSize: 35,
                    color: Colors.white,
                    fontFamily: 'Signatra'
                  ),)
                ],
              ),
            ),
            SizedBox(height: 12,),
            Container(
              padding: EdgeInsets.only(top: 1),
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Colors.pink,Colors.lightGreenAccent],
                      begin: FractionalOffset(0.0,0.0),
                      end: FractionalOffset(1.0,0.0),
                      stops: [0.0,1.0],
                      tileMode:TileMode.clamp
                  )
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.home,color: Colors.white,),
                    title: Text('Home',style: TextStyle(color: Colors.white),),
                    onTap: (){
                      Route route=MaterialPageRoute(builder: (c)=>StoreHome());
                      Navigator.pushReplacement(context, route);
                    },
                  ),
                  Divider(height: 10,thickness: 6,),
                  ListTile(
                    leading: Icon(Icons.reorder,color: Colors.white,),
                    title: Text('My Orders',style: TextStyle(color: Colors.white),),
                    onTap: (){
                      Route route=MaterialPageRoute(builder: (c)=>MyOrders());
                      Navigator.pushReplacement(context, route);
                    },
                  ),
                  Divider(height: 10,thickness: 6,),
                  ListTile(
                    leading: Icon(Icons.shopping_cart,color: Colors.white,),
                    title: Text('My Cart',style: TextStyle(color: Colors.white),),
                    onTap: (){
                      Route route=MaterialPageRoute(builder: (c)=>CartPage());
                      Navigator.pushReplacement(context, route);
                    },
                  ),
                  Divider(height: 10,thickness: 6,),
                  ListTile(
                    leading: Icon(Icons.search,color: Colors.white,),
                    title: Text('Search',style: TextStyle(color: Colors.white),),
                    onTap: (){
                      Route route=MaterialPageRoute(builder: (c)=>SearchProduct());
                      Navigator.pushReplacement(context, route);
                    },
                  ),
                  Divider(height: 10,thickness: 6,),
                  ListTile(
                    leading: Icon(Icons.add_location,color: Colors.white,),
                    title: Text('Add New Address',style: TextStyle(color: Colors.white),),
                    onTap: (){
                      Route route=MaterialPageRoute(builder: (c)=>AddAddress());
                      Navigator.pushReplacement(context, route);
                    },
                  ),
                  Divider(height: 10,thickness: 6,),
                  ListTile(
                    leading: Icon(Icons.exit_to_app,color: Colors.white,),
                    title: Text('Loggout',style: TextStyle(color: Colors.white),),
                    onTap: (){
                   EcommerceApp.auth.signOut().then((c){
                     Route route=MaterialPageRoute(builder: (c)=>AuthenticScreen());
                     Navigator.pushReplacement(context, route);
                   });
                    },
                  ),
                  Divider(height: 10,thickness: 6,)
                ],
              ),
            )
          ],
      ),
    );
  }
}
