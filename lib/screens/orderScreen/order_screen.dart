import 'package:flutter/material.dart';
import 'package:sales_app/components/coustom_bottom_nav_bar.dart';
import 'package:sales_app/enums.dart';
import 'components/ordersLayout.dart';

class OrdersScreen extends StatelessWidget {
  static String routeName = "/orderScreen";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomBottomNavBar(selectedMenu: null),
      appBar: AppBar(
        title: Text("Orders"),
      ),
      body: OrderLayout(),
    );
  }
}
