import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:sales_app/helper/user.dart';

enum Status { Uninitialized, Authenticated, Authenticating, Unauthenticated }

class UserProvider with ChangeNotifier {
  final FirebaseAuth _auth;
  UserProvider(this._auth);

  User user = FirebaseAuth.instance.currentUser;

  Stream<User> get authStateChanges => _auth.idTokenChanges();

  Status _status = Status.Uninitialized;
  Status get status => _status;

  final formkey = GlobalKey<FormState>();

  List cart = [];

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController productName = TextEditingController();
  TextEditingController productQuantity = TextEditingController();
  TextEditingController orderTotalPrice = TextEditingController();
  TextEditingController productSinglePrice = TextEditingController();
  TextEditingController salesName = TextEditingController();
  TextEditingController customerFullName = TextEditingController();
  TextEditingController customerEmail = TextEditingController();
  TextEditingController customerMob = TextEditingController();
  TextEditingController customerAddress = TextEditingController();
  TextEditingController totalOrder = TextEditingController();

  UserServices _userServicse = UserServices();

  Future<bool> signIn() async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      await _auth.signInWithEmailAndPassword(
          email: email.text.trim(), password: password.text.trim());
      return true;
    } catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      print(e.toString());
      return false;
    }
  }

  void submitCustomer(
      {Map cartItem,
      String userId,
      List cart,
      double totalPrice,
      String salesName}) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);
    User user = FirebaseAuth.instance.currentUser;
    var uuid = Uuid();
    FirebaseFirestore.instance
        .collection('salesOrders')
        .doc(user.email)
        .collection('salesOrders')
        .doc()
        .set({
      'SalesName': salesName,
      'ID': user.uid,
      'Email': user.email,
      "CustomerFullName": customerFullName.text,
      "CustomerEmail": customerEmail.text,
      "CustomerMob": customerMob.text,
      "CustomerAddress": customerAddress.text,
      "Status": 'Sent From Sales',
      'totalPrice': totalPrice,
      "cart": cart,
      "CreatedAt": formattedDate
    }).then((value) {
      FirebaseFirestore.instance.collection('sales').doc(user.email).update({
        "TotalOrder": 0,
        'cart': [],
      });
    });
    customerFullName.clear();
    customerEmail.clear();
    customerMob.clear();
    customerAddress.clear();
  }

  Future<bool> addToCart({int quantity}) async {
    User user = FirebaseAuth.instance.currentUser;
    var uuid = Uuid();
    Map cartItem;
    String cartItemId = uuid.v1();
    cart.add(cartItem = {
      "id": cartItemId,
      "productName": productName.text,
      "productQuantity": double.parse(productQuantity.text),
      "productSinglePrice": double.parse(productSinglePrice.text),
      "cartTotal": double.parse(productQuantity.text) *
          double.parse(productSinglePrice.text),
    });
    FirebaseFirestore.instance.collection('sales').doc(user.email).update({
      "cart": FieldValue.arrayUnion([cartItem])
    });
    productName.clear();
    productQuantity.clear();
    orderTotalPrice.clear();
    productSinglePrice.clear();
    _userServicse.increasePrice(cartItem: cartItem);

    return true;
  }

   removeFromCart({ Map cartItem}) {
    User user = FirebaseAuth.instance.currentUser;
    double totalCartPrice = 0;
    totalCartPrice -= cartItem['cartTotal'];
    FirebaseFirestore.instance.collection('sales').doc(user.email).update({
      "cart": FieldValue.arrayRemove([cartItem]),
      "TotalOrder": FieldValue.increment(totalCartPrice),
    });
  }

  Future<DocumentSnapshot> getData() async {
    User user = FirebaseAuth.instance.currentUser;
    print(user.email);
    await Firebase.initializeApp();
    return await FirebaseFirestore.instance
        .collection("sales")
        .doc(user.email)
        .get();
  }

  Future getOrder() async {
    User user = FirebaseAuth.instance.currentUser;
    print(user.email);
    await Firebase.initializeApp();
    return FirebaseFirestore.instance
        .collection("salesOrders")
        .doc(user.email)
        .collection('salesOrders')
        .snapshots();
  }

  Future signOut() async {
    await _auth.signOut();
    _status = Status.Unauthenticated;

    notifyListeners();
  }
}
