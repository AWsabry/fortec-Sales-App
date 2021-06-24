import 'package:flutter/material.dart';
import 'package:sales_app/screens/orderScreen/order_screen.dart';
import 'profile_menu.dart';
import 'user_details.dart';
import '../../../providers/users.dart';
import 'package:provider/provider.dart';
import '../../../screens/splash/splash_screen.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          UserDetails(),
          SizedBox(height: 20),
          ProfileMenu(
            text: "My Orders",
            icon: "assets/icons/receipt.svg",
            press: () {
              Navigator.pushNamed(context, OrdersScreen.routeName);
            },
          ),
          ProfileMenu(
            text: "Log Out",
            icon: "assets/icons/Log out.svg",
            press: () {
              user.signOut() ;
              Navigator.pushNamed(context, SplashScreen.routeName);
            },
          ),
        ],
      ),
    );
  }
}
