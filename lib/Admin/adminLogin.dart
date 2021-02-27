

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:store_app/Admin/uploadItems.dart';
import 'package:store_app/Widgets/customTextField.dart';
import 'package:store_app/DialogBox/errorDialog.dart';
import 'package:store_app/Authentication/authenication.dart';
class AdminSignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
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
      ),
      body: AdminSignInScreen(),
    );
  }
}

class AdminSignInScreen extends StatefulWidget {
  @override
  _AdminSignInScreenState createState() => _AdminSignInScreenState();
}

class _AdminSignInScreenState extends State<AdminSignInScreen>
{
  final TextEditingController _adminIDTextEditing=TextEditingController();
  final TextEditingController _passwordTextEditing=TextEditingController();
  final GlobalKey<FormState>_formKey=GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    double _screenWidth=MediaQuery.of(context).size.width;
    double _screenHeight=MediaQuery.of(context).size.height;

       return SingleChildScrollView(
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
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              alignment: Alignment.bottomCenter,
              child: Image.asset('images/admin.png'),height: 240,width: 240,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Admin',style: TextStyle(color: Colors.white,fontSize: 28),),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [

                  CustomTextField(
                    data: Icons.person,
                    hintText: 'Id',
                    isObsecure: false,
                    controller: _adminIDTextEditing,
                  ),
                  CustomTextField(
                    data: Icons.lock,
                    hintText: 'Password',
                    isObsecure: true,
                    controller: _passwordTextEditing,
                  ),

                  RaisedButton(
                    onPressed: (){
                      _adminIDTextEditing.text.isNotEmpty&&_passwordTextEditing.text.isNotEmpty
                          ?loginAdmin()
                          :showDialog(
                          context:context,
                          builder: (c){
                            return ErrorAlertDialog(message: 'please write email and password',);
                          }
                      );
                    },
                    color: Colors.pink,
                    child: Text('Login',style: TextStyle(color: Colors.white),),
                  ),
                  SizedBox(height: 30,),
                  Container(
                    height: 4,
                    width: _screenWidth*.8,
                    color: Colors.pink,
                  ),
                  SizedBox(height: 30,),
                  FlatButton.icon(onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>AuthenticScreen()));
                  },
                      icon: Icon(Icons.nature_people,color: Colors.pink,),
                      label: Text('Iam not Admin',style: TextStyle(color: Colors.pink,fontWeight: FontWeight.bold),))

                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  loginAdmin() {
    Firestore.instance.collection('admins').getDocuments().then((snapshot){
       snapshot.documents.forEach((result) {
         if(result.data['id']!=_adminIDTextEditing.text){
           Scaffold.of(context).showSnackBar(SnackBar(content:Text('your id is not correct')));
         }
       else  if(result.data['password']!=_passwordTextEditing.text){
           Scaffold.of(context).showSnackBar(SnackBar(content:Text('your password is not correct')));
         }
       else{
           Scaffold.of(context).showSnackBar(SnackBar(content:Text('welcome admin'+result.data['name'])));
           setState(() {
             _adminIDTextEditing.text='';
             _passwordTextEditing.text='';
           });
           Route route=MaterialPageRoute(builder: (c)=>UploadPage());
           Navigator.pushReplacement(context, route);
         }
       });
    });

  }
}
