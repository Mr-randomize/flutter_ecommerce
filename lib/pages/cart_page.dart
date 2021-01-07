import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/models/app_state.dart';
import 'package:flutter_ecommerce/widgets/product_item.dart';
import 'package:flutter_redux/flutter_redux.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  Widget _cartTab() {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (_, state) {
        return Column(
          children: [
            Expanded(
              child: SafeArea(
                top: false,
                bottom: false,
                child: GridView.builder(
                    itemCount: state.cartProducts.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:
                            orientation == Orientation.portrait ? 2 : 3,
                        childAspectRatio:
                            orientation == Orientation.portrait ? 1.0 : 1.3,
                        mainAxisSpacing: 4.0,
                        crossAxisSpacing: 4.0),
                    itemBuilder: (context, i) =>
                        ProductItem(item: state.cartProducts[i])),
              ),
            )
          ],
        );
      },
    );
  }

  Widget _cardsTab() {
    return Text('cart');
  }

  Widget _ordersTab() {
    return Text('cart');
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Cart Page'),
          bottom: TabBar(
            labelColor: Colors.deepOrange[600],
            unselectedLabelColor: Colors.deepOrange[609000],
            tabs: [
              Tab(icon: Icon(Icons.shopping_cart)),
              Tab(icon: Icon(Icons.credit_card)),
              Tab(icon: Icon(Icons.receipt)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _cartTab(),
            _cardsTab(),
            _ordersTab(),
          ],
        ),
      ),
    );
  }
}