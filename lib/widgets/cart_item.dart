import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final String title;
  final String imageUrl;
  final double price;
  final int quantity;
  CartItem({
    required this.id,
    required this.imageUrl,
    required this.price,
    required this.quantity,
    required this.title,
    required this.productId,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Dismissible(
        confirmDismiss: (direction) {
          return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text('Are you sure?'),
              content: Text('Do you want to remove from cart?'),
              actions: [
                Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      child: Text('Confirm'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      child: Text('Cancel'),
                    )
                  ],
                ),
              ],
            ),
          );
        },
        key: ValueKey(id),
        onDismissed: (directions) => Provider.of<Cart>(
          context,
          listen: false,
        ).removeItem(productId),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(
            right: 20,
          ),
          child: Icon(
            Icons.delete,
            color: Theme.of(context).colorScheme.onError,
            size: 40,
          ),
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.error,
              borderRadius: BorderRadius.circular(10)),
          margin: EdgeInsets.all(5),
        ),
        child: Card(
          elevation: 0,
          color:
              Theme.of(context).colorScheme.secondaryContainer.withOpacity(.6),
          child: ListTile(
            leading: Container(
              width: 50,
              height: 50,
              margin: EdgeInsets.symmetric(
                vertical: 4,
              ),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: FittedBox(
                fit: BoxFit.contain,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Image.network(
                      scale: 1 / 1,
                      height: 50,
                      width: 50,
                      imageUrl,
                    ),
                  ),
                ),
              ),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                    width: 130,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$title',
                          style: TextStyle(
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          'Total : ${(quantity * price).toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 10,
                          ),
                        ),
                      ],
                    )),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                  ),
                  child: Text('${(quantity).toString()}x'),
                ),
                ElevatedButton(
                  onPressed: null,
                  child: Text(
                    '$price \$',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


// Container(
//                 width: 130,
//                 child: Text(
//                   'Total : ${(quantity * price)}',
//                   style: TextStyle(
//                     fontSize: 12,
//                   ),
//                 )),