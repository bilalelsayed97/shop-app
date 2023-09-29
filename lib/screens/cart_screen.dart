import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/orders.dart';
import '../widgets/cart_item.dart';
import '../providers/cart.dart' as c;

class CartScreen extends StatefulWidget {
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<c.Cart>(context);
    final orders = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: Column(
        children: [
          Card(
            elevation: 0,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Total : ',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Spacer(),
                  ElevatedButton(
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all(0),
                      backgroundColor: MaterialStateProperty.all(
                          Theme.of(context).colorScheme.primary),
                      foregroundColor: MaterialStateProperty.all(
                          Theme.of(context).colorScheme.onPrimary),
                    ),
                    onPressed: null,
                    child: Text('${(cart.totalAmount.toString())} \$'),
                  ),
                  _isLoading
                      ? Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 35,
                          ),
                          child: SizedBox(
                              height: 25,
                              width: 25,
                              child: CircularProgressIndicator()),
                        )
                      : TextButton(
                          onPressed: cart.items.isEmpty
                              ? null
                              : () => [
                                    setState(() {
                                      _isLoading = true;
                                    }),
                                    orders
                                        .addOrder(
                                      cart.items.values.toList(),
                                      cart.totalAmount!,
                                    )
                                        .then((_) {
                                      setState(() {
                                        _isLoading = false;
                                      });
                                    }),
                                    cart.clearCart()
                                  ],
                          child: Text('ORDER NOW'),
                        ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 0,
          ),
          Expanded(
            child: cart.items.isEmpty
                ? Container(
                    height: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/images/male.png'),
                            opacity: 1)),
                    child: Center(
                      child: Text('Your Cart is empty!'),
                    ),
                  )
                : ListView.builder(
                    itemBuilder: ((ctx, i) => CartItem(
                          id: cart.items.values.toList()[i].id,
                          imageUrl: cart.items.values.toList()[i].imageurl,
                          price: cart.items.values.toList()[i].price,
                          quantity: cart.items.values.toList()[i].quantity,
                          title: cart.items.values.toList()[i].title,
                          productId: cart.items.keys.toList()[i],
                        )),
                    itemCount: cart.itmeCount,
                  ),
          )
        ],
      ),
    );
  }
}
