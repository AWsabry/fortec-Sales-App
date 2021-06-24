import 'package:flutter/material.dart';
import 'components/body.dart';
import '../../components/coustom_bottom_nav_bar.dart';
import '../../enums.dart';
import '../CustomerData/customerData.dart';

class DisplayOrders extends StatelessWidget {
  static String routeName = "/displayOrders";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.orders),
      appBar: AppBar(
        title: Text('Cart Orders'),
      ),
      body: Body(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.arrow_forward_ios),
        onPressed: () {
          Navigator.pushNamed(context, CustomerData.routeName);
        },
        backgroundColor: Colors.black,
      ),
    );
  }
}
