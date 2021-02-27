import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:store_app/Config/config.dart';
import 'package:store_app/Counters/cartitemcounter.dart';
import 'package:store_app/Models/item.dart';
import 'package:store_app/Store/cart.dart';
import 'package:store_app/Store/product_page.dart';
import 'package:store_app/Widgets/loadingWidget.dart';
import 'package:store_app/Widgets/myDrawer.dart';
import 'package:store_app/Widgets/searchBox.dart';

double width;

class StoreHome extends StatefulWidget {
  @override
  _StoreHomeState createState() => _StoreHomeState();
}

class _StoreHomeState extends State<StoreHome> {
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.pink, Colors.lightGreenAccent],
                    begin: FractionalOffset(0.0, 0.0),
                    end: FractionalOffset(1.0, 0.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp)),
          ),
          title: Text('e-shop',
              style: TextStyle(
                  fontSize: 29, color: Colors.white, fontFamily: 'Signatra')),
          centerTitle: true,
          actions: [
            Stack(
              children: [
                IconButton(
                    icon: Icon(
                      Icons.shopping_cart,
                      color: Colors.pink,
                    ),
                    onPressed: () {
                      Route route =
                          MaterialPageRoute(builder: (c) => CartPage());
                      Navigator.pushReplacement(context, route);
                    }),
                Positioned(
                  child: Stack(
                    children: [
                      Icon(
                        Icons.brightness_1,
                        size: 20,
                        color: Colors.green,
                      ),
                      Positioned(
                        top: 3,
                        bottom: 4,
                        left: 3,
                        child: Consumer<CartItemCounter>(
                          builder: (context, counter, _) {
                            return Text(
                              counter.count.toString(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                )
              ],
            )
          ],
        ),
        drawer: MyDrawer(),
        body: CustomScrollView(
          slivers: [
            SliverPersistentHeader(pinned: true, delegate: SearchBoxDelegate()),
            StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance
                  .collection('items')
                  .limit(15)
                  .orderBy('publishedDate', descending: true)
                  .snapshots(),
              builder: (context, dataSnapshot) {
                return !dataSnapshot.hasData
                    ? SliverToBoxAdapter(
                        child: Center(
                          child: circularProgress(),
                        ),
                      )
                    : SliverStaggeredGrid.countBuilder(
                        crossAxisCount: 1,
                        itemCount: dataSnapshot.data.documents.length,
                        staggeredTileBuilder: (C) => StaggeredTile.fit(1),
                        itemBuilder: (context, index) {
                          ItemModel model = ItemModel.fromJson(
                              dataSnapshot.data.documents[index].data);
                          return sourceInfo(model, context);
                        },
                      );
              },
            )
          ],
        ),
      ),
    );
  }
}

Widget sourceInfo(ItemModel model, BuildContext context,
    {Color background, removeCartFunction}) {
  return InkWell(
    onTap: (){
      Route route=MaterialPageRoute(builder: (c)=>ProductPage(itemModel:model));
      Navigator.pushReplacement(context, route);
    },
    splashColor: Colors.pink,
    child: Padding(
      padding: EdgeInsets.all(6),
      child: Container(
        width: width,
        height: 190,
        child: Row(
          children: [
            Image.network(
              model.thumbnailUrl,
              height: 140,
              width: 140,
            ),
            SizedBox(
              width: 4,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                            child: Text(
                          model.title,
                          style: TextStyle(color: Colors.black, fontSize: 14),
                        )),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                            child: Text(
                          model.shortInfo,
                          style: TextStyle(color: Colors.black54, fontSize: 12),
                        )),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle, color: Colors.pink),
                        alignment: Alignment.topLeft,
                        width: 40,
                        height: 43,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '50%',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                    fontWeight: FontWeight.normal),
                              ),
                              Text(
                                'Off%',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                    fontWeight: FontWeight.normal),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                              child: Row(
                                children: [
                                  Text(
                                    r'Original Price:$',
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.grey,
                                      decoration: TextDecoration.lineThrough
                                    ),
                                  ),
                                  Text(
                                    (model.price + model.price).toString(),
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.grey,
                                        decoration: TextDecoration.lineThrough
                                    ),
                                  )
                                ],
                              ),
                              padding: EdgeInsets.only(top: 5)),
                          Padding(
                              child: Row(
                                children: [
                                  Text(
                                    r'New Price:',
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.grey),
                                  ),
                                  Text(
                                    r'$',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.red),
                                  ),
                                  Text(
                                    (model.price).toString(),
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.grey),
                                  )
                                ],
                              ),
                              padding: EdgeInsets.only(top: 0))
                        ],
                      )
                    ],
                  ),
                  Flexible(
                      child:Container()
                  ),
                  // to implement cart item add||remove feature
                  Align(
                    alignment: Alignment.centerRight,
                    child: removeCartFunction==null
                    ?IconButton(icon: Icon(Icons.add_shopping_cart,color: Colors.pink,), onPressed: (){
                      checkItemInCart(model.shortInfo, context);
                    })
                    :IconButton(icon: Icon(Icons.delete,color: Colors.pink,), onPressed: (){}),
                  ),
                  Divider(
                    height: 5,
                    color: Colors.pink,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    ),
  );
}

Widget card({Color primaryColor = Colors.redAccent, String imgPath}) {
  return Container();
}

void checkItemInCart(String shortInfoAsId, BuildContext context) {
  EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList).contains(shortInfoAsId)
  ?Fluttertoast.showToast(msg: 'Item already in cart')
      :addItemToCart(shortInfoAsId,context);
}

addItemToCart(String shortInfoAsId, BuildContext context) {
  List tempList = EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList);
  tempList.add(shortInfoAsId);
  EcommerceApp.firestore.collection(EcommerceApp.collectionUser)
  .document(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
  .updateData({
    EcommerceApp.userCartList:tempList
  }).then((v) {
    Fluttertoast.showToast(msg: 'Item Added to cart');
    EcommerceApp.sharedPreferences.setStringList(EcommerceApp.userCartList,tempList);
    Provider.of<CartItemCounter>(context,listen: false).displayResult();

  });




}
