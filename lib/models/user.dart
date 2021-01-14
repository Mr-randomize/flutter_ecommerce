import 'package:flutter/material.dart';

class User {
  final String id;
  final String username;
  final String email;
  final String jwt;
  final String cartId;
  final String customerId;

  User({
    @required this.id,
    @required this.username,
    @required this.email,
    @required this.jwt,
    @required this.cartId,
    @required this.customerId,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      username: json['username'],
      email: json['email'],
      jwt: json['jwt'],
      cartId: json['cart_id'],
      customerId: json['customer_id'],
    );
  }
}
