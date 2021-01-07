import 'dart:convert';

import 'package:flutter_ecommerce/models/app_state.dart';
import 'package:flutter_ecommerce/models/product.dart';
import 'package:flutter_ecommerce/models/user.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

/*User Actions*/
ThunkAction<AppState> getUserAction = (Store<AppState> store) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final String storedUser = prefs.getString('user');

  final user =
      storedUser != null ? User.fromJson(json.decode(storedUser)) : null;

  store.dispatch(GetUserAction(user));
};

class GetUserAction {
  final User _user;

  GetUserAction(this._user);

  User get user => this._user;
}

ThunkAction<AppState> logoutUserAction = (Store<AppState> store) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('user');

  User user;

  store.dispatch(LogoutUserAction(user));
};

class LogoutUserAction {
  final User _user;

  LogoutUserAction(this._user);

  User get user => this._user;
}

/*Products Actions*/
ThunkAction<AppState> getProductsAction = (Store<AppState> store) async {
  http.Response response = await http.get('http://10.0.2.2:1337/products',
      headers: {"Content-Type": "application/json"});
  final List<dynamic> responseData = json.decode(response.body);
  List<Product> products = [];
  responseData.forEach((productData) {
    final Product product = Product.fromJson(productData);
    products.add(product);
  });

  store.dispatch(GetProductsAction(products));
};

class GetProductsAction {
  final List<Product> _products;

  GetProductsAction(this._products);

  List<Product> get products => this._products;
}

/*Cart Products Items*/
ThunkAction<AppState> toggleCartProductAction(Product cartProduct) {
  return (Store<AppState> store) async {
    final List<Product> cartProducts = store.state.cartProducts;
    final User user = store.state.user;

    final int index =
        cartProducts.indexWhere((product) => product.id == cartProduct.id);
    bool isInCart = index > -1 == true;
    final List<Product> updatedCartProducts = List.from(cartProducts);
    if (isInCart) {
      updatedCartProducts
          .removeWhere((product) => product.id == cartProduct.id);
    } else {
      updatedCartProducts.add(cartProduct);
    }
    final List<String> cartProductsId =
        updatedCartProducts.map((product) => product.id).toList();

    await http.put('http://10.0.2.2:1337/carts/${user.cartId}',
        body: {'products': json.encode(cartProductsId)},
        headers: {'Authorization': 'Bearer ${user.jwt}'});
    store.dispatch(ToggleCartProductAction(updatedCartProducts));
  };
}

class ToggleCartProductAction {
  final List<Product> _cartProducts;

  ToggleCartProductAction(this._cartProducts);

  List<Product> get cartProducts => this._cartProducts;
}

ThunkAction<AppState> getCartProductsAction = (Store<AppState> store) async {
  final prefs = await SharedPreferences.getInstance();
  final String storedUser = prefs.getString('user');
  if (storedUser == null) {
    return;
  }

  final User user = User.fromJson(json.decode(storedUser));

  http.Response response = await http.get(
      'http://10.0.2.2:1337/carts/${user.cartId}',
      headers: {'Authorization': 'Bearer ${user.jwt}'});

  final List<dynamic> responseData = json.decode(response.body)['products'];
  List<Product> cartProducts = [];
  responseData.forEach((productData) {
    final Product product = Product.fromJson(productData);
    cartProducts.add(product);
  });

  store.dispatch(GetCartProductsAction(cartProducts));
};

class GetCartProductsAction {
  final List<Product> _cartProducts;

  GetCartProductsAction(this._cartProducts);

  List<Product> get cartProducts => this._cartProducts;
}
