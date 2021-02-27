import 'package:flutter/cupertino.dart';

class TotalAmount extends ChangeNotifier{
  double _totalMoney=0;
  double get totalMoney=>_totalMoney;
  display(double no)async{
    _totalMoney=no;
    await Future.delayed(Duration(milliseconds:100 ),(){
      notifyListeners();
    });

  }
}