import 'package:flutter_ecommerce/models/app_state.dart';
import 'package:flutter_ecommerce/models/order.dart';
import 'package:flutter_ecommerce/models/product.dart';
import 'package:flutter_ecommerce/models/user.dart';
import 'package:flutter_ecommerce/redux/actions.dart';

AppState appReducer(AppState state, dynamic action) {
  return AppState(
    user: userReducer(state.user, action),
    products: productsReducer(state.products, action),
    cartProducts: cartProductsReducer(state.cartProducts, action),
    cards: cardsReducer(state.cards, action),
    orders: ordersReducer(state.orders, action),
    cardToken: cardTokenReducer(state.cardToken, action),
  );
}

User userReducer(User user, dynamic action) {
  if (action is GetUserAction) {
    //return user from action
    return action.user;
  } else if (action is LogoutUserAction) {
    return action.user;
  }
  return user;
}

List<Product> productsReducer(List<Product> products, dynamic action) {
  if (action is GetProductsAction) {
    //return products from action
    return action.products;
  }
  return products;
}

List<Product> cartProductsReducer(List<Product> cartProducts, dynamic action) {
  if (action is GetCartProductsAction) {
    return action.cartProducts;
  } else if (action is ToggleCartProductAction) {
    return action.cartProducts;
  } else if (action is ClearCartProductsAction) {
    return action.cartProducts;
  }
  return cartProducts;
}

List<dynamic> cardsReducer(List<dynamic> cards, dynamic action) {
  if (action is GetCardsAction) {
    return action.cards;
  } else if (action is AddCardAction) {
    return List.from(cards)..add(action.card);
  }
  return cards;
}

List<Order> ordersReducer(List<Order> orders, dynamic action) {
  if (action is AddOrderAction) {
    return List.from(orders)..add(action.order);
  } else if (action is GetOrdersAction) {
    return action.orders;
  }
  return orders;
}

String cardTokenReducer(String cardToken, dynamic action) {
  if (action is GetCardTokenAction) {
    return action.cardToken;
  }
  if (action is UpdateCardTokenAction) {
    return action.cardToken;
  }
  return cardToken;
}
