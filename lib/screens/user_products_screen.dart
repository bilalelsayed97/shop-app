import 'package:flutter/material.dart';
import 'package:shopapp/screens/edit_products_screen.dart';
import 'package:shopapp/screens/products_overview_screen.dart';
import 'package:shopapp/widgets/user_products_item.dart';
import '../providers/products.dart';
import 'package:provider/provider.dart';

class UserProductsScreen extends StatelessWidget {
  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Available Products'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return EditProductsScreen();
              }));
            },
            icon: Icon(Icons.add),
          ),
        ],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () async {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ProductsOverviewScreen(),
              ),
            );
            // await Provider.of<Products>(context, listen: false)
            //     .fetchAndSetProducts(false);
          },
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            image: DecorationImage(
                opacity: 1,
                image: AssetImage(
                  'assets/images/hero.png',
                ),
                alignment: Alignment.bottomCenter)),
        child: RefreshIndicator(
          onRefresh: () => _refreshProducts(context),
          child: FutureBuilder(
            future: _refreshProducts(context),
            builder: (ctx, snapshot) =>
                snapshot.connectionState == ConnectionState.waiting
                    ? Center(child: CircularProgressIndicator())
                    : Padding(
                        padding: EdgeInsets.all(8),
                        child: ListView.builder(
                          itemBuilder: (_, i) => Container(
                            height: MediaQuery.of(context).size.height / 9,
                            child: Column(
                              children: [
                                UserProductItem(
                                  id: productData.items[i].id,
                                  title: productData.items[i].title,
                                  imageUrl: productData.items[i].imageUrl,
                                ),
                                Divider(),
                              ],
                            ),
                          ),
                          itemCount: productData.items.length,
                        ),
                      ),
          ),
        ),
      ),
    );
  }
}
