


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:store_app/Admin/adminLogin.dart';
import 'package:store_app/Config/config.dart';
import 'package:store_app/DialogBox/errorDialog.dart';
import 'package:store_app/DialogBox/loadingDialog.dart';
import 'package:store_app/Store/storehome.dart';
import 'package:store_app/Widgets/customTextField.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}





class _LoginState extends State<Login>
{
  final TextEditingController _emailTextEditing=TextEditingController();
  final TextEditingController _passwordTextEditing=TextEditingController();
  final GlobalKey<FormState>_formKey=GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    double _screenWidth=MediaQuery.of(context).size.width;
    double _screenHeight=MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              alignment: Alignment.bottomCenter,
              child: Image.asset('images/login.png'),height: 240,width: 240,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Login to your account',style: TextStyle(color: Colors.white),),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [

                  CustomTextField(
                    data: Icons.email,
                    hintText: 'Email',
                    isObsecure: false,
                    controller: _emailTextEditing,
                  ),
                  CustomTextField(
                    data: Icons.lock,
                    hintText: 'Password',
                    isObsecure: true,
                    controller: _passwordTextEditing,
                  ),

                  RaisedButton(
                    onPressed: (){
                      _emailTextEditing.text.isNotEmpty&&_passwordTextEditing.text.isNotEmpty
                          ?loginUser()
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
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>AdminSignInPage()));
                  },
                      icon: Icon(Icons.nature_people,color: Colors.pink,),
                      label: Text('Iam Admin',style: TextStyle(color: Colors.pink,fontWeight: FontWeight.bold),))

                ],
              ),
            )
          ],
        ),
      ),
    );
  }
FirebaseAuth _auth=FirebaseAuth.instance;
 void loginUser()async {
    showDialog(
      context: context,
      builder: (c){
        return LoadingAlertDialog(message: 'Authenticating, Please wait.....',);
      }
    );
    FirebaseUser firebaseUser;
    await _auth.signInWithEmailAndPassword(email: _emailTextEditing.text.trim(),
        password: _passwordTextEditing.text.trim()
    ).then((authUser){
      firebaseUser=authUser.user;
    }).catchError((error){
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (c){
            return ErrorAlertDialog(message: error.message.toString(),);
          }
      );
    });
    if(firebaseUser!=null){
      readData(firebaseUser).then((s) {
        Navigator.pop(context);
        Route route=MaterialPageRoute(builder: (c)=>StoreHome());
        Navigator.pushReplacement(context, route);
      });
    }
 }

  Future readData(FirebaseUser fUser)async {
    Firestore.instance.collection('Users').document(fUser.uid).get().then((snapshot) async {
      await EcommerceApp.sharedPreferences.setString('uid', snapshot.data[EcommerceApp.userUID]);
      await EcommerceApp.sharedPreferences.setString(EcommerceApp.userEmail, snapshot.data[EcommerceApp.userEmail]);
      await EcommerceApp.sharedPreferences.setString(EcommerceApp.userName, snapshot.data[EcommerceApp.userName]);
      await EcommerceApp.sharedPreferences.setString(EcommerceApp.userAvatarUrl, snapshot.data[EcommerceApp.userAvatarUrl]);
      List<String>cartList=snapshot.data[EcommerceApp.userCartList].cast<String>();
      await EcommerceApp.sharedPreferences.setStringList(EcommerceApp.userCartList,cartList);
    });
  }
}
