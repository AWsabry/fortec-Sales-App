import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserServices {
  void increasePrice({
    Map cartItem,
  }) {
    User user = FirebaseAuth.instance.currentUser;

    double totalCartPrice = 0;
    totalCartPrice +=
        cartItem['productQuantity'] * cartItem['productSinglePrice'];
    FirebaseFirestore.instance
        .collection('sales')
        .doc(user.email)
        .update({
      "TotalOrder": FieldValue.increment(totalCartPrice),
      "TotalCommissionCalculation": FieldValue.increment(totalCartPrice),
    });
  }
}
