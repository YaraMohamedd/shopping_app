

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:store_app/Config/config.dart';
import 'package:store_app/DialogBox/errorDialog.dart';
import 'package:store_app/DialogBox/loadingDialog.dart';
import 'package:store_app/Store/storehome.dart';
import 'package:store_app/Widgets/customTextField.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();

}



class _RegisterState extends State<Register>
{
  final TextEditingController _nameTextEditing=TextEditingController();
  final TextEditingController _emailTextEditing=TextEditingController();
  final TextEditingController _passwordTextEditing=TextEditingController();
  final TextEditingController _cPasswordTextEditing=TextEditingController();
  final GlobalKey<FormState>_formKey=GlobalKey<FormState>();
  String imageUrl='';
  File _imageFile;
  @override
  Widget build(BuildContext context) {
    double _screenWidth=MediaQuery.of(context).size.width;
    double _screenHeight=MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,

        children: [
          SizedBox(height: 8,),
          InkWell(
            onTap:_selectAndPickImage,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: _screenWidth*.15,
              backgroundImage: _imageFile==null?null:FileImage(_imageFile),
              child: _imageFile==null?
              Icon(Icons.add_photo_alternate,size: _screenWidth*.15,color: Colors.grey,):null,
            ),
          ),
          SizedBox(height: 8,),
          Form(
            key: _formKey,
            child: Column(
              children: [
                CustomTextField(
                  data: Icons.person,
                  hintText: 'Name',
                  isObsecure: false,
                  controller: _nameTextEditing,
                ),
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
                CustomTextField(
                  data: Icons.lock,
                  hintText: 'Confirm Password',
                  isObsecure: true,
                  controller: _cPasswordTextEditing,
                ),
                RaisedButton(
                  onPressed: (){uploadAndSaveImage();},
                  color: Colors.pink,
                  child: Text('Sign Up',style: TextStyle(color: Colors.white),),
                ),
                SizedBox(height: 30,),
                Container(
                  height: 4,
                  width: _screenWidth*.8,
                  color: Colors.pink,
                ),
                SizedBox(height: 30,),

              ],
            ),
          )
        ],
      ),
    );
  }

  Future<void> _selectAndPickImage()async {
    _imageFile= await ImagePicker.pickImage(source: ImageSource.gallery);
  }

Future<void>   uploadAndSaveImage()async {
    if(_imageFile==null){
      showDialog(
        context: context,
        builder: (c){
          return ErrorAlertDialog(message: 'please select an image',);
        }
      );
    }else{
      _passwordTextEditing.text==_cPasswordTextEditing.text
          ?_emailTextEditing.text.isNotEmpty&&
          _passwordTextEditing.text.isNotEmpty&&
          _cPasswordTextEditing.text.isNotEmpty&&
          _nameTextEditing.text.isNotEmpty
          ?uploadImageTOStorage()
          :displayDialog('please fill up the form')
          :displayDialog('password not match');
    }
}
   displayDialog(String msg){
    showDialog(
      context: context,
      builder: (c){
        return ErrorAlertDialog(message: msg,);
      }

    );

   }
  uploadImageTOStorage()async{
    showDialog(
      context: context,
      builder: (c){
        return LoadingAlertDialog(message:'Registering, Please wait.....');

      }
    );
    String imageFileName=DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference storageReference = FirebaseStorage.instance.ref().child(imageFileName);
    StorageUploadTask uploadTask = storageReference.putFile(_imageFile);
    StorageTaskSnapshot taskSnapshot = await  uploadTask.onComplete;
    await taskSnapshot.ref.getDownloadURL().then((urlImage) {
      imageUrl=urlImage;
      _registerUser();
    });

  }
   FirebaseAuth _auth=FirebaseAuth.instance;
  void _registerUser()async {
    FirebaseUser firebaseUser;
    await _auth.createUserWithEmailAndPassword(
      email: _emailTextEditing.text.trim(),
      password: _passwordTextEditing.text.trim()
    ).then((auth){
      firebaseUser=auth.user;
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
      saveUserInfoToFirestore(firebaseUser).then((value){
        Navigator.pop(context);
        Route route=MaterialPageRoute(builder: (c)=>StoreHome());
        Navigator.pushReplacement(context, route);
      });
    }
  }
  Future saveUserInfoToFirestore(FirebaseUser fUser) async{
    Firestore.instance.collection('Users').document(fUser.uid).setData(
{
  'uid':fUser.uid,
  'email':fUser.email,
  'name':_nameTextEditing.text.trim(),
  'url':imageUrl,
  EcommerceApp.userCartList:['garbageValue']
}
    );
await EcommerceApp.sharedPreferences.setString('uid', fUser.uid);
    await EcommerceApp.sharedPreferences.setString(EcommerceApp.userEmail, fUser.email);
    await EcommerceApp.sharedPreferences.setString(EcommerceApp.userName, _nameTextEditing.text);
    await EcommerceApp.sharedPreferences.setString(EcommerceApp.userAvatarUrl, imageUrl);
    await EcommerceApp.sharedPreferences.setStringList(EcommerceApp.userCartList, ['garbageValue']);

  }
}

