


import 'package:flutter/material.dart';
import 'package:store_app/Models/item.dart';
import 'package:store_app/Store/storehome.dart';
import 'package:store_app/Widgets/customAppBar.dart';
import 'package:store_app/Widgets/myDrawer.dart';

class ProductPage extends StatefulWidget {
  final ItemModel itemModel;

  const ProductPage({ this.itemModel});

  @override
  _ProductPageState createState() => _ProductPageState();
}



class _ProductPageState extends State<ProductPage> {
  int quantityOfItems=1;
  @override
  Widget build(BuildContext context)
  {
    Size screanSize=MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(),
        drawer: MyDrawer(),
        body: ListView(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Center(
                        child: Image.network(widget.itemModel.thumbnailUrl),

                      ),
                      Container(
                        color: Colors.grey[400],
                        child:SizedBox(height: 1,width: double.infinity,) ,
                      )
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.all(20),
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.itemModel.title,style: boldTextStyle,),
                          SizedBox(height: 10,),
                          Text(widget.itemModel.longDescription,),
                          SizedBox(height: 10,),
                          Text(r'$'+widget.itemModel.price.toString(),style: boldTextStyle,),
                          SizedBox(height: 10,)
                        ],
                      ),
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: 8),
                    child: Center(
                      child: InkWell(
                        onTap: ()=>checkItemInCart(widget.itemModel.shortInfo,context),
                        child: Container(
                          width: MediaQuery.of(context).size.width-40,
                          height: 50,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [Colors.pink, Colors.lightGreenAccent],
                                begin: FractionalOffset(0.0, 0.0),
                                end: FractionalOffset(1.0, 0.0),
                                stops: [0.0, 1.0],
                                tileMode: TileMode.clamp)),
                          child: Center(
                            child: Text('Add to Cart',style: TextStyle(color: Colors.white),),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

}

const boldTextStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 20);
const largeTextStyle = TextStyle(fontWeight: FontWeight.normal, fontSize: 20);
