import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/products.dart';
import '../providers/cart.dart';
import '../widgets/badge.dart';

class ProductDetailsScreen extends StatelessWidget {
  final String? id;
  final String? title;

  ProductDetailsScreen(this.id, this.title);
  @override
  Widget build(BuildContext context) {
    final loadedItem =
        Provider.of<Products>(context, listen: true).findById(id!);
    final cart = Provider.of<Cart>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        // backgroundColor: Colors.transparent,
        // elevation: 5,
        title: Text(
          title!,
          style: TextStyle(
            fontFamily: 'RobotoCondensed',
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Consumer<Cart>(
            builder: (_, cartData, _2) => cartData.itmeCount == 0
                ? IconButton(
                    onPressed: () {
                      print(cartData.itmeCount);
                    },
                    icon: Icon(Icons.shopping_cart),
                  )
                : Badgee(
                    child: IconButton(
                      onPressed: () {
                        print(cartData.itmeCount);
                      },
                      icon: Icon(Icons.shopping_cart),
                    ),
                    value: cartData.itmeCount.toString(),
                    color: Theme.of(context).colorScheme.error,
                  ),
          )
        ],
      ),
      // extendBodyBehindAppBar: true,
      // extendBody: true,
      body: SingleChildScrollView(
        child: Container(
          // padding: EdgeInsets.only(top: 80),
          // decoration: BoxDecoration(
          //   gradient: LinearGradient(
          //     begin: Alignment.topRight,
          //     end: Alignment.bottomLeft,
          //     colors: [
          //       Theme.of(context).colorScheme.onInverseSurface.withOpacity(.2),
          //       Theme.of(context).colorScheme.tertiaryContainer.withOpacity(.2),
          //     ],
          //   ),
          // ),
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      // color:
                      //     Theme.of(context).colorScheme.surface.withOpacity(1),
                      color: Colors.white,
                    ),
                    height: 300,
                    width: double.infinity,
                    child: ClipRRect(
                      child: Hero(
                          tag: loadedItem.id,
                          child: Image.network(loadedItem.imageUrl)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Card(
                      elevation: 0,
                      color:
                          Theme.of(context).colorScheme.error.withOpacity(.9),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 5,
                        ),
                        child: Text(
                          '-20% OFF',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onError,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    children: [
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'About this item ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          loadedItem.description,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              'Customer Rating :',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 100,
                            ),
                            for (int i = 0; i < 5; i++)
                              Icon(
                                Icons.star,
                                color: i < 3 ? Colors.orange : Colors.grey,
                                size: 20,
                              ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 500,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 5.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            // mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                '${((1.2 * loadedItem.price).toStringAsFixed(2))}\$',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              Text(
                                'Buy now for : ${(loadedItem.price.toString())}\$',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              cart.addItem(loadedItem.id, loadedItem.price,
                                  loadedItem.title, loadedItem.imageUrl);
                            },
                            icon: Icon(Icons.add_shopping_cart_rounded),
                            label: Text('Add to cart'),
                          ),
                          ElevatedButton.icon(
                            onPressed: () {},
                            icon: Icon(Icons.shopping_cart_checkout_rounded),
                            label: Text('Buy'),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      FittedBox(
                        child: Container(
                          width: 350,
                          height: 60,
                          child: Text(
                              style: TextStyle(fontSize: 10),
                              maxLines: null,
                              'Note : Products with electrical plugs are designed for use in the US. Outlets and voltage differ internationally and this product may require an adapter or converter for use in your destination. Please check compatibility before purchasing.'),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        child: Icon(
          Icons.home,
          size: 32,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.favorite),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.notifications_rounded),
              onPressed: () {},
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
    );
  }
}
