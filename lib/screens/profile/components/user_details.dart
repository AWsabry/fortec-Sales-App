import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../size_config.dart';
import '../../../loading.dart';
import '../../../providers/users.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserDetails extends StatelessWidget {
  const UserDetails({
    Key key,
  }) : super(key: key);

  @override
  Widget build(
    BuildContext context,
  ) {
    final user = Provider.of<UserProvider>(context);
    final firebaseUser = context.watch<User>();
    return FutureBuilder(
      future: user.getData(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            firebaseUser != null) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: double.infinity,
                margin: EdgeInsets.all(getProportionateScreenWidth(5)),
                padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(10),
                  vertical: getProportionateScreenWidth(10),
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ListTile(
                  title: new Text(
                    '${snapshot.data.data()['salesName']}',
                  ),
                  subtitle: Text.rich(TextSpan(
                    text:
                        'Total Sales: ${snapshot.data.data()['TotalCommissionCalculation']}\n',
                    children: [
                      TextSpan(
                          text:
                              "Email : ${snapshot.data.data()['salesEmail']}\n",
                          style: Theme.of(context).textTheme.bodyText1),
                      TextSpan(
                          text:
                              "Phone : ${snapshot.data.data()['salesPhoneNumber']}\n",
                          style: Theme.of(context).textTheme.bodyText1),
                      TextSpan(
                          text:
                              "Address : ${snapshot.data.data()['salesAddress']}\n",
                          style: Theme.of(context).textTheme.bodyText1),
                    ],
                  )),
                  leading: new Text(
                    'Wallet\n${snapshot.data.data()['salesWallet'].toString()}',
                    style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ),
              ),
            ],
          );
        } else if (snapshot.connectionState == ConnectionState.none ||
            firebaseUser == null) {
          return Text("Check Connection or Register to Continue");
        }
        return Loading();
      },
    );
  }
}
