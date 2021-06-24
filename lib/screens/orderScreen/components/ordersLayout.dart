import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User user = FirebaseAuth.instance.currentUser;
    return StreamBuilder(
      stream:
          //FirebaseFirestore.instance.collection('users').snapshots(),
          FirebaseFirestore.instance
              .collection('salesOrders')
              .doc(user.email)
              .collection('salesOrders').orderBy('CreatedAt', descending: true)
              .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: Loading(),
          );
        } else {
          return ListView.separated(
            separatorBuilder: (context, index) => Divider(color: Colors.grey),
            padding: EdgeInsets.all(10.0),
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) => GestureDetector(
              onTap: () {},
              child: ListTile(
                title: new Text(
                    '${snapshot.data.documents[index]['CustomerFullName']}'),
                subtitle: Text.rich(TextSpan(
                  text:
                      'Order Date: ${snapshot.data.documents[index]['CreatedAt']}\n',
                  children: [
                    TextSpan(
                        text:
                            "Status : ${snapshot.data.documents[index]['Status']}\n",
                        style: Theme.of(context).textTheme.bodyText1),
                    TextSpan(
                        text:
                            "Customer Phone : ${snapshot.data.documents[index]['CustomerMob']}\n",
                        style: Theme.of(context).textTheme.bodyText1),
                    TextSpan(
                        text:
                            "Customer Address : ${snapshot.data.documents[index]['CustomerAddress']}\n",
                        style: Theme.of(context).textTheme.bodyText1),
                  ],
                )),
                leading: new Text(
                  snapshot.data.documents[index]['totalPrice'].toString(),
                  style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 21),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
