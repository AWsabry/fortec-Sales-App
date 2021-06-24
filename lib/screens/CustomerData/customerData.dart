import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/components/coustom_bottom_nav_bar.dart';
import 'package:sales_app/components/default_button.dart';
import 'package:sales_app/constants.dart';
import 'package:sales_app/enums.dart';
import 'package:sales_app/loading.dart';
import '../OrderSubmit/OrderSucess.dart';
import 'package:sales_app/providers/users.dart';
import 'package:sales_app/size_config.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CustomerData extends StatefulWidget {
  static String routeName = "/customer_data";
  @override
  _CustomerDataState createState() => _CustomerDataState();
}

class _CustomerDataState extends State<CustomerData> {
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
    UserProvider user = Provider.of<UserProvider>(context);
    User currentUser = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer Data'),
      ),
      body: FutureBuilder(
          future: user.getData(),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: getProportionateScreenHeight(30)),
                      buildCustomerFullNameField(),
                      SizedBox(height: getProportionateScreenHeight(30)),
                      buildCustomerEmailField(),
                      SizedBox(height: getProportionateScreenHeight(30)),
                      buildCustomerAddressField(),
                      SizedBox(height: getProportionateScreenHeight(25)),
                      buildCustomerMobField(),
                      SizedBox(height: getProportionateScreenHeight(50)),
                      Column(
                        children: [
                          Text('Total Order :\n'),
                          Text.rich(
                            TextSpan(
                                style: TextStyle(color: Colors.black),
                                children: [
                                  TextSpan(
                                    text:
                                        "${snapshot.data.data()['TotalOrder'] ?? 'OrderData '} \n",
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green),
                                  ),
                                ]),
                          )
                        ],
                      ),
                      SizedBox(height: getProportionateScreenHeight(20)),
                      DefaultButton(
                        press: () {
                          if (snapshot.data.data()['totalPrice'] == 0) {
                            return showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Dialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            20.0)), //this right here
                                    child: Container(
                                      height: 200,
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Text(
                                                  'Your cart is empty',
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                });
                          }
                          if (snapshot.data.data()['totalPrice'] != 0)
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Dialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            20.0)), //this right here
                                    child: Container(
                                      height: 200,
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Confirm your orders with \L\.\E ${snapshot.data.data()['TotalOrder']} !\n',
                                              textAlign: TextAlign.center,
                                            ),
                                            SizedBox(
                                              width: 300.0,
                                              child: DefaultButton(
                                                press: () async {
                                                  user.submitCustomer(
                                                      totalPrice: snapshot.data
                                                          .data()['TotalOrder'],
                                                      userId: currentUser.uid,
                                                      cart: snapshot.data
                                                          .data()['cart'],
                                                      salesName: snapshot.data
                                                          .data()['salesName']);
                                                  snapshot.data
                                                      .data()['TotalOrder'] = 0;

                                                  Navigator.pushNamed(
                                                      context,
                                                      OrderSuccessScreen
                                                          .routeName);
                                                  for (Map cartItem
                                                      in user.cart) {
                                                    bool value = await user
                                                        .removeFromCart(
                                                            cartItem: cartItem);
                                                    if (value) {
                                                      currentUser.reload();
                                                    } else {
                                                      print(
                                                          "ITEM WAS NOT REMOVED");
                                                    }
                                                  }
                                                },
                                                text: "Confirm",
                                              ),
                                            ),
                                            SizedBox(
                                              height: 6,
                                            ),
                                            SizedBox(
                                              width: 300.0,
                                              child: SecondaryButton(
                                                press: () {
                                                  Navigator.pop(context);
                                                  currentUser.reload();
                                                },
                                                text: "Back",
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ));
                              },
                            );
                          currentUser.reload();
                        },
                        text: 'Submit Order',
                      )
                    ],
                  ),
                ),
              );
            } else if (snapshot.connectionState == ConnectionState.none) {
              return Text("Check Connection or Register to Continue");
            }
            return Loading();
          }),
    );
  }

  TextFormField buildCustomerFullNameField() {
    UserProvider authProvider = Provider.of<UserProvider>(context);
    return TextFormField(
      controller: authProvider.customerFullName,
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kPassNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Customer Name",
        hintText: "Enter Customer Name",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: IconButton(
          onPressed: authProvider.productName.clear,
          icon: Icon(Icons.clear),
        ),
      ),
    );
  }

  TextFormField buildCustomerEmailField() {
    UserProvider authProvider = Provider.of<UserProvider>(context);
    return TextFormField(
      controller: authProvider.customerEmail,
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kPassNullError);
          return "";
        }
        return null;
      },
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: "Customer Email",
        hintText: "Customer Email",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: IconButton(
          onPressed: authProvider.productSinglePrice.clear,
          icon: Icon(Icons.clear),
        ),
      ),
    );
  }

  TextFormField buildCustomerAddressField() {
    UserProvider authProvider = Provider.of<UserProvider>(context);
    return TextFormField(
      controller: authProvider.customerAddress,
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kPassNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Customer Addresss",
        hintText: "Customer Addresss",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: IconButton(
          onPressed: authProvider.productQuantity.clear,
          icon: Icon(Icons.clear),
        ),
      ),
    );
  }

  TextFormField buildCustomerMobField() {
    UserProvider authProvider = Provider.of<UserProvider>(context);
    return TextFormField(
      controller: authProvider.customerMob,
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kPassNullError);
          return "";
        }
        return null;
      },
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: "Customer Mob",
        hintText: "Customer Mob",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: IconButton(
          onPressed: authProvider.orderTotalPrice.clear,
          icon: Icon(Icons.clear),
        ),
      ),
    );
  }
}
