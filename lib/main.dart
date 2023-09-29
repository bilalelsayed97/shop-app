import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shopapp/providers/orders.dart';
import 'package:shopapp/providers/auth.dart';
import './screens/products_overview_screen.dart';
import './themes/color_schemes.g.dart';
import 'package:provider/provider.dart';
import 'providers/cart.dart';
import 'providers/products.dart';
import './screens/auth_screen.dart';
import './screens/splash_screen.dart';

void main() {
  const SystemUiOverlayStyle(
      systemNavigationBarColor: Color.fromARGB(0, 255, 0, 0));
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: Auth()),
          ChangeNotifierProxyProvider<Auth, Products>(
            create: (ctx) => Products('', [], ''),
            update: (context, auth, previousProduct) => Products(
                auth.token,
                previousProduct == null ? [] : previousProduct.items,
                auth.userId),
          ),
          ChangeNotifierProvider.value(value: Cart()),
          ChangeNotifierProxyProvider<Auth, Orders>(
            create: (ctx) => Orders('', '', []),
            update: (context, auth, previousOrder) => Orders(auth.token,
                auth.userId, previousOrder == null ? [] : previousOrder.orders),
          ),
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              useMaterial3: true,
              colorScheme: lightColorScheme,
              textTheme: const TextTheme(
                headlineLarge: TextStyle(
                  fontFamily: 'RobotoCondensed-Regular',
                ),
              ),
            ),
            darkTheme:
                ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
            home: auth.isAuth
                ? ProductsOverviewScreen()
                : FutureBuilder(
                    builder: (ctx, authSnapshot) =>
                        authSnapshot.connectionState == ConnectionState.waiting
                            ? SplashScreen()
                            : AuthScreen(),
                    future: auth.tryAutoLogin(),
                  ),
            // ,
          ),
        ));
  }
}
