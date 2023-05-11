import 'package:flutter/material.dart';
import '../providers/orders.dart' as prov;
import 'package:intl/intl.dart';

class OrderItem extends StatefulWidget {
  final prov.OrderItem order;

  OrderItem(this.order);

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _isExpaned = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.secondaryContainer.withOpacity(.6),
      elevation: 0,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        children: [
          ListTile(
            title: Text(
              '\$${(widget.order.amount)}',
            ),
            subtitle: Text(
              DateFormat('dd/MM/yyyy HH:MM')
                  .format(widget.order.dateTime)
                  .toString(),
            ),
            trailing: IconButton(
                icon: _isExpaned
                    ? Icon(Icons.expand_less)
                    : Icon(Icons.expand_more),
                onPressed: () {
                  setState(() {
                    _isExpaned = !_isExpaned;
                  });
                }),
          ),
          _isExpaned
              ? Container(
                  height: (widget.order.products.length.toDouble() * 60),
                  child: ListView(
                    children: widget.order.products
                        .map(
                          (product) => ListTile(
                            leading: Container(
                              width: 50,
                              height: 50,
                              margin: EdgeInsets.symmetric(
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              child: FittedBox(
                                fit: BoxFit.contain,
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Image.network(
                                      scale: 1 / 1,
                                      height: 50,
                                      width: 50,
                                      product.imageurl,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product.title,
                                          style: TextStyle(
                                            fontSize: 13,
                                          ),
                                        ),
                                        Text(
                                          'Total : ${(product.quantity * product.price).toStringAsFixed(2)}',
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
                                  child:
                                      Text('${(product.quantity).toString()}x'),
                                ),
                                ElevatedButton(
                                  onPressed: null,
                                  child: Text(
                                    '\$${(product.price)}',
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
                )
              : SizedBox(
                  height: 1,
                  width: 1,
                ),
        ],
      ),
    );
  }
}
