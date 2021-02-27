

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store_app/Config/config.dart';
import 'package:store_app/Counters/cartitemcounter.dart';

import 'Authentication/authenication.dart';
import 'Counters/BookQuantity.dart';
import 'Counters/changeAddresss.dart';
import 'Counters/totalMoney.dart';
import 'Store/storehome.dart';

Future<void> main() async
{
  WidgetsFlutterBinding.ensureInitialized();
 EcommerceApp.auth=FirebaseAuth.instance;
 EcommerceApp.sharedPreferences=await SharedPreferences.getInstance();
 EcommerceApp.firestore=Firestore.instance;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers:[
          ChangeNotifierProvider(create: (c)=>CartItemCounter()),
          ChangeNotifierProvider(create: (c)=>BookQuantity()),
          ChangeNotifierProvider(create: (c)=>AddressChanger()),
          ChangeNotifierProvider(create: (c)=>TotalAmount())
        ],
      child: MaterialApp(
          title: 'e-Shop',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: Colors.green,
          ),
          home: SplashScreen()
      ),

    );
  }
}

class SplashScreen extends StatefulWidget {

  @override
  _SplashScreenState createState() => _SplashScreenState();
}


class _SplashScreenState extends State<SplashScreen>
{
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    displaySplash();
  }
  displaySplash(){
    Timer(Duration(seconds: 4), ()async{
      if(await EcommerceApp.auth.currentUser()!=null){
         Route route=MaterialPageRoute(builder: (context)=>StoreHome());
         Navigator.pushReplacement(context, route);
      }else{
        Route route=MaterialPageRoute(builder: (context)=>AuthenticScreen());
        Navigator.pushReplacement(context, route);
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
         decoration: BoxDecoration(
           gradient: LinearGradient(

           colors: [Colors.pink,Colors.lightGreenAccent],
             begin: FractionalOffset(0.0,0.0),
             end: FractionalOffset(1.0,0.0),
             stops: [0.0,1.0],
             tileMode:TileMode.clamp
           )
         ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('images/welcome.png')
            ],
          ),
        ),
        // child: Text(
        //     "Welcome to Flutter Firetore eCommerce Course by Coding Cafe.",
        //   style: TextStyle(color: Colors.green, fontSize: 20.0),
        //   textAlign: TextAlign.center,
        // ),
      ),
    );
  }
}
