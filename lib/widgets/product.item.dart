import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/auth.dart';
import '../providers/cart.dart';
import '../providers/product.dart';
import 'package:shopapp/screens/product_details_screen.dart';

class ProductItem extends StatelessWidget {
  // final String? id;
  // final String? title;
  // final String? price;
  // late final String imageUrl;

  // ProductItem(
  //   this.id,
  //   this.title,
  //   this.price,
  //   this.imageUrl,
  // );

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);
    final cart = Provider.of<Cart>(context, listen: false);
    final auth = Provider.of<Auth>(context, listen: false);
    // assert(debugCheckHasMaterial(context));
    return // Container(
        // decoration: BoxDecoration(
        //   boxShadow: [
        //     BoxShadow(
        //       color: Colors.black.withOpacity(.05),
        //       spreadRadius: 0.1,
        //       blurRadius: 200,
        //       offset: Offset(0, 1), // changes position of shadow
        //     ),
        //   ],
        // ),     child:
        GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ProductDetailsScreen(product.id, product.title);
        }));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.tertiary.withOpacity(.05),
          borderRadius: BorderRadius.circular(15),
        ),
        height: 300,
        child: Column(
          children: [
            Card(
              margin: EdgeInsets.all(0),
              shape: RoundedRectangleBorder(
                // side: BorderSide(
                //   color: Color.fromARGB(255, 113, 113, 113).withOpacity(.05),
                //   width: 1.5,
                // ),
                borderRadius: BorderRadius.circular(15.0),
              ),
              elevation: 0,
              color: Colors.white,
              // color: Theme.of(context).colorScheme.surface.withOpacity(1),
              child: GridTile(
                child: Column(
                  children: [
                    SizedBox(
                      height: 150,
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        child: Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Center(
                                child: Hero(
                                  tag: product.id,
                                  child: Image.network(
                                    product.imageUrl,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 5,
                                horizontal: 6,
                              ),
                              child: Card(
                                elevation: 0,
                                color: Theme.of(context)
                                    .colorScheme
                                    .error
                                    .withOpacity(.9),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 5,
                                  ),
                                  child: Text(
                                    '-20% OFF',
                                    style: TextStyle(
                                      fontSize: 7,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          Theme.of(context).colorScheme.onError,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // Container(
                            //   decoration: BoxDecoration(
                            //     gradient: LinearGradient(
                            //       colors: [
                            //         Theme.of(context)
                            //             .colorScheme
                            //             .primaryContainer
                            //             .withOpacity(.2),
                            //         Colors.transparent
                            //       ],
                            //       begin: Alignment.bottomCenter,
                            //       end: Alignment.center,
                            //     ),
                            //   ),
                            // ),
                            Positioned(
                              top: -5,
                              right: -2,
                              child: IconButton(
                                icon: product.isFavourite
                                    ? Icon(
                                        Icons.favorite,
                                        color:
                                            Theme.of(context).colorScheme.error,
                                      )
                                    : Icon(
                                        Icons.favorite,
                                      ),
                                color: Theme.of(context)
                                    .colorScheme
                                    .errorContainer,
                                onPressed: () {
                                  product.toggleFavourieStatus(
                                      auth.token, auth.userId);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    height: 50,
                    child: FittedBox(
                      fit: BoxFit.contain,
                      // alignment: Alignment.bottomLeft,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.title,
                            style: TextStyle(
                              fontFamily: 'RobotoCondensed',
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          Text(
                            "\$${(product.price).toStringAsFixed(2)}",
                            style: TextStyle(
                              fontFamily: 'RobotoCondensed',
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          Row(
                            children: [
                              for (int i = 0; i < 5; i++)
                                Icon(
                                  Icons.star,
                                  color: i < 3 ? Colors.orange : Colors.grey,
                                  size: 16,
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Ink(
                    decoration: BoxDecoration(
                        // borderRadius: BorderRadius.circular(10),
                        // color: Theme.of(context).colorScheme.primary,
                        ),
                    width: 32.0,
                    height: 32.0,
                    child: Material(
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).colorScheme.primaryContainer,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        highlightColor: Theme.of(context)
                            .colorScheme
                            .onPrimary
                            .withOpacity(.12),
                        onTap: () {
                          cart.addItem(product.id, product.price, product.title,
                              product.imageUrl);
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              duration: Duration(seconds: 2),
                              content: Text('Item added to cart!'),
                              action: SnackBarAction(
                                  label: 'UNDO',
                                  onPressed: () {
                                    cart.undoItem(product.id);
                                  }),
                            ),
                          );
                        },
                        child: Center(
                          child: Icon(
                            size: 20,
                            Icons.add_shopping_cart_rounded,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Positioned(
//   right: 8,
//   bottom: 8,
//   child: Ink(
//     decoration: BoxDecoration(
//       borderRadius: BorderRadius.circular(10),
//       color: Theme.of(context).colorScheme.primary,
//     ),
//     width: 35.0,
//     height: 35.0,
//     child: InkWell(
//       highlightColor: Theme.of(context)
//           .colorScheme
//           .onPrimary
//           .withOpacity(.12),
//       onTap: () {/* ... */},
//       child: Center(
//         child: Icon(
//           Icons.add_shopping_cart_rounded,
//           color: Theme.of(context).colorScheme.onPrimary,
//         ),
//       ),
//     ),
//   ),
// ),

// IconButton(
//                   hoverColor:
//                       Theme.of(context).colorScheme.onPrimary.withOpacity(.12),
//                   highlightColor:
//                       Theme.of(context).colorScheme.onPrimary.withOpacity(.12),
//                   visualDensity: VisualDensity(vertical: -4, horizontal: -3),
//                   color: Theme.of(context).colorScheme.onPrimary,
//                   style: ButtonStyle(
//                       backgroundColor: MaterialStateProperty.all(
//                           Theme.of(context).colorScheme.primary)),
//                   onPressed: () {},
//                   icon: Icon(
//                     Icons.add_shopping_cart_rounded,
//                   ),
//                 ),
