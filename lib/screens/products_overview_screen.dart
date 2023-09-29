import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/main.dart';
import 'package:shopapp/providers/auth.dart';
import 'package:shopapp/providers/products.dart';
import 'package:shopapp/providers/cart.dart';
import 'package:shopapp/screens/auth_screen.dart';
import 'package:shopapp/screens/cart_screen.dart';
import 'package:shopapp/screens/orders_screen.dart';
import 'package:shopapp/screens/user_products_screen.dart';
import '../widgets/products_grid.dart';
import '../widgets/badge.dart';

enum FilterOptions {
  Orders,
  UserProducts,
  LogOut,
}

class ProductsOverviewScreen extends StatefulWidget {
  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFav = false;
  var _isInit = true;
  var _isLoading = false;
  @override
  void initState() {
    // Provider.of<Products>(context).fetchAndSetProducts();
    // WONT WORK CUS INITSTATE X WITH CONTEXT WILL WORK IF DISABLE LISTEN
    // Future.delayed(Duration.zero).then((_) {
    //   Provider.of<Products>(context).fetchAndSetProducts();
    // });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context).fetchAndSetProducts(false).then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchAndSetProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        // backgroundColor: Colors.transparent,
        // elevation: 4,
        title: Text(
          _showOnlyFav ? 'Favourite' : 'Shop',
          style: const TextStyle(
            fontFamily: 'RobotoCondensed',
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Consumer<Cart>(
            builder: (_, cartData, _2) => cartData.itmeCount == 0
                ? IconButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (ctx) => CartScreen()));
                    },
                    icon: Icon(Icons.shopping_cart),
                  )
                : Badgee(
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (ctx) => CartScreen()));
                        });
                      },
                      icon: Icon(Icons.shopping_cart),
                    ),
                    value: cartData.itmeCount.toString(),
                    color: Theme.of(context).colorScheme.error,
                  ),
          )
        ],
        leading: PopupMenuButton(
          icon: const Icon(Icons.more_vert_rounded),
          onSelected: (FilterOptions selectedValue) {
            if (selectedValue == FilterOptions.Orders) {
              Navigator.push(
                  context, MaterialPageRoute(builder: (q) => OrdersScreen()));
            }
            if (selectedValue == FilterOptions.UserProducts) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => UserProductsScreen(),
                ),
              );
            }
            if (selectedValue == FilterOptions.LogOut) {
              Provider.of<Auth>(context, listen: false).logOut();
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (ctx) => MyApp()));
            }
          },
          itemBuilder: (_) => [
            PopupMenuItem(child: Text('Orders'), value: FilterOptions.Orders),
            PopupMenuItem(
                child: Text('\(Admin\) Control Products'),
                value: FilterOptions.UserProducts),
            PopupMenuItem(child: Text('Log Out'), value: FilterOptions.LogOut),
          ],
        ),
      ),
      body: _isLoading
          ? LinearProgressIndicator()
          : ProductsGrid(
              showOnlyFav: _showOnlyFav), //context.watch<Products>().items
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        child: Icon(
          Icons.home,
          size: 32,
        ),
        onPressed: () {
          setState(() {
            _showOnlyFav = false;
          });
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
              onPressed: () {
                setState(() {
                  _showOnlyFav = true;
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.swap_calls),
              onPressed: () {},
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
    );
  }
}
