import 'package:flutter/material.dart';
import 'package:shopapp/providers/products.dart';
import 'package:shopapp/widgets/product.item.dart';
import 'package:provider/provider.dart';
import '../providers/product.dart';

class ProductsGrid extends StatelessWidget {
  final bool showOnlyFav;
  ProductsGrid({required this.showOnlyFav});

  @override
  Widget build(BuildContext context) {
    final prodctsData = Provider.of<Products>(context);
    final products = showOnlyFav ? prodctsData.favItems : prodctsData.items;
    return Container(
      child: GridView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: products.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 2.6 / 3,
          crossAxisSpacing: 5,
          mainAxisSpacing: 5,
        ),
        itemBuilder: (
          context,
          index,
        ) =>
            ChangeNotifierProvider.value(
          value: products[index],
          child: ProductItem(),
        ),
      ),
    );
  }
}
