import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/screens/edit_products_screen.dart';
import '../providers/products.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;
  UserProductItem(
      {required this.id, required this.title, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);
    final scaffold = ScaffoldMessenger.of(context);
    return Card(
      color: Theme.of(context).colorScheme.secondaryContainer.withOpacity(.6),
      elevation: 0,
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
        title: Text(title),
        trailing: Container(
          width: 96,
          child: Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.edit,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditProductsScreen(
                        id: id,
                      ),
                    ),
                  );
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Theme.of(context).colorScheme.error,
                ),
                onPressed: () async {
                  try {
                    await productData.delProduct(id);
                  } catch (error) {
                    scaffold.showSnackBar(
                      SnackBar(
                        content: Text('Deleting failed!',
                            textAlign: TextAlign.center),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
