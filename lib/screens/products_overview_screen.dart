import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/badge.dart';

import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/widgets/products_grid.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFavorite = false;
  // var _isLoading = false;

  late Future<dynamic> _obtainedEarlier;

  Future _obtainFutureProducts() async {
    return await Provider.of<ProductsProvider>(context, listen: false)
        .fetchProduct();
  }

  @override
  void initState() {
    _obtainedEarlier = _obtainFutureProducts();
    super.initState();
  }

  Future<void> _refreshProduct(BuildContext context) async {
    await Provider.of<ProductsProvider>(context, listen: false).fetchProduct();
  }

  @override
  Widget build(BuildContext context) {
    print('rebuild');
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'MyShop',
          style: Theme.of(context).textTheme.headline4!.copyWith(
                fontSize: 26,
                letterSpacing: 0.8,
                fontWeight: FontWeight.w900,
                color: Colors.black87,
              ),
        ),
        centerTitle: true,
        actions: [
          Consumer<Cart>(
            builder: (_, cart, ch) => Badge(
              child: ch!,
              value: cart.itemCount.toString(),
              color: Theme.of(context).accentColor,
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart_outlined),
              iconSize: 26,
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
          PopupMenuButton(
            color: Colors.black87,
            elevation: 8,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            onSelected: (selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Favorites) {
                  // productContainer.showFavorite();
                  _showOnlyFavorite = true;
                } else {
                  // productContainer.showAll();
                  _showOnlyFavorite = false;
                }
              });
            },
            icon: Icon(Icons.filter_alt_outlined),
            iconSize: 26,
            itemBuilder: (_) => [
              PopupMenuItem(
                  child: Text(
                    'Only Favorites',
                    style: Theme.of(context).textTheme.bodyText2!.copyWith(
                          fontSize: 14,
                          letterSpacing: 0.8,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).accentColor,
                        ),
                  ),
                  value: FilterOptions.Favorites),
              PopupMenuItem(
                  child: Text(
                    'Show All',
                    style: Theme.of(context).textTheme.bodyText2!.copyWith(
                          fontSize: 14,
                          letterSpacing: 0.8,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).accentColor,
                        ),
                  ),
                  value: FilterOptions.All),
            ],
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _obtainedEarlier,
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator.adaptive(
                strokeWidth: 3.5,
              ),
            );
          } else {
            if (dataSnapshot.error != null) {
              return Center(
                child: Text('An error occured'),
              );
            } else {
              return Consumer<ProductsProvider>(
                builder: (ctx, _, child) => RefreshIndicator(
                    onRefresh: () => _refreshProduct(context),
                    child: ProductsGrid(_showOnlyFavorite)),
              );
            }
          }
        },
      ),
    );
  }
}
