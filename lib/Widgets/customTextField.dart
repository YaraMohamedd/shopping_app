import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget
{
  final TextEditingController controller;
  final IconData data;
  final String hintText;
  bool isObsecure = true;



  CustomTextField(
      {Key key, this.controller, this.data, this.hintText,this.isObsecure}
      ) : super(key: key);



  @override
  Widget build(BuildContext context)
  {

    return Container
      (
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10))
      ),
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.all(8),
      child: TextFormField(
        cursorColor: Theme.of(context).primaryColor,
        controller: controller,
        obscureText: isObsecure,
        decoration: InputDecoration(
            prefixIcon: Icon(data,color: Theme.of(context).primaryColor,),
            focusColor: Theme.of(context).primaryColor,
            hintText: hintText
        ),
      ),
    );
  }
}
