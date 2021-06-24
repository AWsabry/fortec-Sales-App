import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sales_app/loading.dart';
import 'package:provider/provider.dart';
import '../../../providers/users.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sales_app/size_config.dart';
import 'package:sales_app/constants.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    User currentUser = FirebaseAuth.instance.currentUser;
    final user = Provider.of<UserProvider>(context);
    return FutureBuilder(
      future: user.getData(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return  ListView.builder(
            itemCount: snapshot.data.data()['cart'].length,
            itemBuilder: (_, index) => Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Dismissible(
                key: Key(snapshot.data.data()['cart'][index]['id'].toString()),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  setState(() {
                    currentUser.reload();
                    user.removeFromCart(
                      cartItem: snapshot.data.data()['cart'][index],
                    );
                    snapshot.data.data()['cart'].removeAt(index);
                    currentUser.reload();
                  });
                },
                background: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Color(0xFFFFE6E6),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      Spacer(),
                      SvgPicture.asset("assets/icons/Trash.svg"),
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: new Text(
                      snapshot.data
                          .data()['cart'][index]['cartTotal']
                          .toString(),
                      style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 21),
                    ),
                    title: new Text(
                        '${snapshot.data.data()['cart'][index]['productName']}'),
                    subtitle: Text.rich(TextSpan(
                      text:
                          'Single Price : ${snapshot.data.data()['cart'][index]['productSinglePrice']}\n',
                      children: [
                        TextSpan(
                            text:
                                "Quantity: x${snapshot.data.data()['cart'][index]['productQuantity']}\n",
                            style: Theme.of(context).textTheme.bodyText1),
                      ],
                    )),
                  ),
                ),
              ),
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.none) {
          return Text("No data");
        }
        return Loading();
      },
      
    );
  }
}
