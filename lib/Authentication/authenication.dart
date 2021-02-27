

import 'package:flutter/material.dart';
import 'package:store_app/Authentication/login.dart';
import 'package:store_app/Authentication/register.dart';

class AuthenticScreen extends StatefulWidget {
  @override
  _AuthenticScreenState createState() => _AuthenticScreenState();
}

class _AuthenticScreenState extends State<AuthenticScreen> {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.pink,Colors.lightGreenAccent],
                  begin: FractionalOffset(0.0,0.0),
                  end: FractionalOffset(1.0,0.0),
                  stops: [0.0,1.0],
                  tileMode:TileMode.clamp
              )
            ),

          ),
          title: Text('e-shop',style:TextStyle(fontSize: 29,color: Colors.white,fontFamily:'Signatra' )),
          centerTitle: true,
          bottom: TabBar(
        tabs: [
          Tab(
              icon: Icon(Icons.lock,color: Colors.white,),
              text:'Login'
          ),
          Tab(
              icon: Icon(Icons.lock,color: Colors.white,),
              text:'Register'
          )
        ],
            indicatorColor: Colors.white38,
            indicatorWeight: 5.0,
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.pink,Colors.lightGreenAccent],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                //  stops: [0.0,1.0],
                  tileMode:TileMode.clamp
              )
          ),
          child: TabBarView(
            children: [
              Login(),
              Register()
            ],
          ),
        ),

      ),
    );
  }
}


