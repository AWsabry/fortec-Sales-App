import 'package:flutter/material.dart';
import 'package:sales_app/components/default_button.dart';
import 'package:sales_app/screens/home/home.dart';
import 'package:sales_app/size_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../size_config.dart';
import '../../../loading.dart';
import '../../../providers/users.dart';
import 'package:provider/provider.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();
    if (firebaseUser == null) {
      return Center(
        child: Loading(),
      );
    }
    return Column(
      children: [
        SizedBox(height: SizeConfig.screenHeight * 0.04),
        Image.asset(
          "assets/images/success.png",
          height: SizeConfig.screenHeight * 0.4, //40%
        ),
        SizedBox(height: SizeConfig.screenHeight * 0.08),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Order Added Successfully !",
            style: TextStyle(
              fontSize: getProportionateScreenWidth(24),
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        Spacer(),
        SizedBox(
          width: SizeConfig.screenWidth * 0.6,
          child: DefaultButton(
            text: "Back To Home",
            press: () {
              Navigator.pushNamed(context, HomeScreen.routeName);
            },
          ),
        ),
        Spacer(),
      ],
    );
  }
}
