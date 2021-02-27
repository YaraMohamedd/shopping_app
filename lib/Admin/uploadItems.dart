
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as ImD;
import 'package:image_picker/image_picker.dart';
import 'package:store_app/Admin/adminShiftOrders.dart';
import 'package:store_app/Widgets/loadingWidget.dart';
import 'package:store_app/main.dart';


class UploadPage extends StatefulWidget
{
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> with AutomaticKeepAliveClientMixin<UploadPage>
{
  bool get wantKeepAlive => true;
  File file;
  TextEditingController _descriptionTextEditingController=TextEditingController();
  TextEditingController _titleTextEditingController=TextEditingController();
  TextEditingController _priceTextEditingController=TextEditingController();
  TextEditingController _shortInfoTextEditingController=TextEditingController();
  String productId=DateTime.now().millisecondsSinceEpoch.toString();
  bool uploading=false;
  @override
  Widget build(BuildContext context) {
    return file==null? displayAdminHomeScreen():displayAdminUploadScreen();
  }
  displayAdminHomeScreen(){
    return Scaffold(
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
  leading: IconButton(
    onPressed: (){    Route route=MaterialPageRoute(builder: (c)=>AdminShiftOrders());
    Navigator.pushReplacement(context, route);},
    icon:Icon(Icons.border_color,color: Colors.white),
  ),
actions: [
  FlatButton(onPressed: (){
    Route route=MaterialPageRoute(builder: (c)=>SplashScreen());
    Navigator.pushReplacement(context, route);
  }, child: Text('logout',style: TextStyle(color: Colors.pink,fontSize: 16,fontWeight: FontWeight.bold),))
],
),
      body: getAdminHomeScreenBody(),
    );
  }

  getAdminHomeScreenBody() {
    return Container(
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
            Icon(Icons.shop_two,color: Colors.white,size: 200,),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: RaisedButton(
                onPressed: (){
                 takeImage(context);
                },
                color: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Text('Add new item',style: TextStyle(color: Colors.white,fontSize: 20),),
              ),
            )
          ],
        ),
      ),
    );
  }

   takeImage( mContext) {
     return showDialog
       (
         context:mContext,
       builder: (con){
           return SimpleDialog(
             title: Text('Item Image',style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold),),
             children: [
               SimpleDialogOption(
                 child: Text('Capture with camera',style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold)),
                 onPressed: capturePhotoWithCamera,
               ),
               SimpleDialogOption(
                 child: Text('Select from Gallery',style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold)),
                 onPressed: pickImageFromGallery,
               ),
               SimpleDialogOption(
                 child: Text('Cancel',style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold)),
                 onPressed: (){
                   Navigator.pop(context);
                 },
               )
             ],
           );
       }
     );
  }

   capturePhotoWithCamera() async{
    Navigator.pop(context);
  File imageFile=  await ImagePicker.pickImage(source: ImageSource.camera,maxWidth: 680,maxHeight: 790);
  setState(() {
    file=imageFile;
  });
  }

   pickImageFromGallery()async {
     Navigator.pop(context);
     File imageFile=  await ImagePicker.pickImage(source: ImageSource.gallery,);
     setState(() {
       file=imageFile;
     });
  }

  displayAdminUploadScreen() {
        return Scaffold(
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
            leading: IconButton(
              onPressed: clearFormInfo,
              icon: Icon(Icons.arrow_back,color: Colors.white,
              ),),
            title: Text('New Product',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 24),),
            actions: [
              FlatButton(
                onPressed: uploading?null:()=>uploadImageandSaveItemInfo(),

              child: Text('Add',style:  TextStyle(color: Colors.pink,fontWeight: FontWeight.bold,fontSize: 16),))
            ],
          ),
          body: ListView(
            children: [
              uploading?circularProgress():Text(''),
              Container(
                height: 260,
                width: MediaQuery.of(context).size.width*.8,
                child: Center(child: AspectRatio(
                  aspectRatio: 16/9,
                  child: Container(
                    decoration: BoxDecoration(image: DecorationImage(image: FileImage(file),fit: BoxFit.cover)),
                  ),
                )),
                padding: EdgeInsets.only(top: 12),
              ),
              ListTile(
                leading: Icon(Icons.perm_device_information,color: Colors.pink,),
                title: Container(
                  width: 240,
                  child: TextField(
                    style: TextStyle(color: Colors.deepPurpleAccent),
                    controller: _shortInfoTextEditingController,
                    decoration: InputDecoration(
                      hintText: 'Short Info',
                      hintStyle:   TextStyle(color: Colors.deepPurpleAccent),
                      border: InputBorder.none
                    ),
                  ),
                ),

              ),
              Divider(color: Colors.pink,),
              ListTile(
                leading: Icon(Icons.perm_device_information,color: Colors.pink,),
                title: Container(
                  width: 240,
                  child: TextField(
                    style: TextStyle(color: Colors.deepPurpleAccent),
                    controller: _titleTextEditingController,
                    decoration: InputDecoration(
                        hintText: 'Title',
                        hintStyle:   TextStyle(color: Colors.deepPurpleAccent),
                        border: InputBorder.none
                    ),
                  ),
                ),

              ),
              Divider(color: Colors.pink,),
              ListTile(
                leading: Icon(Icons.perm_device_information,color: Colors.pink,),
                title: Container(
                  width: 240,
                  child: TextField(
                    style: TextStyle(color: Colors.deepPurpleAccent),
                    controller: _descriptionTextEditingController,
                    decoration: InputDecoration(
                        hintText: 'Description',
                        hintStyle:   TextStyle(color: Colors.deepPurpleAccent),
                        border: InputBorder.none
                    ),
                  ),
                ),

              ),
              Divider(color: Colors.pink,),
              ListTile(
                leading: Icon(Icons.perm_device_information,color: Colors.pink,),
                title: Container(
                  width: 240,
                  child: TextField(
                    style: TextStyle(color: Colors.deepPurpleAccent),
                    controller: _priceTextEditingController,
                    decoration: InputDecoration(
                        hintText: 'Price',
                        hintStyle:   TextStyle(color: Colors.deepPurpleAccent),
                        border: InputBorder.none
                    ),
                  ),
                ),

              ),
              Divider(color: Colors.pink,)
            ],
          ),
        );
  }

   clearFormInfo() {
    setState(() {
      file=null;
      _descriptionTextEditingController.clear();
      _titleTextEditingController.clear();
      _priceTextEditingController.clear();
      _shortInfoTextEditingController.clear();
    });
  }

  uploadImageandSaveItemInfo()async {
    setState(() {
      uploading=true;
    });
   String imageDownloadUrl=await uploadItemImage(file);
   saveItemInfo(imageDownloadUrl);
  }

  Future<String> uploadItemImage(mFileImage) async{

   final StorageReference storageReference=FirebaseStorage.instance.ref().child('Items');
   StorageUploadTask uploadTask = storageReference.child('product_$productId.jpg').putFile(mFileImage);
   StorageTaskSnapshot taskSnapshot =await uploadTask.onComplete;
   String downloadURL = await taskSnapshot.ref.getDownloadURL();
   return downloadURL;
  }

   saveItemInfo(String downloadUrl) {
    final itemRef=Firestore.instance.collection('items');
    itemRef.document(productId).setData({
      'shortInfo':_shortInfoTextEditingController.text.trim(),
      'longDescription':_descriptionTextEditingController.text.trim(),
      'price':int.parse(_priceTextEditingController.text),
      'publishedDate':DateTime.now(),
      'status':'available',
      'title':_titleTextEditingController.text.trim(),
      'thumbnailUrl':downloadUrl

    });
    setState(() {
      file=null;
      uploading=false;
      productId=DateTime.now().millisecondsSinceEpoch.toString();
      _shortInfoTextEditingController.clear();
      _titleTextEditingController.clear();
      _descriptionTextEditingController.clear();
      _priceTextEditingController.clear();
    });
   }
}
