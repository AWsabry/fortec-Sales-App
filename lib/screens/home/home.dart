import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../components/coustom_bottom_nav_bar.dart';
import '../../enums.dart';
import '../../loading.dart';
import 'package:provider/provider.dart';
import '../../providers/users.dart';
import '../displayallOrders/Cart_Orders.dart';
import '../CustomerData/customerData.dart';
import '../../snackbar.dart';
import '../../size_config.dart';
import '../../constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = "/home";
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> errors = [];

  void addError({String error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  @override
  Widget build(BuildContext context) {
    Widget okButton = FlatButton(
      child: Text(
        "Done",
        style: TextStyle(
          color: Colors.green,
          fontWeight: FontWeight.bold,
        ),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Added "),
      content: Text("Order Added Successfully !"),
      actions: [
        okButton,
      ],
    );
    UserProvider authProvider = Provider.of<UserProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Add Your Product'),
          actions: [
            Padding(
                padding: const EdgeInsets.all(12.0),
                child: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    User user = FirebaseAuth.instance.currentUser;
                    authProvider.addToCart();
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        authProvider.productName.clear();
                        authProvider.productQuantity.clear();
                        authProvider.orderTotalPrice.clear();
                        authProvider.productSinglePrice.clear();
                        return alert;
                      },
                    );
                    print(user.email);
                  },
                )),
          ],
        ),
        bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.home),
        body: FutureBuilder(
          future: authProvider.getData(),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: getProportionateScreenHeight(15)),
                      Text('TrueTech Sales App',
                          style: TextStyle(
                            fontFamily: 'Signatra',
                            fontSize: 48,
                            color: Colors.green,
                          )),
                      SizedBox(height: getProportionateScreenHeight(30)),
                      buildProductField(),
                      SizedBox(height: getProportionateScreenHeight(30)),
                      buildSinglePriceField(),
                      SizedBox(height: getProportionateScreenHeight(30)),
                      buildQuantityField(),
                      SizedBox(height: getProportionateScreenHeight(30)),
                      // buildTotalPriceField(),
                      SizedBox(height: getProportionateScreenHeight(100)),
                    ],
                  ),
                ),
              );
            } else if (snapshot.connectionState == ConnectionState.none) {
              return Text("Check Connection or Register to Continue");
            }
            return Loading();
          },
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.arrow_forward_ios),
          onPressed: () {
            Navigator.pushNamed(context, DisplayOrders.routeName);
          },
          backgroundColor: Colors.black,
        ));
  }

  TextFormField buildProductField() {
    UserProvider authProvider = Provider.of<UserProvider>(context);
    return TextFormField(
      controller: authProvider.productName,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        }
      },
      decoration: InputDecoration(
        labelText: "Product Name",
        hintText: "Enter Customer Product Name",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: IconButton(
          onPressed: authProvider.productName.clear,
          icon: Icon(
            Icons.clear,
            color: Colors.green,
          ),
        ),
      ),
    );
  }

  TextFormField buildSinglePriceField() {
    UserProvider authProvider = Provider.of<UserProvider>(context);
    return TextFormField(
      controller: authProvider.productSinglePrice,
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kPassNullError);
        }
        return "";
      },
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        }
      },
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: "Product Single Price",
        hintText: "Product Single Price",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: IconButton(
          onPressed: authProvider.productSinglePrice.clear,
          icon: Icon(
            Icons.clear,
            color: Colors.green,
          ),
        ),
      ),
    );
  }

  TextFormField buildQuantityField() {
    UserProvider authProvider = Provider.of<UserProvider>(context);
    return TextFormField(
      controller: authProvider.productQuantity,
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kPassNullError);
        }
        return "";
      },
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        }
      },
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: "Product Quantity",
        hintText: "Enter Customer quantity",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: IconButton(
          onPressed: authProvider.productQuantity.clear,
          icon: Icon(
            Icons.clear,
            color: Colors.green,
          ),
        ),
      ),
    );
  }

  TextFormField buildTotalPriceField() {
    UserProvider authProvider = Provider.of<UserProvider>(context);
    return TextFormField(
      controller: authProvider.orderTotalPrice,
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kPassNullError);
        }
        return "";
      },
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        }
      },
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: "Total Order Price",
        hintText: "Enter Customer total price",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: IconButton(
          onPressed: authProvider.orderTotalPrice.clear,
          icon: Icon(
            Icons.clear,
            color: Colors.green,
          ),
        ),
      ),
    );
  }
}
